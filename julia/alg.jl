abstract type Algorithm
end

abstract type Repeatable <: Algorithm
end

type Sequence <: Algorithm
  nestedAlgs::Array{Repeatable,1}
end

type BaseMove <: Repeatable
  family::String
  amount::Int16
end

type Group <: Repeatable
  nestedAlg::Algorithm
  amount::Int16
end

type Commutator <: Repeatable
  A::Algorithm
  B::Algorithm
  amount::Int16
end

type Conjugate <: Repeatable
  A::Algorithm
  B::Algorithm
  amount::Int16
end

invert(a::Sequence) = Sequence(
  reverse([invert(alg) for alg in a.nestedAlgs])
)
invert(a::Group) = Group(
  invert(a.nestedAlg),
  a.amount
)
invert(a::BaseMove) = BaseMove(
  a.family,
  a.amount
)
invert(a::Commutator) = Commutator(
  invert(a.B),
  invert(a.A),
  a.amount
)

println(invert(Sequence([
  Commutator(
    BaseMove("R", 1),
    BaseMove("U", 1),
    2
  ),
  BaseMove("D", 2),
  BaseMove("F", -1)
])))
