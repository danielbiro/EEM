function genpop(inds)
    return Population(inds, deepcopy(inds[1]), erdos_renyi_graph(N,P,is_directed=false))
end


function update(me::Population)
    update(me.individuals)
    update(me.connectivity)
end


function update(me::AbstractGraph)

end
