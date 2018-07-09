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

Alg.SliceMove(2, "R")

testEq(
  Traversal.invert(Alg.Sequence([
    Alg.Commutator(
      Alg.SliceMove("R"),
      Alg.SliceMove("U"),
      2
    ),
    Alg.SliceMove("D", 2),
    Alg.SliceMove("F", -1)
  ])),
  Alg.Sequence(Alg.Unit[
    Alg.SliceMove("F", 1),
    Alg.SliceMove("D", -2),
    Alg.Commutator(
      Alg.SliceMove("U", 1),
      Alg.SliceMove("R", 1),
      2)
  ])
)

testEq(Alg.SliceMove("R"), Alg.SliceMove("R"))
testEq(Alg.Sequence([
  Alg.SliceMove("D", 2),
  Alg.SliceMove("F", -1)
]), Alg.Sequence([
  Alg.SliceMove("D", 2),
  Alg.SliceMove("F", -1)
]))

testNE(Alg.Sequence([
  Alg.SliceMove("D", 2),
  Alg.SliceMove("F", -1)
]), Alg.Sequence([
  Alg.SliceMove("D", 2),
  Alg.SliceMove("F")
]))

testNE(Alg.Sequence([
  Alg.SliceMove("D", 2),
  Alg.SliceMove("F", -1)
]), Alg.SliceMove("D", 2))

testEq(Traversal.toString(Alg.Sequence([
  Alg.SliceMove("D", 2),
  Alg.Pause(),
  Alg.Pause(),
  Alg.Pause(),
  Alg.SliceMove("F", -1)
])), "D2 ... F'")

testEq(Traversal.toString(Alg.Conjugate(
  Alg.SliceMove("F"),
  Alg.Commutator(
    Alg.SliceMove("R"),
    Alg.SliceMove("U"),
    2
  )
)), "[F: [R, U]2]")

allAlgTypes = Sequence([
  RotationMove("x"),
  RotationMove("y", 2),
  RotationMove("z", -1),
  SliceMove("R"),
  SliceMove("U", 2),
  SliceMove(2, "D"),
  SliceMove(3, "L", 2),
  WideMove("r"),
  WideMove("u", 2),
  WideMove(2, "d"),
  WideMove(3, "r", 2),
  WideMove(2, 4, "f"),
  WideMove(2, 3, "d", 2),
  Group(Alg.Sequence([SliceMove(2, "L"), SliceMove("U")])),
  Commutator(SliceMove(3, "R", 2), SliceMove("U", 2), -1),
  Pause(),
  Conjugate(Group(SliceMove("L", 2)), SliceMove("D", -1), 2)
])

# Test that these work.
testEq(Traversal.toString(allAlgTypes), "x y2 z' R U2 2D 3L2 r u2 2d 3r2 2-4f 2-3d2 (2L U) [3R2, U2]' . [(L2): D']2")
testEq(Traversal.toString(Traversal.invert(allAlgTypes)), "[(L2): D]2 . [U2, 3R2]' (U' 2L') 2-3d2' 2-4f' 3r2' 2d' u2' r' 3L2' 2D' U2' R' z y2' x'")
testEq(Traversal.toString(Traversal.flatten(allAlgTypes)), "x y2 z' R U2 2D 3L2 r u2 2d 3r2 2-4f 2-3d2 2L U U2 3R2 U2' 3R2' . L2 D' L2' L2 D' L2'")
