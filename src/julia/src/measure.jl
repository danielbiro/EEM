function genmeasure()
    time = zeros(Int64,NUMMEAS)
    fitness = zeros(Float64,NUMMEAS)
    fitnessstd = zeros(Float64,NUMMEAS)
    robustness = zeros(Float64,NUMMEAS)
    robustnessstd = zeros(Float64,NUMMEAS)
    pathlength = zeros(Float64,NUMMEAS)
    pathlengthstd = zeros(Float64,NUMMEAS)
    indtypes = zeros(Int64,NUMMEAS)
    inittypes = zeros(Int64,NUMMEAS)
    develtypes = zeros(Int64,NUMMEAS)
    opttypes = zeros(Int64,NUMMEAS)
    mdl = zeros(Float64,NUMMEAS)
    mdlstd = zeros(Float64,NUMMEAS)
    hierarchy = zeros(Float64,NUMMEAS)
    hierarchystd = zeros(Float64,NUMMEAS)

    Measure(time, fitness,fitnessstd,robustness,robustnessstd,
            pathlength, pathlengthstd, indtypes, inittypes,
            develtypes, opttypes, mdl, mdlstd, hierarchy, hierarchystd)
end

function measure(pop::Population, m::Measure, t::Time, n::Int64)
    # update measurements
    pmap(measure,pop.individuals)

    #println("nummeas: $NUMMEAS , time: $t , measurement: $n")

    # store measurements in Measure
    m.time[n] = t
    m.indtypes[n] = length(unique(map(x->x.network,pop.individuals)))
    m.inittypes[n] = length(unique(map(x->x.initstate,pop.individuals)))
    m.develtypes[n] = length(unique(map(x->x.develstate,pop.individuals)))
    m.opttypes[n] = length(unique(map(x->x.optstate,pop.individuals)))
    fitvect = map(x->x.fitness, pop.individuals)
    robustvect = map(x->x.robustness, pop.individuals)
    pathvect = map(x->x.pathlength, pop.individuals)
    modvect = map(x->x.modularity, pop.individuals)
    hiervect = map(x->x.hierarchy, pop.individuals)
    m.fitness[n] = mean(fitvect)
    m.fitnessstd[n] = std(fitvect)
    m.robustness[n] = mean(robustvect)
    m.robustnessstd[n] = std(robustvect)
    m.pathlength[n] = mean(pathvect)
    m.pathlengthstd[n] = std(pathvect)
    m.minimumdescriptionlength[n] = mean(modvect)
    m.minimumdescriptionlengthstd[n] = std(modvect)
    m.hierarchy[n] = mean(hiervect)
    m.hierarchystd[n] = std(hiervect)
end

function save(m::Measure, fname::String)
    df = DataFrame(time=m.time,
                   indtypes=m.indtypes,
                   inittypes=m.inittypes,
                   develtypes=m.develtypes,
                   opttypes=m.opttypes,
                   fitness=m.fitness,
                   fitnessstd=m.fitnessstd,
                   robustness=m.robustness,
                   robustnessstd=m.robustnessstd,
                   pathlength=m.pathlength,
                   pathlengthstd=m.pathlengthstd,
                   modularity=m.minimumdescriptionlength,
                   modularitystd=m.minimumdescriptionlengthstd,
                   hierarchy=m.hierarchy,
                   hierarchystd=m.hierarchystd)
    writetable(fname,df)
    # f = writedlm(joinpath("data",fname),
    #              hcat(m.indtypes,m.inittypes,m.develtypes, m.opttypes,
    #                   m.fitness, m.fitnessstd, m.robustness, m.robustnessstd,
    #                   m.pathlength, m.pathlengthstd), ',')
    return df
end
