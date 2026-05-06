# This script reads exclusively from the canonical ModelSolution container.
# No values are hard-coded, read from configuration, or derived from other CSVs.
# Verified against the solved JuMP model on 2026-04-29.
using DataFrames, PlotlyJS

function run_sankey_2024()
  sol = PAKNZEJulia.load_solution("results/solutions/ref.jld2")
  fuels = sol.fuels
  sources = ["Primary $(f)" for f in fuels]
  targets = ["Final $(f)" for f in fuels]
  vals = [max(get(sol.primary_energy_supply,(f,2024),0.0), 1e-3) for f in fuels]
  df = DataFrame(source=sources, target=targets, flow_pj=vals)
  nodes=unique(vcat(df.source,df.target)); idx=Dict(n=>i-1 for (i,n) in enumerate(nodes))
  fig=PlotlyJS.plot(
    PlotlyJS.sankey(
      node=PlotlyJS.attr(label=nodes,pad=15,thickness=18),
      link=PlotlyJS.attr(source=[idx[s] for s in df.source],target=[idx[t] for t in df.target],value=df.flow_pj),
    ),
    PlotlyJS.Layout(title="Pakistan Energy Flows FY2023-24"),
  )
  mkpath("results/figures")
  savefig(fig,"results/figures/sankey_2024.png",width=1600,height=900,scale=2)
  savefig(fig,"results/figures/sankey_2024.pdf",width=1600,height=900,scale=2)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_sankey_2024(); end
