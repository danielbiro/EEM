using Base.Test
#using Debug

# testdir
require("test/constants.jl")

# srcdir
require("types.jl")
require("individuals.jl")


function testindividuals()
    net1 = [ 0.299269  -1.67306   -1.04407
            -0.132803   1.27519    0.0
            -0.958348   0.729679   0.183351]

    testindinit1 = [-1,1,1]
    testindstable1 = [-1,1,1]
    testindoptstate = [-1,1,1]

    net2 = [ 0.0494486   0.0        0.0
            -0.821331    0.0        0.829691
            -0.674853   -0.0917805  0.0]
    testindinit2 = [1,1,1]
    testindstable2 = [1,-1,-1]

    net3 = [-0.142667  -0.677171  -0.757668
             0.0        0.0        0.889831
            -0.241441   0.0        0.0   ]
    testindinit3 = [1,1,1]
    testindunstable3 = [1,-1,1]

    newind = Individual()
    @test_approx_eq newind.network zeros(G,G)
    @test newind.initstate==zeros(Int64,G)
    @test newind.develstate==zeros(Int64,G)
    @test newind.optstate==zeros(Int64,G)
    @test newind.stable==false
    @test_approx_eq newind.fitness 0.
    @test_approx_eq newind.robustness 0.
    @test newind.pathlength==0

    #=================================
    # iterateind - convergent state
    newind.network = copy(net1)
    newind.initstate = [-1,1,1]
    newind.optstate = [-1,1,1]

    iterateind(newind)

    @test newind.initstate==testindinit1
    @test newind.stable==true
    @test newind.develstate==testindstable1
    @test newind.pathlength>=1

    #=================================
    #fitnesseval
    fitnesseval(newind)
    @test newind.fitness==1

    newind.network = copy(net2)
    newind.initstate = [1,1,1]
    iterateind(newind)

    testindinit2 = [1,1,1]
    testindstable2 = [1,-1,-1]

    @test newind.initstate==testindinit2
    @test newind.stable==true
    @test newind.develstate==testindstable2
    @test newind.pathlength>=1

    #=================================
    #fitnesseval
    fitnesseval(newind)
    fitind3 = exp(-(sum((testindstable2-testindoptstate).^2)/(4*G)/SELSTR))
    @test_approx_eq newind.fitness fitind3

    # iterateind - nonconvergent state
    newind.network = copy(net3)

    newind.initstate = [1,1,1]

    iterateind(newind)

    @test newind.initstate==testindinit3
    @test newind.stable==false
    @test newind.develstate==testindunstable3
    @test newind.pathlength>=1

    #=================================
    #fitnesseval
    fitnesseval(newind)
    @test newind.fitness==0

    # unmodified part of Individual object not modified
    @test newind.optstate==testindoptstate

    #==================================
    # randstableind
    stableind = randstableind()
    @test stableind.stable==true
    @test stableind.initstate!=zeros(Int64,G)
    @test stableind.develstate!=zeros(Int64,G)

    #==================================
    # genfounder
    founder = genfounder()
    @test founder.fitness==1
    @test founder.develstate==founder.optstate

    #==================================
    # mutate
    mutind = Individual(net1)
    mutflag=false
    while mutflag!=true
        @test_approx_eq mutind.network net1
        mutflag=mutate(mutind)
    end
    @assert !isequal(net1,mutind.network)

    #==================================
    # mutone
    mutind = Individual(net1)
    mutnet1 = onemut(mutind)
    @test_approx_eq mutind.network net1
    @assert !isequal(net1,mutnet1)

    #==================================
    # robustness
    @test_approx_eq newind.robustness 0.
    robustness(newind)
    @test newind.robustness <= 1.
    @assert !isequal(newind.robustness, 0.)

    #==================================
    # reproduce
    child = Individual()

    reproindxs = reproduce(newind,mutind,child)

    for i=1:G
        if reproindxs[i]==1
            @test_approx_eq child.network[i,:] newind.network[i,:]
        elseif reproindxs[i]==0
            @test_approx_eq child.network[i,:] mutind.network[i,:]
        end
    end
end

testindividuals()
