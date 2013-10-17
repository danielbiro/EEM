function clustergram(fname)
    run(`python clustergram.py --i $fname`)
end

function plot(simdir)

    # Python script substitutes for Gadfly to plot basic data
    plotspdf = joinpath(simdir,"plots.pdf")
    netspdf = joinpath(simdir,"nets.pdf")

    plotxvar = "time"
    plotyvar = ["pathlength","indtypes","develtypes",
                "modularity","hierarchy"]
    plotspdfs = map(x->joinpath(simdir,string(x,".pdf")),plotyvar)
    run(`python plotdata.py -d $simdir -x $plotxvar -y $plotyvar`)
    run(`gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$plotspdf
            -dBATCH $plotspdfs`)

    nettsvs = map(x->chomp(joinpath(simdir,x)),
                  readlines(`ls $simdir` |> `grep nets` |> `grep .tsv`))
    netpdfs = map(x->replace(x,".tsv",".pdf"),nettsvs)
    pmap(clustergram,nettsvs)
    run(`gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=$netspdf
            -dBATCH $netpdfs`)

    #run(`evince $simdir\/nets.pdf $simdir\/$plotyvar\.pdf`)
    run(`evince $netspdf $plotspdf`)
    run(`libreoffice $simdir\/sim.csv`)

end

simdir=joinpath("..","output",ARGS[1])
plot(simdir)
