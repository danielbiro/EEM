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
