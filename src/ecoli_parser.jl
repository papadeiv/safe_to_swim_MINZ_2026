using CSV, Dates, DataFrames

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
