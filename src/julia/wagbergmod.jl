using Graphs
using Distributions
#using Debug

require("constants.jl")
require("types.jl")
require("individuals.jl")
require("population.jl")

inds = geninds(G,N,C,INDTYPE)
pop  = genpop(inds,N,P)

for t=1:GENS
    update(pop)
end
println("jigga1")
println(pop.individuals)
println(pop.connectivity)
println("jigga2")
