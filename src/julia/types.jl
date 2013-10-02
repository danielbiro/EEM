abstract Individuals

type Individual{T} <: Individuals
    network::Matrix{T}
    initstate::Vector{T}
    develstate::Vector{T}
    optstate::Vector{T}
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
