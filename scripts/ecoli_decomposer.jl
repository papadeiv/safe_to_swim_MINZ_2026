using Dates, DataFrames, CSV, LinearAlgebra, Statistics, ProgressMeter, CairoMakie

df = CSV.read("/Users/dmit755/Desktop/MINZ_2026/data/consolidated/Master_Ecoli_Data.csv", DataFrame)

SiteNamesCol = df[1:end, names(df)[1]];
DatesCol = df[1:end, names(df)[2]];
EColiCol = df[1:end, names(df)[3]];

n = length(SiteNamesCol);

Partition = [1];
s = SiteNamesCol[1];

for i in 2:n
	ss = SiteNamesCol[i];
	if !(s == ss)
		push!(Partition,i);
		s = ss;
	end
end

Partition = push!(Partition,n+1);
p = length(Partition);

for i in 1:(p-1)
	j = Partition[i];
	SiteName = SiteNamesCol[j];
	StartRow = Partition[i];
	EndRow = Partition[i+1]-1;

	CollectionDates = [];
	for k in StartRow:EndRow
		d = Date(split(df[k,2])[1], DateFormat("yyyy-mm-dd"));
		push!(CollectionDates,d)
	end

	EColiValues = df[StartRow:EndRow,3];

	SiteFile  = DataFrame(
	Date = CollectionDates,
    	EColi = EColiValues)


	SiteFileName = replace(string("$SiteName.csv"), r"/" => "");

	CSV.write(
    joinpath("/Users/dmit755/Desktop/MINZ_2026/data/ecoli_decomposed",
             SiteFileName),
    SiteFile
)


end