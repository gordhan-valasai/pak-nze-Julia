using JuMP
"""Add annual and service-level energy balance constraints."""
function add_balance_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, [t in sets.technologies, y in sets.years], model[:annual_activity_mwh][t,y] == sum(model[:activity_mwh][t,y,s] for s in sets.slices))
    @constraint(model, [y in sets.years], sum(model[:annual_activity_mwh][t,y] for t in sets.technologies if t in ["hydro_run_of_river","hydro_reservoir","nuclear_k2_k3","thar_coal_domestic","coal_imported","rlng_ccgt","oil_thermal","solar_utility","solar_distributed","onshore_wind","offshore_wind","green_h2_peaker"]) == params.demand_by_service[("electricity_grid_gwh",y)]*1000)
    for s in sets.service_demands
        s == "electricity_grid_gwh" && continue
        @constraint(model, [y in sets.years], sum(model[:annual_activity_mwh][t,y] for t in sets.technologies) >= params.demand_by_service[(s,y)])
    end
    @constraint(
        model,
        [f in sets.fuels, y in sets.years],
        model[:fuel_import_mwh][f, y] == get(params.fuel_import_share, f, 0.0) * model[:fuel_use_mwh][f, y]
    )
    @constraint(
        model,
        [f in sets.fuels, y in sets.years],
        model[:fuel_use_mwh][f, y] ==
            sum(
                model[:annual_activity_mwh][t, y] / max(get(params.efficiency_fraction, t, 1.0), 1e-6)
                for t in sets.technologies if get(params.technology_fuel, t, "") == f
            )
    )
end
