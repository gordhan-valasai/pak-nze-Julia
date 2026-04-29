# Divergence Analysis

## Time-slice sensitivity (NZE)

- 24 slices: solar=220663.63 GW, battery=0.00 GW, cost=413.90 USD bn, solve_time=2.52 s
- 48 slices: solar=220663.63 GW, battery=0.00 GW, cost=413.90 USD bn, solve_time=4.26 s
- 96 slices: solar=220663.63 GW, battery=-0.00 GW, cost=413.90 USD bn, solve_time=14.90 s

Finding: Increasing temporal resolution from 24 to 96 slices does not move the central-case result toward the booklet battery benchmark in the current calibration; battery remains ~0 GW and solar remains very high. Temporal resolution alone does not explain the divergence for this model version.
Recommendation: retain 24 slices for the published central case due to faster solve time on HiGHS, while keeping higher-slice runs as diagnostics.

## Storage CAPEX sensitivity (NZE)

- NREL ATB 2024 moderate: battery_2050=-0.00 GW
- NREL ATB 2024 conservative (+10%): battery_2050=-0.00 GW
- Pakistan-specific 1500->600 USD/kW: battery_2050=-0.00 GW

Finding: battery build-out is insensitive to the tested CAPEX trajectories in the current LP optimum, indicating other structural constraints dominate storage deployment in this version.
