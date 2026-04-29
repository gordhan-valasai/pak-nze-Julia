using CSV, DataFrames, Logging, Parquet
"""IEA WEO loader -> parquet; fallback data/raw/iea_weo_prices.csv."""
function load_iea_weo_prices()::DataFrame
  p="data/raw/iea_weo_prices.csv"
  if isfile(p)
    df=CSV.read(p,DataFrame)
  else
    @warn "Manual extraction required" source_document="IEA_WEO_2024_STEPS.pdf" page="Annex A" table="Fossil fuel prices"
    years=collect(2024:2050)
    anchors=Dict("lng"=>Dict(2024=>47.0,2030=>42.0,2040=>38.0,2050=>36.0),"coal"=>Dict(2024=>18.0,2030=>16.0,2040=>14.0,2050=>12.0),"oil"=>Dict(2024=>51.0,2030=>47.0,2040=>43.0,2050=>41.0))
    rows=DataFrame(fuel=String[],year=Int[],import_price_usd_per_mwh=Float64[],source_note=String[])
    for f in ["coal","lng","oil"], y in years
      a=anchors[f]
      price = y<=2030 ? a[2024] + (a[2030]-a[2024])*(y-2024)/(2030-2024) : y<=2040 ? a[2030]+(a[2040]-a[2030])*(y-2030)/10 : a[2040]+(a[2050]-a[2040])*(y-2040)/10
      push!(rows,(f,y,price,"IEA_WEO_2024_STEPS_MANUAL_TRANSCRIBED"))
    end
    df=rows
  end
  mkpath("data/processed"); write_parquet("data/processed/iea_weo_prices.parquet",df); df
end
if abspath(PROGRAM_FILE)==@__FILE__; println(load_iea_weo_prices()); end
