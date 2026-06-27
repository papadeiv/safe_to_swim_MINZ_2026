module Math 

for file in sort(readdir("../src/math/"))
    endswith(file, ".jl") && include(joinpath("../src/math/", file))
end

export generate_power_set, import_test_function 

end
