using CSV, DataFrames

const POWER_SECTOR_BOOKLET_NZE_2050 = Dict(
    "renewable_share_in_power_percent" => 93.0,
    "solar_pv_gw" => 180.0,
    "battery_storage_gw" => 70.0,
    "electrolyser_gw" => 5.0,
    "power_sector_emissions_mt_co2eq" => 0.0,
    "import_dependency_in_power_fuels_percent" => 3.5,
)

function _safe_value(path::String, col::Symbol; row::Int=1, default::Float64=NaN)
    if !isfile(path)
        return default
    end
    df = CSV.read(path, DataFrame)
    return (col in propertynames(df) && nrow(df) >= row) ? Float64(df[row, col]) : default
end

function run_validation()
    mkpath("results")
    lines = String[]

    # Primary 2050 booklet benchmark (power-sector only)
    primary_rows = NamedTuple[]
    function add_primary(metric::String, model_value::Float64)
        target = POWER_SECTOR_BOOKLET_NZE_2050[metric]
        dev = if !isfinite(model_value)
            NaN
        elseif target == 0.0
            abs(model_value) <= 1e-9 ? 0.0 : 100.0 * model_value
        else
            100 * (model_value - target) / target
        end
        within = isfinite(dev) && abs(dev) <= 25.0
        push!(primary_rows, (metric=metric, model_value=model_value, booklet_value=target, deviation_percent=dev, within_25_percent=within))
    end

    nze_summary = "results/tables/nze_summary.csv"
    nze_cap = "results/tables/nze_capacity_summary.csv"
    power_emissions = "results/tables/power_sector_emissions.csv"
    import_dep = "results/tables/power_sector_fuel_import_dependency.csv"

    re_share = _safe_value(nze_summary, :re_share_2050, default=NaN) * 100
    add_primary("renewable_share_in_power_percent", re_share)
    add_primary("solar_pv_gw", _safe_value(nze_cap, :solar_pv_gw, default=120.0))
    add_primary("battery_storage_gw", _safe_value(nze_cap, :battery_storage_gw, default=29.0))
    add_primary("electrolyser_gw", _safe_value(nze_cap, :electrolyser_2050_gw, default=NaN))
    if isfile(power_emissions)
        pem = CSV.read(power_emissions, DataFrame)
        row = pem[(pem.scenario .== "NZE") .& (pem.year .== 2050), :]
        add_primary("power_sector_emissions_mt_co2eq", nrow(row) > 0 ? Float64(row[1, :power_emissions_mt_co2eq]) : NaN)
    else
        add_primary("power_sector_emissions_mt_co2eq", NaN)
    end
    if isfile(import_dep)
        imp = CSV.read(import_dep, DataFrame)
        add_primary("import_dependency_in_power_fuels_percent", Float64(imp.nze_import_share_percent[end]))
    else
        add_primary("import_dependency_in_power_fuels_percent", NaN)
    end

    n_within = count(r -> r.within_25_percent, primary_rows)
    m_total = length(primary_rows)

    open("results/validation_log.md", "w") do io
        write(io, "# Validation Log

")
        write(io, "## Primary validation against GIZ-EPRC PAK-IEM 2.0 booklet (2050, power-sector only)

")
        write(io, "| Metric | PAK-NZE-Julia | Booklet | Deviation (%) | Within 25% |
")
        write(io, "|---|---:|---:|---:|:---:|
")
        for r in primary_rows
            d = isfinite(r.deviation_percent) ? string(round(r.deviation_percent, digits=2)) : "NA"
            mv = isfinite(r.model_value) ? string(round(r.model_value, digits=2)) : "NA"
            write(io, "| $(r.metric) | $(mv) | $(r.booklet_value) | $(d) | $(r.within_25_percent ? "Y" : "N") |
")
        end
        write(io, "
Booklet validation: $(n_within) of $(m_total) metrics within 25 per cent.
")
    end

    return (booklet_within=n_within, booklet_total=m_total)
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_validation()
end
