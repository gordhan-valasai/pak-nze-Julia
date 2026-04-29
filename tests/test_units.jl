using Logging
using YAML

if !isdefined(Main, :PAKNZEJulia)
  include("../src/PAKNZEJulia.jl")
end
using .PAKNZEJulia
"""Check parameter unit sanity and stop on invalid values."""
function run_unit_checks(params)
  bad=String[]
  for (t,v) in params.efficiency_fraction; !(0<v<=1) && push!(bad,"efficiency_fraction tech=$(t) value=$(v)"); end
  for (t,v) in params.capex_usd_per_kw; v<0 && push!(bad,"capex_usd_per_kw tech=$(t) value=$(v)"); end
  for (t,v) in params.capacity_factor; !(0<=v<=1) && push!(bad,"capacity_factor tech=$(t) value=$(v)"); end
  for (t,v) in params.emission_factor_tco2_per_mwh; abs(v)>2.5 && push!(bad,"emission_factor_tco2_per_mwh tech=$(t) value=$(v)"); end
  if !isempty(bad)
    for b in bad; @error "Unit validation failed" offending_parameter=b source="config/technologies.yaml"; end
    error("Parameter unit checks failed")
  end
  true
end

if abspath(PROGRAM_FILE) == @__FILE__
  scenario_config = YAML.load_file("config/scenarios.yaml")
  tech_config = YAML.load_file("config/technologies.yaml")
  constraints_config = YAML.load_file("config/constraints.yaml")
  sets = build_sets(scenario_config, tech_config)
  params = build_parameters(sets, scenario_config, constraints_config, tech_config, "REF")
  run_unit_checks(params)
  println("Unit checks completed")
end
