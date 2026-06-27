using DataFrames, CSV
using Dates

function flow_parser(flowsite)
        # Import the file and etxract the column site idx 
        df = CSV.read("../data/flow/Flow_Max.csv", DataFrame)
	      col_idx = findfirst(==(flowsite), names(df))

        # Define the data arrays
        timestep = df[2:end,(names(df))[1]]
        site = (names(df))[col_idx]
        river = df[2:end,site]

        # Clean the data
        filter_idx = findall(!ismissing, river)
        date = Date.(timestep[filter_idx], dateformat"d/mm/yyyy HH:MM:SS p")
        flow = parse.(Float64, river[filter_idx])

        # Return parsed data as a matrix
        return (
                data = hcat(date, flow),
                site = site
               )
end

function rainfall_parser(rainsite)
        # Import the file and etxract the column site idx
        df = CSV.read("../data/rainfall/RFTOTAL.csv", DataFrame)
	      col_idx = findfirst(==(rainsite), names(df))

        # Define the data arrays
        timestep = df[2:end,(names(df))[1]]
        site = (names(df))[col_idx]
        river = df[2:end,site]

        # Clean the data
	      filter_idx = findall(i -> !ismissing(river[i]) && !ismissing(timestep[i]),
   	                         eachindex(river))
        date = Date.(timestep[filter_idx], dateformat"d/mm/yyyy HH:MM:SS p")
        rainfall = parse.(Float64, river[filter_idx])

        # Return parsed data as a matrix
        return (
                data = hcat(date, rainfall),
                site = site
               )
end

function ecoli_parser(filename, col_idx)

        # Import the file 
        df = CSV.read("../data/"*filename, DataFrame)

        # Define the data arrays
        timestep = df[!,(names(df))[1]]
        dates = Date.(timestep, dateformat"d/m/yy H:MM p")
        dates = Date.(year.(dates).+2000, month.(dates), day.(dates))
        feature = (names(df))[col_idx]
        ecoli = df[!, feature]

        return(
               label = feature,
               data = hcat(dates, ecoli)
              )
end
