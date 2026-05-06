using JuMP
"""Add capacity accumulation and expansion constraints."""
function add_capacity_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    y0=first(sets.years)
    @constraint(model, [t in sets.technologies], model[:installed_capacity_mw][t,y0] == model[:new_capacity_mw][t,y0] - model[:retired_capacity_mw][t,y0])
    @constraint(model, [t in sets.technologies, y in sets.years[2:end]], model[:installed_capacity_mw][t,y] == model[:installed_capacity_mw][t,y-1] + model[:new_capacity_mw][t,y] - model[:retired_capacity_mw][t,y])
    @constraint(model, [t in sets.technologies, y in sets.years], model[:annual_activity_mwh][t,y] <= model[:installed_capacity_mw][t,y]*params.capacity_factor[t]*8760)
    @constraint(model, [t in sets.technologies, y in sets.years], model[:new_capacity_mw][t,y] <= params.max_buildrate_mw_per_year[t])
    @constraint(model, [t in sets.technologies, y in sets.years], model[:installed_capacity_mw][t,y] <= params.max_potential_mw[t])
    if "battery_storage_4h" in sets.technologies
        @constraint(model, [y in sets.years], model[:new_capacity_mw]["battery_storage_4h", y] == 0.0)
        @constraint(model, [y in sets.years], model[:installed_capacity_mw]["battery_storage_4h", y] == 0.0)
        @constraint(model, [y in sets.years], model[:annual_activity_mwh]["battery_storage_4h", y] == 0.0)
    end

    y0_b = first(sets.years)
    @constraint(model, [p in sets.provinces], model[:battery_capacity_mw][p, y0_b] == model[:battery_new_capacity_mw][p, y0_b])
    @constraint(model, [p in sets.provinces, y in sets.years[2:end]], model[:battery_capacity_mw][p, y] == model[:battery_capacity_mw][p, y-1] + model[:battery_new_capacity_mw][p, y])
    for y in sets.years
        y>2024 && @constraint(model, model[:new_capacity_mw]["coal_imported",y] == 0)
        y>2024 && @constraint(model, model[:new_capacity_mw]["oil_thermal",y] == 0)
    end
    for (t, cap0_mw) in params.existing_capacity_2024_mw
        t in sets.technologies || continue
        @constraint(model, model[:installed_capacity_mw][t, y0] >= cap0_mw)
        if !haskey(params.retirement_year_by_tech, t)
            @constraint(model, [y in sets.years], model[:installed_capacity_mw][t, y] >= cap0_mw)
        end
    end
    for (t, ret_year) in params.retirement_year_by_tech
        t in sets.technologies || continue
        cap0_mw = get(params.existing_capacity_2024_mw, t, 0.0)
        for y in sets.years
            if y >= ret_year
                @constraint(model, model[:installed_capacity_mw][t, y] == 0.0)
            elseif y > y0
                frac = 1.0 - (y - y0) / max(ret_year - y0, 1)
                @constraint(model, model[:installed_capacity_mw][t, y] >= cap0_mw * max(frac, 0.0))
            end
        end
    end
    @constraint(model, [y in sets.years], sum(model[:annual_activity_mwh][t,y] for t in sets.renewable_technologies) >= params.re_target_share[y] * sum(model[:annual_activity_mwh][t,y] for t in sets.technologies))
    if params.scenario_name == "LCB"
        @constraint(
            model,
            sum(model[:annual_activity_mwh][t,2050] for t in sets.renewable_technologies) <=
            params.renewable_share_cap_2050 * sum(model[:annual_activity_mwh][t,2050] for t in sets.technologies)
        )
    end
end
