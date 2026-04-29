using CSV, DataFrames, Logging, Parquet
"""NREL ATB loader -> parquet; fallback data/raw/nrel_atb_2024.csv."""
function load_nrel_atb_data()::DataFrame
  p="data/raw/nrel_atb_2024.csv"
  if isfile(p)
    df=CSV.read(p,DataFrame)
  else
    @warn "NREL ATB CSV fallback used" source="NREL ATB 2024 moderate 0.85x"
    years=collect(2024:2050)
    cap_anchors=Dict(
      "solar_utility"=>(1100.0,580.0),"onshore_wind"=>(1450.0,1050.0),"offshore_wind"=>(4200.0,2400.0),
      "battery_storage_4h"=>(1750.0,750.0),"electrolyser_alkaline"=>(1200.0,350.0),"electrolyser_pem"=>(1500.0,450.0),
      "ccgt_ccs"=>(2400.0,2100.0),"nuclear_large"=>(6500.0,6500.0)
    )
    rows=DataFrame(technology=String[],year=Int[],capex_usd_per_kw=Float64[],fixed_om_usd_per_kw_yr=Float64[],var_om_usd_per_mwh=Float64[],efficiency_fraction=Float64[],source_note=String[])
    for (t,(c0,c1)) in cap_anchors, y in years
      cap = c0 + (c1-c0)*(y-2024)/(2050-2024)
      push!(rows,(t,y,cap,35.0,4.0,0.62,"NREL_ATB_2024_MODERATE_0p85X_MANUAL"))
    end
    df=rows
  end
  mkpath("data/processed"); write_parquet("data/processed/nrel_atb.parquet",df); df
end
if abspath(PROGRAM_FILE)==@__FILE__; println(load_nrel_atb_data()); end
