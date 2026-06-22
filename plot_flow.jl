using CSV
using DataFrames

# Import the file 
df = CSV.read("./flow/Flow_Min.csv", DataFrame)

# Define the data arrays
timestep = df[!,(names(df))[1]]
river = df[!,(names(df))[2]]

missing_idx = findall(!ismissing, river)
display(missing_idx)

#=
println(timestep[1])
println(timestep[2])
println(timestep[end])
=#

#=
println("Columns:")
for col in names(df)
    println(col)
end

# Iterate through columns
for col in names(df)
    println("\nColumn: $col")

    for value in df[!, col]
        println(value)
    end
end
=#
