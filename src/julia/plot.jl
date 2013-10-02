using Gadfly
using DataFrames

function makedataframe(m::Measure)
    df = DataFrame(fitness=m.fitness,
                   robustness=m.robustness,
                   pathlength=m.pathlength)
end

function writesimdata(m::Measure, fname::String)
    df = makedataframe(m)
    writetable(fname,df)
end

function readsimdata(fname::String)
    df = readtable(fname)
end

function plotmeas(m::Measure)
    df = makedataframe(m)

end
