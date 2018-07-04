include("traversal.jl")

using Alg
using Traversal

println(Traversal.invert(Alg.Sequence([
  Alg.Commutator(
    Alg.BaseMove("R"),
    Alg.BaseMove("U"),
    2
  ),
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
])))

println(Alg.BaseMove("R") == Alg.BaseMove("R"))
println(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]) == Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]))

println(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]) == Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F")
]))

println(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]) == Alg.BaseMove("D", 2))

println(Traversal.toString(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.Pause(),
  Alg.Pause(),
  Alg.Pause(),
  Alg.BaseMove("F", -1)
])))

println(Traversal.toString(Alg.Conjugate(
  Alg.BaseMove("F"),
  Alg.Commutator(
    Alg.BaseMove("R"),
    Alg.BaseMove("U"),
    2
  )
)))
