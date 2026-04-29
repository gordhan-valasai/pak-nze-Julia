# PAK-NZE-Julia: An Economy-Wide Net-Zero Energy Pathway for Pakistan to 2050 with Climate Feedback and Provincial Disaggregation

## Abstract
Pakistan is among the countries most exposed to climate risk while remaining structurally dependent on imported fossil fuels for energy security and macroeconomic stability. No published study has yet presented an economy-wide net-zero energy pathway for Pakistan that integrates cross-sector decarbonisation, provincial power system structure, and climate feedback effects within one optimisation framework. This paper introduces PAK-NZE-Julia, a bottom-up linear programming model implemented in Julia and JuMP, covering power, industry, transport, buildings, and agriculture across seven provincial nodes for the 2024-2050 horizon. Three scenarios are evaluated: Reference (REF), Low-Carbon Balanced (LCB), and Net-Zero Energy (NZE). NZE is enforced through a hard 2050 net-emissions equality, including BECCS and direct air capture as bounded negative-emission options. Under the calibrated central case, NZE reaches 2050 with total discounted system cost of 421.904 USD billion, 2050 net emissions of 0.0 Mt CO2-eq, renewable share of 90.0%, low-carbon share of 97.0%, import dependency of 4.2%, and 11.368 Mt CO2 of negative emissions deployment. Climate feedbacks increase NZE system cost by 8.0 USD billion (1.93%) relative to static-climate assumptions. The model reproduces Pak-TIMES 2035 benchmarks within 0.10% (REF) and -0.08% (LCB). PAK-NZE-Julia is released as open source with reproducible workflows to support transparent policy analysis and future multi-model intercomparison.

**Keywords:** Net-zero energy systems; Pakistan; energy system optimisation model; green hydrogen; climate feedback; provincial energy planning; decarbonisation; JuMP.

---

## 1. Introduction

Pakistan ranks among the ten countries most exposed to climate change despite contributing less than one per cent of global greenhouse gas emissions. The 2022 floods displaced over thirty million people and caused damages estimated at USD 30 billion, equivalent to nearly 9 per cent of national GDP. Heatwaves in 2024 pushed apparent temperatures in Sindh and Balochistan above 52 °C, and glacier retreat in the Upper Indus Basin has begun to alter the seasonal flow on which Pakistan's hydropower fleet depends. The energy sector is both a contributor to and a casualty of this exposure. Pakistan's primary energy supply remains dominated by imported fossil fuels, with combined imports of crude oil, refined products, liquefied natural gas, and thermal coal accounting for approximately 35 per cent of primary energy in fiscal year 2023-24. The associated import bill exceeds USD 17 billion annually and has been a persistent driver of balance-of-payments stress.

Against this backdrop, Pakistan submitted an updated Nationally Determined Contribution to the United Nations Framework Convention on Climate Change in 2021, committing to a 50 per cent reduction in projected emissions by 2030 conditional on international climate finance. The country has not yet declared a formal net-zero year, but successive policy documents including the National Electricity Policy 2021, the Alternative and Renewable Energy Policy 2019, and the draft National Hydrogen Policy have established sectoral targets consistent with deep decarbonisation. The Indicative Generation Capacity Expansion Plan 2022-31, prepared by the National Transmission and Despatch Company, sets a moratorium on new imported coal and oil-fired generation and targets a 60 per cent share of clean energy in installed capacity by 2030.

Quantitative analysis of how these commitments translate into a coherent long-term pathway has been limited. The first integrated energy modelling study for Pakistan was the Pak-IEM exercise developed under Asian Development Bank funding between 2007 and 2011, which used the TIMES framework calibrated to a 2006-07 base year. The model was completed but never connected to national policy formulation, and the calibration is now nearly two decades out of date. Subsequent academic studies have extended the modelling literature in several directions. Farooq, Kumar, and Shrestha (2013) applied MARKAL to evaluate Renewable Portfolio Standards and reported a reduction in 2050 emissions to 170 Mt under a 50 per cent renewable target. Mirjat et al. (2017) reviewed the planning history and recommended LEAP as the appropriate national tool. Mirjat et al. (2018) and Valasai et al. (2017) used LEAP to project demand to 2050 and to compare reference, renewable, clean coal, and energy efficiency scenarios. Rehman et al. (2017a, 2017b) combined LEAP and system dynamics to forecast sectoral demand and to identify the timing of fossil resource depletion. Rehman et al. (2019) developed Pak-TIMES, a national bottom-up optimisation model in the ANSWER-TIMES framework, and reported that a 40 per cent renewable scenario could reduce 2035 emissions to 96 Mt CO2-equivalent compared with 181.5 Mt under business as usual, at an investment cost of USD 179 billion. Sadiqa, Gulagi, and Breyer (2018) modelled a 100 per cent renewable transition for Pakistan's electricity and desalination sectors using hourly resolution and reported a levelised cost decline from EUR 106.6 per MWh in 2015 to EUR 46.2 per MWh in 2050.

This body of work has established the modelling lineage for Pakistan but has not addressed several questions that are now central to the country's climate and energy debate. First, no published study has constructed a formal economy-wide net-zero scenario covering power, industry, transport, buildings, and agriculture together. Second, no Pakistan modelling study has incorporated climate feedback effects on energy supply and demand. Third, no economy-wide Pakistan study has included provincial disaggregation of the power sector. Fourth, no Pakistan energy model has been released as open source with reproducible inputs.

This paper addresses these four gaps through PAK-NZE-Julia, a bottom-up linear programming energy system optimisation model implemented in Julia and JuMP. The model covers Pakistan's full energy economy from 2024 to 2050 in five-year planning nodes, with representative time slices in the power module to capture seasonal and diurnal variation. Three scenarios are constructed: a reference case continuing current policy, a low-carbon balanced case targeting 60 per cent renewable share by 2050, and a net-zero case enforcing a hard equality constraint on energy sector emissions in 2050. The contributions of the paper are four. First, it presents the first economy-wide net-zero pathway for Pakistan with quantified deployment of green hydrogen, carbon capture for cement clinker, BECCS for negative emissions, transport electrification, and biomethane for residential cooking. Second, it integrates a climate feedback module that links a CMIP6-derived temperature anomaly trajectory to five energy sector parameters and reports the resulting change in system cost and capacity build-out. Third, it disaggregates the power sector across the seven provinces and federal territories, with explicit inter-provincial transmission. Fourth, it releases the model under an MIT licence with a Zenodo DOI, a Docker image, and a reproducibility notebook.

The remainder of the paper is organised as follows. Section 2 reviews the prior modelling literature for Pakistan and positions the methodological contribution of PAK-NZE-Julia. Section 3 describes the model framework, scenario design, climate feedback module, provincial disaggregation, data sources, and validation strategy. Section 4 presents scenario results. Section 5 discusses policy levers, climate-feedback implications for NDC ambition, and study limitations. Section 6 concludes with policy recommendations. Sections 7 and 8 provide data/code availability and acknowledgements.

---

## 2. Literature Review

Pakistan energy systems modelling studies can be grouped into four streams: TIMES/MARKAL optimisation studies, LEAP scenario studies, system-dynamics studies, and high-resolution renewable transition studies.

The optimisation lineage includes the original Pak-IEM TIMES exercise and the later Pak-TIMES model. These studies established technology-rich, bottom-up representation for Pakistan and provided the first quantitative evidence on long-horizon decarbonisation costs and power-mix shifts. Farooq et al. (2013) contributed a MARKAL-based policy exploration for renewable portfolio standards. Rehman et al. (2019) remains the principal benchmark for national optimisation modelling through its BAU and RE-40 pathways to 2035.

LEAP-based studies (Mirjat et al., 2018; Valasai et al., 2017; Perwez et al., 2015; Aslam et al., 2021) provided transparent demand-side scenario frameworks and practical policy communication, especially for technology substitution and efficiency pathways. Their strengths are accessibility and policy interpretability; limitations are weaker capacity-expansion optimisation depth and limited endogenous system balancing under strict constraints.

System-dynamics work (Rehman et al., 2017a; Qudrat-Ullah, 2007) contributed macro-structural understanding of demand growth, resource depletion, and policy feedback loops. These studies are informative on dynamic behaviour but less suitable for high-dimensional least-cost infrastructure planning with explicit technology dispatch and emissions constraints.

High-resolution renewable studies (Sadiqa et al., 2018) demonstrated technical feasibility of very high renewable penetration for Pakistan's electricity system and established cost-reduction trajectories under hourly balancing assumptions. Their scope, however, remained electricity-focused and did not capture cross-sector coupling required for economy-wide net-zero assessment.

Across this literature, four limitations remain: absence of a formal economy-wide net-zero pathway to 2050; absence of climate feedback integration; absence of provincial disaggregation in a net-zero context; and absence of open-source, reproducible national modelling workflows. PAK-NZE-Julia is designed to close these four gaps while maintaining compatibility with Pak-TIMES-style validation conventions.

---

## 3. Methodology

### 3.1 Model framework

PAK-NZE-Julia is a bottom-up, technology-rich linear programming energy system optimisation model. The model is implemented in Julia using JuMP. Two solvers are supported: Gurobi and HiGHS. The reported runs use HiGHS 1.14.

The planning horizon runs from 2024 to 2050 in five-year nodes. Annual resolution is used for industry, transport, buildings, and agriculture. The power module uses representative seasonal-diurnal slices. The objective minimises discounted total system cost, including CAPEX, fixed O&M, variable O&M, and fuel cost terms, under an 8% social discount rate.

### 3.2 Sectoral coverage

Five sectors are represented: power, industry, transport, buildings, and agriculture. The technology set includes renewable, low-carbon dispatchable, and fossil technologies with explicit policy constraints (coal and oil moratoria, renewable-share pathways, transport and cooking transitions, hydrogen deployment, CCS and negative emissions).

Service demands are projected from macro drivers to 2050. Demand and technology modules are linked through activity constraints, capacity accumulation, and sector-specific policy levers.

### 3.3 Scenario design

Three scenarios are modelled:

- **REF**: continuation of current policy.
- **LCB**: moderate decarbonisation with 60% renewable share by 2050.
- **NZE**: hard net-zero energy constraint in 2050 (`total_co2eq_emissions_2050 = 0`).

NZE includes bounded BECCS and DAC deployment up to 15 Mt CO2/year by 2050 and sectoral transition constraints (electrolyser floor, EV shares, cooking fuel shift, cement CCS, green ammonia transition).

### 3.4 Climate feedback module

A temperature-dependent parameter modifier is applied at build time using CMIP6/NEX-GDDP pathway assumptions. Five feedbacks are represented: buildings cooling uplift, tube-well demand uplift, hydropower derating, PV derating, and thermal efficiency reduction for gas turbines/CCGT.

Static-climate and dynamic-climate runs are compared for NZE to quantify infrastructure and cost implications.

### 3.5 Provincial disaggregation

The power module is disaggregated across Punjab, Sindh, KPK, Balochistan, GB, AJK, and Islamabad. Provincial demand shares are applied from NEPRA-based baselines. Provincial renewable potential ceilings and simplified inter-provincial transmission constraints are included.

Provincial balance constraints enforce generation plus net imports equals demand by province and time slice. National outputs are aggregated over provinces.

### 3.6 Data sources

Primary inputs include NEPRA SOIR 2023-24, NTDC IGCEP 2022-31, IEA WEO 2024 STEPS, NREL ATB 2024, AEDB resource atlases, and CMIP6 downscaled climate data. Redistribution-restricted sources are referenced with retrieval instructions in `data/raw/README.md`.

Seven previously open data gaps were closed through source-based manual transcription and logged in `results/data_closure_log.md`.

### 3.7 Validation strategy

Validation uses Pak-TIMES 2035 benchmarks:

- REF vs BAU target: 181.5 Mt CO2-eq
- LCB vs RE-40 target: 96 Mt CO2-eq

Achieved deviations are 0.10% (REF) and -0.08% (LCB), both within ±20% threshold. Unit and consistency checks are run through automated test suites.

---

## 4. Results

### 4.1 Baseline energy flows in 2024

Figure 2 shows FY2023-24 baseline flows. Fossil fuels dominate primary supply, with imported oil products and gas as major contributors. Buildings and transport remain the largest final-demand sinks, with substantial biomass use persisting in cooking.

### 4.2 Decarbonisation trajectories by sector and scenario

REF reaches 803.875 Mt CO2-eq by 2050, LCB reaches 298.814 Mt, and NZE reaches 0.0 Mt. Sectoral decomposition shows transport and industry dominate residual pressure under non-net-zero pathways.

### 4.3 Power generation mix evolution under LCB and NZE

LCB reaches a 60% RE share and NZE reaches a 90% RE share by 2050, with NZE low-carbon share at 97%. Solar, wind, hydro, and storage expansion drives the transition; nuclear remains a low-carbon dispatchable contributor.

### 4.4 Hydrogen economy build-out

NZE requires large-scale hydrogen integration for ammonia, industry, and balancing functions. Electrolyser deployment exceeds policy floor constraints, and hydrogen-linked pathways materially support hard-to-abate sector decarbonisation.

### 4.5 Negative emissions deployment

NZE deploys 11.368 Mt CO2 of negative emissions in 2050, within the 15 Mt cap. This offsets residual hard-process emissions and enables strict net-zero equality compliance.

### 4.6 Climate feedback impact on system cost and capacity

Dynamic climate increases NZE system cost by 8.0 USD bn relative to static climate. Cooling demand uplift and renewable derating increase renewable and storage requirements over the horizon.

### 4.7 Provincial generation mix and inter-provincial flows in 2050

Provincial generation outcomes show heterogeneity in RE shares and technology composition. Punjab's generation-based RE share reaches 100% under the chosen metric definition (generation basis, not consumption basis). A consumption-based alternative is reported in supplementary framing and should be used for policy equity discussion.

Inter-provincial flows are represented in model variables; final Figure 9 reporting should use regenerated `inter_provincial_flows_2050_NZE.csv` before submission lock.

### 4.8 Import dependency reduction

2050 import dependency falls to 26.8% (REF), 13.6% (LCB), and 4.2% (NZE). NZE import reduction is computed from scenario-linked solved outputs rather than fixed scenario targets.

### 4.9 Validation against Pak-TIMES

Validation at 2035 aligns tightly with Pak-TIMES benchmark values, supporting structural consistency before 2050 extrapolation.

---

## 5. Discussion

The NZE pathway is feasible at 421.904 USD bn discounted cost, 19.2% above REF. The incremental net-zero cost is modest relative to long-run import bill compression.

### 5.1 Electrolyser deployment and financing

Hydrogen infrastructure scaling is a central policy lever and requires blended financing architecture with export-linked industrial strategy.

### 5.2 Coal transition and retirement sequence

A dated retirement roadmap for imported coal assets remains essential for policy credibility and system planning consistency.

### 5.3 Biomethane mandate and LPG phase-down

Cooking-sector transition is both an emissions and public-health lever, with strong rural co-benefits and waste-to-energy linkages.

### 5.4 Climate feedback and NDC implications

Static-climate planning underestimates required infrastructure. Dynamic-climate calibration should inform the next NDC update cycle.

### 5.5 Limitations

Remaining limitations include manual-source verification dependencies, single-model architecture, simplified financing representation, and exclusion of explicit just-transition optimisation terms.

---

## 6. Conclusions and Policy Recommendations

This paper has presented PAK-NZE-Julia, a bottom-up optimisation model for Pakistan's economy-wide energy transition to 2050. Five findings and five policy recommendations are summarised.

### Findings

1. Net-zero by 2050 is feasible at 421.904 USD bn discounted cost, 19.2% above REF.
2. NZE reaches 90.0% RE and 97.0% low-carbon power share by 2050.
3. Hydrogen and negative-emission technologies are structural requirements, not marginal add-ons.
4. Import dependency falls to 4.2% under NZE by 2050.
5. Climate feedback increases NZE cost by 8.0 USD bn and changes capacity requirements.

### Policy recommendations

1. **Hydrogen law and deployment milestones**: Ministry of Energy/AEDB, 2024-2029 term.
2. **Coal transition roadmap with dated retirements**: Power Division/PPIB, by FY2025-26.
3. **Biomethane blending mandate with LPG reform**: Petroleum Division/PCRET, staged to 2050.
4. **Dynamic-climate basis for NDC updates**: Ministry of Climate Change, next NDC cycle.
5. **Provincial transmission implementation plan**: Planning Commission/NTDC, pre-2040 corridor priorities.

---

## 7. Data and Code Availability

PAK-NZE-Julia is released under MIT licence at `https://github.com/[USERNAME]/PAK-NZE-Julia` with archival DOI `10.5281/zenodo.[TO_BE_MINTED]`. The repository includes model code, scenario configs, ingestion loaders, post-processing scripts, tests, Dockerfile, CI workflow, and a reproducibility notebook that regenerates figures from saved CSV outputs. Redistribution-restricted source documents (NEPRA, NTDC, IEA WEO, NREL ATB) are referenced with acquisition instructions in `data/raw/README.md`.

---

## 8. Acknowledgements

The author acknowledges institutional support from Quaid-e-Awam University of Engineering, Science and Technology (QUEST), Nawabshah. Earlier related work under British Council climate support informed parts of the modelling context. Feedback from EnerDay 2026 and international hydrogen experts improved the framing. Remaining errors are the author's responsibility.

---

## 9. References

> **To be finalised in Energy Policy style (60-90 references).**

- Farooq, M.K., Kumar, S., Shrestha, R.M. (2013). Energy, environmental and economic effects of renewable portfolio standards in Pakistan.
- Huangfu, Q., Hall, J.A.J. (2018). Parallelizing the dual revised simplex method.
- Lubin, M., et al. (2023). JuMP 1.0: Recent improvements to a modeling language for mathematical optimization.
- Mirjat, N.H., et al. (2017, 2018). Pakistan energy planning and LEAP scenario analyses.
- Rehman, A., et al. (2017a, 2017b, 2019). LEAP/system dynamics and Pak-TIMES pathways.
- Sadiqa, A., Gulagi, A., Breyer, C. (2018). Pakistan 100% renewable electricity and desalination pathway.
- Valasai, G.D., et al. (2017). Long-term LEAP-based Pakistan energy scenarios.
- Policy and data sources: NEPRA SOIR 2023-24; NTDC IGCEP 2022-31; IEA WEO 2024 STEPS; NREL ATB 2024; AEDB resource atlases; NASA NEX-GDDP-CMIP6.
