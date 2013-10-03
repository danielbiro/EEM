function iterateind(me::Individual,
                    tau=10, tterm=100,epsilon=10^-4., a=100)

    currstate = deepcopy(me.initstate)
    network = deepcopy(me.network)

    for i=1:tterm
        stateupdate = network*currstate
        stateupdate[find(x -> x>=0,stateupdate)] = 1
        stateupdate[find(x -> x<0,stateupdate)] = -1

        if currstate==stateupdate
            me.stable = true
            me.develstate = stateupdate
            me.pathlength = i
            break
        elseif i==tterm
            me.stable = false
            me.develstate = stateupdate
            me.pathlength = tterm
        end

    end
end

function iterateind(indnet::Matrix, initstate::Vector,
                    tau=10, tterm=100,epsilon=10^-4., a=100)

    convflag = false
    currstate = deepcopy(initstate)
    network = deepcopy(indnet)
    convtime = 0

    for i=1:tterm
        stateupdate = network*currstate
        stateupdate[find(x -> x>=0,stateupdate)] = 1
        stateupdate[find(x -> x<0,stateupdate)] = -1
        if currstate==stateupdate
            convflag = true
            currstate = stateupdate
            convtime = i
            break
        elseif i==tterm
            currstate = stateupdate
            convtime = tterm
        end
    end

    return convflag, currstate, convtime
end

# function iterateind(indnet::Matrix, initstate::Vector,
#                     tau=10, tterm=100,epsilon=10^-4., a=100)

#     # Script to accept a matrix, initial state,
#     # iteration maximum, averaging period, error tolerance,
#     # and sigmoidal paramter
#     # Will output a convergance flag (ConFlag) of 0 for
#     # a matrix that did not converge, or 1 for one
#     # that did As well as the final state vector of a
#     # matrix that did converge

#     #G = size(indnet,2)
#     currstate = deepcopy(initstate)
#     convflag = false
#     paststate = zeros(G,tau)
#     convtime = 0

#     for i=1:tau
#         paststate[:,i] = currstate[:]
#         # Initialize the first tau past states
#         #to be the initial state for averaging purposes
#         #currstate = 2/(1 + exp(-a*indnet*currstate)) - 1
#         stateupdate = indnet*currstate
#         currstate[find(x -> x>=0,stateupdate)] = 1
#         currstate[find(x -> x<0,stateupdate)] = -1
#         #println(currstate)
#         # Determine the first iterated state
#     end

#     for i=tau:tterm
#         #currstate = 2/(1 + exp(-a*indnet*currstate)) - 1
#         stateupdate = indnet*currstate
#         currstate[find(x -> x>=0,stateupdate)] = 1
#         currstate[find(x -> x<0,stateupdate)] = -1
#         avgstate = mean(paststate, 2)

#         dist = 0

#         for j=1:tau
#             tempdiff = paststate[:,j]-avgstate[:]
#             dist = dist + sum(tempdiff.^2)/(4*G)
#             # Calculate distance based on the past states
#             # and a given distance metric
#         end

#         for j=1:(tau-1)
#             paststate[:,j+1] = paststate[:,j]
#             # Shift every past state forward one
#         end

#         paststate[:,tau-1] = currstate[:]
#         # Dan: Set the most recent past state to the current state
#         # Cameron: Where is this being used?

#         if dist<epsilon
#         # If at any point the distance metric
#         # becomes less than the error tolerance,
#         # set the convergence
#         # flag to 1 and break out of the loop
#             convflag = true
#             convtime = i
#             break
#         end
#         convtime = i
#     end

#     return convflag, currstate, convtime
# end


function testconvergence(founder::Matrix,
                         tau=10, tterm=100, epsilon=10^-4., a=100)

    initstate = rand(0:1,G)*2.-1
    conflag, finstate, convtime = iterateind(founder, initstate,
                                             tau, tterm, epsilon, a)

    return conflag, finstate, initstate, convtime
end


function geninds()
    if INDTYPE=="gaussian"
        conflag=false
        founder = []
        finstate=[]
        initstate=[]
        convtime=0

        while conflag!=true
            founder = zeros(Float64,G,G)
            for i=1:G^2
                if rand()<C
                    founder[i] = randn()
                end
            end
            conflag, finstate, initstate, convtime=testconvergence(founder)
        end

        # println("Founder initial state: ")
        # println(initstate)
        # println("Founder final state: ")
        # println(finstate)
        # println()
         inds=[Individual(deepcopy(founder), deepcopy(initstate), deepcopy(finstate), deepcopy(finstate), deepcopy(conflag), 1., 0., deepcopy(convtime)) for i=1:N]
         inds=convert(Array{Individual{Float64},1},inds)
        # inds=[Individual(founder, initstate, finstate, finstate, true, 1., 0., convtime)
        #       for i=1:N]
    elseif INDTYPE=="markov"
        inds=[Individual(rand(Dirichlet(ones(G)),G),
              rand(Dirichlet(ones(G))), rand(Dirichlet(ones(G))), true, 1.)
              for i=1:N]
    end

    return inds
end


function matmutate(initnet::Matrix, rateparam = 0.1, magparam = 1;
                   onemutflag=false)

    # Script to mutate nonzero elements of a matrix
    # according to a probability magnitude and rate
    # parameter

    nzindx = find(initnet)
    # Find the non-zero entries as potential mutation sites

    cnum = length(nzindx)
    # Determine the connectivity of the matrix
    # by counting number of nonzeros

    mutmat = deepcopy(initnet)

    if onemutflag
        i=rand(1:cnum)
        mutmat[nzindx[i]] = magparam*randn()
    else
        for i=1:cnum
            # For each non-zero entry:
            if  rand() < rateparam/cnum
                # With probability R/c*G^2, note cnum=cG^2
                mutmat[nzindx[i]] =  magparam*randn()
                # Mutate a non-zero entry by a number chosen from a gaussian
            end
        end
    end

    return mutmat
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
        perturbednet = matmutate(me.network,onemutflag=true)
        (convflag, pertstate, convtime) = iterateind(perturbednet,me.initstate)
        tempdiff = pertstate - me.initstate
        dist += sum(tempdiff.^2)/(4*G)
    end

    me.robustness=dist/iters
end

function robustness(me::Matrix{Float64}, initstate::Vector{Float64}, iters=10)

    dist = 0.

    for i=1:iters
        perturbednet = matmutate(me,onemutflag=true)
        (convflag, pertstate, convtime) = iterateind(perturbednet,initstate)
        tempdiff = pertstate - initstate
        dist = dist + sum(tempdiff.^2)/(4*G)
    end

    dist/iters
end

function develop(me::Individual)
    iterateind(me)
    fitnesseval(me)
    robustness(me)
end


function reproduce(me::Individual, you::Individual)
# reproduce by row segregation


    us = zeros(G,G)
    reproindxs = rand(0:1,G)
    # Generate a vector of random 0's or 1's
    # of the same length as me's

    # Segragate rows from input matrices me and you
    # to generate new offspring
    for i in find(x->x==1,reproindxs)
        us[i,:] = deepcopy(me.network[i,:])
    end

    for j in find(x->x==0,reproindxs)
        us[j,:] = deepcopy(you.network[j,:])
    end

    return us
end


function update{T}(me::Vector{Individual{T}})
    map(develop,me)

    oldinds = deepcopy(me)

    newind = 1
    while newind <= length(me)
        tempind = Individual(zeros(G,G), zeros(G), zeros(G), zeros(G),
                            false, 0., 0., 100)
        z = rand(1:N)
        r = rand(1:N)
        tempind.network = reproduce(oldinds[z],oldinds[r])
        tempind.network = matmutate(tempind.network)
        tempind.initstate = deepcopy(oldinds[z].initstate)
        tempind.optstate = deepcopy(oldinds[z].optstate)
        iterateind(tempind)
        if tempind.stable
            fitnesseval(tempind)
            println(tempind.fitness)
            if tempind.fitness >= rand()
                me[newind] = deepcopy(tempind)
                robustness(me[newind])
                newind += 1
            end
        end
    end
    me
end
