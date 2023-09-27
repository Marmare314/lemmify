#import "types.typ": assert-type, None

#let LEMMIFY-THEOREM-ID() = 0

#let create-theorem(
  name,
  kind-name,
  group,
  link-to,
  numbering,
  subnumbering,
  style,
  body
) = {
  assert-type(name, "name", str, content, None)
  assert-type(kind-name, "kind-name", str)
  assert-type(group, "group", str)
  assert-type(link-to, "link-to", label, selector, function, None)
  assert-type(numbering, "numbering", function, None)
  assert-type(subnumbering, "subnumbering", str, function, None)
  assert-type(style, "style", function)
  assert-type(body, "body", str, content)

  return figure(
    body,
    caption: name,
    kind: group,
    supplement: kind-name,
    numbering: (..) => (
      type: LEMMIFY-THEOREM-ID,
      link-to: link-to,
      numbering: numbering,
      subnumbering: subnumbering,
      style: style
    )
  )
}

#let is-theorem(c) = {
  if (
    type(c) == content
    and c.func() == figure
    and type(c.numbering) == function
    and type((c.numbering)()) == dictionary // TODO: make sure this cannot fail
  ) {
    let res = (c.numbering)()
    return "type" in res and res.type == LEMMIFY-THEOREM-ID
  } else {
    return false
  }
}

#let assert-theorem(c) = {
  assert(is-theorem(c), message: "expected theorem, but got " + type(c))
}

#let get-theorem-parameters(thm) = {
  assert-theorem(thm)
  let (type, ..hidden-params) = (thm.numbering)()
  return (
    body: thm.body,
    group: thm.kind,
    kind-name: thm.supplement.text,
    name: if thm.caption != none { thm.caption.body },
    ..hidden-params
  )
}

#let resolve-link(thm) = {
  let (link-to,) = get-theorem-parameters(thm)
  if type(link-to) == label or type(link-to) == selector {
    let res = query(selector(link-to).before(thm.location(), inclusive: false), thm.location())
    if res.len() > 0 {
      return res.last()
    }
  } else if type(link-to) == function {
    return link-to(thm.location())
  } else {
    return none
  }
}
