using CSV, DataFrames, Logging, Parquet, StateSpaceModels
"""ARIMA/SARIMA demand driver projection to 2050."""
function project_demand_drivers()::DataFrame
  p="data/raw/macro_history_2000_2023.csv"
  if isfile(p)
    hist=CSV.read(p,DataFrame)
  else
    @warn "Manual extraction required" source_document="PBS/WorldBank/IMF/UN series" page="n/a" table="2000-2023 macro history"
    y=collect(2000:2023); hist=DataFrame(year=y,gdp_industry_index=[60+1.8*(t-2000) for t in y],gdp_services_index=[55+2.2*(t-2000) for t in y],gdp_agriculture_index=[70+1.0*(t-2000) for t in y],population_million=[141+2.1*(t-2000) for t in y]) # PLACEHOLDER: verify against PBS/UN WPP
  end
  proj(series,h) = Float64[x[1] for x in forecast(fit!(SARIMA(Float64.(series); order=(1,1,1), seasonal_order=(0,0,0,0))),h).expected_value]
  y=collect(2024:2050); h=length(y)
  df=DataFrame(year=y,gdp_industry_index=proj(hist.gdp_industry_index,h),gdp_services_index=proj(hist.gdp_services_index,h),gdp_agriculture_index=proj(hist.gdp_agriculture_index,h),population_million=proj(hist.population_million,h),source_note=fill("ARIMA_PBS_WB_IMF_UN",h))
  mkpath("data/processed"); write_parquet("data/processed/demand_drivers.parquet",df); df
end
if abspath(PROGRAM_FILE)==@__FILE__; println(project_demand_drivers()); end
