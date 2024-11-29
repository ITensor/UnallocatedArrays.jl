# # UnallocatedArrays.jl
# 
# [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ITensor.github.io/UnallocatedArrays.jl/stable/)
# [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ITensor.github.io/UnallocatedArrays.jl/dev/)
# [![Build Status](https://github.com/ITensor/UnallocatedArrays.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ITensor/UnallocatedArrays.jl/actions/workflows/CI.yml?query=branch%3Amain)
# [![Coverage](https://codecov.io/gh/ITensor/UnallocatedArrays.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/ITensor/UnallocatedArrays.jl)
# [![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
# [![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

# A module defining a set of unallocated immutable lazy arrays which will be used to quickly construct
# tensors and allocating as little data as possible.

# ## Installation instructions

# This package resides in the `ITensor/JuliaRegistry` local registry.
# In order to install, simply add that registry through your package manager.
# This step is only required once.
#=
```julia
julia> using Pkg: Pkg

julia> Pkg.Registry.add(url="https://github.com/ITensor/JuliaRegistry")
```
=#
# Then, the package can be added as usual through the package manager:

#=
```julia
julia> Pkg.add("UnallocatedArrays")
```
=#

# ## Examples

using UnallocatedArrays: UnallocatedArrays