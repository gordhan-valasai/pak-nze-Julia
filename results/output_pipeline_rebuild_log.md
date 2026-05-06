# Output Pipeline Rebuild Log

## Phase 1
- Added canonical `ModelSolution` container in `src/solution_container.jl`.
- Solve now exports scenario solution snapshots to `results/solutions/<tag>.jld2`.
- Variables extracted from solve: 24 declared JuMP variable groups represented in solution fields.
- Variables omitted with reason: 0
- Post-processing scripts refactored: 9

## Phase 2
- `generation_mix.csv` rebuilt from `ModelSolution.annual_generation`.
- `decarbonisation_trajectory.csv` rebuilt from `ModelSolution.total_co2eq_emissions_by_sector`.
- `hydrogen_flows_2050.csv` rebuilt from `ModelSolution.hydrogen_production` and `hydrogen_end_use`.
- `nze_emissions_decomposition.csv` created from NZE solution container.

## Phase 3
- YELLOW verification outcome: 35 GREEN, 8 YELLOW, 0 RED in `results/csv_audit_v2.md`.
- Unresolved divergences remain in emissions and import-dependency plausibility ranges.

## Phase 4
- End-to-end pipeline rerun completed via `scripts/reproduce_paper.jl`.
- Booklet metrics within 25%: 12 of 13.
- Battery storage NZE 2050: 35.00 GW.
- Solar PV NZE 2050: 220.66 GW.
- REF/LCB/NZE 2050 emissions (Mt): 89.32/64.96/-18.63.

## Phase 5
- Added `tests/test_visual_sanity.jl` (9 checks) and wired into CI.
- Current test status: failing (multiple range checks not met).
