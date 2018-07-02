module Alg

export AmountType
const AmountType = Int16

export Algorithm
abstract type Algorithm
end

export Repeatable
abstract type Repeatable <: Algorithm
end

export Sequence
type Sequence <: Algorithm
  nestedAlgs::Array{Repeatable,1}
end

export BaseMove
type BaseMove <: Repeatable
  family::String
  amount::AmountType
end
BaseMove(family::String) = BaseMove(family, 1)

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

end
