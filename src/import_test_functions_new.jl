using LaTeXStrings

# ------------------------------------------------------------
# Candidate test functions
# ------------------------------------------------------------

function g_rbf(C::Matrix{Float64})
    μ = vec(mean(C, dims=1))
    d2 = sum((C .- μ').^2, dims=2)
    σ2 = mean(d2)
    return exp.(-d2[:] ./ (2σ2))
end

# Export the test functions as a dictionary
function import_test_functions_new()
        g_list = Dict(
                      "rbf"            => g_rbf
                     )
        return g_list
end
