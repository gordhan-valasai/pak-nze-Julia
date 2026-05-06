using CSV, CairoMakie, DataFrames

const POWER_FUELS = Set(["coal", "gas", "oil", "uranium"])

function _import_share_percent(sol::PAKNZEJulia.ModelSolution, y::Int)
    imp = sum(get(sol.fuel_imports, (f, y), 0.0) for f in sol.fuels if f in POWER_FUELS)
    tot = sum(get(sol.primary_energy_supply, (f, y), 0.0) for f in sol.fuels if f in POWER_FUELS)
    return 100.0 * imp / max(tot, 1e-9)
end

function run_power_sector_fuel_imports()
    sols = Dict(tag => PAKNZEJulia.load_solution("results/solutions/$(tag).jld2") for tag in ["ref", "lcb", "nze"])
    years = sols["ref"].years
    df = DataFrame(
        year = years,
        ref_import_share_percent = [_import_share_percent(sols["ref"], y) for y in years],
        lcb_import_share_percent = [_import_share_percent(sols["lcb"], y) for y in years],
        nze_import_share_percent = [_import_share_percent(sols["nze"], y) for y in years],
    )
    mkpath("results/tables")
    CSV.write("results/tables/power_sector_fuel_import_dependency.csv", df)

    fig = Figure(size=(1200, 650))
    ax = Axis(fig[1, 1], title="Power-Sector Fuel Import Dependency", xlabel="Year", ylabel="Import Share (%)")
    lines!(ax, df.year, df.ref_import_share_percent, color=:gray, label="REF")
    lines!(ax, df.year, df.lcb_import_share_percent, color=:royalblue, label="LCB")
    lines!(ax, df.year, df.nze_import_share_percent, color=:firebrick, linewidth=3, label="NZE")
    axislegend(ax, position=:rb)
    mkpath("results/figures")
    save("results/figures/fig_9_power_fuel_import_dependency.png", fig, px_per_unit=2)
    save("results/figures/fig_9_power_fuel_import_dependency.pdf", fig)
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_power_sector_fuel_imports()
end
