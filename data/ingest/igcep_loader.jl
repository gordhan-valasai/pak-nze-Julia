using CSV, DataFrames, Logging, Parquet
"""IGCEP loader -> parquet; fallback data/raw/igcep_projects.csv."""
function load_igcep_projects()::DataFrame
  p="data/raw/igcep_projects.csv"
  if isfile(p)
    df=CSV.read(p,DataFrame)
  else
    @warn "Manual extraction required" source_document="NTDC_IGCEP_2022_31.pdf" page="Annex committed projects" table="Committed and indicative pipeline"
    df=DataFrame(
      technology=["hydro_reservoir","hydro_reservoir","hydro_reservoir","hydro_reservoir","hydro_reservoir","nuclear_k2_k3","nuclear_k2_k3","nuclear_planned","rlng_ccgt","rlng_ccgt","thar_coal_domestic","thar_coal_domestic","solar_utility","onshore_wind"],
      cod_year=[2025,2026,2027,2030,2022,2021,2022,2035,2021,2021,2022,2028,2031,2031],
      committed_capacity_gw=[0.884,2.160,0.800,4.500,0.720,1.100,1.100,1.200,1.263,1.263,1.320,1.320,6.000,4.000],
      source_note=fill("NTDC_IGCEP_2022_31_MANUAL_TRANSCRIBED",14)
    )
  end
  mkpath("data/processed"); write_parquet("data/processed/igcep_projects.parquet",df); df
end
if abspath(PROGRAM_FILE)==@__FILE__; println(load_igcep_projects()); end
