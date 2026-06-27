using CairoMakie 

include("../helpers/utils.jl")

function plot_timeseries(flow_data, rainfall_data, sitenames)
        # Extract the timeseries
        flow = flow_data[!,[1,3]]
        rainfall = rainfall_data[!,[1,3]]
        larger_df = nrow(flow_data) >= nrow(rainfall_data) ? flow_data : rainfall_data
        ecoli = larger_df[:, 1:2]

        # Create and format the figure
        fig = Figure(; size = (900, 600))
        ax1 = Axis(fig[1,1],
                   xgridvisible = false,
                   ygridvisible = false,
                   #xlabel = labels[idx],
                   ylabel = "max daily flow (L/s)",
                   xlabelvisible = true,
                   ylabelvisible = true,
                   title = sitenames.flowsite, 
                   #xticks = [-1,0,1],
                   #yticks = [-0.35,0,0.5],
                   xticklabelsvisible = true,
                   yticklabelsvisible = true,
                   xtickalign = 1,
                   ytickalign = 1,
                  )
        ax2 = Axis(fig[2,1],
                   xgridvisible = false,
                   ygridvisible = false,
                   #xlabel = labels[idx],
                   ylabel = "daily rainfall (mm)",
                   xlabelvisible = true,
                   ylabelvisible = true,
                   title = sitenames.rainsite, 
                   #xticks = [-1,0,1],
                   #yticks = [-0.35,0,0.5],
                   xticklabelsvisible = true,
                   yticklabelsvisible = true,
                   xtickalign = 1,
                   ytickalign = 1,
                  )
        ax3 = Axis(fig[3,1],
                   xgridvisible = false,
                   ygridvisible = false,
                   xlabel = "dates",
                   ylabel = "E.coli (mpn/100mL)",
                   xlabelvisible = true,
                   ylabelvisible = true,
                   title = sitenames.swimsite, 
                   #xticks = [-1,0,1],
                   #yticks = [-0.35,0,0.5],
                   xticklabelsvisible = true,
                   yticklabelsvisible = true,
                   xtickalign = 1,
                   ytickalign = 1,
                  )

        # Plot the timeseries
        lines!(ax1, flow[:,1], flow[:,2])
        lines!(ax2, rainfall[:,1], rainfall[:,2])
        lines!(ax3, ecoli[:,1], ecoli[:,2])

        # Export the figure
        savefig("timeseries.png", fig)
end
