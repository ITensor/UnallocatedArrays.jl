module UnallocatedArrays

using TypeParameterAccessors:
  TypeParameterAccessors,
  Position,
  set_eltype,
  set_ndims,
  set_type_parameters,
  type_parameters
using FillArrays:
  AbstractFill,
  FillArrays,
  AbstractZeros,
  Fill,
  Zeros,
  broadcasted_fill,
  broadcasted_zeros,
  getindex_value,
  kron_fill,
  kron_zeros,
  mult_zeros,
  mult_fill
using UnspecifiedTypes: UnspecifiedArray, UnspecifiedNumber, UnspecifiedZero
using Adapt: adapt

include("abstractfill/abstractfill.jl")

include("unallocatedfill.jl")
include("unallocatedzeros.jl")
include("broadcast.jl")
include("abstractunallocatedarray.jl")
include("set_types.jl")

export UnallocatedFill, UnallocatedZeros, alloctype, set_alloctype, allocate

end
