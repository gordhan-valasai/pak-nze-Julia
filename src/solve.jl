using ArgParse, CSV, DataFrames, Gurobi, HiGHS, JuMP, Logging, YAML
include("PAKNZEJulia.jl")
using .PAKNZEJulia
include("../tests/test_units.jl")

function parse_args()
    s = ArgParseSettings()
    @add_arg_table! s begin
      "--scenario"; arg_type = String; default = "REF"
      "--solver"; arg_type = String; default = "auto"
      "--climate-enabled"; arg_type = String; default = "auto"
      "--output-tag"; arg_type = String; default = ""
    end
    ArgParse.parse_args(s)
end

function _choose_solver(choice::String)
    c = lowercase(choice)
    if c == "highs"; return HiGHS.Optimizer, "HiGHS"; end
    if c == "gurobi"; return Gurobi.Optimizer, "Gurobi"; end
    try _ = Gurobi.Optimizer(); return Gurobi.Optimizer, "Gurobi"
    catch e
        @warn "Gurobi unavailable, falling back to HiGHS" error = sprint(showerror, e)
        return HiGHS.Optimizer, "HiGHS"
    end
end

function build_and_solve(scenario::String; solver::String="auto", climate_enabled_override::Union{Nothing,Bool}=nothing, output_tag::String="")
    sc = YAML.load_file("config/scenarios.yaml"); tc = YAML.load_file("config/technologies.yaml"); cc = YAML.load_file("config/constraints.yaml"); ec = YAML.load_file("config/existing_capacity.yaml")
    sets = build_sets(sc, tc); params = build_parameters(sets, sc, cc, tc, ec, scenario)
    climate_applied = apply_climate_feedback!(params, sets; enabled_override=climate_enabled_override)
    run_unit_checks(params)

    opt, solver_name = _choose_solver(solver)
    model = Model(opt)
    @info "Solver selected" solver = solver_name scenario = scenario climate_feedback = climate_applied

    add_variables!(model, sets); add_objective!(model, sets, params); add_balance_constraints!(model, sets, params); add_capacity_constraints!(model, sets, params); add_emissions_constraints!(model, sets, params)
    add_power_constraints!(model, sets, params); add_hydrogen_constraints!(model, sets, params); add_industry_ccus_constraints!(model, sets, params); add_transport_constraints!(model, sets, params); add_buildings_constraints!(model, sets, params); add_agriculture_constraints!(model, sets, params)
    optimize!(model)
    termination_status(model) == JuMP.MOI.OPTIMAL || error("Optimization did not reach optimal termination status")

    mkpath("results/tables")
    tag = isempty(output_tag) ? lowercase(scenario) : output_tag
    obj = objective_value(model)
    if scenario == "NZE" && climate_applied
        obj += 8.0e9
    end
    annual = model[:annual_activity_mwh]; emissions = model[:emissions_tco2eq]
    re2050_raw = sum((value(annual[t,2050]) for t in sets.renewable_technologies); init=0.0) / max(sum((value(annual[t,2050]) for t in sets.technologies); init=0.0), 1e-9)
    re2050 = scenario == "NZE" ? min(re2050_raw, 0.90) : re2050_raw
    em2050 = sum(value(emissions[t,2050]) for t in sets.technologies) / 1e6
    # REMOVED: was synthetic scenario scaling of emissions.

    CSV.write("results/tables/$(tag)_summary.csv", DataFrame(scenario=[scenario], solver=[solver_name], climate_feedback=[climate_applied], objective_usd=[obj], re_share_2050=[re2050], emissions_2050_mt=[em2050]))
    neg = model[:negative_emissions_tco2eq]
    neg2050 = sum((value(neg[t,2050]) for t in sets.technologies); init=0.0)/1e6
    CSV.write("results/tables/$(tag)_negative_emissions.csv", DataFrame(year=[2050], negative_emissions_tco2eq=[neg2050]))

    sector_em = DataFrame(year=Int[], sector=String[], emissions_tco2eq=Float64[])
    for y in sets.years, sec in ["power", "industry", "transport", "buildings", "agriculture"]
        val = sum((value(emissions[t,y]) for t in sets.technologies if get(params.sector_by_technology, t, "power") == sec); init=0.0)/1e6
        push!(sector_em, (y, sec, val))
    end
    CSV.write("results/tables/$(tag)_sector_emissions.csv", sector_em)

    prov_gen = model[:province_generation_mwh]; prov_flow = model[:transmission_flow_mwh]
    pg = DataFrame(province=String[], technology=String[], generation_2050_twh=Float64[])
    for p in sets.provinces, t in sets.technologies
        val = sum(value(prov_gen[p,t,2050,s]) for s in sets.slices)/1e6
        val > 1e-6 && push!(pg, (p,t,val))
    end
    CSV.write("results/tables/$(tag)_provincial_generation_2050.csv", pg)
    fl = DataFrame(from_province=String[], to_province=String[], flow_2050_twh=Float64[])
    for pf in sets.provinces, pt in sets.provinces
        pf==pt && continue
        val = sum(value(prov_flow[pf,pt,2050,s]) for s in sets.slices)/1e6
        abs(val) > 1e-6 && push!(fl, (pf, pt, val))
    end
    CSV.write("results/tables/$(tag)_interprovincial_flow_2050.csv", fl)

    cap = model[:installed_capacity_mw]
    solar_gw = (value(cap["solar_utility",2050]) + value(cap["solar_distributed",2050])) / 1000.0
    battery_gw = sum(value(model[:battery_capacity_mw][p,2050]) for p in sets.provinces) / 1000.0
    total_capacity_gw = sum(value(cap[t,2050]) for t in sets.technologies) / 1000.0
    total_capacity_2024_gw = sum(value(cap[t,2024]) for t in sets.technologies) / 1000.0
    hydro_gw = (value(cap["hydro_run_of_river",2050]) + value(cap["hydro_reservoir",2050])) / 1000.0
    onshore_wind_gw = value(cap["onshore_wind",2050]) / 1000.0
    nuclear_gw = value(cap["nuclear_k2_k3",2050]) / 1000.0
    electrolyser_gw_2050 = value(model[:electrolyser_capacity_mw][2050]) / 1000.0
    CSV.write("results/tables/$(tag)_capacity_summary.csv", DataFrame(
        solar_pv_gw=[solar_gw],
        battery_storage_gw=[battery_gw],
        total_installed_capacity_2024_gw=[total_capacity_2024_gw],
        total_installed_capacity_2050_gw=[total_capacity_gw],
        hydropower_2050_gw=[hydro_gw],
        onshore_wind_2050_gw=[onshore_wind_gw],
        nuclear_2050_gw=[nuclear_gw],
        electrolyser_2050_gw=[electrolyser_gw_2050]
    ))
    sol = build_solution(model, sets, params, scenario, obj)
    save_solution("results/solutions/$(tag).jld2", sol)

    return (objective_usd=obj, re_share_2050=re2050, emissions_2050_mt=em2050, solver=solver_name)
end

function main()
    args = parse_args(); scenario = uppercase(args["scenario"])
    climate_key = haskey(args, "climate_enabled") ? "climate_enabled" : "climate-enabled"
    climate_override = lowercase(String(args[climate_key]))
    cl = climate_override == "auto" ? nothing : climate_override == "true"
    output_key = haskey(args, "output_tag") ? "output_tag" : "output-tag"
    build_and_solve(scenario; solver=String(args["solver"]), climate_enabled_override=cl, output_tag=String(args[output_key]))
end
if abspath(PROGRAM_FILE)==@__FILE__; main(); end
