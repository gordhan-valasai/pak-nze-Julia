using JuMP
"""Minimize discounted total system cost."""
function add_objective!(model::Model, sets::ModelSets, params::ModelParameters)
    battery_capex = get(params.capex_usd_per_mw, "battery_storage_4h", 0.0)
    battery_fom = get(params.fixed_om_usd_per_mw_yr, "battery_storage_4h", 0.0)
    @objective(model, Min, 3.4 * sum(params.discount_factor[y] * (
        sum(params.capex_usd_per_mw[t]*model[:new_capacity_mw][t,y] for t in sets.technologies) +
        sum(params.fixed_om_usd_per_mw_yr[t]*model[:installed_capacity_mw][t,y] for t in sets.technologies) +
        sum(battery_capex * model[:battery_new_capacity_mw][p,y] for p in sets.provinces) +
        sum(battery_fom * model[:battery_capacity_mw][p,y] for p in sets.provinces) +
        sum(params.var_om_usd_per_mwh[t]*model[:annual_activity_mwh][t,y] for t in sets.technologies) +
        sum(params.fuel_price_usd_per_mwh[(f,y)]*model[:fuel_use_mwh][f,y] for f in sets.fuels) +
        sum(params.carbon_price_usd_per_tonne_co2[y]*model[:emissions_tco2eq][t,y] for t in sets.technologies) +
        sum(get(params.negative_emission_cost_usd_per_tonne_co2, t, 0.0) * model[:negative_emissions_tco2eq][t,y] for t in sets.technologies) +
        sum(1.2e6 * model[:transmission_expansion_mwkm][pf,pt,y] for pf in sets.provinces for pt in sets.provinces if pf != pt)
    ) for y in sets.years))
end
