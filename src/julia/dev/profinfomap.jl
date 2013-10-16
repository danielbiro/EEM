function genlinklist(wgraph)
    linklist=""
    for i=1:size(wgraph,1)
        for j=1:size(wgraph,2)
            if !isapprox(wgraph[i,j],0)
                linklist=string(linklist,
                            @sprintf("%d\t%d\t%d\n",i,j,
                                     abs(wgraph[i,j])))
            end
        end
    end

    return linklist
end

function infomap(linklist,imruns,npipe)


    #-----------------------------
    # run infomap on linklist
    # via named pipe
    #-----------------------------

    #npipe=tempname()
    #run(`rm -f $npipe`)
    #run(`mkfifo $npipe`)

    #linklist = genlinklist(wgraph)
    #println("here1")

    #@spawn run(`echo -e $linklist` |> "$npipe")

    #run(`./tonamedpipe.sh $linklist $npipe`)
    #println("here2")

    fh = open(npipe,"w")
    print_unescaped(fh,linklist)
    close(fh)


    #println(readlines(`cat $npipe`))
    #print(readchomp(`cat $npipe`))
    imm=readlines(`../bin/infomap $npipe .
                                    -i link-list
                                    -N $imruns
                                    --directed -w -0` |>
                   `grep -Po
                   "((?<=Codelengths for $imruns trials: )\[.*\])|(?<=total:\s{10})\[.*\]"`)

    #run(`rm -f $npipe`)
    #println(imm)
    dls = vcat(eval(parse(imm[2])),
             minimum(eval(parse(replace(chomp(imm[1]),", \b\b",""))))
            )


    return dls
end



#wgraph = abs(randn(10,10))
wgraph = rand(1:10,10,10)

function profinfomap()
    np = tempname()
    #np = joinpath("/media","ramdisk","tmp","tempfile")
    println(np)
    #run(`rm -f $np`)
    #run(`mkfifo $np`)
    #fh = open(np,"w")
    #println("here")
    linklist = genlinklist(wgraph)

    for i=1:500
        #infomap(linklist,10,tempname())
        #infomap(linklist,10,"modgraph.txt")
        infomap(linklist,10,np,fh)
    end
    #close(fh)
    #run(`rm -f $np`)
end
