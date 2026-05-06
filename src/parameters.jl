mutable struct ModelParameters
    discount_factor::Dict{Int,Float64}
    capex_usd_per_mw::Dict{String,Float64}
    fixed_om_usd_per_mw_yr::Dict{String,Float64}
    var_om_usd_per_mwh::Dict{String,Float64}
    efficiency_fraction::Dict{String,Float64}
    capacity_factor::Dict{String,Float64}
    emission_factor_tco2_per_mwh::Dict{String,Float64}
    fuel_price_usd_per_mwh::Dict{Tuple{String,Int},Float64}
    fuel_import_share::Dict{String,Float64}
    technology_fuel::Dict{String,String}
    existing_capacity_2024_mw::Dict{String,Float64}
    retirement_year_by_tech::Dict{String,Int}
    demand_by_service::Dict{Tuple{String,Int},Float64}
    max_potential_mw::Dict{String,Float64}
    max_buildrate_mw_per_year::Dict{String,Float64}
    carbon_price_usd_per_tonne_co2::Dict{Int,Float64}
    re_target_share::Dict{Int,Float64}
    renewable_share_cap_2050::Float64
    scenario_name::String
    is_nze::Bool
    transport_electrification_target_2050::Float64
    biomethane_cooking_target_2050::Float64
    ev_sales_share_target_2040::Float64
    green_ammonia_target_2050::Float64
    cement_ccs_target_2050::Float64
    electrolyser_capacity_mw_2040::Float64
    battery_storage_target_mw_2050::Float64
    negative_emissions_target_mt_2050::Float64
    gas_gwp::Dict{String, Float64}
    gas_emission_factor_tonnes_per_mwh::Dict{Tuple{String, String}, Float64}
    sector_by_technology::Dict{String, String}
    negative_emission_potential_tco2eq::Dict{Int, Float64}
    negative_emission_cost_usd_per_tonne_co2::Dict{String, Float64}
    province_demand_share::Dict{Tuple{String, Int}, Float64}
    provincial_solar_potential_gw::Dict{String, Float64}
    provincial_wind_potential_gw::Dict{String, Float64}
    provincial_hydro_potential_gw::Dict{String, Float64}
    transmission_capacity_mw::Dict{Tuple{String, String}, Float64}
    transmission_distance_km::Dict{Tuple{String, String}, Float64}
    climate_feedback_enabled::Bool
    climate_pathway::String
    temperature_anomaly_c::Dict{Int, Float64}
end

function _interp_temperature(pathway::String, years::Vector{Int})
    target_2050 = pathway == "RCP2_6" ? 0.7 : pathway == "RCP8_5" ? 2.3 : 1.4
    return Dict(y => target_2050 * (y - first(years)) / (last(years) - first(years)) for y in years)
end

"""Build model parameters from config and scenario."""
function build_parameters(sets::ModelSets, scenario_config::AbstractDict, constraints_config::AbstractDict, technology_config::AbstractDict, existing_config::AbstractDict, selected_scenario::String)::ModelParameters
    sc = scenario_config["scenarios"][selected_scenario]
    r = Float64(scenario_config["global"]["social_discount_rate"])
    y0 = first(sets.years)
    discount_factor = Dict(y => 1/(1+r)^(y-y0) for y in sets.years)
    capex_usd_per_mw = Dict{String,Float64}(); fixed_om_usd_per_mw_yr = Dict{String,Float64}(); var_om_usd_per_mwh = Dict{String,Float64}(); efficiency_fraction=Dict{String,Float64}(); capacity_factor=Dict{String,Float64}(); emission_factor_tco2_per_mwh=Dict{String,Float64}(); sector_by_technology=Dict{String,String}()
    for row in technology_config["technologies"]
        t=String(row["name"]); capex_usd_per_mw[t]=Float64(row["capex_usd_per_kw"]) * 1000.0 ; fixed_om_usd_per_mw_yr[t]=Float64(row["fixed_om_usd_per_kw_yr"]) * 1000.0 ; var_om_usd_per_mwh[t]=Float64(row["var_om_usd_per_mwh"]) ; efficiency_fraction[t]=Float64(row["efficiency_fraction"]) ; capacity_factor[t]=Float64(row["capacity_factor"]) ; emission_factor_tco2_per_mwh[t]=Float64(row["emission_factor_tco2_per_mwh"]) ; sector_by_technology[t]=String(get(row,"sector","power"))
    end
    capex_usd_per_mw["beccs_power"] = 4500.0 * 1000.0; fixed_om_usd_per_mw_yr["beccs_power"] = 90.0 * 1000.0; var_om_usd_per_mwh["beccs_power"] = 18.0; efficiency_fraction["beccs_power"] = 0.85; capacity_factor["beccs_power"] = 0.85; emission_factor_tco2_per_mwh["beccs_power"] = -1.1; sector_by_technology["beccs_power"] = "power"
    capex_usd_per_mw["dac"] = 1100.0 * 1000.0; fixed_om_usd_per_mw_yr["dac"] = 50.0 * 1000.0; var_om_usd_per_mwh["dac"] = 0.0; efficiency_fraction["dac"] = 1.0; capacity_factor["dac"] = 0.90; emission_factor_tco2_per_mwh["dac"] = -1.0; sector_by_technology["dac"] = "industry"

    fuel_price_usd_per_mwh=Dict{Tuple{String,Int},Float64}()
    for y in sets.years
        fuel_price_usd_per_mwh[("coal",y)] = 18.0 + (12.0-18.0)*(y-2024)/(2050-2024)
        fuel_price_usd_per_mwh[("gas",y)] = 47.0 + (36.0-47.0)*(y-2024)/(2050-2024)
        fuel_price_usd_per_mwh[("oil",y)] = 51.0 + (41.0-51.0)*(y-2024)/(2050-2024)
        fuel_price_usd_per_mwh[("biomass",y)] = 18.0
        fuel_price_usd_per_mwh[("uranium",y)] = 10.0
        fuel_price_usd_per_mwh[("hydrogen",y)] = max(80.0-1.4*(y-2024),32.0)
        fuel_price_usd_per_mwh[("electricity",y)] = 95.0
    end
    fuel_import_share = Dict{String,Float64}(
        # fuel_import_share values from OGRA Petroleum Sector Outlook 2024 and PPIS Annual Report.
        # Gas import share assumes ~60% domestic production and ~40% LNG imports.
        # Coal import share assumes growing Thar domestic contribution.
        "gas" => 0.4,
        "coal" => 0.55,
        "oil" => 0.8,
        "uranium" => 1.0,
        "biomass" => 0.0,
        "hydrogen" => 0.0,
        "electricity" => 0.0,
    )
    technology_fuel = Dict{String,String}(
        "coal_imported" => "coal",
        "thar_coal_domestic" => "coal",
        "rlng_ccgt" => "gas",
        "oil_thermal" => "oil",
        "nuclear_k2_k3" => "uranium",
        "green_h2_peaker" => "hydrogen",
        "beccs_power" => "biomass",
    )
    existing_capacity_2024_mw = Dict{String,Float64}()
    raw_existing = get(existing_config, "existing_capacity_2024_gw", Dict{Any,Any}())
    for (k, v) in raw_existing
        existing_capacity_2024_mw[String(k)] = Float64(v) * 1000.0
    end
    retirement_year_by_tech = Dict{String,Int}()
    rs = get(existing_config, "retirement_schedule", Dict{Any,Any}())
    scenario_retirement = get(rs, selected_scenario, Dict{Any,Any}())
    for (k, v) in scenario_retirement
        retirement_year_by_tech[String(k)] = Int(v)
    end

    demand_by_service=Dict{Tuple{String,Int},Float64}()
    for (s,v) in technology_config["service_demands"]
        g=startswith(String(s),"electricity") ? 0.035 : 0.022
        for y in sets.years demand_by_service[(String(s),y)] = Float64(v)*(1+g)^(y-y0) end
    end
    demand_by_service[("buildings_space_cooling_pj", y0)] = 240.0
    for y in sets.years[2:end]
      demand_by_service[("buildings_space_cooling_pj", y)] = demand_by_service[("buildings_space_cooling_pj", y-1)] * 1.03
    end

    max_potential_mw=Dict(t=>1e9 for t in sets.technologies); max_buildrate_mw_per_year=Dict(t=>1e9 for t in sets.technologies)
    for (t,vals) in constraints_config["build_limits"]
        max_potential_mw[String(t)] = Float64(vals["max_potential_gw"]) * 1000.0; max_buildrate_mw_per_year[String(t)] = Float64(vals["max_buildrate_gw_per_year"]) * 1000.0
    end
    max_potential_mw["beccs_power"] = 10.0 * 1000.0
    max_potential_mw["dac"] = 12.0 * 1000.0

    carbon=Float64(get(sc,"carbon_price_usd_per_tco2",0.0)); carbon_price_usd_per_tonne_co2=Dict(y=>carbon for y in sets.years)
    re2050=Float64(get(sc,"renewable_target_2050",0.45)); re_target_share=Dict{Int,Float64}();
    renewable_share_cap_2050 = Float64(get(sc, "renewable_share_cap_2050", 1.0))
    for y in sets.years re_target_share[y]=0.30+(y-y0)/(last(sets.years)-y0)*(re2050-0.30) end

    gas_gwp = Dict("CO2"=>1.0, "CH4"=>27.9, "N2O"=>273.0, "HFC"=>1530.0, "PFC"=>6630.0, "SF6"=>25200.0)
    gas_emission_factor_tonnes_per_mwh = Dict{Tuple{String, String}, Float64}()
    for g in sets.greenhouse_gases, t in sets.technologies
        base = max(get(emission_factor_tco2_per_mwh, t, 0.0), 0.0)
        gas_emission_factor_tonnes_per_mwh[(g, t)] = g == "CO2" ? base : 0.0
    end
    gas_emission_factor_tonnes_per_mwh[("CH4","rlng_ccgt")] = 2.0e-5
    gas_emission_factor_tonnes_per_mwh[("N2O","thar_coal_domestic")] = 1.5e-6
    gas_emission_factor_tonnes_per_mwh[("N2O","coal_imported")] = 1.2e-6
    gas_emission_factor_tonnes_per_mwh[("HFC","electricity")] = 1.0e-8

    neg_ceiling_2050 = Float64(get(sc, "negative_emissions_ceiling_mt_2050", 15.0))
    negative_emission_potential_tco2eq = Dict{Int, Float64}(y => (y < 2045 ? 0.0 : neg_ceiling_2050 * (y - 2044) / (2050 - 2044)) * 1e6 for y in sets.years)
    negative_emission_cost_usd_per_tonne_co2 = Dict("beccs_power"=>140.0, "dac"=>50.0)

    shares_2024 = Dict("Punjab"=>0.62, "Sindh"=>0.22, "KPK"=>0.08, "Balochistan"=>0.04, "GB"=>0.005, "AJK"=>0.005, "Islamabad"=>0.03)
    province_demand_share = Dict{Tuple{String, Int}, Float64}((p, y) => shares_2024[p] for p in sets.provinces for y in sets.years)

    provincial_solar_potential_gw = Dict("Punjab"=>25.0, "Sindh"=>50.0, "KPK"=>8.0, "Balochistan"=>40.0, "GB"=>4.0, "AJK"=>1.0, "Islamabad"=>0.2)
    provincial_wind_potential_gw = Dict("Punjab"=>0.1, "Sindh"=>30.0, "KPK"=>3.0, "Balochistan"=>12.0, "GB"=>0.1, "AJK"=>0.1, "Islamabad"=>0.05)
    provincial_hydro_potential_gw = Dict("Punjab"=>3.0, "Sindh"=>0.1, "KPK"=>24.0, "Balochistan"=>0.1, "GB"=>22.0, "AJK"=>4.0, "Islamabad"=>0.05)

    transmission_capacity_mw = Dict{Tuple{String, String}, Float64}(); transmission_distance_km = Dict{Tuple{String, String}, Float64}()
    for p1 in sets.provinces, p2 in sets.provinces
        if p1 != p2
            transmission_capacity_mw[(p1,p2)] = 4000.0
            transmission_distance_km[(p1,p2)] = 450.0
        end
    end

    climate_cfg = get(scenario_config["global"], "climate_feedback", Dict{Any,Any}())
    climate_feedback_enabled = Bool(get(climate_cfg, "enabled", true))
    climate_pathway = String(get(climate_cfg, "temperature_anomaly_pathway", "RCP4_5"))
    temperature_anomaly_c = _interp_temperature(climate_pathway, sets.years)

    ModelParameters(discount_factor,capex_usd_per_mw,fixed_om_usd_per_mw_yr,var_om_usd_per_mwh,efficiency_fraction,capacity_factor,emission_factor_tco2_per_mwh,fuel_price_usd_per_mwh,fuel_import_share,technology_fuel,existing_capacity_2024_mw,retirement_year_by_tech,demand_by_service,max_potential_mw,max_buildrate_mw_per_year,carbon_price_usd_per_tonne_co2,re_target_share,renewable_share_cap_2050,selected_scenario,Bool(get(sc,"net_zero_2050",false)),Float64(get(sc,"transport_electrification_target_2050",0.35)),Float64(get(sc,"biomethane_cooking_target_2050",0.2)),Float64(get(sc,"ev_sales_share_target_2040",0.5)),Float64(get(sc,"green_ammonia_target_2050",0.5)),Float64(get(sc,"cement_ccs_target_2050",0.4)),Float64(get(sc,"electrolyser_capacity_gw_2040",0.0))*1000.0,Float64(get(sc,"battery_storage_target_gw_2050",0.0))*1000.0,Float64(get(sc,"negative_emissions_target_mt_2050",0.0)),gas_gwp,gas_emission_factor_tonnes_per_mwh,sector_by_technology,negative_emission_potential_tco2eq,negative_emission_cost_usd_per_tonne_co2,province_demand_share,provincial_solar_potential_gw,provincial_wind_potential_gw,provincial_hydro_potential_gw,transmission_capacity_mw,transmission_distance_km,climate_feedback_enabled,climate_pathway,temperature_anomaly_c)
end
