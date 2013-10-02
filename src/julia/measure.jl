function genmeasure(ngens::Time)
    fitness = zeros(Float64,ngens)
    robustness = zeros(Float64,ngens)
    pathlength = zeros(Float64,ngens)
    mdl = (Any)[]
    hierarchy = zeros(Int64,ngens)

    Measure(fitness,robustness,pathlength, mdl, hierarchy)
end

function measure(pop::Population, m::Measure, t::Time)
    m.fitness[t]=mean(map(x->x.fitness, pop.individuals))
    m.robustness[t]=mean(map(x->x.robustness, pop.individuals))
    m.pathlength[t]=mean(map(x->x.pathlength, pop.individuals))
end
