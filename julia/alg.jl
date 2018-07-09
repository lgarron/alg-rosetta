module Alg

export AmountType
const AmountType = Int64

# TODO: Enforce positive values?
export SliceIndex
const SliceIndex = Nullable{Int64}

export Algorithm
abstract type Algorithm
end

export Unit
abstract type Unit <: Algorithm
end

# TODO: Test that all `BaseMove` subclasses have an `amount`.
export Repeatable
abstract type Repeatable <: Unit
end

export Sequence
type Sequence <: Algorithm
  nestedAlgs::Array{Unit,1}
end

# TODO: Test that all `BaseMove` subclasses have a `family`.
export BaseMove
abstract type BaseMove <: Repeatable
end

export RotationMove
type RotationMove <: BaseMove
  family::String
  amount::AmountType
end
RotationMove(family::String) = RotationMove(family, 1)

# TODO: Slice moves like S vs. "face" moves like U?
export SliceMove
type SliceMove <: BaseMove
  slice::SliceIndex
  family::String
  amount::AmountType
end
SliceMove(family::String) = SliceMove(SliceIndex(), family, 1)
SliceMove(slice::Int64, family::String) = SliceMove(SliceIndex(slice), family, 1)
SliceMove(family::String, amount::AmountType) = SliceMove(SliceIndex(), family, amount)

export WideMove
type WideMove <: BaseMove
  startSlice::SliceIndex
  endSlice::SliceIndex
  family::String
  amount::AmountType
end
function WideMove(family::String)
  return WideMove(SliceIndex(), SliceIndex(), family, 1)
end
function WideMove(family::String, amount::AmountType)
  return WideMove(SliceIndex(), SliceIndex(), family, amount)
end
function WideMove(endSlice::Int64, family::String)
  return WideMove(SliceIndex(), SliceIndex(endSlice), family, 1)
end
function WideMove(endSlice::Int64, family::String, amount::AmountType)
  return WideMove(SliceIndex(), SliceIndex(endSlice), family, amount)
end
function WideMove(startSlice::Int64, endSlice::Int64, family::String)
  return WideMove(SliceIndex(startSlice), SliceIndex(endSlice), family, 1)
end

export Group
type Group <: Repeatable
  nestedAlg::Algorithm
  amount::AmountType
end
Group(nestedAlg::Algorithm) = Group(nestedAlg, 1)

export Commutator
type Commutator <: Repeatable
  A::Algorithm
  B::Algorithm
  amount::AmountType
end
Commutator(A::Algorithm, B::Algorithm) = Commutator(A, B, 1)

export Conjugate
type Conjugate <: Repeatable
  A::Algorithm
  B::Algorithm
  amount::AmountType
end
Conjugate(A::Algorithm, B::Algorithm) = Conjugate(A, B, 1)

export Pause
type Pause <: Unit
end

end
