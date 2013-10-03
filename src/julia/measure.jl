function genmeasure()
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
    mdl = (Any)[]
    hierarchy = zeros(Int64,GENS)

    Measure(fitness,fitnessstd,robustness,robustnessstd,
            pathlength, pathlengthstd, indtypes, inittypes,
            develtypes, opttypes, mdl, hierarchy)
end

function measure(pop::Population, m::Measure, t::Time)
    fitvect = map(x->x.fitness, pop.individuals)
    robustvect = map(x->x.robustness, pop.individuals)
    pathvect = map(x->x.pathlength, pop.individuals)
    m.fitness[t] = mean(fitvect)
    m.fitnessstd[t] = std(fitvect)
    m.robustness[t] = mean(robustvect)
    m.robustnessstd[t] = std(robustvect)
    m.pathlength[t] = mean(pathvect)
    m.pathlengthstd[t] = std(pathvect)
    m.indtypes[t] = length(unique(map(x->x.network,pop.individuals)))
    m.inittypes[t] = length(unique(map(x->x.initstate,pop.individuals)))
    m.develtypes[t] = length(unique(map(x->x.develstate,pop.individuals)))
    m.opttypes[t] = length(unique(map(x->x.optstate,pop.individuals)))
end

function save(m::Measure, fname::String)
    f = writedlm(joinpath("data",fname),
                 hcat(m.indtypes,m.inittypes,m.develtypes, m.opttypes,
                      m.fitness, m.fitnessstd, m.robustness, m.robustnessstd,
                      m.pathlength, m.pathlengthstd), ',')
end
