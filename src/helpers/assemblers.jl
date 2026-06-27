using DataFrames, CSV 
using ProgressMeter

include("./utils.jl")
include("./parsers.jl")

function flow_assembler(EColiSiteName, FlowSiteName)
        # Import and extract the flow data
        data = flow_parser(FlowSiteName)
        flow_dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))
        flow_value = float.(data.data[:,2])

        # Import the and extract E.coli data
        data = CSV.read("../data/ecoli/$EColiSiteName.csv", DataFrame)
        ecoli_dates = Date.(string.(data[:,1]), DateFormat("yyyy-mm-d"))
        ecoli_value = float.(data[:,2])

        # Loop over the E.coli measurements 
        flow_idx = Integer[]
        ecoli_idx = Integer[]
        for (idx, date) in enumerate(ecoli_dates)
                # Check if the E.coli measurement date matches a flow measurement date
                if date ∈ flow_dates && !ismissing(ecoli_value[idx])
                        # Update the measurement date index
                        push!(ecoli_idx, idx)
                        push!(flow_idx, findfirst(==(date), flow_dates) - 1)
                end
        end

        # Loop over the different lags
        for m in 1:6
                # Build the observation matrix
                observation_matrix = Matrix{Any}(undef, length(ecoli_idx), 6)
                observation_matrix[:,1] = ecoli_dates[ecoli_idx]
                observation_matrix[:,2] = ecoli_value[ecoli_idx]
                observation_matrix[:,3] = flow_dates[flow_idx]
                observation_matrix[:,4] = flow_value[flow_idx]

                # Loop over the measurement indices
                for (n, idx) in enumerate(flow_idx)
                        # Assemble the array of lagged observations
                        lagged_observations = Float64[]
                        push!(lagged_observations, flow_value[idx])
                        for lag_idx in 1:m 
                                push!(lagged_observations, flow_value[idx - lag_idx])
                        end

                        # Compute the observables of the lagged observations
                        observation_matrix[n,5] = maximum(lagged_observations)
                        observation_matrix[n,6] = sum(lagged_observations) 
                end

                # Export the observation matrix
                colnames = ["E.coli date", 
                            "E.coli value", 
                            "Max flow date (past 24 hours)", 
                            "Max flow value (past 24 hours)", 
                            "Max flow value (past $(24*(m+1)) hours)", 
                            "Total flow value (past $(24*(m+1)) hours)", 
                           ]
                df = DataFrame(observation_matrix, Symbol.(colnames))
                writeout("flow_max/$(m+1).csv", df)
        end       
end

function rainfall_assembler(EColiSiteName, RainfallSiteName)
        # Import and extract the rainfall data
        data = rainfall_parser(RainfallSiteName)
        rainfall_dates = Date.(string.(data.data[:,1]), DateFormat("yyyy-mm-d"))
        rainfall_value = float.(data.data[:,2])

        # Import the and extract E.coli data
        data = CSV.read("../data/ecoli/$EColiSiteName.csv", DataFrame)
        ecoli_dates = Date.(string.(data[:,1]), DateFormat("yyyy-mm-d"))
        ecoli_value = float.(data[:,2])

        # Loop over the E.coli measurements 
        rainfall_idx = Integer[]
        ecoli_idx = Integer[]
        for (idx, date) in enumerate(ecoli_dates)
                # Check if the E.coli measurement date matches a flow measurement date
                if date ∈ rainfall_dates && !ismissing(ecoli_value[idx])
                        # Update the measurement date index
                        push!(ecoli_idx, idx)
                        push!(rainfall_idx, findfirst(==(date), rainfall_dates) - 1)
                end
        end

        # Loop over the different lags
        for m in 1:6
                # Build the observation matrix
                observation_matrix = Matrix{Any}(undef, length(ecoli_idx), 6)
                observation_matrix[:,1] = ecoli_dates[ecoli_idx]
                observation_matrix[:,2] = ecoli_value[ecoli_idx]
                observation_matrix[:,3] = rainfall_dates[rainfall_idx]
                observation_matrix[:,4] = rainfall_value[rainfall_idx]

                # Loop over the measurement indices
                for (n, idx) in enumerate(rainfall_idx)
                        # Assemble the array of lagged observations
                        lagged_observations = Float64[]
                        push!(lagged_observations, rainfall_value[idx])
                        for lag_idx in 1:m 
                                push!(lagged_observations, rainfall_value[idx - lag_idx])
                        end

                        # Compute the observables of the lagged observations
                        observation_matrix[n,5] = maximum(lagged_observations)
                        observation_matrix[n,6] = sum(lagged_observations) 
                end

                # Export the observation matrix
                colnames = ["E.coli date", 
                            "E.coli value", 
                            "Max rainfall date (past 24 hours)", 
                            "Max rainfall value (past 24 hours)", 
                            "Max rainfall value (past $(24*(m+1)) hours)", 
                            "Total rainfall value (past $(24*(m+1)) hours)", 
                           ]
                df = DataFrame(observation_matrix, Symbol.(colnames))
                writeout("rainfall/$(m+1).csv", df)
        end       
end

function assembler(sitenames)
        # Generate the flow and rainfall lagged observation matrices
        flow_assembler(sitenames.swimsite, sitenames.flowsite)
        rainfall_assembler(sitenames.swimsite, sitenames.rainsite)

        # Loop over the observation matrices
        flow_matrix = nothing 
        flow_names = nothing 
        rainfall_matrix = nothing 
        rainfall_names = nothing 
        flow_sample_names = String[]
        rainfall_sample_names = String[]
        printstyled("Assembling the data matrices\n"; bold=true, underline=true, color=:light_blue)
        @showprogress for n in 2:7
                # Extract the flow data 
                filename = "../results/flow_max/$n.csv"
                df = CSV.read(filename, DataFrame)
                flow_ecoli_dates = df[!,(names(df))[1]]
                flow_ecoli_value = df[!,(names(df))[2]]
                flow_dates = df[!,(names(df))[3]]
                flow_value = df[!,(names(df))[4]]
                max_flow_value = df[!,(names(df))[5]]
                tot_flow_value = df[!,(names(df))[6]]
                flow_names = [(names(df))[m] for m in 1:6]

                # Extract the rainfall data 
                filename = "../results/rainfall/$n.csv"
                df = CSV.read(filename, DataFrame)
                rainfall_ecoli_dates = df[!,(names(df))[1]]
                rainfall_ecoli_value = df[!,(names(df))[2]]
                rainfall_dates = df[!,(names(df))[3]]
                rainfall_value = df[!,(names(df))[4]]
                max_rainfall_value = df[!,(names(df))[5]]
                tot_rainfall_value = df[!,(names(df))[6]]
                rainfall_names = [(names(df))[m] for m in 1:6]

                # Append columns to the data matrix
                if n==2
                        flow_sample_names = [flow_names[1], flow_names[2], flow_names[4], flow_names[5], flow_names[6]] 
                        flow_matrix = hcat(flow_ecoli_dates,
                                           flow_ecoli_value,
                                           flow_value,
                                           max_flow_value,
                                           tot_flow_value
                                          ) 
                        rainfall_sample_names = [rainfall_names[1], rainfall_names[2], rainfall_names[4], rainfall_names[5], rainfall_names[6]] 
                        rainfall_matrix = hcat(rainfall_ecoli_dates,
                                               rainfall_ecoli_value,
                                               rainfall_value,
                                               max_rainfall_value,
                                               tot_rainfall_value
                                              )
                else
                        flow_sample_names = vcat(flow_sample_names, flow_names[5], flow_names[6])
                        flow_matrix = hcat(flow_matrix, max_flow_value, tot_flow_value)
                        rainfall_sample_names = vcat(rainfall_sample_names, rainfall_names[5], rainfall_names[6])
                        rainfall_matrix = hcat(rainfall_matrix, max_rainfall_value, tot_rainfall_value)
                end
        end

        # Return the observation matrices
        return(
               flow_matrix = DataFrame(flow_matrix, Symbol.(flow_sample_names)),
               rainfall_matrix = DataFrame(rainfall_matrix, Symbol.(rainfall_sample_names)),
              )
end
