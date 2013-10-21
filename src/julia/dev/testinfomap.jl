using Graphs
#using Winston

function infomap(wgraph,imruns,npipe="/tmp/linklistpipe.txt")
    #agraph.inclist
    linklist=""
    for i=1:size(wgraph,1)
        for j=1:size(wgraph,2)
            if !isapprox(wgraph[i,j],0)
                linklist=string(linklist,
                            @sprintf("%d\t%d\t%f\n",i,j,abs(wgraph[i,j])))
            end
        end
    end

    #-----------------------------
    # run infomap on linklist
    # via named pipe
    #-----------------------------
    run(`rm -f $npipe`)
    run(`mkfifo $npipe`)
    @spawn run(`echo -e $linklist` |> "$npipe")
    #print(readchomp(`cat $npipe`))
    imm=readlines(`../bin/infomap $npipe . -i link-list -N $imruns --directed -w -0` |> `grep -Po "((?<=Codelengths for $imruns trials: )\[.*\])|(?<=total:\s{10})\[.*\]"`)
    #println(imm)
    #run(`rm -f $npipe`)

    vcat(eval(parse(imm[2])),
             min(eval(parse(replace(chomp(imm[1]),", \b\b",""))))
            )
end

function gengraph(graphtype="random",N=10,P=1,K=3,Beta=0.1)
    if graphtype=="random"
        agraph = erdos_renyi_graph(N,P,is_directed=true,
                                     has_self_loops=true)
    elseif graphtype=="smallworld"
        agraph = watts_strogatz_graph(N,K,Beta)
    else
        error("wrong graphtype")
    end

    weights = randn(agraph.nedges)
    #weights = ones(agraph.nedges)
    #weights = rand(agraph.nedges)
    #weights = rand(-1:1,agraph.nedges)

    weight_matrix(agraph,weights)
end

N=10;P=1;K=3;Beta=0.1;
graphtype="smallworld" # random | smallworld
numgraphs=500
imruns=10

#immv=(Array{Any})[]
immv = [infomap(gengraph(graphtype,N,P,K,Beta),imruns,tempname()) for i=1:numgraphs]

immdl = convert(Array{Float64,1},map(x->x[endof(x)],immv))
imhl = convert(Array{Int,1},map(x->length(x),immv))

# p1 = FramedPlot()
# setattr(p1, "title", "distribution")
# setattr(p1, "xlabel", "min desc len")
# setattr(p1, "ylabel", "count")
# immdlhist = hist(immdl,20)
# add( p1, Histogram(immdlhist...) )
# setattr(p1, "yrange", (0,max(immdlhist[2])+3))

# p2 = FramedPlot()
# setattr(p2, "title", "distribution")
# setattr(p2, "xlabel", "levels in hierarchy")
# setattr(p2, "ylabel", "count")
# imhlhist = hist(imhl,20)
# add( p2, Histogram(imhlhist...) )
# setattr(p2, "yrange", (0,max(imhlhist[2])+3))

# #hist(convert(Array{Int,1},map(x->length(x),immv)),20)

# t1= Table(1,2)
# t1[1,1] = p1
# t1[1,2] = p2

# run(`mkdir -p fig`)
# file(t1,"fig/immdlhist_N=$N\_P=$P\_K=$K\_B=$Beta\.pdf")
#run(`evince fig/immdlhist_N=$N\_P=$P\_K=$K\_B=$Beta\.pdf`)

#-----------------------------
# save linklist to file for testing
#-----------------------------
# f = open("linklist.txt","w")
# print(f,linklist)
# close(f)



