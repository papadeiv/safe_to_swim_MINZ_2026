using DataFrames, CSV
using LinearAlgebra, Statistics
using ProgressMeter, CairoMakie, LaTeXStrings

include("../src/assembler.jl")
include("../src/generate_power_set.jl")
include("../src/import_test_functions_new.jl")
include("../src/fit_bif_diag.jl")
include("../src/export_figure.jl")

# Build the observation matrices
observation_matrices = assembler()
flow_df = observation_matrices.flow_matrix
rainfall_df = observation_matrices.rainfall_matrix

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

# Build and normalize the sample (zero mean and unitary standard deviation)
sample = hcat(flow_df, rainfall_df[:, 3:end])
X = (Float64.(Matrix(sample[:,2:end])) .- mean(Float64.(Matrix(sample[:,2:end])), dims=1))./std(Float64.(Matrix(sample[:,2:end])), dims=1)

# Split the sample in observations (x) and covariates (C)
x = X[:,1]
C = X[:,2:end]

# Extract the plausible covariates (C_tilde)
cov_idx = [5, 7, 9, 11, 13, 26]
C_tilde = C[:,cov_idx]

# Generate the power set of all possible combinations of plausible covariates
#subsets = generate_power_set(size(C_tilde, 2))
subsets = [[2,4,5,6]]

# Import list of test functions
g_list = import_test_functions_new()

# Loop over the elements of the power set
subset_idx = 1
for subset in subsets
        # Generate the subset
        c = C_tilde[:, subset]

        # Loop over the elements in the subset
        c_name = ""
        for (n, e) in enumerate(subset)
                # Append covariate element to the string
                c_name = c_name*L"c_%$(e),"
        end

        # Loop over the test functions
        function_idx = 1
        for (label, g) in g_list
                # Compute μ = g(c)
                μ = g(c)

                # Fit the bifurcation diagram
                coefficients = [0.9, 2.8, -15.0, 13.0, 0.0] 
                fit = fit_bif_diag(x, μ, coefficients)
                μ_lim = fit.μ_limits

                # Create and format the figure
                title = L"\mu \in %$(label)(%$(c_name))"
                fig = Figure(; size = (600, 300))
                ax = Axis(fig[1, 1],
                          limits = (μ_lim[1], μ_lim[2], -0.75, 1.5),
                          xgridvisible = false,
                          ygridvisible = false,
                          xlabel = L"\mu",
                          ylabel = L"X_t",
                          xlabelvisible = true,
                          ylabelvisible = true,
                          title = L"\mu \in %$(label)(%$(c_name))",
                          #title = "$(new_coeff)",
                          #xticks = [-1,0,1],
                          #yticks = [-0.35,0,0.5],
                          xticklabelsvisible = true,
                          yticklabelsvisible = true,
                          xtickalign = 1,
                          ytickalign = 1,
                         )

                # Plot and export the figure 
                lines!(ax, fit.μ, fit.x, color = :black, linewidth = 3.0)
                colors = Tuple{Symbol,Float64}[]
                for ecoli in x
                        if ecoli > 0.5
                                push!(colors, (:red,0.5))
                        else
                                push!(colors, (:green,0.5))
                        end
                end
                scatter!(ax, μ, x, color = colors, strokewidth = 1.0, markersize=20)
                savefig("/model/$(subset_idx)/$(function_idx).png", fig)
                function_idx = function_idx + 1
        end

        # Update plotting subset
        global subset_idx = subset_idx + 1
end
