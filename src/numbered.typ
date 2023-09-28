#import "theorem.typ": is-theorem, get-theorem-parameters

#let is-countable(c) = {
  return (
    type(c) == content
    and c.func() in (heading, page, math.equation, figure)
  )
}

#let assert-countable(arg, arg-name) = {
  assert(
    is-countable(arg),
    message: "expected " + arg-name + "to be one of heading, page, math.equation or figure, but got " + str(type(arg))
  )
}

#let get-countable-parameters(c) = {
  assert-countable(c, "c")

  let counter = if c.func() == heading {
    counter(heading)
  } else if c.func() == page {
    counter(page)
  } else if c.func() == math.equation {
    counter(math.equation)
  } else if c.func() == figure {
    c.counter
  }

  let numbering = if is-theorem(c) {
    get-theorem-parameters(c).subnumbering
  } else {
    if c.has("numbering") {
      c.numbering
    } else {
      none
    }
  }

  return (
    numbering: numbering,
    counter: counter,
    location: c.location()
  )
}

/// Check if argument is numbered.
/// That means it is one of
/// `heading`, `page`, `math.equation` or `figure`
/// and its numbering is not `none`.
///
/// - n (any):
/// -> bool
#let is-numbered(n) = {
  if is-countable(n) {
    let params = get-countable-parameters(n)
    return params.numbering != none
  }
  return false
}

#let assert-numbered(arg, arg-name) = {
  assert(
    is-numbered(arg),
    message: "expected " + arg-name + " to be numbered, but got " + str(type(arg))
  )
}

/// Display the numbering of the argument
/// at its location.
///
/// - n (numbered):
/// -> content
#let display-numbered(n) = {
  assert-numbered(n, "n")

  let params = get-countable-parameters(n)
  numbering(params.numbering, ..params.counter.at(params.location))
}
