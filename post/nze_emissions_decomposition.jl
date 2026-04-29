using CSV, CairoMakie, DataFrames
function run_nze_emissions_decomposition()
    df=CSV.read("results/tables/nze_sector_emissions.csv",DataFrame)
    sectors=["power","industry","transport","buildings","agriculture"]; years=unique(df.year)
    fig=Figure(size=(1400,800)); ax=Axis(fig[1,1], title="NZE emissions decomposition", xlabel="Year", ylabel="MtCO2-eq")
    base=zeros(length(years))
    for s in sectors
      vals=[df[(df.year.==y).&(df.sector.==s),:emissions_mtco2][1] for y in years]
      barplot!(ax, years, vals, fillto=copy(base)); base .+= vals
    end
    hlines!(ax,[0.0],color=:black)
    mkpath("results/figures"); save("results/figures/nze_emissions_decomposition.png",fig,px_per_unit=2); save("results/figures/nze_emissions_decomposition.pdf",fig)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_nze_emissions_decomposition(); end
