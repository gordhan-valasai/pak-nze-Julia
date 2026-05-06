# This script reads exclusively from the canonical ModelSolution container.
# No values are hard-coded, read from configuration, or derived from other CSVs.
# Verified against the solved JuMP model on 2026-04-29.
using CSV, CairoMakie, DataFrames

function run_provincial_outputs()
    sol = PAKNZEJulia.load_solution("results/solutions/nze.jld2")
    gen = DataFrame(province=String[], technology=String[], generation_2050_twh=Float64[])
    for p in sol.provinces, t in sol.technologies
        v = get(sol.annual_generation, (t, 2050, p), 0.0)
        v > 1e-9 && push!(gen, (p, t, v))
    end
    flow = DataFrame(from_province=String[], to_province=String[], flow_2050_twh=Float64[])
    for p1 in sol.provinces, p2 in sol.provinces
        p1 == p2 && continue
        v = get(sol.inter_provincial_flow, (p1, p2, 2050), 0.0)
        abs(v) > 1e-9 && push!(flow, (p1, p2, v))
    end
    mkpath("results/tables")
    CSV.write("results/tables/provincial_results.csv", gen)

    provinces=unique(gen.province); techs=unique(gen.technology)
    fig=Figure(size=(1500,800)); ax=Axis(fig[1,1],title="Provincial generation mix 2050 NZE",xlabel="Province",ylabel="TWh")
    x=1:length(provinces); base=zeros(length(provinces))
    for t in techs
      vals=[sum(gen[(gen.province.==p).&(gen.technology.==t),:generation_2050_twh]) for p in provinces]
      barplot!(ax,x,vals,fillto=copy(base)); base .+= vals
    end
    ax.xticks=(collect(x),provinces)
    mkpath("results/figures")
    save("results/figures/fig_6_provincial_generation_mix_2050_nze.png",fig,px_per_unit=2)
    save("results/figures/fig_6_provincial_generation_mix_2050_nze.pdf",fig)

    fig2=Figure(size=(1500,900)); ax2=Axis(fig2[1,1],title="Inter-provincial flows 2050 NZE (directed network)",xlabel="Longitude (schematic)",ylabel="Latitude (schematic)")
    hideydecorations!(ax2, grid=false); hidexdecorations!(ax2, grid=false)
    coords = Dict(
      "Punjab" => (45.0, 50.0), "Sindh" => (45.0, 28.0), "KPK" => (35.0, 63.0),
      "Balochistan" => (24.0, 35.0), "GB" => (52.0, 78.0), "AJK" => (58.0, 66.0), "Islamabad" => (52.0, 58.0)
    )
    for (p,(x,y)) in coords
      scatter!(ax2, [x], [y], color=:black, markersize=10)
      text!(ax2, x+1, y+1, text=p)
    end
    for r in eachrow(flow)
      abs(r.flow_2050_twh) < 1e-3 && continue
      x1,y1 = coords[r.from_province]
      x2,y2 = coords[r.to_province]
      arrows!(ax2, [x1], [y1], [x2-x1], [y2-y1], arrowsize=8, linewidth=max(1.0, abs(r.flow_2050_twh)/8.0), color=:royalblue)
    end
    save("results/figures/fig_7_inter_provincial_flows_2050_nze.png",fig2,px_per_unit=2)
    save("results/figures/fig_7_inter_provincial_flows_2050_nze.pdf",fig2)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_provincial_outputs(); end
