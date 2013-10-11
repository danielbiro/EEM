const G=3 # number of genes per individual, default 10, small 3
const N=10 # population size, default 500, small 10
const C=0.75 # connectivity probability for individuals (Gaussian matrices)
const GENS=10 # total number of generations, default 400, small 10
const MAXCONV=100 # max number of iterations to test for convergence
const MUTRATE=0.1 # mutation rate used in MUTRATE/(cG^2)
const MUTMAG=1 # magnitude of mutations
const SELSTR=1 # selection strength aka \sigma
const ROBIT=10 # number of iterations to run in robustness testing
const P=0.5 # connectivity probability for population structure graph
const TAU=10 # look-behind depth for convergence testing with sigmoidal function, default 10
const INP1=[] # if empty, the intial state of the founder is generated at random

# flags
const RANDPOP=false # if true generate initial population with random interactions rather than a homogeneous one
const SEXUALREPRO=true # if true interleave rows from two individuals each generation
const MEASUREFIT=true # measure fitness
const MEASUREROBUST=true # measure robustness
const MEASUREMOD=false # measure modularity
const SWITCHENV=false # switch inputs
