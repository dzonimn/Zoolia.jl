abstract type Optimizer end

struct OptimizationResult{T<:AbstractArray}
    best_fitness::Float64
    best_position::T
end