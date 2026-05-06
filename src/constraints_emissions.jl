using JuMP
"""Add emissions accounting and net-zero constraint for NZE."""
function add_emissions_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, [g in sets.greenhouse_gases, t in sets.technologies, y in sets.years],
        model[:gas_emissions_tonnes][g,t,y] == model[:annual_activity_mwh][t,y] * params.gas_emission_factor_tonnes_per_mwh[(g,t)]
    )
    @constraint(model, [t in sets.technologies, y in sets.years],
        model[:emissions_tco2eq][t,y] == sum(model[:gas_emissions_tonnes][g,t,y] * params.gas_gwp[g] for g in sets.greenhouse_gases) - model[:negative_emissions_tco2eq][t,y]
    )
    for t in sets.technologies, y in sets.years
        if !(t in ["beccs_power", "dac"])
            @constraint(model, model[:negative_emissions_tco2eq][t,y] == 0.0)
        end
    end
    @constraint(model, [y in sets.years], sum(model[:negative_emissions_tco2eq][t,y] for t in ["beccs_power", "dac"] if t in sets.technologies) <= params.negative_emission_potential_tco2eq[y])
    if params.is_nze && params.negative_emissions_target_mt_2050 > 0
        @constraint(model, sum(model[:negative_emissions_tco2eq][t,2050] for t in ["beccs_power", "dac"] if t in sets.technologies) >= params.negative_emissions_target_mt_2050 * 1e6)
    end
    if params.is_nze
        @constraint(model, sum(model[:emissions_tco2eq][t,2050] for t in sets.technologies) <= 0.0)
    end
end
