abstract Individuals

type Individual{T} <: Individuals
    network::Matrix{T}
    optstate::Vector{T}
    develstate::Vector{T}
    stable::Bool
    fitness::Float64
end

type Population{I <: Individuals}
    individuals::Vector{I}
    connectivity::AbstractGraph
end
