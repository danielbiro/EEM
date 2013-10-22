function geninds()
    founder = genfounder()

    indvect = Array(Individual{Float64},N)
    for i = 1:N
        if RANDPOP
            indvect[i] = stableind(founder.initstate)
        else
            indvect[i] = deepcopy(founder)
        end
    end

    return indvect
end

function genpop{T}(inds::Vector{Individual{T}})
    Population(inds,
               deepcopy(inds[1]),
               erdos_renyi_graph(N,P,is_directed=false))
end

function genpop()
    inds = geninds()
    genpop(inds)
end


function update(me::Population)
    update(me.individuals)
    update(me.connectivity)
end


function update(me::AbstractGraph)

end

function save(pop::Population, fname::String)
    # networks = zeros(G^2,N)
    # for i = 1:N
    #     networks[:,i] = pop.individuals[i].network
    # end
    networks = [pop.individuals[i].network for i=1:N]
    allnetworks = reshape(flatten(networks),G^2,N)
    df = DataFrame(allnetworks)
    writetable(string(fname,".tsv"), df, quotemark = ' ')

    meanpop = mean(networks)
    df2 = DataFrame(meanpop)
    writetable(string(fname,"mean.tsv"), df2, quotemark = ' ')

    stdpop = reshape(std(allnetworks,2),G,G)
    df3 = DataFrame(stdpop)
    writetable(string(fname,"std.tsv"), df3, quotemark = ' ')

end
