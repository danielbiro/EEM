tests = [
    "types",
    "individuals",
    "population"
    ]

println("Running tests:")

for t in tests
    test_fn = joinpath("test", "$t.jl")
    println(" * $test_fn")
    include(test_fn)
end
