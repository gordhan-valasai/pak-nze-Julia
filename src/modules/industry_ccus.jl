using JuMP
"""Industry and CCUS module constraints."""
function add_industry_ccus_constraints!(model::Model, sets::ModelSets, params::ModelParameters)
    @constraint(model, [y in sets.years[2:end]], model[:cement_ccs_share][y] >= model[:cement_ccs_share][y-1])
    @constraint(model, [y in sets.years[2:end]], model[:green_ammonia_share][y] >= model[:green_ammonia_share][y-1])
    if params.is_nze
      @constraint(model, model[:cement_ccs_share][2050] >= params.cement_ccs_target_2050)
      @constraint(model, model[:green_ammonia_share][2050] == params.green_ammonia_target_2050)
    end
end
