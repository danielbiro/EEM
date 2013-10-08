# TODO

## short

1. Add unique timestamp to output files
1. Save networks at any timepoint and plot heatmap of the population
1. Save Measure data to dataframe and plot with gadfly

## long term

1. Integrate measure of individual [modularity][1] (already implemented)
1. Convert individuals from matrices to graphs for use with modularity measure
1. Implement more effective stability detection that includes cycles (see [here](http://dx.plos.org/10.1371/journal.pone.0034285))
1. Cosider using stochastic matrices for individuals -- function to compute perron vector: perron(B)=rref(vcat(hcat(B-eye(size(B,2)), zeros(size(B,2))),ones(size(B,2)+1)'))[1:size(B,2),end] -- generate stoch mats individuals=[Individual(rand(Dirichlet(ones(G)),G), rand(Dirichlet(ones(G))), rand(Dirichlet(ones(G))), true, 1.) for i=1:N]

# completed

1. Paralellize developmental process
1. Rewrite tests for Individual types
1. DRY up constants to config files
1. Test properties
1. Write custom constructors for Individuals
1. Create type for storing measurements of population level statistics
1. Use sign-flipping method to check convergence
1. Keep track of path length
1. Add function to compute robustness
1. Add function for sexual reproduction
1. Translate python version of wagbergmod to julia
1. Give each individual an initial state and initialize it to that of founder


[1]: http://igraph.sourceforge.net/doc/python/igraph.GraphBase-class.html#modularity
