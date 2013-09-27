using Graphs

require("types.jl")
require("individuals.jl")

# question: what proportion of convergent individuals
#           has an initial state different from its stable state?
function testdifffininit(G,C)
    # julia> testdifffininit(10,0.75)
    # Nsame, Ndiff, Ndiff/(Ndiff+Nsame)
    # (9634,366,0.0366)
    Ndiff=0
    Nsame=0
    for i=1:10000
        founder = zeros(Float64,G,G)

        conflag=false
        diffflag=false
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

        if sum([isapprox(finstate[i],initstate[i]) for i=1:length(finstate)])==G
            Ndiff=Ndiff+1
            diffflag=true
        else
            Nsame=Nsame+1
        end
    end
    return Nsame, Ndiff, Ndiff/(Ndiff+Nsame)
end

# question: how does proportion of individuals converging
#           scale with individual connectivity
