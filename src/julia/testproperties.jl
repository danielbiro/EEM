using Graphs
#using Debug
using Winston

require("types.jl")
require("individuals.jl")
require("textprogressbar.jl")
require("constants.jl")

# question: what proportion of convergent individuals
#           has an initial state different from its stable state?
# answer: almost all
function testdifffininit(tests,tau=10,tterm=100)
    convtimevect = zeros(Int64,tests)
    robustvect = zeros(Float64,tests)

    tpb=textprogressbar("running: ",[])

    for i=1:tests
        potfounder = randstableind()
        robustness(potfounder)
        convtimevect[i]=potfounder.pathlength
        robustvect[i]=potfounder.robustness

        tpb=textprogressbar(i/tests*100,tpb)
    end
    textprogressbar(" done.",tpb)

    p1 = FramedPlot()
    setattr(p1, "title", "distribution")
    setattr(p1, "xlabel", "convergence time")
    setattr(p1, "ylabel", "count")
    convtimehist = hist(convtimevect,20)
    add( p1, Histogram(convtimehist...) )
    setattr(p1, "yrange", (0,max(convtimehist[2])+5))
    file(p1,"fig/convtimehist_$tau\_$tterm.pdf")
    #run(`evince fig/convtimehist2_$tau\_$tterm.pdf`)

    p2 = FramedPlot()
    setattr(p2, "title", "distribution")
    setattr(p2, "xlabel", "mean phenotypic distance")
    setattr(p2, "ylabel", "count")
    robusthist = hist(robustvect,20)
    add( p2, Histogram(robusthist...) )
    setattr(p2, "yrange", (0,max(robusthist[2])+5))
    file(p2,"fig/robustvect_$G\_$C\_$tests.pdf")
    run(`evince fig/robustvect_$G\_$C\_$tests.pdf fig/convtimehist_$tau\_$tterm.pdf`)

    return min(convtimevect), max(convtimevect), mean(convtimevect),
           min(robustvect), max(robustvect), mean(robustvect)
end

println(testdifffininit(1000,10,100))

# question: how does proportion of individuals converging
#           scale with individual connectivity

# an inhibitor of a downregulated gene
# contributes to the upregulation of that gene

# question: what is the average convergence time
#           for convergent individuals?
#   julia> testdifffininit(10,0.75,1000)
#   (1000,0,0.0,10,58,15.35)

# question: what is the relationship between
#           the structure of those individuals that
#           do and do not converge
# approach: plot dendrogram of individuals that do converge
#           and those that do not

# question: do individuals that converge in the short term
#           converge in the long term
# approach: compare distance between time-averaged state vectors
#           in short-term convergence







