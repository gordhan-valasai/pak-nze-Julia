# Data Gap Register

## Required Manual Verification Items

1. `igcep_loader.jl` - **PLACEHOLDER_IGCEP**
   - Source document: `NTDC_IGCEP_2022_31.pdf`
   - Page: `project pipeline pages` (exact page to confirm)
   - Table: `Committed projects`
   - Fields: `technology`, `cod_year`, `committed_capacity_gw`

2. `iea_weo_loader.jl` - **PLACEHOLDER_IEA_WEO**
   - Source document: `IEA_WEO_2024_STEPS.pdf`
   - Page: `fuel trajectory appendix`
   - Table: `Pakistan import prices`
   - Fields: `fuel`, `year`, `import_price_usd_per_mwh`

3. `nrel_atb_loader.jl` - **PLACEHOLDER_ATB**
   - Source document: `NREL ATB 2024 CSV download`
   - Page: `n/a (CSV source)`
   - Table: `Technology cost/performance trajectories`
   - Fields: `capex_usd_per_kw`, `fixed_om_usd_per_kw_yr`, `efficiency_fraction`

4. `demand_projection.jl` - **PLACEHOLDER historical series**
   - Source document: `PBS/WorldBank/IMF/UN series`
   - Page: `n/a`
   - Table: `2000-2023 macro history`
   - Fields: `gdp_industry_index`, `gdp_services_index`, `gdp_agriculture_index`, `population_million`

5. `nepra_sankey_loader.jl` - **PLACEHOLDER_NEPRA**
   - Source document: `NEPRA_SOI_2023_24.pdf`
   - Page: `Figure 11 vicinity`
   - Table: `Energy flow table`
   - Fields: `source`, `target`, `flow_pj`

6. `config/constraints.yaml` - **AEDB GIS placeholders**
   - Source document: `AEDB resource atlases`
   - Page: `GIS layers`
   - Table: `Technical potential and annual build limits`
   - Fields: `max_potential_gw`, `max_buildrate_gw_per_year` for solar/wind

7. `src/parameters.jl` - **IEA fuel-price placeholders**
   - Source document: `IEA WEO 2024 STEPS`
   - Page: `regional fuel appendix`
   - Table: `coal/gas/oil price trajectories`
   - Fields: `fuel_price_usd_per_mwh`
