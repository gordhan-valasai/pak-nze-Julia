using CSV, CairoMakie, DataFrames

function run_power_sector_emissions()
    scenarios = ["ref", "lcb", "nze"]
    rows = DataFrame(scenario=String[], year=Int[], power_emissions_mt_co2eq=Float64[])
    for tag in scenarios
        sol = PAKNZEJulia.load_solution("results/solutions/$(tag).jld2")
        for y in sol.years
            push!(rows, (uppercase(sol.scenario), y, get(sol.total_co2eq_emissions_by_sector, ("power", y), 0.0)))
        end
    end
    mkpath("results/tables")
    CSV.write("results/tables/power_sector_emissions.csv", rows)

    fig = Figure(size=(1200, 650))
    ax = Axis(fig[1, 1], title="Power-Sector Emissions Trajectory", xlabel="Year", ylabel="MtCO2-eq")
    for sc in ["REF", "LCB", "NZE"]
        sub = rows[rows.scenario .== sc, :]
        lines!(ax, sub.year, sub.power_emissions_mt_co2eq, label=sc)
    end
    axislegend(ax, position=:rt)
    mkpath("results/figures")
    save("results/figures/fig_2_power_emissions_trajectory.png", fig, px_per_unit=2)
    save("results/figures/fig_2_power_emissions_trajectory.pdf", fig)
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_power_sector_emissions()
end
