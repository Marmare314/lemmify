#let None = type(none)

#let check-type-args(types) = {
  assert(types.named().len() == 0, message: "expected no named arguments")
  assert(types.pos().len() > 0, message: "expected at least one argument")
  for t in types.pos() {
    assert(type(t) == type, message: "expected only type arguments, but got " + str(type(t)))
  }
}

#let check-type(arg, ..types) = {
  check-type-args(types)
  return type(arg) in types.pos()
}

#let types-to-string(..types) = {
  check-type-args(types)
  return types.pos().map(str).join(", ", last: " or ")
}

#let assert-type-error-msg(arg, arg-name, ..types) = {
  check-type-args(types)
  let s = if types.pos().len() == 1 {
    " to be of type "
  } else {
    " to be one of "
  }
  return "expected " + arg-name + s + types-to-string(..types) + ", but got " + str(type(arg))
}

#let assert-type(arg, arg-name, ..types) = {
  check-type-args(types)
  assert(
    check-type(arg, ..types),
    message: assert-type-error-msg(arg, arg-name, ..types)
  )
}
