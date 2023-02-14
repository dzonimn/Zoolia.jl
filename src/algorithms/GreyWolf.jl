"""
Implementation of original Grey Wolf Optimizer by Seyedali Mirjalili, Seyed Mohammad Mirjalili, Andrew Lewis.

Seyedali Mirjalili, Seyed Mohammad Mirjalili, Andrew Lewis,
Grey Wolf Optimizer,
Advances in Engineering Software,
Volume 69,
2014,
Pages 46-61,
ISSN 0965-9978,
https://doi.org/10.1016/j.advengsoft.2013.12.007.
(https://www.sciencedirect.com/science/article/pii/S0965997813001853)
"""
struct GreyWolfOptimizer <: Optimizer
    pop_size::Int
    max_iter::Int
    verbose::Bool
end
GreyWolfOptimizer(; pop_size=100, max_iter=1000, verbose=true) = GreyWolfOptimizer(pop_size, max_iter, verbose)

mutable struct _Wolf
    position::Vector{Float64}
    fitness::Float64
end
fitness(w::_Wolf) = w.fitness

function (GWO::GreyWolfOptimizer)(func, search_range, n_dim)
    pop_size = GWO.pop_size
    max_iter = GWO.max_iter
    minx, maxx = search_range

    # Initialise the wolves
    population = Vector{_Wolf}(undef, pop_size)
    for i in eachindex(population)
        init_position = Vector{Float64}(undef, n_dim)
        for d in 1:n_dim
            init_position[d] = (maxx - minx) * rand() + minx
        end
        population[i] = _Wolf(init_position, func(init_position))
    end
    
    # Sort the wolves in order and extract the top 3 wolves
    sort!(population; by=fitness)
    Wₐ, Wᵦ, Wᵧ = population[1:3]

    Iter = 0
    X1, X2, X3, Xnew = zeros(n_dim), zeros(n_dim), zeros(n_dim), zeros(n_dim)
    while Iter < max_iter
        if GWO.verbose && Iter > 1 && Iter % 10 == 0
            @info "Iter = $Iter: Best fitness = $(Wₐ.fitness)"
        end
        
        a = 2(1 - Iter/max_iter)
        
        for i in 1:pop_size
            A1, A2, A3 = a*(2rand() - 1), a*(2rand() - 1), a*(2rand() - 1) 
            C1, C2, C3 = 2rand(), 2rand(), 2rand() 

            for j in 1:n_dim
                X1[j] = Wₐ.position[j] - A1 * abs(C1 * Wₐ.position[j] - population[i].position[j])
                X2[j] = Wᵦ.position[j] - A2 * abs(C2 * Wᵦ.position[j] - population[i].position[j])
                X3[j] = Wᵧ.position[j] - A3 * abs(C3 * Wᵧ.position[j] - population[i].position[j])
                Xnew[j] += X1[j] + X2[j] + X3[j]
            end
            Xnew ./= 3.0
            
            fnew = func(Xnew)
            
            if fnew < population[i].fitness
                population[i].position .= Xnew
                population[i].fitness = fnew
            end
        end
        
        sort!(population; by=fitness)
        
        Wₐ, Wᵦ, Wᵧ = population[1:3]
        
        X1 .= 0.0
        X2 .= 0.0
        X3 .= 0.0
        Xnew .= 0.0

        Iter += 1
    end
    
    if GWO.verbose
        @info "Best fitness = $(Wₐ.fitness) at $(Wₐ.position)"
    end
    
    return OptimizationResult(
        Wₐ.fitness,
        Wₐ.position   
    )
end