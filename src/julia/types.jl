abstract Individuals

type Individual{T} <: Individuals
    network::Matrix{T}
    optstate::Vector{T}
    develstate::Vector{T}
    stable::Bool
    fitness::Float64
end

typealias GaussMat Individual
typealias MarkovMat Individual

type Population{I <: Individuals}
    individuals::Vector{I}
    connectivity::AbstractGraph
    #connectivity::GenericIncidenceList{S}
end
