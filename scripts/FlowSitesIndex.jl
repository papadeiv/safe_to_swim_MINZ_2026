using CSV, DataFrames

function FindMaxFlowSiteIndex(SiteName)
	df = CSV.read("/Users/dmit755/Desktop/MINZ_2026/data/flow/Flow_Max.csv", DataFrame)
	idx = findfirst(==(SiteName), names(df))
	return idx
end