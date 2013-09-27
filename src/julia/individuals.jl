function iterateind(indnet::Matrix, initstate::Vector, tterm=100, tau=10, epsilon=10^-4., a=100)

    # Script to accept a matrix, initial state, iteration maximum, averaging period, error tolerance,
    # and sigmoidal paramter
    # Will output a convergance flag (ConFlag) of 0 for a matrix that did not converge, or 1 for one
    # that did As well as the final state vector of a matrix that did converge

    N = size(indnet,2)
    currstate = deepcopy(initstate)
    convflag = false
    paststate = zeros(N,tau)
    convtime = 0

    for i=1:tau
        paststate[:,i] = currstate[:]
        # Initialize the first tau past states to be the initial state for averaging purposes
        currstate = 2/(1 + exp(-a*indnet*currstate)) - 1
        # Determine the first iterated state
    end

    for i=tau:tterm
        currstate = 2/(1 + exp(-a*indnet*currstate)) - 1
        avgstate = mean(paststate, 2)

        dist = 0

        for j=1:tau
            tempdiff = paststate[:,j]-avgstate[:]
            dist = dist + sum(tempdiff.^2)/(4*N)
            # Calculate distance based on the past states
            # and a given distance metric
        end

        for j=1:(tau-1)
            paststate[:,j+1] = paststate[:,j]
            # Shift every past state forward one
        end

        paststate[:,tau-1] = currstate[:]
        # Dan: Set the most recent past state to the current state
        # Cameron: Where is this being used?

        if dist<epsilon
        # If at any point the distance metric becomes less than the error tolerance, set the
        # convergence
        # flag to 1 and break out of the loop
            convflag = true
            convtime = i
            break
        end
        convtime = i
    end

    return convflag, currstate, convtime
end

function testconvergence(founder::Matrix)
    G = size(founder,2)
    initstate = rand(0:1,G)*2.-1
    conflag, finstate, convtime = iterateind(founder, initstate)

    return conflag, finstate, initstate
end

function geninds(G,N,C,INDTYPE)
    if INDTYPE=="gaussian"
        b = 0
        founder = zeros(Float64,G,G)

        conflag=false
        finstate=[]
        initstate=[]

        while conflag!=true
            for i=1:G^2
                if rand()<C
                    founder[i] = randn()
                end
            end
            conflag, finstate, initstate=testconvergence(founder)
        end

        # println("Founder initial state: ")
        # println(initstate)
        # println("Founder final state: ")
        # println(finstate)
        # println()
        inds=[Individual(founder, initstate, finstate, finstate, true, 1.) for i=1:N]

    elseif INDTYPE=="markov"
        inds=[Individual(rand(Dirichlet(ones(G)),G), rand(Dirichlet(ones(G))),
                   rand(Dirichlet(ones(G))), true, 1.) for i=1:N]
    end

    return inds
end

function matmutate(initnet::Matrix, rateparam = 0.1, magparam = 1)

    # Script to mutate nonzero elements of a matrix according to a probability magnitude and rate
    # parameter
    G = size(initnet,2)
    P = find(initnet)

    # Find the non-zero entries as potential mutation sites
    cnum = length(P)
    # Determine the connectivity of the matrix by counting number of nonzeros

    mutmat = deepcopy(initnet)

    for i=1:cnum
        # For each non-zero entry:
        if  rand() < rateparam/(cnum*G)
            # With probability R/cG^2, note cnum=cG
            mutmat[P[i]] =  magparam*randn()
            # Mutate a non-zero entry by a number chosen from a gaussian
        end
    end

    return mutmat
end

function fitnesseval(me::Individual,sigma=1)
    if me.stable
        G = length(me.optstate)
        statediff = me.develstate - me.optstate
        distance = dot(statediff,statediff)/(4*G)
        me.fitness = exp(-(distance/sigma))
    else
        me.fitness=0
    end
end

function develop(me::Individual)
    (me.stable,me.develstate,convtime) = iterateind(me.network,me.initstate)
    fitnesseval(me)
end

function reproduce(me::Individual)

end

function update{T}(me::Vector{Individual{T}})
    map(develop,me)

    oldinds = deepcopy(me)
    N = 1
    while N < length(me)
        z = rand(1:N)
        if oldinds[z].fitness > rand()
            tempind = matmutate(oldinds[z].network)
            (tempconvflag, tempdevelstate, tempconvtime) =
                                    iterateind(tempind,oldinds[z].initstate)
            if tempconvflag == 1
                me[N].network = tempind
                me[N].develstate = tempdevelstate
                me[N].stable = true
                fitnesseval(me[N])
                N = N + 1
            end
        end
    end
    me
end
