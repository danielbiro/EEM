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
end

type Population{I <: Individuals}
    individuals::Vector{I}
    founder::I
    connectivity::AbstractGraph
end

type Measure
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
    minimumdescriptionlength::Vector{Any}
    hierarchy::Vector{Int64}
end

typealias Time Int64
