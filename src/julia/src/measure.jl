function genmeasure()
    time = zeros(Int64,GENS)
    fitness = zeros(Float64,GENS)
    fitnessstd = zeros(Float64,GENS)
    robustness = zeros(Float64,GENS)
    robustnessstd = zeros(Float64,GENS)
    pathlength = zeros(Float64,GENS)
    pathlengthstd = zeros(Float64,GENS)
    indtypes = zeros(Int64,GENS)
    inittypes = zeros(Int64,GENS)
    develtypes = zeros(Int64,GENS)
    opttypes = zeros(Int64,GENS)
    mdl = zeros(Float64,GENS)
    mdlstd = zeros(Float64,GENS)
    hierarchy = zeros(Float64,GENS)
    hierarchystd = zeros(Float64,GENS)

    Measure(time, fitness,fitnessstd,robustness,robustnessstd,
            pathlength, pathlengthstd, indtypes, inittypes,
            develtypes, opttypes, mdl, mdlstd, hierarchy, hierarchystd)
end

function measure(pop::Population, m::Measure, t::Time)
    m.time[t] = t
    m.indtypes[t] = length(unique(map(x->x.network,pop.individuals)))
    m.inittypes[t] = length(unique(map(x->x.initstate,pop.individuals)))
    m.develtypes[t] = length(unique(map(x->x.develstate,pop.individuals)))
    m.opttypes[t] = length(unique(map(x->x.optstate,pop.individuals)))
    fitvect = map(x->x.fitness, pop.individuals)
    robustvect = map(x->x.robustness, pop.individuals)
    pathvect = map(x->x.pathlength, pop.individuals)
    modvect = map(x->x.modularity, pop.individuals)
    hiervect = map(x->x.hierarchy, pop.individuals)
    m.fitness[t] = mean(fitvect)
    m.fitnessstd[t] = std(fitvect)
    m.robustness[t] = mean(robustvect)
    m.robustnessstd[t] = std(robustvect)
    m.pathlength[t] = mean(pathvect)
    m.pathlengthstd[t] = std(pathvect)
    m.minimumdescriptionlength[t] = mean(modvect)
    m.minimumdescriptionlengthstd[t] = std(modvect)
    m.hierarchy[t] = mean(hiervect)
    m.hierarchystd[t] = std(hiervect)
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
