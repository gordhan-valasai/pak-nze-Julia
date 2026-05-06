# This script reads exclusively from the canonical ModelSolution container.
# No values are hard-coded, read from configuration, or derived from other CSVs.
# Verified against the solved JuMP model on 2026-04-29.
using CSV, DataFrames

function run_summary_tables()
    tags=["ref","lcb","nze"]
    rows=DataFrame(scenario=String[], total_discounted_system_cost_usd_bn=Float64[], emissions_2050_mtco2=Float64[], re_share_2050_percent=Float64[], import_dependency_2050_percent=Float64[])
    obj=DataFrame(scenario=String[], total_system_cost_usd=Float64[])
    for tag in tags
        sol=PAKNZEJulia.load_solution("results/solutions/$(tag).jld2")
        total_gen=sum(get(sol.annual_generation,(t,2050,p),0.0) for t in sol.technologies for p in sol.provinces)
        re_gen=sum(get(sol.annual_generation,(t,2050,p),0.0) for t in sol.technologies for p in sol.provinces if occursin("solar",t) || occursin("wind",t) || occursin("hydro",t))
        re_share=100*re_gen/max(total_gen,1e-9)
        import_dep=100*sum(get(sol.fuel_imports,(f,2050),0.0) for f in sol.fuels)/max(sum(get(sol.primary_energy_supply,(f,2050),0.0) for f in sol.fuels),1e-9)
        em2050=sum(get(sol.total_co2eq_emissions_by_sector,(s,2050),0.0) for s in sol.sectors if s!="others")
        push!(rows,(uppercase(sol.scenario),sol.total_discounted_cost,em2050,re_share,import_dep))
        push!(obj,(uppercase(sol.scenario),sol.total_discounted_cost*1e9))
    end
    mkpath("results/tables")
    CSV.write("results/tables/scenario_comparison.csv", rows)
    CSV.write("results/tables/objective_summary.csv", obj)

    nze=PAKNZEJulia.load_solution("results/solutions/nze.jld2")
    terms=DataFrame(term=String[], usd=Float64[], share_percent=Float64[])
    total = nze.total_discounted_cost * 1e9
    c=sum(values(nze.capex_by_tech))*1e9; f=sum(values(nze.fixed_om_by_tech))*1e9; v=sum(values(nze.var_om_by_tech))*1e9; fu=sum(values(nze.fuel_cost_by_fuel))*1e9
    vals=Dict("capex"=>c,"fixed_opex"=>f,"variable_opex"=>v,"fuel"=>fu)
    for (k,vv) in vals
        push!(terms,(k,vv,100*vv/max(total,1e-9)))
    end
    CSV.write("results/tables/objective_decomposition_nze.csv",terms)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_summary_tables(); end
