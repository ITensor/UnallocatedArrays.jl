using TypeParameterAccessors: TypeParameterAccessors
using UnspecifiedTypes: UnspecifiedArray, UnspecifiedNumber, UnspecifiedZero
using FillArrays: AbstractFill, Fill, Zeros

## TODO is this type piracy? 
function TypeParameterAccessors.default_type_parameters(::Type{<:AbstractFill})
  return (
    UnspecifiedNumber{UnspecifiedZero},
    0,
    Tuple{},
  )
end

unspecify_parameters(::Type{<:Fill}) = Fill
unspecify_parameters(::Type{<:Zeros}) = Zeros