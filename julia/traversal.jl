include("alg.jl")

module Traversal
using Alg

function BaseMoveWithNewAmount(a::Alg.RotationMove, amount::Alg.AmountType)::Alg.RotationMove
  return Alg.RotationMove(
    a.family,
    amount
  )
end

function BaseMoveWithNewAmount(a::Alg.SliceMove, amount::Alg.AmountType)::Alg.SliceMove
  return Alg.SliceMove(
    a.slice,
    a.family,
    amount
  )
end

function BaseMoveWithNewAmount(a::Alg.WideMove, amount::Alg.AmountType)::Alg.WideMove
  return Alg.WideMove(
    a.startSlice,
    a.endSlice,
    a.family,
    amount
  )
end

# Inverse

invert(a::Alg.Sequence)::Alg.Sequence = Alg.Sequence(
  reverse([invert(alg) for alg in a.nestedAlgs])
)

invert(a::Alg.Group)::Alg.Group = Alg.Group(
  invert(a.nestedAlg),
  a.amount
)

function invert(a::Alg.BaseMove)::Alg.BaseMove
  return BaseMoveWithNewAmount(a, -a.amount)
end

invert(a::Alg.Commutator)::Alg.Commutator = Alg.Commutator(
  a.B,
  a.A,
  a.amount
)

invert(a::Alg.Conjugate)::Alg.Conjugate = Alg.Conjugate(
  a.A,
  invert(a.B),
  a.amount
)

invert(a::Alg.Pause)::Alg.Pause = Alg.Pause()

# concat

# TODO: Turn into an iterator
listWrap(a::Alg.Unit)::Array{<:Unit,1} = [a]
listWrap(a::Alg.Sequence)::Array{<:Unit,1} = a.nestedAlgs

function listJoin(l::Array{<:Alg.Algorithm,1})::Array{Unit,1}
  return mapreduce(listWrap, vcat, [], l)
end

concat(a1::Alg.Unit, a2::Alg.Unit) = Alg.Sequence(vcat(
  listWrap(a1),
  listWrap(a2)
))

# flatten

function flatten(a::Alg.Sequence)::Alg.Sequence
  return Alg.Sequence(listJoin([flatten(n) for n in a.nestedAlgs]))
end

function repeat(a::Alg.Algorithm, n::Alg.AmountType)::Alg.Algorithm
  # TODO: Catch n == 0?
  if n < 0
    return repeat(invert(a), -n)
  end
  if n == 1
    return a
  end
  return Alg.Sequence(listJoin([a for i in 1:n]))
end

function flatten(a::Alg.Group)::Alg.Algorithm
  return repeat(flatten(a.nestedAlg), a.amount)
end

flatten(a::Alg.BaseMove)::Alg.BaseMove = a

flatten(a::Alg.Commutator)::Alg.Sequence = repeat(
  Alg.Sequence(listJoin([
    flatten(a.A),
    flatten(a.B),
    flatten(invert(a.A)),
    flatten(invert(a.B))
  ])),
  a.amount
)

flatten(a::Alg.Conjugate)::Alg.Sequence = repeat(
  Alg.Sequence(listJoin([
    flatten(a.A),
    flatten(a.B),
    flatten(invert(a.A))
  ])),
  a.amount
)

flatten(a::Alg.Pause)::Alg.Pause = a

# Equality

# For an alg of a given alg.Algorithm subtype, we first define it *not* to be
# equal to any other algorithm, and then we specialize equality if the subtypes
# match.

Base.:(==)(a1::Alg.Sequence, a2::Alg.Algorithm) = false
function Base.:(==)(a1::Alg.Sequence, a2::Alg.Sequence)
  s1 = size(a1.nestedAlgs, 1)
  if s1 != size(a2.nestedAlgs, 1)
    return false
  end
  for i = 1:size(a1.nestedAlgs, 1)
    if a1.nestedAlgs[i] != a2.nestedAlgs[i]
      return false
    end
  end
  return true
end

Base.:(==)(a1::Alg.Group, a2::Alg.Algorithm) = false
Base.:(==)(a1::Alg.Group, a2::Alg.Group) = (
  return a1.nestedAlg == a2.nestedAlg
)

Base.:(==)(a1::Alg.RotationMove, a2::Alg.Algorithm)::Bool = false
Base.:(==)(a1::Alg.RotationMove, a2::Alg.RotationMove)::Bool = (
  a1.family == a2.family &&
  a1.amount == a2.amount
)

function NullableEqual(a::Nullable, b::Nullable)
  if isnull(a)
    return isnull(b)
  end
  # From here on, `a` has a value.
  if isnull(b)
    return false
  end
  # From here on, `b` has a value.
  return get(a) == get(b)
end

# TODO: Decide if we really want 1R != R
Base.:(==)(a1::Alg.SliceMove, a2::Alg.Algorithm)::Bool = false
Base.:(==)(a1::Alg.SliceMove, a2::Alg.SliceMove)::Bool = (
  a1.family == a2.family &&
  NullableEqual(a1.slice, a1.slice) &&
  a1.amount == a2.amount
)

# TODO: Decide if we really want 3r != r and 1-3r != 3r
Base.:(==)(a1::Alg.WideMove, a2::Alg.Algorithm)::Bool = false
Base.:(==)(a1::Alg.WideMove, a2::Alg.WideMove)::Bool = (
  a1.family == a2.family &&
  NullableEqual(a1.startSlice, a1.startSlice) &&
  NullableEqual(a1.endSlice, a1.endSlice) &&
  a1.amount == a2.amount
)

Base.:(==)(a1::Alg.Commutator, a2::Alg.Algorithm)::Bool = false
Base.:(==)(a1::Alg.Commutator, a2::Alg.Commutator)::Bool = (
  return a1.A == a2.A && a1.B == a2.B
)

Base.:(==)(a1::Alg.Conjugate, a2::Alg.Algorithm)::Bool = false
Base.:(==)(a1::Alg.Conjugate, a2::Alg.Conjugate)::Bool = (
  return a1.A == a2.A && a1.B == a2.B
)

Base.:(==)(a1::Alg.Pause, a2::Alg.Algorithm)::Bool = false
Base.:(==)(a1::Alg.Pause, a2::Alg.Pause)::Bool = true

# toString

spacer(::Alg.Algorithm, ::Alg.Algorithm)::String = " "
spacer(::Alg.Pause, ::Alg.Pause)::String = ""

function toString(a::Alg.Sequence)::String
  out = IOBuffer()
  local last = nothing
  for (index, value) in enumerate(a.nestedAlgs)
    if index > 1
      write(out, spacer(last, value))
    end
    write(out, toString(value))
    last = value
  end
  return String(take!(out))
end

function toString(a::Alg.Group)::String
  return "(" * toString(a.nestedAlg) * ")" * repetitionSuffix(a.amount)
end

function repetitionSuffix(amount::Alg.AmountType)::String
  output = ""
  absAmount = abs(amount)
  if absAmount != 1
    output *= string(absAmount)
  end
  if absAmount !== amount
    output *= "'"
  end
  return output
end

# TODO: Throw error for BaseMove by default?
function toString(a::Alg.RotationMove)::String
  return a.family * repetitionSuffix(a.amount)
end

function toString(a::Alg.SliceMove)::String
  out = a.family * repetitionSuffix(a.amount)
  if isnull(a.slice)
    return out
  end
  return string(get(a.slice)) * out
end

function toString(a::Alg.WideMove)::String
  out = a.family * repetitionSuffix(a.amount)
  if isnull(a.endSlice)
    if !isnull(a.startSlice)
      throw(NullException())
    end
    return out
  end
  out = string(get(a.endSlice)) * out
  if !isnull(a.startSlice)
    out = string(get(a.startSlice)) * "-" * out
  end
  return out
end

function toString(a::Alg.Commutator)::String
  return "[" * toString(a.A) * ", " * toString(a.B) * "]" * repetitionSuffix(a.amount)
end

function toString(a::Alg.Conjugate)::String
  return "[" * toString(a.A) * ": " * toString(a.B) * "]" * repetitionSuffix(a.amount)
end

function toString(a::Alg.Pause)::String
  return "."
end

# clone
# invert
# flatten
# countBaseMoves
# structureEquals
# coalesceMoves
# concat
# toString

end
