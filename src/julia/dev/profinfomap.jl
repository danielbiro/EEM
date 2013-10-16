function infomap(linklist,imruns,npipe="/tmp/linklistpipe.txt")

    #-----------------------------
    # run infomap on linklist
    # via named pipe
    #-----------------------------
    run(`rm -f $npipe`)
    run(`mkfifo $npipe`)
    @spawn run(`echo -e $linklist` |> "$npipe")
    #print(readchomp(`cat $npipe`))
    imm=readlines(`../bin/infomap $npipe .
                                    -i link-list
                                    -N $imruns
                                    --directed -w -0` |>
                   `grep -Po
                   "((?<=Codelengths for $imruns trials: )\[.*\])|(?<=total:\s{10})\[.*\]"`)

    run(`rm -f $npipe`)

    dls = vcat(eval(parse(imm[2])),
             min(eval(parse(replace(chomp(imm[1]),", \b\b",""))))
            )


    return dls
end


wgraph = abs(randn(10,10))

linklist=""
for i=1:size(wgraph,1)
    for j=1:size(wgraph,2)
        if !isapprox(wgraph[i,j],0)
            linklist=string(linklist,
                        @sprintf("%d\t%d\t%f\n",i,j,
                                 abs(wgraph[i,j])))
        end
    end
end

function profinfomap()
    for i=1:500
        infomap(linklist,10,tempname())
    end
end
