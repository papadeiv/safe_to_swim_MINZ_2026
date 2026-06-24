using CSV, DataFrames

function FindRainfallSiteIndex(SiteName)
	df = CSV.read("/Users/dmit755/Desktop/MINZ_2026/data/rainfall/RFTOTAL.csv", DataFrame)
	idx = findfirst(==(SiteName), names(df))
	return idx
end