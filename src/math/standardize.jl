using Statistics

function standardize(sample)
        # Define the sample matrix
        X = Float64.(Matrix(sample[:,2:end]))

        # Normalize the sample (zero mean and unitary standard deviation)
        X = (X .- mean(X, dims=1))./std(X, dims=1)

        # Sanity check
        for (idx, feature) in enumerate(eachcol(X))
                if mean(feature) > 1e-15 || abs(std(feature)-1) > 1e-14
                        printstyled("Standardization of the sample failed for feature $(idx)\n"; bold=true, underline=true, color=:red)
                end
        end

        # Return the standardized sample
        return X
end
