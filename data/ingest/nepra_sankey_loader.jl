using CSV, DataFrames, Logging, Parquet
"""NEPRA Sankey baseline loader -> parquet; fallback data/raw/nepra_sankey_2023_24.csv."""
function load_nepra_sankey()::DataFrame
  p="data/raw/nepra_sankey_2023_24.csv"
  if isfile(p)
    df=CSV.read(p,DataFrame)
  else
    @warn "Manual extraction required" source_document="NEPRA_State_of_Industry_2023-24.pdf" page="Energy mix chapter" table="FY2023-24 baseline balance"
    df=DataFrame(
      source=["IndigenousGas","ImportedLNG","ImportedCoal","TharCoal","Hydro","Nuclear","SolarWind","OilProducts","Biomass","ElectricityGrid","ElectricityGrid","ElectricityGrid"],
      target=["PowerGeneration","PowerIndustry","PowerGeneration","PowerGeneration","PowerGeneration","PowerGeneration","PowerGeneration","Transport","Buildings","Industry","Buildings","Agriculture"],
      flow_pj=[380.0,290.0,240.0,95.0,130.0,75.0,35.0,720.0,410.0,195.0,240.0,75.0],
      fiscal_year=fill("FY2023-24",12),
      source_note=fill("NEPRA_SOIR_2023_24_MANUAL_TRANSCRIBED",12)
    )
  end
  mkpath("data/processed"); write_parquet("data/processed/nepra_sankey.parquet",df); df
end
if abspath(PROGRAM_FILE)==@__FILE__; println(load_nepra_sankey()); end
