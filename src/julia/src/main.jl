using Graphs
using Distributions
using Datetime
using DataFrames
#using Debug

configfile = "constants.jl"
#configfile = "constants_test.jl"
#configfile = "constants_bergsieg2002.jl"
indir = joinpath("..","input")
outdir = joinpath("..","output")
require(joinpath(indir,configfile))

require("utilities.jl")
require("types.jl")
require("individuals.jl")
require("population.jl")
require("textprogressbar.jl")
require("measure.jl")

timestamp = gentimestamp()

simdir = joinpath(outdir,timestamp)
run(`mkdir $simdir`)
run(`cp $indir\/$configfile $simdir`)

pop  = genpop()
meas = genmeasure()

tpb=textprogressbar("running grn evolution: ",[])
for t=1:GENS
    update(pop)
    measure(pop,meas,t)
    tpb=textprogressbar(t/GENS*100,tpb)
end
textprogressbar(" done.",tpb)

save(pop,joinpath(simdir,"nets.tsv"))
save(meas,joinpath(simdir,"sim.csv"))
#save(pop,"nets_g$G\_n$N\_c$C\_t$GENS\.tsv")
#save(meas,"sim_g$G\_n$N\_c$C\_t$GENS\.csv")

run(`python clustergram.py --i $simdir\/nets.tsv`)

println("\nSample Final Individuals from Population:")
println("===========================================\n")
println(pop.individuals[1:5])
println("\nPopulation Founder:")
println("===========================================\n")
println(pop.founder)
println("\nConnectivity of Population:")
println("===========================================\n")
println(pop.connectivity)
println("\nNumber of non-zeros in founder:")
println("===========================================\n")
println(length(find(pop.founder.network)))
println("\nAverage number of non-zeros in final pop:")
println("===========================================\n")
println(mean(map(x -> length(find(x.network)), pop.individuals)))
println()
