#import "types.typ": assert-type, None
#import "theorem.typ": get-theorem-parameters

/// Selector-function which selects the last heading.
///
/// - ignore-unnumbered (bool): Use the last heading which is numbered.
/// - max-level (int, none): Do not select headings above this level.
/// - loc (location):
/// -> heading, none
#let last-heading(
  ignore-unnumbered: false,
  max-level: none,
  loc
) = {
  assert-type(ignore-unnumbered, "ignore-unnumbered", bool)
  assert-type(max-level, "max-level", int, None)
  if max-level != none { assert(max-level >= 0, message: "max-level should be at least 0") }
  assert-type(loc, "loc", location)

  let sel = if max-level == none {
    selector(heading)
  } else if max-level > 0 {
    let s = heading.where(level: 1)
    for i in range(2, max-level + 1) {
      s = s.or(heading.where(level: i))
    }
    s
  } else {
    heading.where(level: 0) // pretty much impossible
  }
  
  let headings = query(sel.before(loc), loc)
  if headings.len() == 0 {
    return none
  }
  if ignore-unnumbered {
    let current-level = headings.last().level
    for h in headings.rev() {
      if h.level <= current-level and h.numbering != none {
        return h
      }
    }
  } else {
    return headings.last()
  }
}

/// Generate selector that selects all
/// theorems of the same group as the
/// argument.
///
/// - thm-func (theorem-function):
/// -> selector
#let select-group(thm-func) = {
  assert-type(thm-func, "thm-func", function)
  let params = get-theorem-parameters(thm-func[])
  return figure.where(kind: params.group)
}

/// Generate selector that selects only
/// theorems that were create from
/// the #ref-type("theorem-function").
///
/// - thm-func (theorem-function):
/// -> selector
#let select-kind(thm-func) = {
  assert-type(thm-func, "thm-func", function)

  let params = get-theorem-parameters(thm-func[])
  return figure.where(kind: params.group, supplement: [#params.kind-name])
}
