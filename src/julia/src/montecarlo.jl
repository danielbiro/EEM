using Graphs
#using Distributions
using Datetime
using DataFrames
#using Gadfly
#using Debug

#-------------------------
# setup
#-------------------------

configfile = "constants_mc.jl"
indir = joinpath("..","input")
outdir = joinpath("..","output")
require(joinpath(indir,configfile))

require("utilities.jl")
require("types.jl")
require("modularity.jl")
require("individuals.jl")
require("population.jl")
require("textprogressbar.jl")
require("measure.jl")

timestamp = gentimestamp()

simdir = joinpath(outdir,timestamp)
run(`mkdir $simdir`)
println("\nOutput directory created:")
println("===========================================\n")
println(simdir)
configpath = joinpath(indir,configfile)
run(`cp $configpath $simdir`)

NUMMCSIMS=500

modvect=(Float64)[]
l1vect=(Float64)[]
l2vect=(Float64)[]
hvect=(Float64)[]
envvect=(ASCIIString)[]

if PROGBAR
    tpb=textprogressbar("running mc simulation: ",[])
else
    println("start loop")
end


for i=1:NUMMCSIMS
    # generate individual stable under input 1
    ind = stableind(INP1,OPT1)

    # measure modularity wrt input 1
    modularity(ind)
    push!(modvect,ind.modularity)
    push!(l1vect,ind.level1)
    push!(l2vect,ind.level2)
    push!(hvect,ind.hierarchy)
    push!(envvect,"one")
    #env1mod[i]=ind.modularity

    # transform to individual stable under input 2
    # gt = diagm(INP2)
    # inp2net = gt*ind.network*gt
    # indxs = find(x->x[1]==x[2],
    #              [(x,y) for (x,y) in zip(ind.network,inp2net)])
    # twoInpnet = zeros(size(inp2net))
    # twoInpnet[indxs]=inp2net[indxs]
    # twoInpnet == gt*twoinpnet*gt
    # ind.network = twoInpnet
    # println(ind.network)
    # measure modularity wrt inputs 1 and 2
    # modularity(ind)
    # env12mod[i]=ind.modularity

    ind.initstate = copy(INP2)
    iterateind(ind)
    if ind.develstate==OPT2
        modularity(ind)
        push!(modvect,ind.modularity)
        push!(l1vect,ind.level1)
        push!(l2vect,ind.level2)
        push!(hvect,ind.hierarchy)
        push!(envvect,"one and two")
        #env12mod[i]=ind.modularity
    else
        ind2 = stableind(INP1,OPT1)
        while ind2.stable!=true
            ind2.initstate = copy(INP2)
            iterateind(ind2)
            if ind2.develstate!=OPT2
                ind2 = stableind(INP1,OPT1)
                ind2.stable=false
            end
        end
        modularity(ind2)
        push!(modvect,ind2.modularity)
        push!(l1vect,ind2.level1)
        push!(l2vect,ind2.level2)
        push!(hvect,ind2.hierarchy)
        push!(envvect,"one and two")
        #env12mod[i]=ind2.modularity
    end

    if PROGBAR
        tpb=textprogressbar(i/NUMMCSIMS*100,tpb)
    end
end

if PROGBAR
    textprogressbar(" done.",tpb)
else
    println("end loop")
end

simfile = joinpath(simdir,"sim.csv")

df = DataFrame(environment=envvect,
               modularity=modvect,
               level1=l1vect,
               level2=l2vect,
               hierarchy=hvect)
writetable(simfile,df)

println("\nData saved to:")
println("===========================================\n")
println(simdir)
println()

envpdf = joinpath(simdir,"env.pdf")
run(`python plotmc.py -d $simdir`)

spawn(`evince $envpdf`)
spawn(`libreoffice $simfile`)






