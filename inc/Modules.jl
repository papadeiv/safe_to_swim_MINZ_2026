using DataFrames, CSV
using LinearAlgebra, Statistics
using ProgressMeter, CairoMakie

if !@isdefined Helpers
        include("./Helpers.jl")
        import .Helpers: assembler, builder 
        import .Helpers: writeout, savefig 
end

if !@isdefined Plotters 
        include("./Plotters.jl")
        import .Plotters: plot_timeseries 
end

if !@isdefined Math 
        include("./Math.jl")
        import .Math: standardize 
        import .Math: generate_power_set, import_test_functions 
end
