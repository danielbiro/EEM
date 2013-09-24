function geninds(G,N,C,indtype)
    if indtype=="gaussian"
        b = 0
        founder = zeros(Float64,G,G)
        for i=1:G^2
            if rand()<C
                founder[i] = randn()
            end
        end
        #[Individual(founder,randn(G)) for i=1:N]
        [GaussMat(founder,randn(G)) for i=1:N]
    elseif indtype=="markov"
        #[Individual(rand(Dirichlet(ones(G)),G),rand(Dirichlet(ones(G)))) for i=1:N]
        [MarkovMat(rand(Dirichlet(ones(G)),G),rand(Dirichlet(ones(G)))) for i=1:N]
    end
end

function genpop(inds,N,P)
    Population(inds, erdos_renyi_graph(N,P,is_directed=false))
end
