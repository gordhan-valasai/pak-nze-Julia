"""Apply climate feedback parameter modifiers at model build time."""
function apply_climate_feedback!(params::ModelParameters, sets::ModelSets; enabled_override::Union{Nothing,Bool}=nothing)
    enabled = isnothing(enabled_override) ? params.climate_feedback_enabled : enabled_override
    if !enabled
        return false
    end
    for y in sets.years
        dt = params.temperature_anomaly_c[y]
        params.demand_by_service[("buildings_space_cooling_pj", y)] = get(params.demand_by_service, ("buildings_space_cooling_pj", y), 240.0) * (1 + 0.085 * dt)
        if haskey(params.demand_by_service, ("agriculture_tubewell_pj", y))
            params.demand_by_service[("agriculture_tubewell_pj", y)] *= (1 + 0.05 * dt)
        end
    end
    for t in ["hydro_run_of_river", "hydro_reservoir"]
        haskey(params.capacity_factor, t) && (params.capacity_factor[t] *= (1 - 0.015 * params.temperature_anomaly_c[2050]))
    end
    for t in ["solar_utility", "solar_distributed"]
        haskey(params.efficiency_fraction, t) && (params.efficiency_fraction[t] *= (1 - 0.004 * params.temperature_anomaly_c[2050]))
    end
    haskey(params.efficiency_fraction, "rlng_ccgt") && (params.efficiency_fraction["rlng_ccgt"] *= (1 - 0.0025 * params.temperature_anomaly_c[2050]))
    return true
end
