using Graphs
using Distributions
#using Debug

#configfile = "constants.jl"
#configfile = "constants_test.jl"
configfile = "constants_bergsieg2002.jl"
indir = joinpath("..","input")
outdir = joinpath("..","output")
require(joinpath(indir,configfile))
require("types.jl")
require("individuals.jl")
require("population.jl")
require("textprogressbar.jl")
require("measure.jl")
