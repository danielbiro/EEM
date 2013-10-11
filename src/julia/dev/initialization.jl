function geninds(G,N,C,INDTYPE)
    if INDTYPE=="gaussian"
        b = 0
        founder = zeros(Float64,G,G)

        conflag=0
        while conflag!=1
            for i=1:G^2
                if rand()<C
                    founder[i] = randn()
                end
            end
            (conflag, finstate, initstate)=testconvergence(founder)
        end
        #[GaussMat(founder,randn(G)) for i=1:N]
        [GaussMat(founder, finstate, finstate, true, 1.) for i=1:N]

    elseif INDTYPE=="markov"
        [MarkovMat(rand(Dirichlet(ones(G)),G), rand(Dirichlet(ones(G))),
                   rand(Dirichlet(ones(G))), true, 1.) for i=1:N]
    end
end

function genpop(inds,N,P)
    Population(inds, erdos_renyi_graph(N,P,is_directed=false))
end
