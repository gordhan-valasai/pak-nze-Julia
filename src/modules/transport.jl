using JuMP
"""Transport module constraints."""
function add_transport_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, [y in sets.years[2:end]], model[:transport_electricity_share][y] >= model[:transport_electricity_share][y-1])
    @constraint(model, [y in sets.years[2:end]], model[:ev_sales_share][y] >= model[:ev_sales_share][y-1])
    @constraint(model, model[:transport_electricity_share][2050] >= params.transport_electrification_target_2050)
    params.is_nze && @constraint(model, model[:ev_sales_share][2040] >= params.ev_sales_share_target_2040)
end
