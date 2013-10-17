# TODO

## short

1. Use argparse package for scripts that can be called with cl-args

## hold

1. Implement more effective stability detection that includes cycles (see [here](http://dx.plos.org/10.1371/journal.pone.0034285))
1. Consider using stochastic or transition rate matrices for individuals -- function to compute perron vector: perron(B)=rref(vcat(hcat(B-eye(size(B,2)), zeros(size(B,2))),ones(size(B,2)+1)'))[1:size(B,2),end] -- generate stoch mats individuals=[Individual(rand(Dirichlet(ones(G)),G), rand(Dirichlet(ones(G))), rand(Dirichlet(ones(G))), true, 1.) for i=1:N]
1. Try plotting with Gadfly once errors are resolved by package updates
1. interface directly with C code rather than using shared library

## completed

1. Add plot target to makefile
1. Put error bars on output
1. Experiment with named pipes vs flat files and switch
to flat files due to increased speed
1. Fix scaling of weights to work with mod meas
1. Make progressbar optional
1. Cluster population average of individual networks
1. Adapt python script to make a plot for each column in output
1. Add parameters to configure measurement period
1. Plot measure data with Python
1. Implement input switching
1. Integrate measure of individual [modularity][1] (already implemented)
1. Plot heatmap of networks
1. Save networks to dataframe at any timepoint
1. Save Measure data to dataframe
1. Reorganize folder structure
1. Add unique timestamp to output files
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
1. Translate python version to julia
1. Give each individual an initial state and initialize it to that of founder


[1]: http://igraph.sourceforge.net/doc/python/igraph.GraphBase-class.html#modularity
