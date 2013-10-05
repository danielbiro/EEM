using Base.Test
#using Debug

# testdir
require("test/constants.jl")

# srcdir
require("types.jl")
require("individuals.jl")
require("population.jl")

function testpopulation()
    @test typeof(genpop())==Population{Individual{Float64}}

    #=================================
    #geninds
    inds = geninds()

    @test length(inds)==N

    individual1 = inds[1]
    individual3 = inds[3]

    @test size(individual1.network,2) == G
    @test size(individual3.network,2) == G
    @test individual1.network == individual3.network
    @test individual1.initstate == individual3.initstate
    @test individual1.develstate == individual3.develstate
    @test individual1.optstate == individual3.optstate
    @test individual1.stable == individual3.stable
    @test individual1.fitness == individual3.fitness

    #=================================
    #update - no connectivity change
    oldinds = deepcopy(inds)
    pop = genpop(inds)
    for i=1:10
        # Note: calling update function
        update(pop)
    end

    newinds = pop.individuals

    for i=1:length(inds)
        for j=1:length(inds)
            @test find(newinds[i].network)==find(oldinds[j].network)
        end
    end
end

testpopulation()
