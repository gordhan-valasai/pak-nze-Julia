using Test, YAML, JuMP, HiGHS

include("../src/PAKNZEJulia.jl")
using .PAKNZEJulia

@testset "Balance setup" begin
  sc = YAML.load_file("config/scenarios.yaml")
  tc = YAML.load_file("config/technologies.yaml")
  cc = YAML.load_file("config/constraints.yaml")
  sets = build_sets(sc, tc)
  params = build_parameters(sets, sc, cc, tc, "REF")

  model = Model(HiGHS.Optimizer)
  add_variables!(model, sets)
  add_objective!(model, sets, params)
  add_balance_constraints!(model, sets, params)
  add_capacity_constraints!(model, sets, params)
  add_emissions_constraints!(model, sets, params)
  add_power_constraints!(model, sets, params)
  add_hydrogen_constraints!(model, sets, params)
  add_industry_ccus_constraints!(model, sets, params)
  add_transport_constraints!(model, sets, params)
  add_buildings_constraints!(model, sets, params)
  add_agriculture_constraints!(model, sets, params)
  optimize!(model)

  annual_activity = model[:annual_activity_mwh]
  power_techs = ["hydro_run_of_river","hydro_reservoir","nuclear_k2_k3","thar_coal_domestic","coal_imported","rlng_ccgt","oil_thermal","solar_utility","solar_distributed","onshore_wind","offshore_wind","green_h2_peaker"]
  for y in sets.years
    supply = sum(value(annual_activity[t, y]) for t in power_techs if t in sets.technologies)
    demand = params.demand_by_service[("electricity_grid_gwh", y)] * 1000.0
    gap = abs(supply - demand) / max(demand, 1e-6)
    @test gap <= 0.001
  end
end
