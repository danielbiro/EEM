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
    mdl1 = zeros(Float64,NUMMEAS)
    mdl1std = zeros(Float64,NUMMEAS)
    mdl2 = zeros(Float64,NUMMEAS)
    mdl2std = zeros(Float64,NUMMEAS)
    mdl = zeros(Float64,NUMMEAS)
    mdlstd = zeros(Float64,NUMMEAS)
    hierarchy = zeros(Float64,NUMMEAS)
    hierarchystd = zeros(Float64,NUMMEAS)

    Measure(time, fitness,fitnessstd,robustness,robustnessstd,
            pathlength, pathlengthstd, indtypes, inittypes,
            develtypes, opttypes, mdl1, mdl1std, mdl2, mdl2std,
            mdl, mdlstd, hierarchy, hierarchystd)
end

function measure(pop::Population, m::Measure, t::Time, n::Int64)
    # update measurements
    pmap(measure,pop.individuals)

    println("nummeas: $NUMMEAS , time: $t , measurement: $n")

    # store measurements in Measure
    m.time[n] = t
    m.indtypes[n] = length(unique(map(x->x.network,pop.individuals)))
    m.inittypes[n] = length(unique(map(x->x.initstate,pop.individuals)))
    m.develtypes[n] = length(unique(map(x->x.develstate,pop.individuals)))
    m.opttypes[n] = length(unique(map(x->x.optstate,pop.individuals)))
    fitvect = map(x->x.fitness, pop.individuals)
    robustvect = map(x->x.robustness, pop.individuals)
    pathvect = map(x->x.pathlength, pop.individuals)
    level1vect = map(x->x.level1, pop.individuals)
    level2vect = map(x->x.level2, pop.individuals)
    modvect = map(x->x.modularity, pop.individuals)
    hiervect = map(x->x.hierarchy, pop.individuals)
    m.fitness[n] = mean(fitvect)
    m.fitnessstd[n] = std(fitvect)
    m.robustness[n] = mean(robustvect)
    m.robustnessstd[n] = std(robustvect)
    m.pathlength[n] = mean(pathvect)
    m.pathlengthstd[n] = std(pathvect)
    m.level1[n] = mean(level1vect)
    m.level1std[n] = std(level1vect)
    m.level2[n] = mean(level2vect)
    m.level2std[n] = std(level2vect)
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
                   level1=m.level1,
                   level1std=m.level1std,
                   level2=m.level2,
                   level2std=m.level2std,
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
