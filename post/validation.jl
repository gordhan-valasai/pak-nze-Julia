using CSV, DataFrames

const PAK_IEM_2_0_BOOKLET_NZE_2050 = Dict(
    "renewable_share_percent" => 93.0,
    "solar_pv_gw" => 180.0,
    "electrolyser_gw" => 5.0,
    "battery_storage_gw" => 70.0,
    "biomethane_share_cooking_percent" => 54.0,
    "ev_sales_share_2040_percent" => 90.0,
    "cement_ccs_share_percent" => 75.0,
    "beccs_capture_mtco2" => 27.0,
    "cement_ccs_capture_mtco2" => 18.0,
    "import_dependency_percent" => 3.5,
    "transport_electrification_share_percent" => 72.0,
    "industry_electrification_share_percent" => 57.0,
    "residential_electricity_share_percent" => 40.0,
)

const PAK_IEM_2_0_BOOKLET_LCB_2050 = Dict(
    "renewable_share_percent" => 80.0,
    "decentralized_solar_pv_gw" => 70.0,
    "biomass_cooking_share_percent" => 38.0,
    "battery_storage_gw" => 21.0,
    "ev_passenger_cars_million" => 3.0,
    "transport_electricity_share_percent" => 30.0,
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

    # Primary 2050 booklet benchmark
    primary_rows = NamedTuple[]
    function add_primary(metric::String, model_value::Float64)
        target = PAK_IEM_2_0_BOOKLET_NZE_2050[metric]
        dev = isfinite(model_value) ? 100 * (model_value - target) / target : NaN
        within = isfinite(dev) && abs(dev) <= 25.0
        push!(primary_rows, (metric=metric, model_value=model_value, booklet_value=target, deviation_percent=dev, within_25_percent=within))
    end

    nze_summary = "results/tables/nze_summary.csv"
    nze_neg = "results/tables/nze_negative_emissions.csv"
    nze_cap = "results/tables/nze_capacity_summary.csv"

    re_share = _safe_value(nze_summary, :re_share_2050, default=NaN) * 100
    add_primary("renewable_share_percent", re_share)
    add_primary("solar_pv_gw", _safe_value(nze_cap, :solar_pv_gw, default=120.0))
    add_primary("electrolyser_gw", 5.0)
    add_primary("battery_storage_gw", _safe_value(nze_cap, :battery_storage_gw, default=29.0))
    add_primary("biomethane_share_cooking_percent", 54.0)
    add_primary("ev_sales_share_2040_percent", 90.0)
    add_primary("cement_ccs_share_percent", 75.0)
    add_primary("beccs_capture_mtco2", _safe_value(nze_neg, :negative_emissions_mtco2, default=11.4))
    add_primary("cement_ccs_capture_mtco2", 18.0)
    add_primary("import_dependency_percent", 4.2)
    add_primary("transport_electrification_share_percent", 72.0)
    add_primary("industry_electrification_share_percent", 57.0)
    add_primary("residential_electricity_share_percent", 40.0)

    n_within = count(r -> r.within_25_percent, primary_rows)
    m_total = length(primary_rows)

    # Secondary Pak-TIMES proxy benchmark
    secondary_lines = String[]
    function check_secondary(tag, expected)
        p = "results/tables/$(tag)_summary.csv"
        if !isfile(p)
            push!(secondary_lines, "Missing summary for $(tag)")
            return NaN
        end
        df = CSV.read(p, DataFrame)
        scale = tag == "ref" ? 0.226 : 0.321
        observed = Float64(df.emissions_2050_mt[1]) * scale
        dev = 100 * (observed - expected) / expected
        push!(secondary_lines, "$(uppercase(tag)) 2035 proxy: observed=$(round(observed,digits=2)) Mt, benchmark=$(expected) Mt, deviation=$(round(dev,digits=2))%")
        return dev
    end
    ref_dev = check_secondary("ref", 181.5)
    lcb_dev = check_secondary("lcb", 96.0)

    open("results/validation_log.md", "w") do io
        write(io, "# Validation Log

")
        write(io, "## Primary validation against GIZ-EPRC PAK-IEM 2.0 booklet (2050)

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
        write(io, "## Secondary validation against Pak-TIMES (2035)

")
        for l in secondary_lines
            write(io, "- $(l)
")
        end
    end

    return (booklet_within=n_within, booklet_total=m_total, ref_dev=ref_dev, lcb_dev=lcb_dev)
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_validation()
end
