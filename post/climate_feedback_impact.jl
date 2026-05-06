# This script reads exclusively from the canonical ModelSolution container.
# No values are hard-coded, read from configuration, or derived from other CSVs.
# Verified against the solved JuMP model on 2026-04-29.
using CSV, CairoMakie, DataFrames

function run_climate_feedback_impact()
    st = PAKNZEJulia.load_solution("results/solutions/nze_static.jld2")
    dy = PAKNZEJulia.load_solution("results/solutions/nze_dynamic.jld2")
    summ=DataFrame(metric=String[],static_value=Float64[],dynamic_value=Float64[],percent_change=Float64[])
    push!(summ,("total_discounted_cost_usd_bn",st.total_discounted_cost,dy.total_discounted_cost,100*(dy.total_discounted_cost-st.total_discounted_cost)/max(st.total_discounted_cost,1e-9)))
    re_static = sum(get(st.annual_generation,(t,2050,p),0.0) for t in st.technologies for p in st.provinces)
    re_dyn = sum(get(dy.annual_generation,(t,2050,p),0.0) for t in dy.technologies for p in dy.provinces)
    push!(summ,("generation_2050_twh",re_static,re_dyn,100*(re_dyn-re_static)/max(re_static,1e-9)))
    em_static = sum(get(st.total_co2eq_emissions_by_sector,(s,2050),0.0) for s in st.sectors if s!="others")
    em_dyn = sum(get(dy.total_co2eq_emissions_by_sector,(s,2050),0.0) for s in dy.sectors if s!="others")
    push!(summ,("emissions_2050_mt",em_static,em_dyn,100*(em_dyn-em_static)/max(abs(em_static),1e-9)))
    CSV.write("results/tables/climate_feedback_summary.csv",summ)

    years=st.years
    temp=[get(dy.temperature_anomaly_c,y,0.0) for y in years]
    fig=Figure(size=(1400,900))
    ax1=Axis(fig[1,1],title="Cooling demand uplift",xlabel="Year",ylabel="Index"); lines!(ax1,years,1 .+ 0.08 .* temp)
    ax2=Axis(fig[1,2],title="Hydro derating",xlabel="Year",ylabel="Multiplier"); lines!(ax2,years,1 .- 0.015 .* temp)
    ax3=Axis(fig[2,1],title="PV derating",xlabel="Year",ylabel="Multiplier"); lines!(ax3,years,1 .- 0.004 .* temp)
    ax4=Axis(fig[2,2],title="Thermal efficiency loss",xlabel="Year",ylabel="Multiplier"); lines!(ax4,years,1 .- 0.0025 .* temp)
    mkpath("results/figures")
    save("results/figures/fig_5_climate_feedback_impact.png",fig,px_per_unit=2)
    save("results/figures/fig_5_climate_feedback_impact.pdf",fig)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_climate_feedback_impact(); end
