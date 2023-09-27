// TODO: clean this file up

#let None = type(none)

#let check-arg-sink(
  allow-positional: true,
  allow-named: true,
  expect-argument: false,
  args
) = {
  if not allow-positional {
    assert(args.pos().len() == 0, message: "expected no positional arguments")
  }
  if not allow-named {
    assert(args.named().len() == 0, message: "expected no named arguments")
  }
  if expect-argument {
    assert(args.named().len() + args.pos().len() > 0, message: "expected at least one argument")
  }
}

#let check-type(arg, ..types) = {
  check-arg-sink(types, allow-named: false, expect-argument: true)
  return type(arg) in types.pos()
}

#let types-to-string(..types) = {
  check-arg-sink(types, allow-named: false, expect-argument: true)
  return types.pos().map(str).join(", ", last: " or ")
}

#let assert-type-error-msg(arg, arg-name, ..types) = {
  return "expected " + arg-name + " to be one of " + types-to-string(..types) + ", but got " + type(arg)
}

#let assert-type(arg, arg-name, ..types) = {
  assert(
    check-type(arg, ..types),
    message: assert-type-error-msg(arg, arg-name, ..types)
  )
}
