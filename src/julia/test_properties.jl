using Graphs
#using Debug
using Winston

require("types.jl")
require("individuals.jl")

# question: what proportion of convergent individuals
#           has an initial state different from its stable state?
function testdifffininit(G,C,tests)
    # julia> testdifffininit(10,0.75)
    # Nsame, Ndiff, Ndiff/(Ndiff+Nsame)
    # (366,9634,0.9634)
    Ndiff=0
    Nsame=0
    convtimevect = zeros(Int64,tests)
    for i=1:tests
        conflag=false
        diffflag=false
        finstate=[]
        initstate=[]
        founder = []

        convtime=0
        while conflag!=true
            founder = zeros(Float64,G,G)
            for j=1:G^2
                if rand()<C
                    founder[j] = randn()
                end
            end
            conflag, finstate, initstate, convtime=testconvergence(founder)
        end

        convtimevect[i]=convtime
        # println(sum([isapprox(finstate[i],initstate[i],rtol=10^-2.) for i=1:length(finstate)])==3)
        # println(founder)
        # println(finstate)
        # println(initstate)
        #if sum([isapprox(finstate[i],initstate[i],rtol=10^-2.) for i=1:length(finstate)])==G
        if true
            Nsame=Nsame+1
        else
            Ndiff=Ndiff+1
            diffflag=true
        end
    end

    p = FramedPlot()
    setattr(p, "title", "distribution")
    setattr(p, "xlabel", "convergence time")
    setattr(p, "ylabel", "count")
    convtimehist = hist(convtimevect,20)
    add( p, Histogram(convtimehist...) )
    setattr(p, "yrange", (0,max(convtimehist[2])+5))
    file(p,"convtimehist.pdf")
    run(`evince convtimehist.pdf`)

    return Nsame, Ndiff, Ndiff/(Ndiff+Nsame), min(convtimevect),
            max(convtimevect), mean(convtimevect)
end

# question: how does proportion of individuals converging
#           scale with individual connectivity

# an inhibitor of a downregulated gene
# contribute to the upregulation of that gene

# question: what is the average convergence time
#           for convergent individuals?
#   julia> testdifffininit(10,0.75,1000)
#   (1000,0,0.0,10,58,15.35)

# question: what is the relationship between
#           the structure of those individuals that
#           do and do not converge
# approach: plot histogram of individuals that do converge
#           and those that do not

# question: do individuals that converge in the short term
#           converge in the long term
# approach: compare distance between time-averaged state vectors
#           in short-term convergence







