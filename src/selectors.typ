#import "theorem.typ": *

#let last-heading(
  ignore-unnumbered: false,
  max-level: none,
  loc
) = {
  assert(type(ignore-unnumbered) == bool) // TODO: add message
  assert(type(loc) == location)

  let sel = if max-level == none {
    selector(heading)
  } else {
    assert(type(max-level) == int) // TODO: add message
    assert(max-level >= 1) // TODO: add message

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

#let LEMMIFY-DEFAULT-THEOREM-GROUP = "LEMMIFY-DEFAULT-THEOREM-GROUP"
#let LEMMIFY-DEFAULT-PROOF-GROUP = "LEMMIFY-DEFAULT-PROOF-GROUP"

#let select-group(group) = {
  return figure.where(kind: group)
}

#let select-default-group() = {
  return select-group(LEMMIFY-DEFAULT-THEOREM-GROUP)
}

#let select-default-proof-group() = {
  return select-group(LEMMIFY-DEFAULT-PROOF-GROUP)
}

#let select-kind(kind-func) = {
  let params = get-theorem-parameters(kind-func[])
  return figure.where(kind: params.group, supplement: params.kind-name)
}
