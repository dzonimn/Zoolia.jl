"""
Seyedali Mirjalili, Andrew Lewis,
The Whale Optimization Algorithm,
Advances in Engineering Software,
Volume 95,
2016,
Pages 51-67,
ISSN 0965-9978,
https://doi.org/10.1016/j.advengsoft.2016.01.008.
(https://www.sciencedirect.com/science/article/pii/S0965997816300163)
"""
struct WhaleOptimizer <: Optimizer
    pop_size::Int
    max_iter::Int
    verbose::Bool
end
WhaleOptimizer(; pop_size=100, max_iter=1000, verbose=true) = WhaleOptimizer(pop_size, max_iter, verbose)

mutable struct _Whale
    position::Vector{Float64}
    fitness::Float64
end
fitness(w::_Whale) = w.fitness
function fittest(ws::Vector{_Whale})
    fittest = ws[1]
    for w in @view(ws[2:end])
        if w.fitness < fittest.fitness
            fittest = w
        end
    end
    return fittest
end

function (WO::WhaleOptimizer)(func, search_range, n_dim)
    pop_size = WO.pop_size
    max_iter = WO.max_iter
    minx, maxx = search_range
    
    population = Vector{_Whale}(undef, pop_size)
    for i in eachindex(population)
        init_position = Vector{Float64}(undef, n_dim)
        for d in 1:n_dim
            init_position[d] = (maxx - minx) * rand() + minx
        end
        population[i] = _Whale(init_position, func(init_position))
    end
    
    X¹ = fittest(population)
    
    t = 0
    while t < max_iter
        if WO.verbose && t > 1 && t % 10 == 0
            @info "Iter = $t: Best fitness = $(X¹.fitness)"
        end

        for X in population
            a = 2(1 - t/max_iter) # linearly decreased from 2 to 0
            A = 2a*rand() - a
            C = 2rand()
            l = rand(Uniform(-1, 1))
            p = rand()
            b = 1
            
            if p < 0.5
                if abs(A) < 1
                    D = abs.(C*X¹.position - X.position)
                    X.position .= D
                else
                    Xrand = rand(population)
                    D = abs.(C*Xrand.position - X.position)
                    X.position .= Xrand.position - A*D
                end
            else
                D = abs.(X¹.position - X.position)
                X.position .= D .* exp(b*l) .* cos(2π*l) + X¹.position
            end
        end
        
        # Amend any whales beyond search space
        # and calculate new fitness values
        for i in eachindex(population)
            clamp!(population[i].position, minx, maxx)
            population[i].fitness = func(population[i].position)
        end
        
        X¹ = fittest(population)
        
        t += 1
    end
    
    if WO.verbose
        @info "Best fitness = $(X¹.fitness) at $(X¹.position)"
    end

    return OptimizationResult(
        X¹.fitness,
        X¹.position   
    )
end