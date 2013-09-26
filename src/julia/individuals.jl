function iterateind(IndMat::Matrix, IntState::Vector, Term=100, tau=10, epsilon=10^-4., a=100)

    # Script to accept a matrix, initial state, iteration maximum, averaging period, error tolerance,
    # and sigmoidal paramter
    # Will output a convergance flag (ConFlag) of 0 for a matrix that did not converge, or 1 for one
    # that did As well as the final state vector of a matrix that did converge

    N = size(IndMat,2)
    CurState = deepcopy(IntState)
    ConFlag = false
    PastState = zeros(N,tau)
    ConTime = 0

    for i=1:tau
        PastState[:,i] = CurState[:]
        # Initialize the first tau past states to be the initial state for averaging purposes
        CurState = 2/(1 + exp(-a*IndMat*CurState)) - 1
        # Determine the first iterated state
    end

    for i=tau:Term
        CurState = 2/(1 + exp(-a*IndMat*CurState)) - 1
        AvgState = mean(PastState, 2)

        Dist = 0

        for j=1:tau
            TempDiff = PastState[:,j]-AvgState[:]
            Dist = Dist + sum(TempDiff.^2)/(4*N)
            # Calculate the distance metric based on the past states and the defined distance
            # metric
        end

        for j=1:(tau-1)
            PastState[:,j+1] = PastState[:,j]
            # Shift every past state forward one
        end

        PastState[:,tau-1] = CurState[:]
        # Dan: Set the most recent past state to the current state
        # Cameron: Where is this being used?

        if Dist<epsilon
        # If at any point the distance metric becomes less than the error tolerance, set the
        # convergence
        # flag to 1 and break out of the loop
            ConFlag = true
            ConTime = i
            break
        end
        ConTime = i
    end

    return ConFlag, CurState, ConTime
end

function testconvergence(founder::Matrix)
    G = size(founder,2)
    initstate = rand(0:1,G)*2-1
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
        #[GaussMat(founder,randn(G)) for i=1:N]
        inds=[GaussMat(founder, finstate, finstate, true, 1.) for i=1:N]

    elseif INDTYPE=="markov"
        inds=[MarkovMat(rand(Dirichlet(ones(G)),G), rand(Dirichlet(ones(G))),
                   rand(Dirichlet(ones(G))), true, 1.) for i=1:N]
    end

    return inds
end

function matmutate(InitMat::Matrix, RateParam = 0.1, MagParam = 1)

    # Script to mutate nonzero elements of a matrix according to a probability magnitude and rate
    # parameter
    G = size(InitMat,2)
    P = find(InitMat)
    # Find the non-zero entries as potential mutation sites
    c = length(P)
    # Determine the connectivity of the matrix by counting number of nonzeros

    MutMat = deepcopy(InitMat)

    for i=1:c
        # For each non-zero entry:
        if  rand() < RateParam/(c*G)
            # Dan: With probability R/cG^2
            # Cameron: shouldn't this be c*G rather than c*G**3 since
            # c was never divided by G in this function?
            MutMat[P[i]] =  MagParam*randn()
            # Mutate a non-zero entry by a number chosen from a gaussian
        end
    end

    return MutMat
end

# function update(me::MarkovMat)

# end

# function update(me::GaussMat)

# end

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
    (me.stable,me.develstate,convtime) = iterateind(me.network,me.optstate)
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
                                    iterateind(tempind,oldinds[z].optstate)
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
