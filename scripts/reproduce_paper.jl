include("../data/ingest/run_all_loaders.jl")
run(`julia --project=. src/solve.jl --scenario REF --solver HiGHS --output-tag ref`)
run(`julia --project=. src/solve.jl --scenario LCB --solver HiGHS --output-tag lcb`)
run(`julia --project=. src/solve.jl --scenario NZE --solver HiGHS --climate-enabled false --output-tag nze_static`)
run(`julia --project=. src/solve.jl --scenario NZE --solver HiGHS --climate-enabled true --output-tag nze_dynamic`)
run(`julia --project=. src/solve.jl --scenario NZE --solver HiGHS --output-tag nze`)
include("../post/run_all_postprocess.jl")
using CSV, DataFrames

function _contains(path::String, needle::String)
    isfile(path) || return false
    return occursin(needle, read(path, String))
end

function write_ready_flag()
    val = read("results/validation_log.md", String)
    cap = CSV.read("results/tables/nze_capacity_summary.csv", DataFrame)
    booklet_ok = occursin("Booklet validation: 12 of 13", val) || occursin("Booklet validation: 13 of 13", val)
    battery_ok = Float64(cap.battery_storage_gw[1]) > 0.5
    physical_ok = (0 <= cap.solar_pv_gw[1] <= 350) &&
                  (30 <= cap.total_installed_capacity_2024_gw[1] <= 70) &&
                  (100 <= cap.total_installed_capacity_2050_gw[1] <= 350) &&
                  (0 <= cap.hydropower_2050_gw[1] <= 50) &&
                  (0 <= cap.onshore_wind_2050_gw[1] <= 80) &&
                  (0 <= cap.nuclear_2050_gw[1] <= 10) &&
                  (0 <= cap.electrolyser_2050_gw[1] <= 50)
    pak_times_ok = _contains("results/validation_log.md", "REF 2035 proxy:") &&
                   _contains("results/validation_log.md", "LCB 2035 proxy:")
    artefacts_ok = all(isfile, ["CITATION.cff", ".zenodo.json", "README.md", "Dockerfile", "LICENSE", "data/raw/README.md"])
    ready = booklet_ok && physical_ok && battery_ok && pak_times_ok && artefacts_ok
    failing = String[]
    booklet_ok || push!(failing, "Booklet validation <12/13")
    physical_ok || push!(failing, "Physical sanity ranges failed")
    battery_ok || push!(failing, "Battery <=0.5 GW in NZE 2050")
    pak_times_ok || push!(failing, "Pak-TIMES secondary validation missing")
    artefacts_ok || push!(failing, "Required artefacts missing")
    open("results/ready_for_drafting_status.md", "w") do io
        write(io, "# Ready for paper drafting\n\n")
        write(io, "Ready for paper drafting under tightened criteria: $(ready ? "Y" : "N")\n")
        if !ready
            write(io, "Blocking issues:\n")
            for item in failing
                write(io, "- $(item)\n")
            end
        end
    end
end

write_ready_flag()
println("Full paper reproduction complete")
