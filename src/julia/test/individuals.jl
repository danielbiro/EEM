using Base.Test

require("types.jl")
require("individuals.jl")

testind1 = [0.299269  -1.67306   -1.04407
            -0.132803   1.27519    0.0
            -0.958348   0.729679   0.183351]

# testind2 = [-.5171601684080414  0   0
#             -.3252679834777976  -1.338027123296406  -.5353476936243659
#             1.5551844915039323  -.46996721344812914 -.020179822868444778]

# testindinit2 = [-1.0,1.0,1.0]
# testindstable2 = [1.0,-1.0,-1.0]

#=================================
#iterateind - convergent state
testindinit1 = [-1.0,1.0,1.0]
testindstable1 = [-1.0,1.0,1.0]

outconvflag, outstate, outconvtime = iterateind(testind1,testindinit1)

#print(outconvtime)

@test outconvflag==true
@test_approx_eq outstate testindstable1

#iterateind - nonconvergent state
testindinit2 = [-1.0,-1.0,1.0]
testindunstable2 = [1.0,-1.0,-1.0]

outconvflag, outstate, outconvtime = iterateind(testind1,testindinit2)

#print(outconvtime)

@test outconvflag==false
@test_approx_eq outstate testindunstable2

#=================================
#testconvergence
conflag=true
finstate = []
initstate = []
while conflag!=false
    conflag, finstate, initstate, convtime = testconvergence(testind1)
end
@test finstate!=initstate

#=================================
#geninds
inds = geninds(3,5,0.75,"gaussian")

@test length(inds)==5

individual1 = inds[1]
individual3 = inds[3]

@test size(individual1.network,2) == 3
@test size(individual3.network,2) == 3
@test individual1.network == individual3.network
@test individual1.initstate == individual3.initstate
@test individual1.develstate == individual3.develstate
@test individual1.optstate == individual3.optstate
@test individual1.stable == individual3.stable
@test individual1.fitness == individual3.fitness

#=================================
#matmutate
mutrate1 = length(find(testind1))*size(testind1,2)
mutmat = matmutate(testind1,mutrate1,10)
@test find(testind1)==find(mutmat)
@test testind1!=mutmat

mutrate2 = 0
mutmat = matmutate(testind1,mutrate2,10)
@test find(testind1)==find(mutmat)
@test testind1==mutmat

#=================================
#fitnesseval
@test fitnesseval(individual1)==individual1.fitness
@test_approx_eq fitnesseval(individual1,100) 1
individual1.stable=false
@test fitnesseval(individual1)==0
individual1.stable=true

#=================================
#update - no connectivity change
oldinds = deepcopy(inds)

for i=1:10
    update(inds)
end

for i=1:length(inds)
    for j=1:length(inds)
        @test find(inds[i].network)==find(oldinds[j].network)
    end
end
