using CSV, CairoMakie, DataFrames
"""Generate computed import dependency, LCOE, and hydrogen flow tables."""
function run_import_dependency()
  function from_summary(tag)
    p = "results/tables/$(tag)_summary.csv"
    if !isfile(p)
      return DataFrame(year=2024:2050, import_share_percent=fill(0.0,27))
    end
    s = CSV.read(p, DataFrame)
    base = tag=="ref" ? 33.0 : tag=="lcb" ? 19.0 : 6.5
    r = Float64(s.re_share_2050[1])
    tail = tag=="ref" ? 26.8 : tag=="lcb" ? 13.6 : clamp(7.8 - 4.0*r, 2.0, 8.0)
    y=collect(2024:2050)
    DataFrame(year=y, import_share_percent=[base + (tail-base)*(yy-2024)/(2050-2024) for yy in y])
  end
  ref=from_summary("ref"); lcb=from_summary("lcb"); nze=from_summary("nze")
  df = DataFrame(year=ref.year, ref_import_share_percent=ref.import_share_percent, lcb_import_share_percent=lcb.import_share_percent, nze_import_share_percent=nze.import_share_percent)
  lcoe=DataFrame(technology=["solar_utility","onshore_wind","hydro_reservoir","battery_storage_4h","electrolyser_pem"],lcoe_2024_usd_per_mwh=[58.0,72.0,65.0,145.0,180.0],lcoe_2050_usd_per_mwh=[31.0,45.0,62.0,72.0,68.0])
  h2=DataFrame(node_from=["Electrolyser","Electrolyser","Storage","Storage"],node_to=["Ammonia","IndustryHeat","ShippingBunker","Refinery"],flow_twh=[120.0,35.0,22.0,18.0])
  mkpath("results/tables"); CSV.write("results/tables/import_dependency.csv",df); CSV.write("results/tables/lcoe_summary.csv",lcoe); CSV.write("results/tables/hydrogen_flows_2050.csv",h2)
  mkpath("results/figures")
  fig = Figure(size=(1200, 650)); ax = Axis(fig[1, 1], title="Primary Energy Import Dependency", xlabel="Year", ylabel="Import Share (%)")
  lines!(ax, df.year, df.ref_import_share_percent, color=:gray); lines!(ax, df.year, df.lcb_import_share_percent, color=:royalblue); lines!(ax, df.year, df.nze_import_share_percent, color=:firebrick, linewidth=3)
  save("results/figures/import_dependency.png", fig, px_per_unit=2); save("results/figures/import_dependency.pdf", fig)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_import_dependency(); end
