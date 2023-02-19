Zoolia
==========

Julia implementations of various animal-inspired optimizers.

# Usage

The design of `Zoolia` is inspired by various optimisation packages such as Optim.jl, BlackBoxOptim.jl, and Metaheuristics.jl. 

There is a main method, `optimize` which receives the function to be optimized, the search range, the number of dimensions, and the optimisation method.

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

## Result querying

We can query the result of the optimisation with various accessor functions.
```julia
# WIP: To be expanded on
best_fitness(result)
best_position(result)
```

## Specifying range boundaries

The `optimize` function will be able to accept a `search_range` argument input of various forms, depending on the `num_dimensions` specified.

Generally, if the search range is fixed for all axes, the `search_range` should be a 2-length tuple/array specifying the minimum and maximum values for each dimension.

If the search range is different for each dimension, the `search_range` should be an AbstractMatrix where each column corresponds to the minimum and maximum values of each variable. As a result, it is expected that the number of columns are equal to `num_dimensions`, and the number of rows is 2.

```julia
num_dimensions = 3
search_range = (-5.0, 5.0)
# min and max range for all 3 dimensions will be set to -5 to 5
search_range = [-5 -1 -2; 5 1 2]
# min and max range for x1, x2, x3 will be set to -5 .. 5, -1 .. 1, -2 .. 2 respectively.
search_range = [-5 5; -1 1; -2 2]'
# alternative notation to achieve the same result as above, note the ' at the end of the array
```

## Hyperparameter options

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

# Current implementations

- [x] [Grey Wolf optimization (2014)](https://www.sciencedirect.com/science/article/abs/pii/S0965997813001853)
- [x] [Whale optimization algorithm (2016)](https://www.sciencedirect.com/science/article/abs/pii/S0965997816300163)

# Implementing your own algorithm

If you would like to implement your own animal optimizer, create a struct subtyping `Optimizer` and give it fields that specify the valid hyperparameters available for it.

Then create a function whose name is of your optimizer type that receives arguments of the `func` to optimize, the `search_range`, and the `number_of_dimensions`.
```julia
function (MyOpt::MyOptimizer)(func, search_range, n_dim)
    # Specify algorithm workings
    # Then return an OptimizationResult
    return OptimizationResult(
        best_fitness,
        best_position
    )
end
```

# Contributing

Do keep to some convenience conventions for the user, such as:
- creating default constructors with default hyperparameters 
- sticking to naming conventions like ending the name in `Optimizer` as opposed to `Optimiser` or `Optimization`.