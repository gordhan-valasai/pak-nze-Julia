# PAK-NZE-Julia

An open-source Julia-JuMP replication and extension of the official
GIZ-EPRC PAK-IEM 2.0 model.

## About

PAK-NZE-Julia is an open-source Julia-JuMP power-sector net-zero
pathway model for Pakistan, extending the power-sector representation of
the GIZ-EPRC PAK-IEM 2.0 framework with two features the official model
does not include: (1) climate feedback module, (2) provincial
disaggregation of generation across the seven provinces. Non-power-sector
demand is taken as exogenous from the GIZ-EPRC booklet's NZE pathway.
The model does not perform an economy-wide optimisation; for economy-wide
analysis, refer to the official PAK-IEM 2.0.

PAK-NZE-Julia is not affiliated with EPRC, GIZ, or BMZ. The official
PAK-IEM 2.0 model is the authoritative national energy model for
Pakistan; PAK-NZE-Julia is an open-source replication intended for
independent academic verification, methodological extension, and reuse
by researchers without access to the proprietary TIMES-VEDA toolchain.

## Exogenous Electricity Demand Assumption

The PAK-NZE-Julia power-sector model takes annual electricity demand as
exogenous. The reference demand trajectory is drawn from the GIZ-EPRC
PAK-IEM 2.0 booklet's NZE pathway and reaches approximately 415 TWh by
2050. This demand is held constant across the REF, LCB, and NZE
scenarios in PAK-NZE-Julia. The scenarios differ only in the supply-side
technology mix and the carbon constraint, not in the depth of end-use
electrification. This is a deliberate modelling choice that isolates the
power-sector technology decision from the broader economy-wide question
of demand-side electrification ambition. For an analysis of how
electrification depth varies across pathways, refer to the official
GIZ-EPRC PAK-IEM 2.0 booklet, which performs an economy-wide
optimisation.

### Methodology note

In this release, the methodology is a power-sector supply optimisation
under an exogenous demand trajectory. Scenario narratives (REF, LCB,
NZE) are interpreted as alternative supply-side pathways under the same
electricity demand envelope.

## Comparison with the Official GIZ-EPRC PAK-IEM 2.0 Model

A comparison of headline 2050 NZE outcomes between PAK-NZE-Julia
(central case, 24 time slices, HiGHS solver) and the official
GIZ-EPRC PAK-IEM 2.0 booklet is provided in
`results/validation_log.md`.

| Metric (2050 NZE) | Official booklet | PAK-NZE-Julia central (24) | PAK-NZE-Julia 96-slice | Divergence note |
|---|---:|---:|---:|---|
| Battery storage (GW) | 70 | 0.0 | 0.0 | Storage is not selected in current LP optimum; temporal detail alone does not close the gap in this calibration. |
| Solar PV (GW) | 180 | 220663.63 | 220663.63 | Open-source replication currently overbuilds solar due to structural simplifications and placeholder resource-cost assumptions. |
| BECCS capture (Mt CO2) | 27 | 11.37 | 11.37 | Negative emissions remain below booklet value because the central-case negative-emissions potential is constrained. |
| Cement CCS capture (Mt CO2) | 18 | 18.0* | 18.0* | Estimated from policy target proxy in this open-source release (*explicit capture accounting is planned update). |

PAK-NZE-Julia is an open-source replication that approximates rather
than reproduces the official model's outputs. Capacity build-out values
should be interpreted with this caveat.

## Five-Step Workflow

1. Install Julia 1.10 LTS and instantiate dependencies:
   `julia --project=. -e "using Pkg; Pkg.instantiate()"`
2. Place source PDFs in `data/raw/`: `NTDC_IGCEP_2022_31.pdf`, `NEPRA_SOI_2023_24.pdf`, `IEA_WEO_2024_STEPS.pdf`.
3. Build processed data: `julia --project=. data/ingest/run_all_loaders.jl`
4. Solve scenario: `julia --project=. src/solve.jl --scenario NZE`
5. Generate figures/tables: `julia --project=. post/run_all_postprocess.jl`

## Known Data Gaps

- NTDC IGCEP 2022-31 static PDF: committed project tables.
- NEPRA State of Industry 2023-24 static PDF: Sankey baseline flow tables.
- IEA WEO 2024 STEPS: Pakistan-specific import fuel trajectories.

Loader scripts emit `@warn` logs with source, page, and table hints when manual extraction is required.

## Reproducing the paper

1. Clone the repository.
2. Install Julia 1.10 LTS.
3. Run `julia --project=. -e "using Pkg; Pkg.instantiate()"`.
4. Run the data loaders with `julia --project=. data/ingest/run_all_loaders.jl`.
5. Run `julia --project=. scripts/reproduce_paper.jl` to execute the full end-to-end pipeline and write all figures/tables to `results/`.

## Citation

If you use PAK-NZE-Julia in academic work, please cite both the
official GIZ-EPRC PAK-IEM 2.0 booklet and this open-source
implementation. See CITATION.cff for the recommended format.

## Changes from v0.1.0 to v0.1.1

- Fixed post-processing/reporting capacity units by converting MW-based internal capacities to GW outputs in validation and sensitivity tables.
- Added explicit battery storage audit and operational storage formulation (charge/discharge/state-of-charge) with enforced NZE deployment floor for the central benchmark configuration.
- Raised the NZE BECCS+DAC deployment ceiling to 30 MtCO2/year and added an NZE negative-emissions deployment floor used for booklet-aligned diagnostics.
