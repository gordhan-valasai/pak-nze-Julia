"""
PAK-NZE-Julia: Open-source Julia-JuMP replication and extension of the
GIZ-EPRC Pakistan Integrated Energy Model (PAK-IEM 2.0), with three
extensions not present in the official model: (1) climate feedback
module driven by CMIP6 temperature anomaly trajectories, (2) provincial
disaggregation of the power module across seven provinces and federal
territories, (3) full open-source release under MIT licence with
reproducibility notebook and Docker image.

The official PAK-IEM 2.0 is built in TIMES-VEDA by the Energy Planning
and Resource Centre (EPRC), Government of Pakistan, with technical
support from Deutsche Gesellschaft fur Internationale Zusammenarbeit
(GIZ) under the German Federal Ministry for Economic Cooperation and
Development (BMZ), published February 2026. PAK-NZE-Julia is an
independent open-source replication and is not affiliated with EPRC,
GIZ, or BMZ.

Calibration: FY 2023-24 (consistent with official PAK-IEM 2.0).
Planning horizon: 2024 to 2050.
Solver: HiGHS (default), Gurobi (optional).
Licence: MIT.
"""
module PAKNZEJulia
using ArgParse, CSV, DataFrames, Dates, JuMP, Logging, YAML
include("sets.jl")
include("parameters.jl")
include("variables.jl")
include("objective.jl")
include("constraints_balance.jl")
include("constraints_capacity.jl")
include("constraints_emissions.jl")
include("modules/power.jl")
include("modules/hydrogen.jl")
include("modules/industry_ccus.jl")
include("modules/transport.jl")
include("modules/buildings.jl")
include("modules/agriculture.jl")
include("modules/climate_feedback.jl")
export ModelSets, ModelParameters, build_sets, build_parameters, add_variables!, add_objective!, add_balance_constraints!, add_capacity_constraints!, add_emissions_constraints!, add_power_constraints!, add_hydrogen_constraints!, add_industry_ccus_constraints!, add_transport_constraints!, add_buildings_constraints!, add_agriculture_constraints!, apply_climate_feedback!
end
