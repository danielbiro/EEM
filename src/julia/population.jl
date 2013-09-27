function genpop(inds,N,P)
    return Population(inds, inds[1], erdos_renyi_graph(N,P,is_directed=false))
end


function update(me::Population)
    update(me.individuals)
    update(me.connectivity)
end


function update(me::AbstractGraph)
    me
end
