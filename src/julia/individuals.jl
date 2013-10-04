function iterateind(me::Individual,
                           qtau=10, tterm=100,epsilon=10^-4., a=100)
    currstate = deepcopy(me.initstate)
    network = deepcopy(me.network)

    for i=1:tterm
        stateupdate = network*currstate
        stateupdate[find(x -> x>=0,stateupdate)] = 1
        stateupdate[find(x -> x<0,stateupdate)] = -1
        stateupdate = convert(Vector{Int64},stateupdate)

        if currstate==stateupdate
            me.stable = true
            me.develstate = deepcopy(stateupdate)
            me.pathlength = deepcopy(i)
            break
        elseif i==tterm
            me.stable = false
            me.develstate = deepcopy(stateupdate)
            me.pathlength = deepcopy(tterm)
        end

        currstate = deepcopy(stateupdate)
    end
end

function copy(me::Individual)
    newind = Individual(zeros(G,G), zeros(Int64,G), zeros(Int64,G),
                        zeros(Int64,G), false, 0., 0., 100)

    newind.network = deepcopy(me.network)
    newind.initstate = deepcopy(me.initstate)
    newind.develstate = deepcopy(me.develstate)
    newind.optstate = deepcopy(me.optstate)
    newind.stable = deepcopy(me.stable)
    newind.fitness = deepcopy(me.fitness)
    newind.robustness = deepcopy(me.robustness)
    newind.pathlength = deepcopy(me.pathlength)

    return newind
end

function geninds()
    if INDTYPE=="gaussian"

        founder = Individual(zeros(G,G), zeros(Int64,G), zeros(Int64,G),
                             zeros(Int64,G), false, 0., 0., 100)

        while founder.stable!=true
            founder.network = zeros(Float64,G,G)
            for i=1:G^2
                if rand()<C
                    founder.network[i] = randn()
                end
            end
            founder.initstate = rand(0:1,G)*2.-1
            iterateind(founder)
        end

        founder.fitness = 1
        founder.optstate = deepcopy(founder.develstate)

        individuals = Array(Individual{Float64},N)
        for i = 1:N
            individuals[i]= copy(founder)
        end

    elseif INDTYPE=="markov"
        individuals=[Individual(rand(Dirichlet(ones(G)),G),
              rand(Dirichlet(ones(G))), rand(Dirichlet(ones(G))), true, 1.)
              for i=1:N]
    end

    return individuals
end


function mutate(me::Individual, rateparam = 0.1, magparam = 1;
                   onemutflag=false)

    # Script to mutate nonzero elements of a matrix
    # according to a probability magnitude and rate
    # parameter

    # Find the non-zero entries as potential mutation sites
    nzindx = find(me.network)

    # Determine the connectivity of the matrix
    # by counting number of nonzeros
    cnum = length(nzindx)

    if onemutflag
        i=rand(1:cnum)
        mutmat = deepcopy(me.network)
        mutmat[nzindx[i]] = magparam*randn()
        return mutmat
    else
        for i=1:cnum
            # For each non-zero entry:
            # With probability R/c*G^2, note cnum=cG^2
            if  rand() < rateparam/cnum
                # Mutate a non-zero entry by a number chosen from a gaussian
                me.network[nzindx[i]] =  magparam*randn()
            end
        end
    end
end

function fitnesseval(me::Individual,sigma=1)
    if me.stable
        statediff = me.develstate - me.optstate
        distance = sum(statediff.^2)/(4*G)
        me.fitness = exp(-(distance/sigma))
    else
        me.fitness=0
    end
end


function robustness(me::Individual, iters=10)

    dist = 0.

    for i=1:iters
        #perturbednet = mutate(me,onemutflag=true)
        perturbed = Individual(mutate(me,onemutflag=true), me.initstate,
                               zeros(Int64,G), zeros(Int64,G), false,
                               0., 0., 100)
        iterateind(perturbed)
        tempdiff = perturbed.develstate - me.develstate
        dist += sum(tempdiff.^2)/(4*G)
    end

    me.robustness=dist/iters
end

function develop(me::Individual)
    iterateind(me)
    fitnesseval(me)
    robustness(me)
end


function reproduce(me::Individual, you::Individual, us::Individual)
# reproduce by row segregation

    reproindxs = rand(0:1,G)
    # Generate a vector of random 0's or 1's
    # of the same length as me's

    # Segragate rows from input matrices me and you
    # to generate new offspring
    for i in find(x->x==1,reproindxs)
        us.network[i,:] = deepcopy(me.network[i,:])
    end

    for j in find(x->x==0,reproindxs)
        us.network[j,:] = deepcopy(you.network[j,:])
    end
end


function update{T}(mes::Vector{Individual{T}})
    map(develop,mes)

    oldinds = deepcopy(mes)

    newind = 1

    while newind <= length(mes)
        tempind = Individual(zeros(G,G), zeros(Int64,G), zeros(Int64,G),
                             zeros(Int64,G), false, 0., 0., 100)

        z = rand(1:N)
        r = rand(1:N)
        reproduce(oldinds[z],oldinds[r],tempind)
        mutate(tempind)

        tempind.initstate = deepcopy(oldinds[z].initstate)
        tempind.optstate = deepcopy(oldinds[z].optstate)

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

    #println(length(unique(map(x->x.network,mes))))

    if pointer(mes[1].network)==pointer(mes[2].network)
        println("problem")
    end
    if pointer(mes[1].initstate)==pointer(mes[2].initstate)
        println("problem")
    end
    if pointer(mes[1].develstate)==pointer(mes[2].develstate)
        println("problem")
    end
    if pointer(mes[1].optstate)==pointer(mes[2].optstate)
        println("problem")
    end
end
