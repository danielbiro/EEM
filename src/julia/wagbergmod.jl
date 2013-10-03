using Graphs
using Distributions
#using Debug

#require("constants.jl")
require("constants_bergsieg2002.jl")
require("types.jl")
require("individuals.jl")
require("population.jl")
require("textprogressbar.jl")
require("measure.jl")

inds = geninds()
pop  = genpop(inds)
meas = genmeasure()

tpb=textprogressbar("running grn evolution: ",[])
for t=1:GENS
    update(pop)
    measure(pop,meas,t)
    tpb=textprogressbar(t/GENS*100,tpb)
end
textprogressbar(" done.",tpb)

save(meas,"sim_g$G\_n$N\_c$C\_t$GENS\.csv")

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
