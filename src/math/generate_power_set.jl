using Combinatorics 

function generate_power_set(m)
        # Generate the set of all natural numbers up to m 
        numbers = collect(1:m)

        # Loop over the set above 
        subsets = Vector{Vector{Int}}()
        for n in 2:m
                # Create subset of the power set (index starts at 2 to avoid including singletons)
                append!(subsets, collect(combinations(numbers, n)))
        end

        # Return the reduced power set
        return subsets
end
