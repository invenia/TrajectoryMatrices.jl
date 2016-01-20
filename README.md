# TrajectoryMatrices.jl

[![Build Status](https://travis-ci.org/invenia/TrajectoryMatrices.jl.svg?branch=master)](https://travis-ci.org/invenia/TrajectoryMatrices.jl)
[![codecov.io](https://codecov.io/github/invenia/TrajectoryMatrices.jl/coverage.svg?branch=master)](https://codecov.io/github/invenia/TrajectoryMatrices.jl?branch=master)

Creates a [trajectory matrix](https://en.wikipedia.org/wiki/Singular_spectrum_analysis#SSA_as_a_model-free_tool) representation of a time series sequence given the original sequence data (as an array) and a window size. More importantly, 
it does this without duplicating data by wrapping the source array and handling index conversions from the trajectory to the source.

While a TrajectoryMatrix can be built from array with any numbers of dimensions,under most use cases it'll either be a 1d array or a 2d array (ie: each time step as a set of features).

## Intallation:
TrajectoryMatrices.jl isn't registered, so you'll need to use `Pkg.clone` to install it.
```
julia> Pkg.clone("https://github.com/invenia/TrajectoryMatrices.jl")
```

## Usage:
```
julia> using TrajectoryMatrices

julia> traj_1dim = TrajectoryMatrix(1:21; window=3)
19x3 TrajectoryMatrix{Int64,2}:
  1   2   3
  2   3   4
  3   4   5
  4   5   6
  5   6   7
  6   7   8
  7   8   9
  8   9  10
  9  10  11
 10  11  12
 11  12  13
 12  13  14
 13  14  15
 14  15  16
 15  16  17
 16  17  18
 17  18  19
 18  19  20
 19  20  21

julia> traj_1dim'
3x19 TrajectoryMatrix{Int64,2}:
 1  2  3  4  5  6  7   8   9  10  11  12  13  14  15  16  17  18  19
 2  3  4  5  6  7  8   9  10  11  12  13  14  15  16  17  18  19  20
 3  4  5  6  7  8  9  10  11  12  13  14  15  16  17  18  19  20  21

julia> data = [1 1 1 1; 2 2 2 2; 3 3 3 3; 4 4 4 4; 5 5 5 5]
5x4 Array{Int64,2}:
 1  1  1  1
 2  2  2  2
 3  3  3  3
 4  4  4  4
 5  5  5  5

julia> traj_2dim = TrajectoryMatrix(data; window=2)
4x8 TrajectoryMatrix{Int64,2}:
 1  1  1  1  2  2  2  2
 2  2  2  2  3  3  3  3
 3  3  3  3  4  4  4  4
 4  4  4  4  5  5  5  5

julia> traj_2dim'
8x4 TrajectoryMatrix{Int64,2}:
 1  2  3  4
 1  2  3  4
 1  2  3  4
 1  2  3  4
 2  3  4  5
 2  3  4  5
 2  3  4  5
 2  3  4  5
 ```
