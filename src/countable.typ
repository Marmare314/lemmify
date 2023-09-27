#import "theorem.typ": is-theorem, get-theorem-parameters

#let is-countable(c) = {
  return (
    type(c) == content
    and c.func() in (heading, page, math.equation, figure)
  )
}

#let assert-countable(c) = {
  assert(
    is-countable(c),
    message: "expected heading, page, math.equation or figure, got " + type(c)
  )
}

#let get-countable-parameters(c) = {
  assert-countable(c)

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

#let display-countable(c) = {
  assert-countable(c)

  let params = get-countable-parameters(c)
  if params.numbering != none {
    numbering(params.numbering, ..params.counter.at(params.location))
  }
}
