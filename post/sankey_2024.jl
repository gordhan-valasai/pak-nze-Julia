using DataFrames, Parquet, PlotlyJS
"""Build FY2023-24 Sankey figure."""
function run_sankey_2024()
  df=DataFrame(read_parquet("data/processed/nepra_sankey.parquet")); nodes=unique(vcat(df.source,df.target)); idx=Dict(n=>i-1 for (i,n) in enumerate(nodes))
  fig=PlotlyJS.plot(
    PlotlyJS.sankey(
      node=PlotlyJS.attr(label=nodes,pad=15,thickness=18),
      link=PlotlyJS.attr(source=[idx[s] for s in df.source],target=[idx[t] for t in df.target],value=df.flow_pj),
    ),
    PlotlyJS.Layout(title="Pakistan Energy Flows FY2023-24"),
  )
  mkpath("results/figures"); savefig(fig,"results/figures/sankey_2024.png",width=1600,height=900,scale=2); savefig(fig,"results/figures/sankey_2024.pdf",width=1600,height=900,scale=2)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_sankey_2024(); end
