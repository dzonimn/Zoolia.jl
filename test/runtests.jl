using Zoolia
using Test

@testset "Zoolia.jl" begin
    easyfunc(x) = -5*x[1]^2 - x[1] + 8*x[1]^4

    @testset "GreyWolf" begin
        res = optimize(easyfunc, (-100, 100), 1, GreyWolfOptimizer())
        pos = round(Zoolia.best_position(res)[1]; digits = 4)
        @test pos == 0.6036
    end

    @testset "Whale" begin
        res = optimize(easyfunc, (-100, 100), 1, WhaleOptimizer())
        pos = round(Zoolia.best_position(res)[1]; digits = 4)
        @test pos == 0.6035
    end
end
