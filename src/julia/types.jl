abstract Individuals

type Individual{T} <: Individuals
    network::Matrix{T}
    state::Vector{T}
end

typealias GaussMat Individual
typealias MarkovMat Individual

type Population{I <: Individuals}
    individuals::Vector{I}
    connectivity::AbstractGraph
    #connectivity::GenericIncidenceList{S}
end
