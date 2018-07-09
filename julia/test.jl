include("traversal.jl")

using Alg
using Traversal

function test(expectEq, a, b)
  if (a == b) == expectEq
    println("✅")
  else
    println("❌")
  end
end

testEq(a, b) = test(true, a, b)
testNE(a, b) = test(false, a, b)

testEq(
  Traversal.invert(Alg.Sequence([
    Alg.Commutator(
      Alg.BaseMove("R"),
      Alg.BaseMove("U"),
      2
    ),
    Alg.BaseMove("D", 2),
    Alg.BaseMove("F", -1)
  ])),
  Alg.Sequence(Alg.Unit[
    Alg.BaseMove("F", 1),
    Alg.BaseMove("D", -2),
    Alg.Commutator(
      Alg.BaseMove("U", 1),
      Alg.BaseMove("R", 1),
      2)
  ])
)

testEq(Alg.BaseMove("R"), Alg.BaseMove("R"))
testEq(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]), Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]))

testNE(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]), Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F")
]))

testNE(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.BaseMove("F", -1)
]), Alg.BaseMove("D", 2))

testEq(Traversal.toString(Alg.Sequence([
  Alg.BaseMove("D", 2),
  Alg.Pause(),
  Alg.Pause(),
  Alg.Pause(),
  Alg.BaseMove("F", -1)
])), "D2 ... F'")

testEq(Traversal.toString(Alg.Conjugate(
  Alg.BaseMove("F"),
  Alg.Commutator(
    Alg.BaseMove("R"),
    Alg.BaseMove("U"),
    2
  )
)), "[F: [R, U]2]")

allAlgTypes = Sequence([
  BaseMove("R", -1),
  Group(Alg.Sequence([BaseMove("L"), BaseMove("U")])),
  Commutator(BaseMove("R", 2), BaseMove("U", 2), -1),
  Pause(),
  Conjugate(BaseMove("L", 2), BaseMove("D", -1), 2)
])

# Test that these work.
testEq(Traversal.toString(allAlgTypes), "R' (L U) [R2, U2]' . [L2: D']2")
testEq(Traversal.toString(Traversal.flatten(allAlgTypes)), "R' L U U2 R2 U2' R2' . L2 D' L2' L2 D' L2'")
