#import "types.typ": assert-type, None
#import "theorem.typ": get-theorem-parameters

#let last-heading(
  ignore-unnumbered: false,
  max-level: none,
  loc
) = {
  assert-type(ignore-unnumbered, "ignore-unnumbered", bool)
  assert-type(max-level, "max-level", int, None)
  assert-type(loc, "loc", location)

  let sel = if max-level == none {
    selector(heading)
  } else {
    assert(max-level >= 1, message: "max-level should be at least 1")

    let s = heading.where(level: 1)
    for i in range(2, max-level + 1) {
      s = s.or(heading.where(level: i))
    }
    s
  }
  
  let headings = query(sel.before(loc), loc)
  if ignore-unnumbered {
    let current-level = headings.last().level
    for h in headings.rev() {
      if h.level <= current-level and h.numbering != none {
        return h
      }
    }
  } else {
    if headings.len() > 0 {
      return headings.last()
    }
  }
}

#let select-group(kind-func) = {
  assert-type(kind-func, "kind-func", function)
  let params = get-theorem-parameters(kind-func[])
  return figure.where(kind: params.group)
}

#let select-kind(kind-func) = {
  assert-type(kind-func, "kind-func", function)

  let params = get-theorem-parameters(kind-func[])
  return figure.where(kind: params.group, supplement: [#params.kind-name])
}
