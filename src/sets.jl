struct ModelSets
    years::Vector{Int}
    slices::Vector{String}
    technologies::Vector{String}
    fuels::Vector{String}
    service_demands::Vector{String}
    renewable_technologies::Vector{String}
    greenhouse_gases::Vector{String}
    provinces::Vector{String}
end

"""Build model index sets from config dictionaries."""
function build_sets(config::AbstractDict, technology_config::AbstractDict)::ModelSets
    years = collect(Int(config["global"]["start_year"]):Int(config["global"]["end_year"]))
    slices = String.(config["global"]["representative_slices"])
    technologies = [String(x["name"]) for x in technology_config["technologies"]]
    for extra in ["beccs_power", "dac"]
        extra in technologies || push!(technologies, extra)
    end
    fuels = ["coal", "gas", "oil", "uranium", "biomass", "hydrogen", "electricity"]
    service_demands = collect(keys(technology_config["service_demands"]))
    renewable_technologies = [String(x["name"]) for x in technology_config["technologies"] if get(x, "is_renewable", false)]
    greenhouse_gases = ["CO2", "CH4", "N2O", "HFC", "PFC", "SF6"]
    provinces = ["Punjab", "Sindh", "KPK", "Balochistan", "GB", "AJK", "Islamabad"]
    ModelSets(years, slices, technologies, fuels, service_demands, renewable_technologies, greenhouse_gases, provinces)
end
