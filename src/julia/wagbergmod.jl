using Graphs
using Distributions
#using Debug

require("constants.jl")
#require("constants_bergsieg2002.jl")
require("types.jl")
require("individuals.jl")
require("population.jl")
require("textprogressbar.jl")

inds = geninds(G,N,C,INDTYPE)
pop  = genpop(inds,N,P)

tpb=textprogressbar("running grn evolution: ",[])
for t=1:GENS
    update(pop)
    tpb=textprogressbar(t/GENS*100,tpb)
end
textprogressbar(" done.",tpb)

println("\nIndividuals in Population")
println(pop.individuals)
println("\nFounder of Population")
println(pop.founder)
println("\nConnectivity of Population")
println(pop.connectivity)
