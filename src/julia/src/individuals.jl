# ---------------------------
# constructors
# ---------------------------
function Individual(network::Matrix{Float64},initstate::Vector{Int64})
    Individual(copy(network), copy(initstate), zeros(Int64,G),
                             zeros(Int64,G), false, 0., 0., 0, 0., 0., 0., 0)
end

function Individual(network::Matrix{Float64})
    Individual(copy(network), zeros(Int64,G))
end

function Individual()
    Individual(zeros(G,G))
end

# ---------------------------
# methods
# ---------------------------

function iterateind(me::Individual)
# iterate individuals from their initial state to
# their developmental state and store the results
# in the Individual object

    currstate = copy(me.initstate)

    for i=1:MAXCONV
        stateupdate = me.network*currstate
        stateupdate[find(x -> x>=0,stateupdate)] = 1
        stateupdate[find(x -> x<0,stateupdate)] = -1
        stateupdate = convert(Vector{Int64},stateupdate)

        if currstate==stateupdate
            me.stable = true
            me.develstate = copy(stateupdate)
            me.pathlength = copy(i)
            break
        elseif i==MAXCONV
            me.stable = false
            me.develstate = copy(stateupdate)
            me.pathlength = copy(MAXCONV)
        end

        currstate = copy(stateupdate)
    end
end

function fitnesseval(me::Individual)
# measure fitness according to the distance
# between the developmental state determined
# by running iterateind(me) and the optimum
# state

    if me.stable
        statediff = me.develstate - me.optstate
        distance = sum(statediff.^2)/(4*G)
        me.fitness = exp(-(distance/SELSTR))
    else
        me.fitness=0
    end
end

function stableind(initstate::Vector{Int64},optstate::Vector{Int64})
# generate a random Individual that is
# developmentally stable

    randind = Individual()

    while ((randind.stable!=true) | (if isempty(optstate); false; else; randind.develstate!=optstate; end))
        randind.network = zeros(Float64,G,G)
        for i=1:G^2
            if rand()<C
                if INDWEIGHTS=="discrete"
                    #randind.network[i] = [-1,1][rand(1:2)]
                    randind.network[i] = rand(-1:1)
                elseif INDWEIGHTS=="gaussian"
                    randind.network[i] = MUTMAG*randn()
                else
                    error(string("wrong specification of individual weights:",
                           " use discrete or gaussian"))
                end
            end
        end
        randind.initstate = copy(initstate)
        iterateind(randind)
    end

    randind.fitness=1

    return randind
end

function stableind(initstate::Vector{Int64})
    stableind(initstate,(Int64)[])
end

function randstableind()
# generate a random Individual that is
# developmentally stable
    randind = stableind(rand(0:1,G)*2-1)

    return randind
end

function genfounder()
# generate a founding individual whose
# developmental state is equivalent to
# its optimal state and thereby determines
# the optimal state for the population
    if isempty(INP1) & isempty(OPT1)
        founder = randstableind()
    elseif isempty(OPT1)
        founder = stableind(INP1)
        founder.optstate = copy(founder.develstate)
        founder.fitness = 1
    else
        founder = stableind(INP1,OPT1)
        founder.optstate = copy(OPT1)
        fitnesseval(founder)
    end

    return founder
end

function connectmutate(me::Individual)
# mutate nonzero elements of an individuals network
# to zero elements and vice versa 
# according to MacCarthy and Bergman

    # Find the non-zero entries as potential mutation sites
    nzindx = find(me.network)
    # Find the zero entries
    zindx = find(me.network.==0)
    # Determine the connectivity of the matrix
    # by counting the number of non-zeros
    cnum = length(nzindx)
    zernum = length(zindx)
    conn = cnum/G^2
    

    conmutflagz=false
    conmutflagnz=false

    if MAINTAINFLAG
        b = 1 - 2*C
    else
        b = CONMUTPARAM
    end

    k = conn*(1 + b) + (1 - conn)*(1 - b)

    for i=1:cnum
        # For each non-zero entry:
        # with appropriate probability
        if  rand() < CONMUTRATE*(1+b)/k
            # Mutate a non-zero entry to a zero
            me.network[nzindx[i]] =  0
            conmutflagz=true
        end
    end

    for i=1:zernum
        # For each zero entry:
        # With appropriate probability
        if  rand() < CONMUTRATE*(1-b)/k
            # Mutate a zero entry to a number chosen from a gaussian
            me.network[zindx[i]] =  MUTMAG*randn()
            conmutflagnz=true
        end
    end
    return conmutflagz
end

function mutate(me::Individual)
# mutate nonzero elements of an individuals
# network according to a rate parameter normalized
# by the size of the nonzero entries in an
# individual network

    # Find the non-zero entries as potential mutation sites
    nzindx = find(me.network)

    # Determine the connectivity of the matrix
    # by counting the number of non-zeros
    cnum = length(nzindx)
    mutflag=false
    for i=1:cnum
        # For each non-zero entry:
        # With probability R/c*G^2, note cnum=cG^2
        if  rand() < MUTRATE/cnum
            # Mutate a non-zero entry by a number chosen from a gaussian
            me.network[nzindx[i]] =  MUTMAG*randn()
            mutflag=true
        end
    end
    return mutflag
end

function onemut(me::Individual)
# perform a one-site mutation of a given
# individual's network

    nzindx = find(me.network)
    cnum = length(nzindx)
    i=rand(1:cnum)
    mutmat = copy(me.network)
    mutmat[nzindx[i]] = MUTMAG*randn()

    return mutmat
end

function robustness(me::Individual)
# measure sensitivity to mutations
# of the developmental state

    dist = 0.

    for i=1:ROBIT
        perturbed = Individual(onemut(me), me.initstate)
        iterateind(perturbed)
        tempdiff = perturbed.develstate - me.develstate
        dist += sum(tempdiff.^2)/(4*G)
    end

    me.robustness=dist/ROBIT
end

function modularity(me::Individual)

    weights = zeros(size(me.network))
    indxs = find(!map(x->isapprox(x,0,atol=1e-2),me.network))
    #weights[indxs] = 10*sigmoid(me.network[indxs],3)
    weights[indxs] = 10*sigmoid(me.network[indxs],1)
    immv = infomap(weights,10)
    me.level1 = immv[1]
    me.level2 = immv[2]
    me.modularity = immv[end]
    me.hierarchy = length(immv)

end

function switchinput(me::Individual)
    if me.initstate==INP1
        me.initstate = copy(INP2)
        me.optstate = copy(OPT2)
    elseif me.initstate==INP2
        me.initstate = copy(INP1)
        me.optstate = copy(OPT1)
    end
    #me.initstate = -1*me.initstate
end


function develop(me::Individual)
# run the developmental process

    iterateind(me)

end

function measure(me::Individual)
# update fitness, robustness, and modularity measures
    if MEASUREFIT
        fitnesseval(me)
    end
    if MEASUREROBUST
        robustness(me)
    end
    if MEASUREMOD
        modularity(me)
    end
end

function reproduce(me::Individual, you::Individual, us::Individual)
# sexual reproduction via independent row segregation

    reproindxs = rand(0:1,G)

    for i in find(x->x==1,reproindxs)
        us.network[i,:] = copy(me.network[i,:])
    end

    for j in find(x->x==0,reproindxs)
        us.network[j,:] = copy(you.network[j,:])
    end

    return reproindxs
end


function update{T}(mes::Vector{Individual{T}})
# update the state of a vector of individuals

    # runs in parallel if julia is
    # invoked with multiple threads
    pmap(develop,mes)

    oldinds = deepcopy(mes)

    newind = 1

    while newind <= length(mes)
        tempind = Individual()

        z = rand(1:N)

        if SEXUALREPRO
            r = rand(1:N)
            reproduce(oldinds[z],oldinds[r],tempind)
        else
            tempind.network = copy(oldinds[z].network)
        end

        mutate(tempind)

        if CONMUTFLAG
            connectmutate(tempind)
        end


        tempind.initstate = copy(oldinds[z].initstate)
        tempind.optstate = copy(oldinds[z].optstate)

        iterateind(tempind)
        if tempind.stable

            if MEASUREFIT
                fitnesseval(tempind)
            else
                tempind.fitness = 1.
            end

            if tempind.fitness >= rand()

                mes[newind] = deepcopy(tempind)
                newind += 1
            end

        end
    end

    #pmap(measure,mes)

    if SWITCHENV
        map(switchinput,mes)
    end
end
