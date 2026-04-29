using CSV, CairoMakie, DataFrames
function run_provincial_outputs()
    gen=CSV.read("results/tables/nze_provincial_generation_2050.csv",DataFrame)
    flow=CSV.read("results/tables/nze_interprovincial_flow_2050.csv",DataFrame)
    CSV.write("results/tables/provincial_results.csv",gen)
    provinces=unique(gen.province); techs=unique(gen.technology)
    fig=Figure(size=(1500,800)); ax=Axis(fig[1,1],title="Provincial generation mix 2050 NZE",xlabel="Province",ylabel="TWh")
    x=1:length(provinces); base=zeros(length(provinces))
    for t in techs
      vals=[sum(gen[(gen.province.==p).&(gen.technology.==t),:generation_2050_twh]) for p in provinces]
      barplot!(ax,x,vals,fillto=copy(base)); base .+= vals
    end
    ax.xticks=(collect(x),provinces)
    mkpath("results/figures"); save("results/figures/provincial_generation_mix_2050_NZE.png",fig,px_per_unit=2); save("results/figures/provincial_generation_mix_2050_NZE.pdf",fig)

    fig2=Figure(size=(1500,800)); ax2=Axis(fig2[1,1],title="Inter-provincial flows 2050 NZE",xlabel="Route",ylabel="TWh")
    route=["$(r.from_province)->$(r.to_province)" for r in eachrow(flow)]
    vals=Float64.(collect(skipmissing(flow.flow_2050_twh)))
    if isempty(vals)
      vals=[0.0]; route=["No Net Transfers"]
    end
    barplot!(ax2,1:length(vals),vals); ax2.xticks=(collect(1:length(vals)),route)
    save("results/figures/inter_provincial_flows_2050_NZE.png",fig2,px_per_unit=2); save("results/figures/inter_provincial_flows_2050_NZE.pdf",fig2)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_provincial_outputs(); end
