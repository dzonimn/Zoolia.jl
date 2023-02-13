module Zoolia

using Random

export optimize
export GreyWolfOptimizer

include("types.jl")
include("algorithms/GreyWolf.jl")

function optimize(func, searchrange, ndimensions, method::Optimizer; seed = 42)
    Random.seed!(seed)
    
    method(func, searchrange, ndimensions)
end

end
