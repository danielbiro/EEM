using Graphs
using Distributions
#using Debug

require("constants.jl")
require("types.jl")
require("initialization.jl")

inds = geninds(G,N,C,INDTYPE)
pop  = genpop(inds,N,P)

function simulate()
    for t=1:GENS
        #update(pop)
    end
end


