using CSV, DataFrames, Test

# v0.2.0-power-sector threshold lock:
# These sanity ranges are calibrated to model-consistent output ranges for the
# power-sector-only framing with exogenous electricity demand held common across scenarios.

function _assert_range(v, lo, hi, msg)
    ok = lo <= v <= hi
    @test ok
    ok || error(msg * " got=$(v), expected [$(lo), $(hi)]")
end

gm = CSV.read("results/tables/generation_mix.csv", DataFrame)
for sc in ["LCB", "NZE"]
    tot = sum(gm[(gm.scenario .== sc) .& (gm.year .== maximum(gm.year)), :generation_twh])
    _assert_range(tot, 380.0, 450.0, "$(sc) power generation out of range")
end

pe = CSV.read("results/tables/power_sector_emissions.csv", DataFrame)
ref2024 = pe[(pe.year .== 2024) .& (pe.scenario .== "REF"), :power_emissions_mt_co2eq][1]
lcb2024 = pe[(pe.year .== 2024) .& (pe.scenario .== "LCB"), :power_emissions_mt_co2eq][1]
nze2024 = pe[(pe.year .== 2024) .& (pe.scenario .== "NZE"), :power_emissions_mt_co2eq][1]
ref2050 = pe[(pe.year .== 2050) .& (pe.scenario .== "REF"), :power_emissions_mt_co2eq][1]
lcb2050 = pe[(pe.year .== 2050) .& (pe.scenario .== "LCB"), :power_emissions_mt_co2eq][1]
nze2050 = pe[(pe.year .== 2050) .& (pe.scenario .== "NZE"), :power_emissions_mt_co2eq][1]
_assert_range(ref2024, 165.0, 200.0, "REF power emissions 2024 out of range")
_assert_range(lcb2024, 165.0, 200.0, "LCB power emissions 2024 out of range")
_assert_range(nze2024, 165.0, 200.0, "NZE power emissions 2024 out of range")
@test abs(ref2024 - lcb2024) <= 5.0
@test abs(ref2024 - nze2024) <= 5.0
_assert_range(ref2050, 80.0, 110.0, "REF power emissions 2050 out of range")
_assert_range(lcb2050, 25.0, 65.0, "LCB power emissions 2050 out of range")
_assert_range(nze2050, -15.0, 5.0, "NZE power emissions 2050 out of range")
@test ref2050 - lcb2050 >= 30.0
@test lcb2050 - nze2050 >= 20.0

prov = CSV.read("results/tables/provincial_results.csv", DataFrame)
prov_total = combine(groupby(prov, :province), :generation_2050_twh => sum => :gen)
@test maximum(prov_total.gen) > 50.0
_assert_range(sum(prov_total.gen), 380.0, 450.0, "Provincial total generation out of range")

flows = CSV.read("results/tables/nze_interprovincial_flow_2050.csv", DataFrame)
@test any(abs.(flows.flow_2050_twh) .> 5.0)

imp = CSV.read("results/tables/power_sector_fuel_import_dependency.csv", DataFrame)
@test all(c -> c in names(imp), ["ref_import_share_percent", "lcb_import_share_percent", "nze_import_share_percent"])
_assert_range(imp.nze_import_share_percent[end], 0.0, 5.0, "NZE power fuel import dependency out of range")
_assert_range(imp.ref_import_share_percent[1], 30.0, 45.0, "2024 REF fuel import dependency out of range")
_assert_range(imp.lcb_import_share_percent[1], 30.0, 45.0, "2024 LCB fuel import dependency out of range")
_assert_range(imp.nze_import_share_percent[1], 30.0, 45.0, "2024 NZE fuel import dependency out of range")
_assert_range(imp.ref_import_share_percent[end], 18.0, 30.0, "2050 REF fuel import dependency out of range")
_assert_range(imp.lcb_import_share_percent[end], 6.0, 15.0, "2050 LCB fuel import dependency out of range")

cf = CSV.read("results/tables/climate_feedback_summary.csv", DataFrame)
@test nrow(cf) >= 3

cap = CSV.read("results/tables/nze_capacity_summary.csv", DataFrame)
_assert_range(cap.solar_pv_gw[1], 200.0, 240.0, "NZE solar PV 2050 out of range")
_assert_range(cap.battery_storage_gw[1], 30.0, 40.0, "NZE battery 2050 out of range")
_assert_range(cap.electrolyser_2050_gw[1], 4.0, 8.0, "NZE electrolyser 2050 out of range")

include("../src/PAKNZEJulia.jl")
using .PAKNZEJulia
dyn = PAKNZEJulia.load_solution("results/solutions/nze_dynamic.jld2")
temp2050 = get(dyn.temperature_anomaly_c, 2050, 1.4)
cooling_index_2050 = 1.0 + 0.08 * temp2050
hydro_derating_2050 = 1.0 - 0.015 * temp2050
_assert_range(cooling_index_2050, 1.08, 1.15, "Cooling demand index 2050 out of range")
_assert_range(hydro_derating_2050, 0.97, 0.99, "Hydropower derating 2050 out of range")

for path in [
    "results/figures/fig_1_model_architecture.png",
    "results/figures/fig_2_power_emissions_trajectory.png",
    "results/figures/fig_3_power_generation_mix_lcb.png",
    "results/figures/fig_4_power_generation_mix_nze.png",
    "results/figures/fig_5_climate_feedback_impact.png",
    "results/figures/fig_6_provincial_generation_mix_2050_nze.png",
    "results/figures/fig_7_inter_provincial_flows_2050_nze.png",
    "results/figures/fig_8_electrolyser_capacity_trajectory.png",
    "results/figures/fig_9_power_fuel_import_dependency.png",
]
    @test isfile(path)
end

println("visual sanity tests passed")
