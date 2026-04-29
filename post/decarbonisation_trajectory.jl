using CSV, CairoMakie, DataFrames
"""Generate sectoral decarbonisation trajectory outputs."""
function run_decarbonisation_trajectory()
  y=collect(2024:2050); sec=["power","transport","industry","buildings","agriculture"]; out=DataFrame(year=Int[],sector=String[],emissions_mtco2=Float64[])
  for s in sec, yy in y
    base=s=="power" ? 110.0 : s=="transport" ? 65.0 : s=="industry" ? 72.0 : s=="buildings" ? 40.0 : 22.0; d=s=="industry" ? 1.5 : 2.2; push!(out,(yy,s,max(base-d*(yy-2024),s=="industry" ? 8.0 : 0.5)))
  end
  mkpath("results/tables"); CSV.write("results/tables/decarbonisation_trajectory.csv",out)
  fig=Figure(size=(1300,700)); ax=Axis(fig[1,1],title="Decarbonisation Trajectory by Sector",xlabel="Year",ylabel="MtCO2"); for s in sec; sub=out[out.sector.==s,:]; lines!(ax,sub.year,sub.emissions_mtco2,label=s); end; axislegend(ax,position=:rt)
  mkpath("results/figures"); save("results/figures/decarbonisation_trajectory.png",fig,px_per_unit=2); save("results/figures/decarbonisation_trajectory.pdf",fig)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_decarbonisation_trajectory(); end
