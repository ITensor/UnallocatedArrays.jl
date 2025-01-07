struct UnallocatedFill{ElT,N,Axes,Alloc} <: AbstractFill{ElT,N,Axes}
  f::Fill{ElT,N,Axes}
  alloc::Alloc
end

function UnallocatedFill{ElT,N,Axes}(f::Fill, alloc::Type) where {ElT,N,Axes}
  return UnallocatedFill{ElT,N,Axes,Type{alloc}}(f, alloc)
end

function UnallocatedFill{ElT,N}(f::Fill, alloc) where {ElT,N}
  return UnallocatedFill{ElT,N,typeof(axes(f))}(f, alloc)
end

function UnallocatedFill{ElT}(f::Fill, alloc) where {ElT}
  return UnallocatedFill{ElT,ndims(f)}(f, alloc)
end

set_alloctype(f::Fill, alloc::Type) = UnallocatedFill(f, alloc)

Base.parent(F::UnallocatedFill) = F.f

Base.convert(::Type{<:UnallocatedFill}, A::UnallocatedFill) = A

TypeParameterAccessors.position(::Type{<:UnallocatedFill}, ::typeof(eltype)) = Position(1)
TypeParameterAccessors.position(::Type{<:UnallocatedFill}, ::typeof(ndims)) = Position(2)
TypeParameterAccessors.position(::Type{<:UnallocatedFill}, ::typeof(axes)) = Position(3)
function TypeParameterAccessors.position(::Type{<:UnallocatedFill}, ::typeof(alloctype))
  return Position(4)
end

function TypeParameterAccessors.default_type_parameters(::Type{<:UnallocatedFill})
  return (Float64, 1, Tuple{Base.OneTo{Int}}, Vector{Float64})
end

#############################################
# Arithmatic

# mult_fill(a, b, val, ax) = Fill(val, ax)
function FillArrays.mult_fill(a::UnallocatedFill, b, val, ax)
  return UnallocatedFill(Fill(val, ax), alloctype(a))
end
FillArrays.mult_fill(a, b::UnallocatedFill, val, ax) = mult_fill(b, a, val, ax)
function FillArrays.mult_fill(a::UnallocatedFill, b::UnallocatedFill, val, ax)
  @assert alloctype(a) == alloctype(b)
  return UnallocatedFill(Fill(val, ax), alloctype(a))
end

function FillArrays.broadcasted_fill(f, a::UnallocatedFill, val, ax)
  return UnallocatedFill(Fill(val, ax), alloctype(a))
end

function FillArrays.broadcasted_fill(f, a::UnallocatedFill, b, val, ax)
  return UnallocatedFill(Fill(val, ax), alloctype(a))
end
function FillArrays.broadcasted_fill(f, a, b::UnallocatedFill, val, ax)
  return broadcasted_fill(f, b, a, val, ax)
end

function FillArrays.kron_fill(a::UnallocatedFill, b::UnallocatedFill, val, ax)
  @assert alloctype(a) == alloctype(b)
  return UnallocatedFill(Fill(val, ax), alloctype(a))
end

Base.:+(A::UnallocatedFill, B::UnallocatedFill) = A .+ B

function Base.Broadcast.broadcasted(
  ::Base.Broadcast.DefaultArrayStyle, op, r::UnallocatedFill
)
  f = op.(parent(r))
  return broadcasted_fill(op, r, getindex_value(f), axes(f))
end
