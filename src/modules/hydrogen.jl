using JuMP
"""Hydrogen module constraints."""
function add_hydrogen_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, [y in sets.years[2:end]], model[:electrolyser_capacity_mw][y] >= model[:electrolyser_capacity_mw][y-1])
    params.is_nze && @constraint(model, model[:electrolyser_capacity_mw][2040] >= params.electrolyser_capacity_mw_2040)
end
