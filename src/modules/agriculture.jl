using JuMP
"""Agriculture module constraints."""
function add_agriculture_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, model[:transport_electricity_share][2050] >= 0.55)
end
