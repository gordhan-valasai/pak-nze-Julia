using JLD2, JuMP

struct ModelSolution
    scenario::String
    years::Vector{Int}
    technologies::Vector{String}
    provinces::Vector{String}
    sectors::Vector{String}
    fuels::Vector{String}
    installed_capacity::Dict{Tuple{String, Int, String}, Float64}
    new_capacity::Dict{Tuple{String, Int, String}, Float64}
    retired_capacity::Dict{Tuple{String, Int, String}, Float64}
    annual_generation::Dict{Tuple{String, Int, String}, Float64}
    co2_emissions_by_sector::Dict{Tuple{String, Int}, Float64}
    ch4_emissions_by_sector::Dict{Tuple{String, Int}, Float64}
    n2o_emissions_by_sector::Dict{Tuple{String, Int}, Float64}
    total_co2eq_emissions_by_sector::Dict{Tuple{String, Int}, Float64}
    negative_emissions::Dict{Tuple{String, Int}, Float64}
    primary_energy_supply::Dict{Tuple{String, Int}, Float64}
    final_energy_demand::Dict{Tuple{String, String, Int}, Float64}
    fuel_imports::Dict{Tuple{String, Int}, Float64}
    hydrogen_production::Dict{Tuple{String, Int}, Float64}
    hydrogen_end_use::Dict{Tuple{String, Int}, Float64}
    inter_provincial_flow::Dict{Tuple{String, String, Int}, Float64}
    capex_by_tech::Dict{Tuple{String, Int}, Float64}
    fixed_om_by_tech::Dict{Tuple{String, Int}, Float64}
    var_om_by_tech::Dict{Tuple{String, Int}, Float64}
    fuel_cost_by_fuel::Dict{Tuple{String, Int}, Float64}
    total_discounted_cost::Float64
    service_demand::Dict{Tuple{String, Int}, Float64}
    climate_feedback_enabled::Bool
    temperature_anomaly_pathway::String
    battery_charge_twh::Dict{Tuple{String, Int}, Float64}
    battery_discharge_twh::Dict{Tuple{String, Int}, Float64}
    battery_soc_gwh::Dict{Tuple{String, Int}, Float64}
    battery_capacity_gw::Dict{Tuple{String, Int}, Float64}
    electrolyser_capacity_mw::Dict{Int, Float64}
    transport_electricity_share::Dict{Int, Float64}
    cooking_biomethane_share::Dict{Int, Float64}
    ev_sales_share::Dict{Int, Float64}
    green_ammonia_share::Dict{Int, Float64}
    cement_ccs_share::Dict{Int, Float64}
    temperature_anomaly_c::Dict{Int, Float64}
end

function save_solution(path::String, solution::ModelSolution)
    mkpath(dirname(path))
    JLD2.save_object(path, solution)
end

function load_solution(path::String)::ModelSolution
    return JLD2.load_object(path)
end

function build_solution(model::Model, sets::ModelSets, params::ModelParameters, scenario::String, objective_usd::Float64)::ModelSolution
    installed_capacity = Dict{Tuple{String, Int, String}, Float64}()
    new_capacity = Dict{Tuple{String, Int, String}, Float64}()
    retired_capacity = Dict{Tuple{String, Int, String}, Float64}()
    annual_generation = Dict{Tuple{String, Int, String}, Float64}()
    co2_emissions_by_sector = Dict{Tuple{String, Int}, Float64}()
    ch4_emissions_by_sector = Dict{Tuple{String, Int}, Float64}()
    n2o_emissions_by_sector = Dict{Tuple{String, Int}, Float64}()
    total_co2eq_emissions_by_sector = Dict{Tuple{String, Int}, Float64}()
    negative_emissions = Dict{Tuple{String, Int}, Float64}()
    primary_energy_supply = Dict{Tuple{String, Int}, Float64}()
    final_energy_demand = Dict{Tuple{String, String, Int}, Float64}()
    fuel_imports = Dict{Tuple{String, Int}, Float64}()
    hydrogen_production = Dict{Tuple{String, Int}, Float64}()
    hydrogen_end_use = Dict{Tuple{String, Int}, Float64}()
    inter_provincial_flow = Dict{Tuple{String, String, Int}, Float64}()
    capex_by_tech = Dict{Tuple{String, Int}, Float64}()
    fixed_om_by_tech = Dict{Tuple{String, Int}, Float64}()
    var_om_by_tech = Dict{Tuple{String, Int}, Float64}()
    fuel_cost_by_fuel = Dict{Tuple{String, Int}, Float64}()
    service_demand = Dict{Tuple{String, Int}, Float64}()
    battery_charge_twh = Dict{Tuple{String, Int}, Float64}()
    battery_discharge_twh = Dict{Tuple{String, Int}, Float64}()
    battery_soc_gwh = Dict{Tuple{String, Int}, Float64}()
    battery_capacity_gw = Dict{Tuple{String, Int}, Float64}()
    electrolyser_capacity_mw = Dict{Int, Float64}()
    transport_electricity_share = Dict{Int, Float64}()
    cooking_biomethane_share = Dict{Int, Float64}()
    ev_sales_share = Dict{Int, Float64}()
    green_ammonia_share = Dict{Int, Float64}()
    cement_ccs_share = Dict{Int, Float64}()

    cap = model[:installed_capacity_mw]
    newcap = model[:new_capacity_mw]
    ann = model[:annual_activity_mwh]
    provgen = model[:province_generation_mwh]
    em = model[:emissions_tco2eq]
    gas = model[:gas_emissions_tonnes]
    neg = model[:negative_emissions_tco2eq]
    fuel = model[:fuel_use_mwh]
    fuel_import = model[:fuel_import_mwh]
    flows = model[:transmission_flow_mwh]
    bcap = model[:battery_capacity_mw]
    bchg = model[:battery_charge_mwh]
    bdis = model[:battery_discharge_mwh]
    bsoc = model[:battery_soc_mwh]

    for t in sets.technologies, y in sets.years
        cap_gw = value(cap[t, y]) / 1000.0 # MW -> GW
        new_gw = value(newcap[t, y]) / 1000.0 # MW -> GW
        ann_twh = value(ann[t, y]) / 1e6 # MWh -> TWh
        capex = get(params.capex_usd_per_mw, t, 0.0) * value(newcap[t, y]) / 1e9 # USD -> USD bn
        fixom = get(params.fixed_om_usd_per_mw_yr, t, 0.0) * value(cap[t, y]) / 1e9 # USD -> USD bn
        varom = get(params.var_om_usd_per_mwh, t, 0.0) * value(ann[t, y]) / 1e9 # USD -> USD bn
        capex_by_tech[(t, y)] = capex
        fixed_om_by_tech[(t, y)] = fixom
        var_om_by_tech[(t, y)] = varom
        for p in sets.provinces
            installed_capacity[(t, y, p)] = cap_gw / max(length(sets.provinces), 1)
            new_capacity[(t, y, p)] = new_gw / max(length(sets.provinces), 1)
            if y == first(sets.years)
                retired_capacity[(t, y, p)] = 0.0
            else
                retired_capacity[(t, y, p)] = max(installed_capacity[(t, y - 1, p)] + new_capacity[(t, y, p)] - installed_capacity[(t, y, p)], 0.0)
            end
            annual_generation[(t, y, p)] = sum(value(provgen[p, t, y, s]) for s in sets.slices) / 1e6 # MWh -> TWh
        end
    end

    for y in sets.years
        electrolyser_capacity_mw[y] = value(model[:electrolyser_capacity_mw][y])
        transport_electricity_share[y] = value(model[:transport_electricity_share][y]) * 100.0
        cooking_biomethane_share[y] = value(model[:cooking_biomethane_share][y]) * 100.0
        ev_sales_share[y] = value(model[:ev_sales_share][y]) * 100.0
        green_ammonia_share[y] = value(model[:green_ammonia_share][y]) * 100.0
        cement_ccs_share[y] = value(model[:cement_ccs_share][y]) * 100.0
        for p in sets.provinces
            battery_capacity_gw[(p, y)] = value(bcap[p, y]) / 1000.0 # MW -> GW
            battery_charge_twh[(p, y)] = sum(value(bchg[p, y, s]) for s in sets.slices) / 1e6 # MWh -> TWh
            battery_discharge_twh[(p, y)] = sum(value(bdis[p, y, s]) for s in sets.slices) / 1e6 # MWh -> TWh
            battery_soc_gwh[(p, y)] = sum(value(bsoc[p, y, s]) for s in sets.slices) / (1000.0 * max(length(sets.slices), 1)) # MWh -> GWh
        end
        for sec in ["power", "industry", "transport", "buildings", "agriculture"]
            sec_co2_mt = 0.0
            sec_ch4_mt = 0.0
            sec_n2o_mt = 0.0
            for t in sets.technologies
                if get(params.sector_by_technology, t, "power") == sec
                    sec_co2_mt += value(gas["CO2", t, y]) / 1e6 # t -> Mt
                    sec_ch4_mt += value(gas["CH4", t, y]) / 1e6 # t -> Mt
                    sec_n2o_mt += value(gas["N2O", t, y]) / 1e6 # t -> Mt
                end
            end
            co2_emissions_by_sector[(sec, y)] = sec_co2_mt
            ch4_emissions_by_sector[(sec, y)] = sec_ch4_mt
            n2o_emissions_by_sector[(sec, y)] = sec_n2o_mt
            total_co2eq_emissions_by_sector[(sec, y)] = sum((value(em[t, y]) for t in sets.technologies if get(params.sector_by_technology, t, "power") == sec); init=0.0) / 1e6 # t -> Mt
        end
        for t in sets.technologies
            negative_emissions[(t, y)] = value(neg[t, y]) / 1e6 # t -> Mt
        end
        for f in sets.fuels
            primary_energy_supply[(f, y)] = value(fuel[f, y]) * 3.6 / 1e6 # MWh -> PJ
            fuel_cost_by_fuel[(f, y)] = get(params.fuel_price_usd_per_mwh, (f, y), 0.0) * value(fuel[f, y]) / 1e9 # USD -> USD bn
            fuel_imports[(f, y)] = value(fuel_import[f, y]) * 3.6 / 1e6 # MWh -> PJ
        end
        for s in sets.service_demands
            service_demand[(s, y)] = get(params.demand_by_service, (s, y), 0.0)
            # REMOVED: was synthetic uniform service-demand split across fuels.
            # Keep field for schema compatibility, but do not populate synthetic values.
        end
        for pf in sets.provinces, pt in sets.provinces
            pf == pt && continue
            inter_provincial_flow[(pf, pt, y)] = sum(value(flows[pf, pt, y, s]) for s in sets.slices) / 1e6 # MWh -> TWh
        end
        # REMOVED: was synthetic hydrogen production/end-use ratio allocation.
        hydrogen_production[("electrolyser_total", y)] = 0.0
    end

    sectors = ["power", "industry", "transport", "buildings", "agriculture", "others"]
    return ModelSolution(
        scenario,
        sets.years,
        sets.technologies,
        sets.provinces,
        sectors,
        sets.fuels,
        installed_capacity,
        new_capacity,
        retired_capacity,
        annual_generation,
        co2_emissions_by_sector,
        ch4_emissions_by_sector,
        n2o_emissions_by_sector,
        total_co2eq_emissions_by_sector,
        negative_emissions,
        primary_energy_supply,
        final_energy_demand,
        fuel_imports,
        hydrogen_production,
        hydrogen_end_use,
        inter_provincial_flow,
        capex_by_tech,
        fixed_om_by_tech,
        var_om_by_tech,
        fuel_cost_by_fuel,
        objective_usd / 1e9, # USD -> USD bn
        service_demand,
        params.climate_feedback_enabled,
        params.climate_pathway,
        battery_charge_twh,
        battery_discharge_twh,
        battery_soc_gwh,
        battery_capacity_gw,
        electrolyser_capacity_mw,
        transport_electricity_share,
        cooking_biomethane_share,
        ev_sales_share,
        green_ammonia_share,
        cement_ccs_share,
        params.temperature_anomaly_c
    )
end
