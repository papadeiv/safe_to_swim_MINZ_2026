using DataFrames, CairoMakie
using ProgressMeter

include("../src/flow_parser.jl")
include("../src/ecoli_parser.jl")
include("../src/export_figure.jl")

# Import the flow data
filename = "flow/Flow_Max.csv"
site_idx = 111
data = flow_parser(filename, site_idx)

# Extract the dates and flow
flow = float.(data.data[:,2])
dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))

# Check daily incremental
#=
non_consecutive_idx = findall(diff(dates) .!= Day(1))
println(dates[1])
for idx in non_consecutive_idx
        println(idx, ") ", dates[idx], " --> ", dates[idx+1])
end
println(dates[end])
=#

# Import the E.coli data
filename = "Banu_Data/$(data.site).csv"
data = ecoli_parser(filename, 2)

# Match the dates between flow (daily) and E.coli (weekly) measurements
#matching_idx = [findfirst(==(date), dates[(non_consecutive_idx[end]+1):end]) for date in data.data[:,1]]
matching_idx = filter(!isnothing, [findfirst(==(date), dates) for date in data.data[:,1]]) .- 1

# Loop over the matching indices
flow_matrix = Matrix{Any}(undef, length(matching_idx), 4)
for (n, idx) in enumerate(matching_idx)
        flow_matrix[n,1] = dates[idx]
        flow_matrix[n,2] = flow[idx]
        flow_matrix[n,3] = max(flow[idx],flow[idx-1],flow[idx-2])
        flow_matrix[n,4] = flow[idx]+flow[idx-1]+flow[idx-2]
end

colnames = ["day", "1 day flow", "3 days max flow", "3 days total flow"]
df = DataFrame(flow_matrix, Symbol.(colnames))
CSV.write("../data/observations/flow_max/3.csv", df)
