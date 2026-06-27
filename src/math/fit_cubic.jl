function fit_cubic(sample, estimated_parameter, coefficients)
        # Build the bifurcation diagram's polynomial
        c = coefficients
        p(x) = c[4]*(x-c[5])^3 + c[3]*(x-c[5])^2 + c[2]*(x-c[5]) + c[1]

        # Extract range of the bifurcation diagram
        x_min = minimum(sample)
        x_max = maximum(sample)
        Δx = x_max - x_min
        μ_min = minimum(estimated_parameter)
        μ_max = maximum(estimated_parameter)
        Δμ = μ_max - μ_min

        # Define the domain
        x = LinRange(x_min - 0.1*Δx, x_max + 0.1*Δx, 1000)

        # Compute the bifurcation diagram
        μ = [p(s) for s in x]

        # Return the bifurcation diagram
        return (
                x = x,
                μ = μ,
                μ_limits = [μ_min - 0.1*Δμ, μ_max + 0.1*Δμ]
               )
end
