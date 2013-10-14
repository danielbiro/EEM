abstract Individuals

type Individual{T} <: Individuals
    network::Matrix{T}
    initstate::Vector{Int64}
    develstate::Vector{Int64}
    optstate::Vector{Int64}
    stable::Bool
    fitness::Float64
    robustness::Float64
    pathlength::Int64
    modularity::Float64
    hierarchy::Int64
end

type Population{I <: Individuals}
    individuals::Vector{I}
    founder::I
    connectivity::AbstractGraph
end

type Measure
    time::Vector{Int64}
    fitness::Vector{Float64}
    fitnessstd::Vector{Float64}
    robustness::Vector{Float64}
    robustnessstd::Vector{Float64}
    pathlength::Vector{Float64}
    pathlengthstd::Vector{Float64}
    indtypes::Vector{Int64}
    inittypes::Vector{Int64}
    develtypes::Vector{Int64}
    opttypes::Vector{Int64}
    minimumdescriptionlength::Vector{Float64}
    minimumdescriptionlengthstd::Vector{Float64}
    hierarchy::Vector{Float64}
    hierarchystd::Vector{Float64}
end

typealias Time Int64
