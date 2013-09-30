using Graphs

N=10
P=1
K=3
Beta=0.1

a = time()
for kkd=1:500
#agraph = erdos_renyi_graph(N,P,is_directed=true,
#                                 has_self_loops=true)
agraph = watts_strogatz_graph(N,K,Beta)

weights = randn(agraph.nedges)
#weights = ones(agraph.nedges)
#weights = rand(agraph.nedges)
wgraph = weight_matrix(agraph,weights)

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

#for kkd=1:10
    #run(`rm -f /tmp/linklistpipe.txt` |> `mkfifo /tmp/linklistpipe.txt`)
    run(`rm -f /tmp/linklistpipe.txt`)
    run(`mkfifo /tmp/linklistpipe.txt`)
    @spawn run(`echo -e $linklist` |> "/tmp/linklistpipe.txt")
    #print(readchomp(`cat /tmp/linklistpipe.txt`))
    imm=readchomp(`./infomap /tmp/linklistpipe.txt . -i link-list -N 10 --directed -w -0` |> `grep -Po "(?<=total:          )\[.*\]"`)
    #imm=readchomp(`./Infomap-0.11.5/Infomap /tmp/linklistpipe.txt . -i link-list -N 10 -0` |> `grep -Po "(?<=total:          )\[.*\]"`)
    run(`rm -f /tmp/linklistpipe`)
    #println(imm)
end
b = time()
println(b-a)

#-----------------------------
# save linklist to file for testing
#-----------------------------
# f = open("linklist.txt","w")
# print(f,linklist)
# close(f)



