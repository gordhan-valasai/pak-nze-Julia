using JuMP
"""Buildings module constraints."""
function add_buildings_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, [y in sets.years[2:end]], model[:cooking_biomethane_share][y] >= model[:cooking_biomethane_share][y-1])
    params.is_nze && @constraint(model, model[:cooking_biomethane_share][2050] >= params.biomethane_cooking_target_2050)
end
