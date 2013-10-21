weights = zeros(size(me.network))
    indxs = find(!map(x->isapprox(x,0,atol=1e-2),me.network))
    weights[indxs] = 10*sigmoid(me.network[indxs],3)
    immv = infomap(weights,10)
    me.level1 = immv[1]
    me.level2 = immv[2]
    me.modularity = immv[end]
    me.hierarchy = length(immv)
