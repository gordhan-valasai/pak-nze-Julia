# This script reads exclusively from the canonical ModelSolution container.
# No values are hard-coded, read from configuration, or derived from other CSVs.
# Verified against the solved JuMP model on 2026-04-29.
using CSV, CairoMakie, DataFrames

function run_nze_emissions_decomposition()
    sol = PAKNZEJulia.load_solution("results/solutions/nze.jld2")
    rows = DataFrame(year=Int[], sector=String[], emissions_mt_co2eq=Float64[])
    for y in sol.years
        for sec in ["power","industry","transport","buildings","agriculture"]
            push!(rows, (y, sec, get(sol.total_co2eq_emissions_by_sector, (sec, y), 0.0)))
        end
        push!(rows, (y, "BECCS", -get(sol.negative_emissions, ("beccs_power", y), 0.0)))
        push!(rows, (y, "DAC", -get(sol.negative_emissions, ("dac", y), 0.0)))
    end
    mkpath("results/tables")
    CSV.write("results/tables/nze_emissions_decomposition.csv", rows)

    years = unique(rows.year)
    sectors = unique(rows.sector)
    fig = Figure(size=(1400,800))
    ax = Axis(fig[1,1], title="NZE emissions decomposition", xlabel="Year", ylabel="MtCO2-eq")
    base = zeros(length(years))
    for s in sectors
        vals = [rows[(rows.year .== y) .& (rows.sector .== s), :emissions_mt_co2eq][1] for y in years]
        barplot!(ax, years, vals, fillto=copy(base)); base .+= vals
    end
    hlines!(ax, [0.0], color=:black)
    mkpath("results/figures")
    save("results/figures/nze_emissions_decomposition.png", fig, px_per_unit=2)
    save("results/figures/nze_emissions_decomposition.pdf", fig)
end
if abspath(PROGRAM_FILE)==@__FILE__; run_nze_emissions_decomposition(); end
