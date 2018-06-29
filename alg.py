# TODO: Add pyre annotations?
# TODO: should alg subclasses call super() on parent classes even if parent currently does nothing?

# TODO: enforce types on arguments (e.g. string for BaseMove family)

class Algorithm:
  def __init__(self):
    if self.__class__ is Algorithm:
      raise NotImplementedError("Cannot construct an Algorithm class instance directly. Construct a subclass instead.")

class Sequence(Algorithm):
  def __init__(self, nestedAlgs):
    self.nestedAlgs = nestedAlgs

  def __str__(self):
    return " ".join([str(nested) for nested in self.nestedAlgs])

class Repeatable(Algorithm):
  def __init__(self, amount=1):
    if self.__class__ is Repeatable:
      raise NotImplementedError("Cannot construct a Repeatable class instance directly. Construct a subclass instead.")
    self.amount = amount

  def amountSuffixString(self):
    out = ""
    if abs(self.amount) != 1:
      out += str(abs(self.amount))
    if self.amount < 0:
      out += "'"
    return out

class Group(Repeatable):
  def __init__(self, nestedAlgs, amount=1):
    Repeatable.__init__(self, amount)
    self.nestedAlgs = nestedAlgs

  def __str__(self):
    return "(%s)%s" % (
      " ".join([str(nested) for nested in self.nestedAlgs]),
      self.amountSuffixString()
    )

class BaseMove(Repeatable):
  # TODO: layers
  def __init__(self, family, amount=1):
    Repeatable.__init__(self, amount)
    self.family = family

  def __str__(self):
    return "%s%s" % (
      self.family,
      self.amountSuffixString()
    )

class Commutator(Repeatable):
  def __init__(self, A, B, amount=1):
    Repeatable.__init__(self, amount)
    self.A = A
    self.B = B

  def __str__(self):
    return "[%s, %s]%s" % (
      self.A,
      self.B,
      self.amountSuffixString()
    )

class Conjugate(Repeatable):
  def __init__(self, A, B, amount=1):
    Repeatable.__init__(self, amount)
    self.A = A
    self.B = B

  def __str__(self):
    return "[%s, %s]%s" % (
      self.A,
      self.B,
      self.amountSuffixString()
    )

class Pause(Algorithm):
  def __init__(self):
    pass

  def __str__(self):
    return "."

class NewLine(Algorithm):
  def __init__(self):
    pass

  def __str__(self):
    return "\n"

class CommentShort(Algorithm):
  def __init__(self, comment):
    self.comment = comment

  def __str__(self):
    # TODO: include //?
    return self.comment

class CommentLong(Algorithm):
  def __init__(self, comment):
    self.comment = comment

  def __str__(self):
    # TODO: include /* */?
    return self.comment

# JSON

toJSONishFunctions = {
  Sequence:     (lambda a: {"type": "sequence", "nestedAlgs": [toJSONish(nested) for nested in a.nestedAlgs]}),
  BaseMove:     (lambda a: {"type": "baseMove", "family": a.family, "amount": a.amount}),
  Group:        (lambda a: {"type": "group", "nestedAlgs": [toJSONish(nested) for nested in a.nestedAlgs], "amount": a.amount}),
  BaseMove:     (lambda a: {"type": "baseMove", "family": a.family, "amount": a.amount}),
  Commutator:   (lambda a: {"type": "commutator", "A": toJSONish(a.A), "B": toJSONish(a.B), "amount": a.amount}),
  Conjugate:    (lambda a: {"type": "conjugate", "A": toJSONish(a.A), "B": toJSONish(a.B), "amount": a.amount}),
  Pause:        (lambda a: {"type": "pause"}),
  NewLine:      (lambda a: {"type": "newLine"}),
  CommentShort: (lambda a: {"type": "commentShort", "comment": a.comment}),
  CommentLong:  (lambda a: {"type": "commentLong", "comment": a.comment})
}

def toJSONish(a):
  return toJSONishFunctions[a.__class__](a)
