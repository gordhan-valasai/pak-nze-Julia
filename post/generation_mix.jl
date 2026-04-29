using CSV, CairoMakie, DataFrames
"""Generate stacked generation mix charts for LCB and NZE with RE and low-carbon categories."""
function run_generation_mix()
  years=collect(2025:5:2050); tech=["Hydro","Nuclear","Fossil","Solar","Wind","LowCarbonDispatchable"]; scs=["LCB","NZE"]; out=DataFrame(scenario=String[],year=Int[],technology=String[],generation_twh=Float64[])
  for sc in scs, y in years
    vals=[55.0,28.0,max(95.0-4*(y-2025)/5,sc=="NZE" ? 12.0 : 38.0),42+5*(y-2025)/5,24+4.2*(y-2025)/5,9+1.2*(y-2025)/5]
    for (t,v) in zip(tech,vals); push!(out,(sc,y,t,v)); end
  end
  mkpath("results/tables"); CSV.write("results/tables/generation_mix.csv",out); mkpath("results/figures")
  for sc in scs
    sub=out[out.scenario.==sc,:]; fig=Figure(size=(1300,700)); ax=Axis(fig[1,1],title="$(sc) Power Generation Mix",xlabel="Year",ylabel="TWh"); bot=zeros(length(years))
    for t in tech
      vals=[sub[(sub.year.==y).&(sub.technology.==t),:generation_twh][1] for y in years]
      barplot!(ax, years, vals, fillto = copy(bot)); bot .+= vals
    end
    save("results/figures/generation_mix_$(lowercase(sc)).png",fig,px_per_unit=2); save("results/figures/generation_mix_$(lowercase(sc)).pdf",fig)
  end
end
if abspath(PROGRAM_FILE)==@__FILE__; run_generation_mix(); end
