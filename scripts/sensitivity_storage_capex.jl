using CSV, DataFrames, JuMP, HiGHS, YAML
include("../src/PAKNZEJulia.jl")
using .PAKNZEJulia

function run_case(label::String; multiplier::Float64=1.0, start_capex::Union{Nothing,Float64}=nothing, end_capex::Union{Nothing,Float64}=nothing)
    sc = YAML.load_file("config/scenarios.yaml")
    tc = YAML.load_file("config/technologies.yaml")
    cc = YAML.load_file("config/constraints.yaml")

    sets = build_sets(sc, tc)
    params = build_parameters(sets, sc, cc, tc, "NZE")
    apply_climate_feedback!(params, sets)

    if start_capex !== nothing && end_capex !== nothing
        frac = (2050 - 2024) / (2050 - 2024)
        params.capex_usd_per_kw["battery_storage_4h"] = start_capex + (end_capex - start_capex) * frac
    else
        params.capex_usd_per_kw["battery_storage_4h"] *= multiplier
    end

    model = Model(HiGHS.Optimizer)
    add_variables!(model, sets)
    add_objective!(model, sets, params)
    add_balance_constraints!(model, sets, params)
    add_capacity_constraints!(model, sets, params)
    add_emissions_constraints!(model, sets, params)
    add_power_constraints!(model, sets, params)
    add_hydrogen_constraints!(model, sets, params)
    add_industry_ccus_constraints!(model, sets, params)
    add_transport_constraints!(model, sets, params)
    add_buildings_constraints!(model, sets, params)
    add_agriculture_constraints!(model, sets, params)
    optimize!(model)

    cap = model[:installed_capacity_gw]
    battery = value(cap["battery_storage_4h",2050])
    return (trajectory=label, battery_storage_gw_2050=battery)
end

mkpath("results/tables")
rows = DataFrame([
    run_case("NREL ATB 2024 moderate"),
    run_case("NREL ATB 2024 conservative (+10%)"; multiplier=1.10),
    run_case("Pakistan-specific 1500->600 USD/kW"; start_capex=1500.0, end_capex=600.0),
])
CSV.write("results/tables/storage_capex_sensitivity.csv", rows)
println("Wrote results/tables/storage_capex_sensitivity.csv")
