# Rename and Reposition Log

- Initialized Phase 1 rename operations.

## Phase 1 checks
- Remaining "PAK-IEM 2.0" references: 21
- Sample retained upstream citations:
  - `Dockerfile`: LABEL org.opencontainers.image.description="Open-source Julia-JuMP replication of GIZ-EPRC PAK-IEM 2.0"
  - `CITATION.cff`: title: "PAK-NZE-Julia: Open-Source Julia-JuMP Replication of the GIZ-EPRC PAK-IEM 2.0 Model with Climate Feedback and Provincial Disaggregation"
  - `CITATION.cff`: title: "Pakistan Integrated Energy Model (PAK-IEM 2.0)"
- Confirmed rename scope applied to codebase naming; retained references are for official GIZ-EPRC booklet context.

## Phase 3 checks
- Updated validation framework uses GIZ-EPRC PAK-IEM 2.0 booklet as primary 2050 benchmark and Pak-TIMES as secondary 2035 benchmark.
- Booklet validation outcome: 10 of 13 metrics within 25 per cent.

## Phase 4 checks
- Updated release artefacts: CITATION.cff, .zenodo.json, README.md, Dockerfile labels, LICENSE notice, and data/raw/README.md attribution section.

## Phase 5 checks
- Re-ran `scripts/reproduce_paper.jl` successfully end-to-end.
- Re-ran both sensitivity scripts and validation script successfully.
- 10 of 13 metrics within 25 per cent.
- 24/48/96-slice solve times (s): 2.34, 4.22, 14.21.
- Storage CAPEX trajectories battery (GW): -0.00, -0.00, -0.00.
