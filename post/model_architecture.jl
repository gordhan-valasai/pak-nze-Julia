using CairoMakie

function run_model_architecture()
    fig = Figure(size=(1400, 800))
    ax = Axis(fig[1, 1], title="PAK-NZE-Julia Power-Sector Model Architecture")
    hidedecorations!(ax)
    hidespines!(ax)
    xlims!(ax, 0, 100)
    ylims!(ax, 0, 100)

    # Inputs
    poly!(ax, Rect(5, 65, 24, 24), color=:lightgray, strokecolor=:black)
    text!(ax, 17, 77, text="Exogenous Inputs\nDemand, CAPEX,\nFuel Prices", align=(:center, :center))

    # Core optimizer
    poly!(ax, Rect(36, 58, 28, 30), color=:lightblue, strokecolor=:black)
    text!(ax, 50, 73, text="JuMP Power Optimizer\nNational Capacity Build\n24 Slices", align=(:center, :center))

    # Provincial layer
    poly!(ax, Rect(70, 58, 25, 30), color=:lightgreen, strokecolor=:black)
    text!(ax, 82.5, 73, text="Provincial Dispatch\n7 Provinces +\nTransmission", align=(:center, :center))

    # Climate feedback
    poly!(ax, Rect(36, 20, 28, 24), color=:wheat, strokecolor=:black)
    text!(ax, 50, 32, text="Climate Feedback\nTemperature ->\nDemand & Derating", align=(:center, :center))

    # Outputs
    poly!(ax, Rect(70, 20, 25, 24), color=:mistyrose, strokecolor=:black)
    text!(ax, 82.5, 32, text="Outputs\nEmissions, Mix,\nFlows, Imports", align=(:center, :center))

    arrows!(ax, [29], [77], [7], [0], arrowsize=14, linewidth=2, color=:black)
    arrows!(ax, [64], [73], [6], [0], arrowsize=14, linewidth=2, color=:black)
    arrows!(ax, [50], [44], [0], [12], arrowsize=14, linewidth=2, color=:black)
    arrows!(ax, [64], [32], [6], [0], arrowsize=14, linewidth=2, color=:black)
    arrows!(ax, [64], [58], [0], [-14], arrowsize=14, linewidth=2, color=:black)

    mkpath("results/figures")
    save("results/figures/fig_1_model_architecture.png", fig, px_per_unit=2)
    save("results/figures/fig_1_model_architecture.pdf", fig)
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_model_architecture()
end
