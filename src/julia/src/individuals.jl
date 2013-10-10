# ---------------------------
# constructors
# ---------------------------
function Individual(network::Matrix{Float64},initstate::Vector{Int64})
    Individual(copy(network), copy(initstate), zeros(Int64,G),
                             zeros(Int64,G), false, 0., 0., 0)
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

function randstableind()
# generate a random Individual that is
# developmentally stable

    randind = Individual()

    while randind.stable!=true
        randind.network = zeros(Float64,G,G)
        for i=1:G^2
            if rand()<C
                randind.network[i] = randn()
            end
        end
        randind.initstate = rand(0:1,G)*2.-1
        iterateind(randind)
    end

    return randind
end

function genfounder()
# generate a founding individual whose
# developmental state is equivalent to
# its optimal state and thereby determines
# the optimal state for the population

    founder = randstableind()
    founder.fitness = 1
    founder.optstate = copy(founder.develstate)

    return founder
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

function develop(me::Individual)
# run the developmental process
# and update fitness and robustness measures

    iterateind(me)
    fitnesseval(me)
    robustness(me)
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
        r = rand(1:N)
        reproduce(oldinds[z],oldinds[r],tempind)
        mutate(tempind)

        tempind.initstate = copy(oldinds[z].initstate)
        tempind.optstate = copy(oldinds[z].optstate)

        iterateind(tempind)
        if tempind.stable
            fitnesseval(tempind)
            if tempind.fitness >= rand()
                mes[newind] = deepcopy(tempind)
                robustness(mes[newind])
                newind += 1
            end
        end
    end
end
