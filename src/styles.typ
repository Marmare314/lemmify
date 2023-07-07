#import "util.typ": *

// Numbering function which combines
// heading number and theorem number
// with a dot: 1.1 and 2 -> 1.1.2
#let thm-numbering-heading(numb, counter, location) = {
  if numb != none {
    display-heading-counter-at(location)
    "."
    if type(numb) != "string" { panic(numb, type(numb), counter.at(location)) }
    numbering(numb, ..counter.at(location))
  }
}

// Numbering function which only
// returns the theorem number.
#let thm-numbering-linear(numb, counter, location) = {
  if numb != none {
    numbering(numb, ..counter.at(location))
  }
}

// Numbering which returns nothing
#let thm-numbering-hidden(numb, counter, location) = {}


// Simple theorem style:
// thm-type n (name) body
#let thm-style-simple(
  thm-type,
  name,
  number,
  body
) = block(width: 100%, breakable: true)[#{
  strong(thm-type) + " "
  if number != none {
    strong(number) + " "
  }

  if name != none {
    emph[(#name)] + " "
  }
  " " + body
}]

// Reversed theorem style:
// n thm-type (name) body
#let thm-style-reversed(
  thm-type,
  name,
  number,
  body
) = block(width: 100%, breakable: true)[#{
  if number != none {
    strong(number) + " "
  }
  strong(thm-type) + " "

  if name != none {
    emph[(#name)] + " "
  }
  " " + body
}]

// Simple proof style:
// thm-type n (name) body □
#let thm-style-proof(
  thm-type,
  name,
  number,
  body
) = block(width: 100%, breakable: true)[#{
  strong(thm-type) + " "
  if number != none {
    strong(number) + " "
  }

  if name != none {
    emph[(#name)] + " "
  }
  " " + body + h(1fr) + $square$
}]

// Basic theorem reference style:
// @thm -> thm-type n
// @thm[X] -> X n
// where n is the numbering specified
// by the numbering function
#let thm-ref-style-simple(
  thm-type,
  thm-numbering,
  ref
) = link(ref.target, box[#{
  assert(
    ref.element.numbering != none,
    message: "cannot reference theorem without numbering"
  )

  if ref.citation.supplement != none {
    ref.citation.supplement
  } else {
    thm-type
  }
  " " + thm-numbering-style(thm-numbering, ref.element)
}])
