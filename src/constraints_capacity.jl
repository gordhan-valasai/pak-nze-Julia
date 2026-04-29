using JuMP
"""Add capacity accumulation and expansion constraints."""
function add_capacity_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    y0=first(sets.years)
    @constraint(model, [t in sets.technologies], model[:installed_capacity_gw][t,y0] == model[:new_capacity_gw][t,y0])
    @constraint(model, [t in sets.technologies, y in sets.years[2:end]], model[:installed_capacity_gw][t,y] == model[:installed_capacity_gw][t,y-1] + model[:new_capacity_gw][t,y])
    @constraint(model, [t in sets.technologies, y in sets.years], model[:annual_activity_mwh][t,y] <= model[:installed_capacity_gw][t,y]*params.capacity_factor[t]*8760)
    @constraint(model, [t in sets.technologies, y in sets.years], model[:new_capacity_gw][t,y] <= params.max_buildrate_gw_per_year[t])
    @constraint(model, [t in sets.technologies, y in sets.years], model[:installed_capacity_gw][t,y] <= params.max_potential_gw[t])
    if "battery_storage_4h" in sets.technologies
        @constraint(model, [y in sets.years], model[:new_capacity_gw]["battery_storage_4h", y] == 0.0)
        @constraint(model, [y in sets.years], model[:installed_capacity_gw]["battery_storage_4h", y] == 0.0)
        @constraint(model, [y in sets.years], model[:annual_activity_mwh]["battery_storage_4h", y] == 0.0)
    end

    y0_b = first(sets.years)
    @constraint(model, [p in sets.provinces], model[:battery_capacity_mw][p, y0_b] == model[:battery_new_capacity_mw][p, y0_b])
    @constraint(model, [p in sets.provinces, y in sets.years[2:end]], model[:battery_capacity_mw][p, y] == model[:battery_capacity_mw][p, y-1] + model[:battery_new_capacity_mw][p, y])
    for y in sets.years
        y>=2024 && @constraint(model, model[:new_capacity_gw]["coal_imported",y] == 0)
        y>=2024 && @constraint(model, model[:new_capacity_gw]["oil_thermal",y] == 0)
    end
    @constraint(model, [y in sets.years], sum(model[:annual_activity_mwh][t,y] for t in sets.renewable_technologies) >= params.re_target_share[y] * sum(model[:annual_activity_mwh][t,y] for t in sets.technologies))
end
