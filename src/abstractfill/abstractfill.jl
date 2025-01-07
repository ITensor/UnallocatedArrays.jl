## Here are functions specifically defined for UnallocatedArrays
## not implemented by FillArrays
## TODO this might need a more generic name maybe like compute unit
function alloctype(A::AbstractFill)
  return A.alloc
end

## TODO this fails if the parameter is a type
function alloctype(Atype::Type{<:AbstractFill})
  return type_parameter(Atype, alloctype)
end

axestype(T::Type{<:AbstractArray}) = type_parameter(axestype)
set_axestype(T::Type{<:AbstractFill}, ax::Type) = s(T, axestype, ax)
