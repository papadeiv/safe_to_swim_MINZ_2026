# Load up the library modules
include("../inc/Modules.jl")

# Input sites triple
sites = (
         swimsite = "Waikawa at North Manakau Road", # Waikawa Estuary at Footbridge
         flowsite = "Waikawa at North Manakau Road", # Waikawa at North Manakau Road
         rainsite = "Ohau at Makahika"               # Manakau at Manakau
        )

# Build the observation matrices and plot the timeseries of the sites
observation_matrices = assembler(sites)

flow_df = observation_matrices.flow_matrix
rainfall_df = observation_matrices.rainfall_matrix
plot_timeseries(flow_df[:, 1:3], rainfall_df[:, 1:3], sites)

# Extract the measurement dates
flow_dates = flow_df[!,(names(flow_df))[1]]
rainfall_dates = rainfall_df[!,(names(rainfall_df))[1]]

# Loop over the measurement dates
missing_idx = Integer[]
for (idx, date) in enumerate(rainfall_dates)
        # Check if the flow dates and the rainfall dates match
        if date ∈ flow_dates
                # Skip this step
        else
                push!(missing_idx, idx)
        end
end

# Remove the missing measurements from the rainfall data
deleteat!(rainfall_df, missing_idx)

# Build the sample
sample = hcat(flow_df, rainfall_df[:, 3:end])
writeout("sample.csv", sample)

# Normalize the sample (zero mean and unitary standard deviation)
X = (Float64.(Matrix(sample[:,2:end])) .- mean(Float64.(Matrix(sample[:,2:end])), dims=1))./std(Float64.(Matrix(sample[:,2:end])), dims=1)
writeout("standardized_sample.csv", X)

# Sanity check
for (idx, feature) in enumerate(eachcol(X))
        println("col.", idx, "    mean=", mean(feature), ", std=", std(feature))
end

# Compute the covariance matrix
Σ = cov(X) # (1/(size(X,2) - 1)).*(transpose(X)*X)
writeout("covariance.csv", Σ)

# Perform the eigendecomposition of the covariance matrix
decomposition = eigen(Σ)
Λ = decomposition.values
V = decomposition.vectors
writeout("eigenvectors.csv", V)

# Plot the data distribution
plot_distribution(X)
