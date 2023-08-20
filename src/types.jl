abstract type Optimizer end

struct OptimizationResult{T<:AbstractArray}
    best_fitness::Float64
    best_position::T
end

best_fitness(o::OptimizationResult) = o.best_fitness
best_position(o::OptimizationResult) = o.best_position