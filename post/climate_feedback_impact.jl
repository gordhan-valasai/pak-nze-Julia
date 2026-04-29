using CSV, CairoMakie, DataFrames
function run_climate_feedback_impact()
    st=CSV.read("results/tables/nze_static_summary.csv",DataFrame); dy=CSV.read("results/tables/nze_dynamic_summary.csv",DataFrame)
    summ=DataFrame(metric=String[],static_value=Float64[],dynamic_value=Float64[],percent_change=Float64[])
    push!(summ,("total_discounted_cost_usd",st.objective_usd[1],dy.objective_usd[1],100*(dy.objective_usd[1]-st.objective_usd[1])/st.objective_usd[1]))
    push!(summ,("re_share_2050",st.re_share_2050[1],dy.re_share_2050[1],100*(dy.re_share_2050[1]-st.re_share_2050[1])/max(st.re_share_2050[1],1e-9)))
    push!(summ,("emissions_2050_mt",st.emissions_2050_mt[1],dy.emissions_2050_mt[1],100*(dy.emissions_2050_mt[1]-st.emissions_2050_mt[1])/max(abs(st.emissions_2050_mt[1]),1e-9)))
    CSV.write("results/tables/climate_feedback_summary.csv",summ)
    years=2024:2050
    fig=Figure(size=(1400,900))
    ax1=Axis(fig[1,1],title="Cooling demand uplift",xlabel="Year",ylabel="Index"); lines!(ax1,years,[1+0.085*1.4*(y-2024)/(2050-2024) for y in years])
    ax2=Axis(fig[1,2],title="Hydro derating",xlabel="Year",ylabel="Multiplier"); lines!(ax2,years,[1-0.015*1.4*(y-2024)/(2050-2024) for y in years])
    ax3=Axis(fig[2,1],title="PV derating",xlabel="Year",ylabel="Multiplier"); lines!(ax3,years,[1-0.004*1.4*(y-2024)/(2050-2024) for y in years])
    ax4=Axis(fig[2,2],title="Thermal efficiency loss",xlabel="Year",ylabel="Multiplier"); lines!(ax4,years,[1-0.0025*1.4*(y-2024)/(2050-2024) for y in years])
    mkpath("results/figures"); save("results/figures/climate_feedback_impact.png",fig,px_per_unit=2); save("results/figures/climate_feedback_impact.pdf",fig)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_climate_feedback_impact(); end
