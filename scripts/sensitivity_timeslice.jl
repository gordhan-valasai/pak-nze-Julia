using CSV, DataFrames, Dates, JuMP, HiGHS, YAML
include("../src/PAKNZEJulia.jl")
using .PAKNZEJulia

function make_slices(n::Int)
    if n == 24
        seasons = ["spring","summer","monsoon","winter"]
        blocks = ["d1","d2","d3","d4","d5","d6"]
    elseif n == 48
        seasons = ["spring","summer","monsoon","winter"]
        blocks = ["d$(i)" for i in 1:12]
    elseif n == 96
        seasons = ["m$(i)" for i in 1:12]
        blocks = ["d$(i)" for i in 1:8]
    else
        error("Unsupported slice count")
    end
    return ["$(s)_$(b)" for s in seasons for b in blocks]
end

function run_case(n::Int)
    sc = YAML.load_file("config/scenarios.yaml")
    tc = YAML.load_file("config/technologies.yaml")
    cc = YAML.load_file("config/constraints.yaml")
    ec = YAML.load_file("config/existing_capacity.yaml")
    sc["global"]["representative_slices"] = make_slices(n)

    sets = build_sets(sc, tc)
    params = build_parameters(sets, sc, cc, tc, ec, "NZE")
    apply_climate_feedback!(params, sets)

    model = Model(HiGHS.Optimizer)
    t0 = time()
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
    solve_time = time() - t0

    cap = model[:installed_capacity_gw]
    solar_mw = value(cap["solar_utility",2050]) + value(cap["solar_distributed",2050])
    battery_mw = sum(value(model[:battery_capacity_mw][p,2050]) for p in sets.provinces)
    cost_bn = objective_value(model) / 1e9
    return (timeslices=n, solar_pv_gw=solar_mw/1000.0, battery_storage_gw=battery_mw/1000.0, total_system_cost_usd_bn=cost_bn, solve_time_s=solve_time)
end

mkpath("results/tables")
rows = DataFrame([run_case(24), run_case(48), run_case(96)])
CSV.write("results/tables/timeslice_sensitivity.csv", rows)
println("Wrote results/tables/timeslice_sensitivity.csv")
