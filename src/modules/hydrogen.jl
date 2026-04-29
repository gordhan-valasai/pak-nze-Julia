using JuMP
"""Hydrogen module constraints."""
function add_hydrogen_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, [y in sets.years[2:end]], model[:electrolyser_capacity_gw][y] >= model[:electrolyser_capacity_gw][y-1])
    params.is_nze && @constraint(model, model[:electrolyser_capacity_gw][2040] >= params.electrolyser_capacity_gw_2040)
end
