# Raw Data Inputs and License Status

## Redistribution-restricted sources

1. `NTDC_IGCEP_2022_31.pdf`
   - Source: NTDC IGCEP 2022-31
   - License status: redistribution-restricted
   - Place manually in this folder.

2. `NEPRA_SOI_2023_24.pdf`
   - Source: NEPRA State of Industry Report 2023-24
   - License status: redistribution-restricted
   - Place manually in this folder.

3. `IEA_WEO_2024_STEPS.pdf`
   - Source: IEA World Energy Outlook 2024 STEPS
   - License status: redistribution-restricted
   - Place manually in this folder.

## Optional CSV fallback inputs

- `igcep_projects.csv`
- `iea_weo_prices.csv`
- `nrel_atb_2024.csv`
- `macro_history_2000_2023.csv`
- `nepra_sankey_2023_24.csv`

These are schema-compatible fallback files used by loaders when PDF extraction is not possible.


## Reference to the Official PAK-IEM 2.0 Model

Calibration values used in PAK-NZE-Julia are drawn from the same authoritative sources used in the official PAK-IEM 2.0 (NEPRA SOIR 2023-24, NTDC IGCEP 2022-31, IEA WEO 2024, NREL ATB 2024) but transcribed independently. The official model may use additional Pakistan-specific data developed by EPRC and E4SMA that are not publicly available, which is one source of divergence between the two implementations.
