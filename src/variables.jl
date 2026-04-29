using JuMP
"""Add JuMP decision variables."""
function add_variables!(model::Model, sets::ModelSets)
    @variable(model, new_capacity_gw[t in sets.technologies, y in sets.years] >= 0)
    @variable(model, installed_capacity_gw[t in sets.technologies, y in sets.years] >= 0)
    @variable(model, activity_mwh[t in sets.technologies, y in sets.years, s in sets.slices] >= 0)
    @variable(model, annual_activity_mwh[t in sets.technologies, y in sets.years] >= 0)
    @variable(model, fuel_use_mwh[f in sets.fuels, y in sets.years] >= 0)
    @variable(model, emissions_mtco2[t in sets.technologies, y in sets.years])
    @variable(model, gas_emissions_mt[g in sets.greenhouse_gases, t in sets.technologies, y in sets.years] >= 0)
    @variable(model, negative_emissions_mtco2[t in sets.technologies, y in sets.years] >= 0)

    @variable(model, province_generation_mwh[p in sets.provinces, t in sets.technologies, y in sets.years, s in sets.slices] >= 0)
    @variable(model, transmission_flow_mwh[p_from in sets.provinces, p_to in sets.provinces, y in sets.years, s in sets.slices] >= 0)
    @variable(model, transmission_expansion_mwkm[p_from in sets.provinces, p_to in sets.provinces, y in sets.years] >= 0)

    @variable(model, transport_electricity_share[y in sets.years] >= 0, upper_bound=1)
    @variable(model, cooking_biomethane_share[y in sets.years] >= 0, upper_bound=1)
    @variable(model, ev_sales_share[y in sets.years] >= 0, upper_bound=1)
    @variable(model, green_ammonia_share[y in sets.years] >= 0, upper_bound=1)
    @variable(model, cement_ccs_share[y in sets.years] >= 0, upper_bound=1)
    @variable(model, electrolyser_capacity_gw[y in sets.years] >= 0)
end
