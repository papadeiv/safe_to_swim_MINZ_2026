module Plotters 

for file in sort(readdir("../src/plotters/"))
    endswith(file, ".jl") && include(joinpath("../src/plotters/", file))
end

export plot_timeseries, plot_distribution 

end
