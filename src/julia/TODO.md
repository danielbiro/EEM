# TODO
1. Create type for storing measurements of population level statistics
1. Use sign-flipping method to check convergence
1. Integrate measure of individual [modularity][1]
1. Convert individuals from matrices to graphs
1. Implement more effective stability detection (see [here](http://dx.plos.org/10.1371/journal.pone.0034285))
1. Function to compute perron vector: perron(B)=rref(vcat(hcat(B-eye(size(B,2)), zeros(size(B,2))),ones(size(B,2)+1)'))[1:size(B,2),end]

# completed
1. Keep track of path length
1. Add function to compute robustness
1. Add function for sexual reproduction
1. Write tests
1. Translate python version of wagbergmod to julia
1. Give each individual an initial state and initialize it to that of founder


[1]: http://igraph.sourceforge.net/doc/python/igraph.GraphBase-class.html#modularity
