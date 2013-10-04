const INDTYPE="gaussian" # type of matrices used to represent individuals (gaussian or markov)
const G=10 # number of genes per individual, default 10, small 3
const N=500 # population size, default 500, small 10
const C=0.4 # connectivity probability for individuals (Gaussian matrices)
const P=0.5 # connectivity probability for population structure graph
const GENS=50 # total number of generations, default 400, small 10
const TAU=10 # look-behind depth, default 10
