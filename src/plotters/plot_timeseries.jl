using CairoMakie 

include("../helpers/utils.jl")

function plot_timeseries(ecoli, flow, rainfall, sitenames)
        # Create and format the figure
        fig = Figure(; size = (1200, 800))
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
        lines!(ax1, ecoli[:,1], flow)
        lines!(ax2, ecoli[:,1], rainfall)
        lines!(ax3, ecoli[:,1], ecoli[:,2])

        # Export the figure
        savefig("timeseries.pdf", fig)
end
