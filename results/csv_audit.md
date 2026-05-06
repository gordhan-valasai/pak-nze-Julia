# CSV Audit

## Section 1: CSV Inventory

| File path | Size (bytes) | Rows | Columns | Last modified |
|---|---:|---:|---|---|
| `results/tables/climate_feedback_summary.csv` | 145 | 3 | metric, static_value, dynamic_value, percent_change | 2026-04-29 19:22:27 |
| `results/tables/decarbonisation_trajectory.csv` | 3035 | 135 | year, sector, emissions_mtco2 | 2026-04-29 19:22:21 |
| `results/tables/generation_mix.csv` | 1694 | 72 | scenario, year, technology, generation_twh | 2026-04-29 19:22:13 |
| `results/tables/hydrogen_flows_2050.csv` | 135 | 4 | node_from, node_to, flow_twh | 2026-04-29 19:22:25 |
| `results/tables/import_dependency.csv` | 1616 | 27 | year, ref_import_share_percent, lcb_import_share_percent, nze_import_share_percent | 2026-04-29 19:22:25 |
| `results/tables/lcb_capacity_summary.csv` | 252 | 1 | solar_pv_gw, battery_storage_gw, total_installed_capacity_2024_gw, total_installed_capacity_2050_gw, hydropower_2050_gw, onshore_wind_2050_gw, nuclear_2050_gw, electrolyser_2050_gw | 2026-04-29 19:21:33 |
| `results/tables/lcb_interprovincial_flow_2050.csv` | 40 | 0 | from_province, to_province, flow_2050_twh | 2026-04-29 19:21:33 |
| `results/tables/lcb_negative_emissions.csv` | 39 | 1 | year, negative_emissions_mtco2 | 2026-04-29 19:21:32 |
| `results/tables/lcb_provincial_generation_2050.csv` | 645 | 16 | province, technology, generation_2050_twh | 2026-04-29 19:21:33 |
| `results/tables/lcb_sector_emissions.csv` | 2891 | 135 | year, sector, emissions_mtco2 | 2026-04-29 19:21:32 |
| `results/tables/lcb_summary.csv` | 139 | 1 | scenario, solver, climate_feedback, objective_usd, re_share_2050, emissions_2050_mt | 2026-04-29 19:21:32 |
| `results/tables/lcoe_summary.csv` | 186 | 5 | technology, lcoe_2024_usd_per_mwh, lcoe_2050_usd_per_mwh | 2026-04-29 19:22:25 |
| `results/tables/nze_capacity_summary.csv` | 251 | 1 | solar_pv_gw, battery_storage_gw, total_installed_capacity_2024_gw, total_installed_capacity_2050_gw, hydropower_2050_gw, onshore_wind_2050_gw, nuclear_2050_gw, electrolyser_2050_gw | 2026-04-29 19:23:33 |
| `results/tables/nze_dynamic_capacity_summary.csv` | 293 | 1 | solar_pv_gw, battery_storage_gw, total_installed_capacity_2024_gw, total_installed_capacity_2050_gw, hydropower_2050_gw, onshore_wind_2050_gw, nuclear_2050_gw, electrolyser_2050_gw | 2026-04-29 19:21:51 |
| `results/tables/nze_dynamic_interprovincial_flow_2050.csv` | 472 | 12 | from_province, to_province, flow_2050_twh | 2026-04-29 19:21:51 |
| `results/tables/nze_dynamic_negative_emissions.csv` | 54 | 1 | year, negative_emissions_mtco2 | 2026-04-29 19:21:51 |
| `results/tables/nze_dynamic_provincial_generation_2050.csv` | 1010 | 25 | province, technology, generation_2050_twh | 2026-04-29 19:21:51 |
| `results/tables/nze_dynamic_sector_emissions.csv` | 2640 | 135 | year, sector, emissions_mtco2 | 2026-04-29 19:21:51 |
| `results/tables/nze_dynamic_summary.csv` | 108 | 1 | scenario, solver, climate_feedback, objective_usd, re_share_2050, emissions_2050_mt | 2026-04-29 19:21:51 |
| `results/tables/nze_interprovincial_flow_2050.csv` | 40 | 0 | from_province, to_province, flow_2050_twh | 2026-04-29 19:23:33 |
| `results/tables/nze_negative_emissions.csv` | 40 | 1 | year, negative_emissions_mtco2 | 2026-04-29 19:23:33 |
| `results/tables/nze_provincial_generation_2050.csv` | 575 | 14 | province, technology, generation_2050_twh | 2026-04-29 19:23:33 |
| `results/tables/nze_sector_emissions.csv` | 2907 | 135 | year, sector, emissions_mtco2 | 2026-04-29 19:23:33 |
| `results/tables/nze_static_capacity_summary.csv` | 292 | 1 | solar_pv_gw, battery_storage_gw, total_installed_capacity_2024_gw, total_installed_capacity_2050_gw, hydropower_2050_gw, onshore_wind_2050_gw, nuclear_2050_gw, electrolyser_2050_gw | 2026-04-29 19:21:42 |
| `results/tables/nze_static_interprovincial_flow_2050.csv` | 472 | 12 | from_province, to_province, flow_2050_twh | 2026-04-29 19:21:42 |
| `results/tables/nze_static_negative_emissions.csv` | 54 | 1 | year, negative_emissions_mtco2 | 2026-04-29 19:21:42 |
| `results/tables/nze_static_provincial_generation_2050.csv` | 1010 | 25 | province, technology, generation_2050_twh | 2026-04-29 19:21:42 |
| `results/tables/nze_static_sector_emissions.csv` | 2640 | 135 | year, sector, emissions_mtco2 | 2026-04-29 19:21:42 |
| `results/tables/nze_static_summary.csv` | 107 | 1 | scenario, solver, climate_feedback, objective_usd, re_share_2050, emissions_2050_mt | 2026-04-29 19:21:41 |
| `results/tables/nze_summary.csv` | 139 | 1 | scenario, solver, climate_feedback, objective_usd, re_share_2050, emissions_2050_mt | 2026-04-29 19:23:33 |
| `results/tables/objective_decomposition_nze.csv` | 295 | 6 | term, usd, share_percent | 2026-04-29 18:32:41 |
| `results/tables/objective_summary.csv` | 57 | 1 | scenario, total_system_cost_usd | 2026-04-29 17:54:35 |
| `results/tables/provincial_results.csv` | 4207 | 105 | province, technology, generation_2050_twh | 2026-04-29 19:22:27 |
| `results/tables/ref_capacity_summary.csv` | 253 | 1 | solar_pv_gw, battery_storage_gw, total_installed_capacity_2024_gw, total_installed_capacity_2050_gw, hydropower_2050_gw, onshore_wind_2050_gw, nuclear_2050_gw, electrolyser_2050_gw | 2026-04-29 19:21:23 |
| `results/tables/ref_interprovincial_flow_2050.csv` | 40 | 0 | from_province, to_province, flow_2050_twh | 2026-04-29 19:21:23 |
| `results/tables/ref_negative_emissions.csv` | 39 | 1 | year, negative_emissions_mtco2 | 2026-04-29 19:21:23 |
| `results/tables/ref_provincial_generation_2050.csv` | 649 | 16 | province, technology, generation_2050_twh | 2026-04-29 19:21:23 |
| `results/tables/ref_sector_emissions.csv` | 2889 | 135 | year, sector, emissions_mtco2 | 2026-04-29 19:21:23 |
| `results/tables/ref_summary.csv` | 153 | 1 | scenario, solver, climate_feedback, objective_usd, re_share_2050, emissions_2050_mt | 2026-04-29 19:21:23 |
| `results/tables/scenario_comparison.csv` | 287 | 3 | scenario, total_discounted_system_cost_usd_bn, emissions_2050_mtco2, re_share_2050_percent, import_dependency_2050_percent | 2026-04-29 18:33:19 |
| `results/tables/storage_capex_sensitivity.csv` | 142 | 3 | trajectory, battery_storage_gw_2050 | 2026-04-29 19:29:46 |
| `results/tables/timeslice_sensitivity.csv` | 271 | 3 | timeslices, solar_pv_gw, battery_storage_gw, total_system_cost_usd_bn, solve_time_s | 2026-04-29 19:29:37 |

No CSV files found under `results/figures/`.

## Section 2: Per-File Provenance Trace

### File: results/tables/climate_feedback_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: Derived from model-generated static/dynamic summaries and consistent with rendered panel behaviour; comparatively reliable.

### File: results/tables/decarbonisation_trajectory.csv

- Writing script: `post/decarbonisation_trajectory.jl`
- Writing function: `run_decarbonisation_trajectory()`
- Write call line range: lines `4-8`
- Data source classification: **HARD_CODED**
- If HARD_CODED: Literal base/delta trajectories in script
- Plausibility flag: **BROKEN**
- Plausibility reasoning: Script populates literal values directly, so outputs are not tied to solved model state and are not paper-safe.

### File: results/tables/generation_mix.csv

- Writing script: `post/generation_mix.jl`
- Writing function: `run_generation_mix()`
- Write call line range: lines `4-9`
- Data source classification: **HARD_CODED**
- If HARD_CODED: Literal vectors in script (`vals=[55.0,28.0,...]`)
- Plausibility flag: **BROKEN**
- Plausibility reasoning: Script populates literal values directly, so outputs are not tied to solved model state and are not paper-safe.

### File: results/tables/hydrogen_flows_2050.csv

- Writing script: `post/import_dependency.jl`
- Writing function: `run_import_dependency()`
- Write call line range: lines `19-20`
- Data source classification: **HARD_CODED**
- If HARD_CODED: Literal flow_twh values in script
- Plausibility flag: **BROKEN**
- Plausibility reasoning: Script populates literal values directly, so outputs are not tied to solved model state and are not paper-safe.

### File: results/tables/import_dependency.csv

- Writing script: `post/import_dependency.jl`
- Writing function: `run_import_dependency()`
- Write call line range: lines `4-20`
- Data source classification: **COMPUTED**
- If COMPUTED: Computed from `*_summary.csv` with hard-coded base/tail anchors
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: Three-scenario structure exists, but trajectories are generated from hard-coded anchors and summary scalar interpolation, not full model energy-flow accounting.

### File: results/tables/lcb_capacity_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/lcb_interprovincial_flow_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/lcb_negative_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/lcb_provincial_generation_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/lcb_sector_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/lcb_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/lcoe_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: Script populates literal values directly, so outputs are not tied to solved model state and are not paper-safe.

### File: results/tables/nze_capacity_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_dynamic_capacity_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_dynamic_interprovincial_flow_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_dynamic_negative_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_dynamic_provincial_generation_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_dynamic_sector_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_dynamic_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_interprovincial_flow_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_negative_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_provincial_generation_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_sector_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_static_capacity_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_static_interprovincial_flow_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_static_negative_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_static_provincial_generation_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_static_sector_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_static_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/nze_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/objective_decomposition_nze.csv

- Writing script: `(no active writer found)`
- Writing function: `(n/a)`
- Write call line range: lines `(n/a)`
- Data source classification: **DERIVED_FROM_OTHER_CSV**
- If DERIVED_FROM_OTHER_CSV: Orphan/stale table; no current code writes this file
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: No active writer exists in current pipeline; file appears stale/orphaned and cannot be trusted without regeneration provenance.

### File: results/tables/objective_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: No active writer exists in current pipeline; file appears stale/orphaned and cannot be trusted without regeneration provenance.

### File: results/tables/provincial_results.csv

- Writing script: `post/provincial_outputs.jl`
- Writing function: `run_provincial_outputs()`
- Write call line range: lines `3-5`
- Data source classification: **DERIVED_FROM_OTHER_CSV**
- If DERIVED_FROM_OTHER_CSV: Direct copy of `nze_provincial_generation_2050.csv`
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is copied from a model output CSV, but values are near-uniform and two orders below expected national scale, indicating upstream aggregation/indexing issues.

### File: results/tables/ref_capacity_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/ref_interprovincial_flow_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/ref_negative_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/ref_provincial_generation_2050.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/ref_sector_emissions.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/ref_summary.csv

- Writing script: `src/solve.jl`
- Writing function: `build_and_solve()`
- Write call line range: lines `54-90`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP variables via value() extraction
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/scenario_comparison.csv

- Writing script: `(no active writer found)`
- Writing function: `(n/a)`
- Write call line range: lines `(n/a)`
- Data source classification: **DERIVED_FROM_OTHER_CSV**
- If DERIVED_FROM_OTHER_CSV: Orphan/stale table; no current code writes this file
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: No active writer exists in current pipeline; file appears stale/orphaned and cannot be trusted without regeneration provenance.

### File: results/tables/storage_capex_sensitivity.csv

- Writing script: `scripts/sensitivity_storage_capex.jl`
- Writing function: `run_case() + script body`
- Write call line range: lines `5-46`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP solved battery capacity under CAPEX variants
- Plausibility flag: **SUSPICIOUS**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

### File: results/tables/timeslice_sensitivity.csv

- Writing script: `scripts/sensitivity_timeslice.jl`
- Writing function: `run_case() + script body`
- Write call line range: lines `21-56`
- Data source classification: **MODEL_DERIVED**
- If MODEL_DERIVED: JuMP solved capacities/objective by slice variant
- Plausibility flag: **PLAUSIBLE**
- Plausibility reasoning: File is written from JuMP variable values after `optimize!(model)` in `src/solve.jl` or dedicated sensitivity solve scripts.

## Section 3: In-Depth Audit (Requested Files)

### File: results/tables/generation_mix.csv

- Classification: **HARD_CODED**
- Writer: `post/generation_mix.jl` / `run_generation_mix()` / lines `4-9`

First 10 rows:

```csv
scenario,year,technology,generation_twh
LCB,2025,Hydro,55.0
LCB,2025,Nuclear,28.0
LCB,2025,Fossil,95.0
LCB,2025,Solar,42.0
LCB,2025,Wind,24.0
LCB,2025,LowCarbonDispatchable,9.0
LCB,2030,Hydro,55.0
LCB,2030,Nuclear,28.0
LCB,2030,Fossil,91.0
LCB,2030,Solar,47.0
```

### File: results/tables/decarbonisation_trajectory.csv

- Classification: **HARD_CODED**
- Writer: `post/decarbonisation_trajectory.jl` / `run_decarbonisation_trajectory()` / lines `4-8`

First 10 rows:

```csv
year,sector,emissions_mtco2
2024,power,110.0
2025,power,107.8
2026,power,105.6
2027,power,103.4
2028,power,101.2
2029,power,99.0
2030,power,96.8
2031,power,94.6
2032,power,92.4
2033,power,90.2
```

### File: results/tables/provincial_results.csv

- Classification: **DERIVED_FROM_OTHER_CSV**
- Writer: `post/provincial_outputs.jl` / `run_provincial_outputs()` / lines `3-5`

First 10 rows:

```csv
province,technology,generation_2050_twh
Punjab,hydro_run_of_river,0.6949498853881283
Punjab,hydro_reservoir,0.6949404111898433
Punjab,nuclear_k2_k3,0.6949280827995166
Punjab,coal_imported,0.6949362005928557
Punjab,thar_coal_domestic,0.6949454265181837
Punjab,rlng_ccgt,0.643444964467062
Punjab,oil_thermal,0.6434743284816298
Punjab,solar_utility,0.6434561083181476
Punjab,solar_distributed,0.643465764859075
Punjab,onshore_wind,0.6434548037437863
```

### File: results/tables/import_dependency.csv

- Classification: **COMPUTED**
- Writer: `post/import_dependency.jl` / `run_import_dependency()` / lines `4-20`

First 10 rows:

```csv
year,ref_import_share_percent,lcb_import_share_percent,nze_import_share_percent
2024,33.0,19.0,6.5
2025,32.761538461538464,18.79230769230769,6.488442851085171
2026,32.52307692307692,18.584615384615386,6.4768857021703425
2027,32.284615384615385,18.376923076923077,6.465328553255514
2028,32.04615384615385,18.16923076923077,6.453771404340685
2029,31.807692307692307,17.96153846153846,6.442214255425856
2030,31.56923076923077,17.753846153846155,6.430657106511028
2031,31.33076923076923,17.546153846153846,6.419099957596198
2032,31.092307692307692,17.338461538461537,6.407542808681369
2033,30.853846153846153,17.130769230769232,6.3959856597665405
```

### File: results/tables/scenario_comparison.csv

- Classification: **DERIVED_FROM_OTHER_CSV**
- Writer: `(no active writer found)` / `(n/a)` / lines `(n/a)`

First 10 rows:

```csv
scenario,total_discounted_system_cost_usd_bn,emissions_2050_mtco2,re_share_2050_percent,import_dependency_2050_percent
REF,353.89444386041606,803.8754265552932,44.99999999999999,26.8
LCB,366.8664060171763,298.8142999720683,60.0,13.6
NZE,421.90357752726413,0.0,90.0,4.199999999999999
```

### File: results/tables/hydrogen_flows_2050.csv

- Classification: **HARD_CODED**
- Writer: `post/import_dependency.jl` / `run_import_dependency()` / lines `19-20`

First 10 rows:

```csv
node_from,node_to,flow_twh
Electrolyser,Ammonia,120.0
Electrolyser,IndustryHeat,35.0
Storage,ShippingBunker,22.0
Storage,Refinery,18.0
```

### File: results/tables/lcoe_summary.csv

- Classification: **MODEL_DERIVED**
- Writer: `src/solve.jl` / `build_and_solve()` / lines `54-90`

First 10 rows:

```csv
technology,lcoe_2024_usd_per_mwh,lcoe_2050_usd_per_mwh
solar_utility,58.0,31.0
onshore_wind,72.0,45.0
hydro_reservoir,65.0,62.0
battery_storage_4h,145.0,72.0
electrolyser_pem,180.0,68.0
```

### File: results/tables/objective_summary.csv

- Classification: **MODEL_DERIVED**
- Writer: `src/solve.jl` / `build_and_solve()` / lines `54-90`

First 10 rows:

```csv
scenario,total_system_cost_usd
LCB,1.0790188409117575e11
```

### File: results/tables/climate_feedback_summary.csv

- Classification: **MODEL_DERIVED**
- Writer: `src/solve.jl` / `build_and_solve()` / lines `54-90`

First 10 rows:

```csv
metric,static_value,dynamic_value,percent_change
total_discounted_cost_usd,0.0,8.0e9,Inf
re_share_2050,0.0,0.0,0.0
emissions_2050_mt,0.0,0.0,0.0
```

### File: results/tables/timeslice_sensitivity.csv

- Classification: **MODEL_DERIVED**
- Writer: `scripts/sensitivity_timeslice.jl` / `run_case() + script body` / lines `21-56`

First 10 rows:

```csv
timeslices,solar_pv_gw,battery_storage_gw,total_system_cost_usd_bn,solve_time_s
24,220.6636302129342,35.0,413.9106553735201,3.1594860553741455
48,220.6636302129342,35.0,413.91065537352006,13.703420162200928
96,220.66363021293458,35.0,413.91065537352034,332.2313048839569
```

### File: results/tables/storage_capex_sensitivity.csv

- Classification: **MODEL_DERIVED**
- Writer: `scripts/sensitivity_storage_capex.jl` / `run_case() + script body` / lines `5-46`

First 10 rows:

```csv
trajectory,battery_storage_gw_2050
NREL ATB 2024 moderate,35.0
NREL ATB 2024 conservative (+10%),35.0
Pakistan-specific 1500->600 USD/kW,35.0
```

### Missing File Check: `results/tables/nze_emissions_decomposition.csv`

- Status: **Missing** (file does not exist).
- Related script: `post/nze_emissions_decomposition.jl`.
- Finding: script reads `results/tables/nze_sector_emissions.csv` and renders figures only; it does not write any decomposition CSV.

## Section 4: Solver-to-CSV Data Flow

1. `scripts/reproduce_paper.jl` runs `src/solve.jl` for `REF`, `LCB`, `NZE_static`, `NZE_dynamic`, and `NZE`.
2. In `src/solve.jl`, `optimize!(model)` executes the JuMP solve, then writes model-derived CSVs: `*_summary`, `*_negative_emissions`, `*_sector_emissions`, `*_provincial_generation_2050`, `*_interprovincial_flow_2050`, `*_capacity_summary`.
3. `post/run_all_postprocess.jl` then executes post scripts. Some scripts consume model-derived CSVs (`climate_feedback_impact.jl`, `provincial_outputs.jl`, `nze_emissions_decomposition.jl`), while others generate synthetic/hard-coded tables (`generation_mix.jl`, `decarbonisation_trajectory.jl`, parts of `import_dependency.jl`).
4. No JLD2/HDF5 serialized model state is passed; post-processing is CSV-based only. Disconnects occur when post scripts do not read model CSVs and instead construct literals.

## Section 5: Root Cause Pattern

Primary pattern: **single placeholder scaffolding never replaced** in multiple post-processing scripts. The breakage is not a single refactor bug; it is a mixed pipeline where some outputs are model-derived and others are synthetic fallbacks/literals. `generation_mix.jl` and `decarbonisation_trajectory.jl` are explicit placeholder generators. `import_dependency.jl` partially derives from summaries but still uses hard-coded anchor values and hard-coded LCOE/H2 tables. This creates internally inconsistent figures even when core model summaries are plausible.

## Section 6: Triage Recommendation

| File path | Classification | Affected paper sections | Estimated rebuild effort |
|---|---|---|---|
| `results/tables/climate_feedback_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/decarbonisation_trajectory.csv` | RED | Section 4.2, Figure decarbonisation | large |
| `results/tables/generation_mix.csv` | RED | Section 4.3, Figure power mix | large |
| `results/tables/hydrogen_flows_2050.csv` | RED | Section 4.4 hydrogen allocation | large |
| `results/tables/import_dependency.csv` | YELLOW | Section 4.8, import dependency figure | medium |
| `results/tables/lcb_capacity_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/lcb_interprovincial_flow_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/lcb_negative_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/lcb_provincial_generation_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/lcb_sector_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/lcb_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/lcoe_summary.csv` | YELLOW | Section 4.8 cost decomposition | medium |
| `results/tables/nze_capacity_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_dynamic_capacity_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_dynamic_interprovincial_flow_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/nze_dynamic_negative_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_dynamic_provincial_generation_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/nze_dynamic_sector_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_dynamic_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_interprovincial_flow_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/nze_negative_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_provincial_generation_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/nze_sector_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_static_capacity_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_static_interprovincial_flow_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/nze_static_negative_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_static_provincial_generation_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/nze_static_sector_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_static_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/nze_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/objective_decomposition_nze.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/objective_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/provincial_results.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/ref_capacity_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/ref_interprovincial_flow_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/ref_negative_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/ref_provincial_generation_2050.csv` | YELLOW | Section 4.7, provincial figure/table | medium |
| `results/tables/ref_sector_emissions.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/ref_summary.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/scenario_comparison.csv` | YELLOW | Headline results summary sections | medium |
| `results/tables/storage_capex_sensitivity.csv` | YELLOW | Section 4 (tables/figures dependent) | medium |
| `results/tables/timeslice_sensitivity.csv` | GREEN | Section 4 (tables/figures dependent) | small |

- Total CSVs audited: 42
- GREEN: 1
- YELLOW: 38
- RED: 3
- Root cause pattern: mixed pipeline with model-derived core solve outputs and multiple post-processing placeholders/hard-coded generators that were never replaced.
- Recommended rebuild path: option (a) targeted patches if RED count is small, option (b) rollback to v0.0.1-pre-rename if RED count exceeds half of total
- Audit recommendation based on counts: option (a) targeted patches is recommended first (RED does not exceed half), with rollback fallback if post patch scope expands.
