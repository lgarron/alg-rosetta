from __future__ import print_function

import json
import pprint

# TODO: Is there a more iiomatic approach to import the library code being test?
import sys
sys.path.append('..')
import alg

try:
  alg.Repeatable(2)
except NotImplementedError, e:
  print("Error raised as expected: %s" % e)

a = alg.Sequence([
  alg.BaseMove("R", 2),
  alg.Pause(),
  alg.Group([
    alg.BaseMove("U", 2),
    alg.BaseMove("F", -1)
  ]),
  alg.CommentShort("// hi there"),
  alg.NewLine(),
  alg.CommentLong("/* lots to say\n    here! */"),
  alg.Commutator(
    alg.Sequence([
      alg.BaseMove("R"),
      alg.BaseMove("U"),
      alg.CommentLong("/* wheee! */"),
      alg.BaseMove("R", -2),
    ]),
    alg.Conjugate(
      alg.BaseMove("R"),
      alg.BaseMove("U")
    )
  )
])

print(str(a) == "R2 . (U2 F') // hi there \n /* lots to say\n    here! */ [R U /* wheee! */ R2', [R, U]]")
# TODO
pprint.pprint(alg.toJSONish(a))
