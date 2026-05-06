# This script reads exclusively from the canonical ModelSolution container.
# No values are hard-coded, read from configuration, or derived from other CSVs.
# Verified against the solved JuMP model on 2026-04-29.
using CSV, CairoMakie, DataFrames

function run_generation_mix()
    years = [2024, 2030, 2035, 2040, 2045, 2050]
    scenarios = ["lcb", "nze"]
    rows = DataFrame(scenario=String[], year=Int[], technology=String[], generation_twh=Float64[])
    for tag in scenarios
        sol = PAKNZEJulia.load_solution("results/solutions/$(tag).jld2")
        sc = uppercase(sol.scenario)
        for y in years, t in sol.technologies
            g = sum(get(sol.annual_generation, (t, y, p), 0.0) for p in sol.provinces)
            push!(rows, (sc, y, t, g))
        end
    end
    mkpath("results/tables")
    CSV.write("results/tables/generation_mix.csv", rows)
    totals = combine(groupby(rows, [:scenario, :year]), :generation_twh => sum => :total_generation_twh)
    CSV.write("results/tables/generation_mix_totals.csv", totals)

    mkpath("results/figures")
    for sc in unique(rows.scenario)
        sub = rows[rows.scenario .== sc, :]
        techs = unique(sub.technology)
        fig = Figure(size=(1300,700))
        ax = Axis(fig[1,1], title="$(sc) Power Generation Mix", xlabel="Year", ylabel="TWh")
        bot = zeros(length(years))
        for t in techs
            vals = [sub[(sub.year .== y) .& (sub.technology .== t), :generation_twh][1] for y in years]
            barplot!(ax, years, vals, fillto=copy(bot))
            bot .+= vals
        end
        fig_path = sc == "LCB" ? "fig_3_power_generation_mix_lcb" : "fig_4_power_generation_mix_nze"
        save("results/figures/$(fig_path).png", fig, px_per_unit=2)
        save("results/figures/$(fig_path).pdf", fig)
    end
end
if abspath(PROGRAM_FILE)==@__FILE__; run_generation_mix(); end
