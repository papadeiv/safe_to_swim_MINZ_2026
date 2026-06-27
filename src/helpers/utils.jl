using DataFrames, CSV
using CairoMakie 

function writeout(filename, A::Matrix)
        # Export a matrix as a csv file
        fullpath = "../results/data/"*filename
        mkpath(dirname(fullpath))
        CSV.write(fullpath, DataFrame(A, :auto); header=false)
end

function writeout(filename, df::DataFrame)
        # Export a dataframe as a csv file
        fullpath = "../results/data/"*filename
        mkpath(dirname(fullpath))
        CSV.write(fullpath, df)
end

function savefig(path, figure)
        # Create the export directory if it doesn't exist
        fullpath = "../results/figures/"*path 
        mkpath(dirname(fullpath))

        # Export the figure
        save(fullpath, figure)
end
