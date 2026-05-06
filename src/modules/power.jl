using JuMP
"""Power module constraints with provincial disaggregation and transmission."""
function add_power_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    "coal_imported" in sets.technologies && @constraint(model, model[:installed_capacity_mw]["coal_imported",2050] <= 0.2*model[:installed_capacity_mw]["coal_imported",2024])
    "oil_thermal" in sets.technologies && @constraint(model, model[:installed_capacity_mw]["oil_thermal",2050] <= 0.1*model[:installed_capacity_mw]["oil_thermal",2024])
    if "offshore_wind" in sets.technologies
      for y in sets.years; y<2035 && @constraint(model, model[:new_capacity_mw]["offshore_wind",y]==0); end
    end
    if "green_h2_peaker" in sets.technologies
      for y in sets.years; y<2035 && @constraint(model, model[:new_capacity_mw]["green_h2_peaker",y]==0); end
    end

    @constraint(model, [t in sets.technologies, y in sets.years, s in sets.slices],
        sum(model[:province_generation_mwh][p,t,y,s] for p in sets.provinces) == model[:activity_mwh][t,y,s]
    )

    battery_eta = get(params.efficiency_fraction, "battery_storage_4h", 0.90)
    hours_per_slice = 8760.0 / length(sets.slices)
    battery_duration_h = 4.0

    for y in sets.years, p in sets.provinces
        for (idx, s) in enumerate(sets.slices)
            prev_s = idx == 1 ? sets.slices[end] : sets.slices[idx-1]
            @constraint(model, model[:battery_soc_mwh][p,y,s] ==
                model[:battery_soc_mwh][p,y,prev_s] +
                battery_eta * model[:battery_charge_mwh][p,y,s] -
                model[:battery_discharge_mwh][p,y,s] / battery_eta
            )
            @constraint(model, model[:battery_charge_mwh][p,y,s] <= model[:battery_capacity_mw][p,y] * hours_per_slice)
            @constraint(model, model[:battery_discharge_mwh][p,y,s] <= model[:battery_capacity_mw][p,y] * hours_per_slice)
            @constraint(model, model[:battery_soc_mwh][p,y,s] <= model[:battery_capacity_mw][p,y] * battery_duration_h)
        end
    end
    if params.is_nze && params.battery_storage_target_mw_2050 > 0
        @constraint(model, sum(model[:battery_capacity_mw][p,2050] for p in sets.provinces) >= params.battery_storage_target_mw_2050)
    end

    for y in sets.years, s in sets.slices, p in sets.provinces
        provincial_demand_slice = params.demand_by_service[("electricity_grid_gwh", y)] * 1_000.0 * params.province_demand_share[(p,y)] / length(sets.slices)
        @constraint(model,
            sum(model[:province_generation_mwh][p,t,y,s] for t in sets.technologies) +
            model[:battery_discharge_mwh][p,y,s] -
            model[:battery_charge_mwh][p,y,s] +
            sum(model[:transmission_flow_mwh][pf,p,y,s] for pf in sets.provinces if pf != p) -
            sum(model[:transmission_flow_mwh][p,pt,y,s] for pt in sets.provinces if pt != p)
            == provincial_demand_slice
        )
    end

    for pf in sets.provinces, pt in sets.provinces, y in sets.years, s in sets.slices
        if pf != pt
            cap_mwh_per_slice = (params.transmission_capacity_mw[(pf,pt)] + model[:transmission_expansion_mwkm][pf,pt,y] / max(params.transmission_distance_km[(pf,pt)], 1.0)) * (8760.0 / length(sets.slices))
            @constraint(model, model[:transmission_flow_mwh][pf,pt,y,s] <= cap_mwh_per_slice)
        else
            @constraint(model, model[:transmission_flow_mwh][pf,pt,y,s] == 0.0)
            @constraint(model, model[:transmission_expansion_mwkm][pf,pt,y] == 0.0)
        end
    end
end
