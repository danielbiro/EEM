function geninds()
    founder = genfounder()

    indvect = Array(Individual{Float64},N)
    for i = 1:N
        indvect[i]= deepcopy(founder)
    end

    return indvect
end

function genpop()
    inds = geninds()
    return Population(inds,
                      deepcopy(inds[1]),
                      erdos_renyi_graph(N,P,is_directed=false))
end


function update(me::Population)
    update(me.individuals)
    update(me.connectivity)
end


function update(me::AbstractGraph)

end
