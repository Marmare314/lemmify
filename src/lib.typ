#import "theorem.typ": *
#import "styles.typ": *
#import "translations.typ": get-translation
#import "selectors.typ": *
#import "reset-counter.typ": *
#import "types.typ": assert-type, None

#let theorem-kind(
  kind-name,
  group: LEMMIFY-DEFAULT-THEOREM-GROUP,
  link-to: none,
  numbering: numbering-concat,
  subnumbering: "1",
  style: style-simple
) = {
  assert-type(kind-name, "kind-name", str)
  assert-type(group, "group", str)
  assert-type(link-to, "link-to", label, selector, function, None)
  assert-type(numbering, "numbering", function)
  assert-type(subnumbering, "subnumbering", function, str, None)
  assert-type(style, "style", function)

  let KIND-ID() = 0
  return (
    name: none,
    link-to: link-to,
    numbering: numbering,
    body
  ) => create-theorem(
    name,
    kind-name,
    KIND-ID,
    group,
    link-to,
    numbering,
    subnumbering,
    style,
    body
  )
}

#let theorem-rules(content) = {
  show figure: it => if is-theorem(it) {
    let params = get-theorem-parameters(it)
    if params.numbering == none {
      it.counter.update(n => n - 1)
    }
    (params.style)(it)
  } else {
    it
  }
  show ref: it => {
    if it.element == none or not is-theorem(it.element) {
      return it
    }

    let params = get-theorem-parameters(it.element)
    link(it.target, {
      params.kind-name
      " "
      (params.numbering)(it.element, true)
    })
  }
  content
}

#let default-theorems(
  group: LEMMIFY-DEFAULT-THEOREM-GROUP,
  proof-group: LEMMIFY-DEFAULT-PROOF-GROUP,
  lang: "en",
  style: style-simple,
  proof-style: style-simple.with(qed: true),
  numbering: numbering-concat,
  proof-numbering: numbering-proof,
  link-to: last-heading,
  proof-link-to: none,
  subnumbering: "1",
  max-reset-level: none
) = {
  assert-type(group, "group", str)
  assert-type(proof-group, "proof-group", str)
  assert-type(lang, "lang", str)
  assert-type(style, "style", function)
  assert-type(proof-style, "proof-style", function)
  assert-type(numbering, "numbering", function)
  assert-type(proof-numbering, "proof-numbering", function)
  assert-type(link-to, "link-to", label, selector, function, None)
  assert-type(proof-link-to, "proof-link-to", label, selector, function, None)
  assert-type(subnumbering, "subnumbering", function, str, None)
  assert-type(max-reset-level, "max-reset-level", int, None)

  let (proof: proof-translation, ..other-kinds) = get-translation(lang)

  if link-to == last-heading {
    link-to = last-heading.with(max-level: max-reset-level)
  }

  let theorems = (:)
  for (kind, translation) in other-kinds {
    theorems.insert(kind, theorem-kind(
      translation,
      group: group,
      numbering: numbering,
      subnumbering: subnumbering,
      style: style,
      link-to: link-to
    ))
  }

  theorems.insert("proof", theorem-kind(
    proof-translation,
    group: proof-group,
    numbering: proof-numbering,
    subnumbering: subnumbering,
    style: proof-style,
    link-to: proof-link-to
  ))

  let rules = if max-reset-level != none {
    concat-fold((
      theorem-rules,
      reset-counter-heading.with(group, max-reset-level),
      reset-counter-heading.with(proof-group, max-reset-level)
    ))
  } else {
    theorem-rules
  }
  return (
    ..theorems,
    theorem-rules: rules
  )
}
