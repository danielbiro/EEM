#using DataFrames
#using Gadfly

function plotmc(simdir)
    envpdf = joinpath(simdir,"env.pdf")
    # simdat = joinpath(simdir,"sim.csv")

    # df = readtable(simdat)
    # #df[:(environment .== "one"),:]
    # #df[:(environment .== "two"),:]

    # p1 = plot(df, x="modularity", color="environment",Geom.histogram)
    # #p1 = plot(df, x="modularity", color="environment",Geom.density)
    # draw(PDF(envpdf, 8inch, 6inch), p1)
    # #draw(PDF(env12pdf, 6inch, 3inch), plot(df, x="env12", Geom.histogram))

    run(`python plotmc.py -d $simdir`)
    spawn(`evince $envpdf`)
end

simdir=joinpath("..","output",ARGS[1])
plotmc(simdir)
