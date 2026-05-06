using CSV, CairoMakie, DataFrames

function run_hydrogen_capacity()
    rows = DataFrame(scenario=String[], year=Int[], electrolyser_capacity_gw=Float64[])
    for tag in ["ref", "lcb", "nze"]
        sol = PAKNZEJulia.load_solution("results/solutions/$(tag).jld2")
        for y in sol.years
            push!(rows, (uppercase(sol.scenario), y, get(sol.electrolyser_capacity_gw, y, 0.0)))
        end
    end
    mkpath("results/tables")
    CSV.write("results/tables/hydrogen_capacity.csv", rows)

    fig = Figure(size=(1200, 650))
    ax = Axis(fig[1, 1], title="Electrolyser Capacity Trajectory", xlabel="Year", ylabel="GW")
    for sc in ["REF", "LCB", "NZE"]
        sub = rows[rows.scenario .== sc, :]
        lines!(ax, sub.year, sub.electrolyser_capacity_gw, label=sc)
    end
    axislegend(ax, position=:lt)
    mkpath("results/figures")
    save("results/figures/fig_8_electrolyser_capacity_trajectory.png", fig, px_per_unit=2)
    save("results/figures/fig_8_electrolyser_capacity_trajectory.pdf", fig)
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_hydrogen_capacity()
end
