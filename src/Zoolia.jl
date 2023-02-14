module Zoolia

using Random
using Distributions

export optimize
export GreyWolfOptimizer, WhaleOptimizer

include("types.jl")
include("algorithms/GreyWolf.jl")
include("algorithms/Whale.jl")

function optimize(func, searchrange, ndimensions, method::Optimizer; seed = 42)
    Random.seed!(seed)
    
    method(func, searchrange, ndimensions)
end

end
