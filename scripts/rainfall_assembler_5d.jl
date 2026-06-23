using DataFrames, CairoMakie
using ProgressMeter

include("../src/rainfall_parser.jl")
include("../src/ecoli_parser.jl")
include("../src/export_figure.jl")

# Import the rainfall data
filename = "rainfall/RFTOTAL.csv"
site_idx = 56
data = rainfall_parser(filename, site_idx)

# Extract the dates and rainfall
rainfall = float.(data.data[:,2])
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
filename = "ecoli/Waikawa at North Manakau Road.csv"
data = ecoli_parser(filename, 2)

# Match the dates between flow (daily) and E.coli (weekly) measurements
#matching_idx = [findfirst(==(date), dates[(non_consecutive_idx[end]+1):end]) for date in data.data[:,1]]

matching_idx = filter(!isnothing, [findfirst(==(date), dates) for date in data.data[:,1]]) .- 1

# Loop over the matching indices
rainfall_matrix = Matrix{Any}(undef, length(matching_idx), 4)
for (n, idx) in enumerate(matching_idx)
        rainfall_matrix[n,1] = dates[idx]
        rainfall_matrix[n,2] = rainfall[idx]
        rainfall_matrix[n,3] = max(rainfall[idx],rainfall[idx-1],rainfall[idx-2],rainfall[idx-3],rainfall[idx-4])
        rainfall_matrix[n,4] = rainfall[idx]+rainfall[idx-1]+rainfall[idx-2]+rainfall[idx-3]+rainfall[idx-4]
end

colnames = ["day", "1 day", "5 days max", "5 days total"]
df = DataFrame(rainfall_matrix, Symbol.(colnames))
CSV.write("../data/observations/rainfall/5.csv", df)
