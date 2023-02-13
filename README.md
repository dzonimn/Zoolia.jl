Zoolia
==========

Julia implementations of various animal-inspired optimizers.

# Usage

The design of `Zoolia` is inspired by various optimisation packages such as Optim.jl and BlackBoxOptim.jl, such that there is a main method, `optimize` which receives the function to be optimized, the search range, the number of dimensions, and the optimisation method.
```julia
using Zoolia

rosenbrock2d(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
search_range = (-5.0, 5.0) # min and max range for x
num_dimensions = 2 # this is a function that receives two x values

result = optimize(
    rosenbrock2d, 
    search_range, 
    num_dimensions, 
    GreyWolfOptimizer()
)
```
One can also add hyperparameters for the method chosen in the optimizer method constructor.
```julia
result = optimize(
    rosenbrock2d, 
    search_range, 
    num_dimensions, 
    GreyWolfOptimizer(;
        pop_size=100, max_iter=1000
    )
)
```

We can query the result of the optimisation with various accessor functions.
```julia
# WIP: To be expanded on
best_fitness(result)
```

# Contributing

If you would like to implement your own animal optimizer, create a struct subtyping `Optimizer` and give it fields that specify the valid hyperparameters available for it.

Then create a function whose name is of your optimizer type that receives arguments of the `func` to optimize, the `search_range`, and the `number_of_dimensions`.
```julia
function (MyOpt::MyOptimizer)(func, search_range, n_dim)
    # Specify algorithm workings
    # Return a OptimizationResult
end
```

Do keep to some convenience conventions for the user, such as 
- creating default constructors with default hyperparameters 
- sticking to naming conventions like ending the name in `Optimizer` as opposed to `Optimiser` or `Optimization`.