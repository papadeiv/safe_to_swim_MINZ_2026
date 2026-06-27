# Load up the library modules
include("../inc/Modules.jl")

# Load the list of sites under analysis
include("./sites_list.jl")

# Build, plot and export the data sample 
observations = assembler(sites[5])
sample = builder(observations)
plot_timeseries(sample[:, 1:2], sample[:, 3], sample[:, 16], sites[5])
writeout("sample.csv", sample)

# Compute the covariance matrix of the (standardized) sample
Σ = cov(standardize(sample))
writeout("covariance.csv", Σ)

# Perform the eigendecomposition of the covariance matrix
decomposition = eigen(Σ)
Λ = decomposition.values
V = decomposition.vectors
writeout("eigenvectors.csv", V)
