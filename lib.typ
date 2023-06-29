// TODO: comment
#let new-thm-func(
  group,
  subgroup,
  numbering: "1"
) = {
  return (name: none, numbering: numbering, content) => {
    figure(
      content,
      caption: name,
      kind: group,
      supplement: subgroup,
      numbering: numbering
    )
  }
}

// TODO: is there any better way to avoid this nameclash?
// TODO: comment
#let new-proof-func(
  group,
  subgroup,
  numb: "1"
) = {
  return new-thm-func(
    group,
    subgroup,
    numbering: n => numbering(numb, n - 1)
  )
}

// Creates a selector for all theorems of
// the specified group. If subgroup is
// specified, only the theorems belonging to
// will be selected.
#let thm-selector(group, subgroup: none) = {
  if subgroup == none {
    figure.where(kind: group)
  } else {
    figure.where(kind: group, supplement: [#subgroup])
  }
}

// Applies theorem styling and theorem
// numbering functions to theorem.
#let thm-style(
  thm-styling,
  thm-numbering,
  fig
) = {
  thm-styling(
    fig.caption,
    thm-numbering(fig),
    fig.body
  )
}

// Applies reference styling to the
// theorems belonging to the specified
// group/subgroups.
#let thm-ref-style(
  group,
  subgroups: none,
  ref-styling,
  content
) = {
  show ref: it => {
    if it.element == none {
      return it
    }
    if it.element.func() != figure {
      return it
    }
    if it.element.kind != group {
      return it
    }

    let refd-subgroup = it.element.supplement.text
    if subgroups == none {
      ref-styling(it)
    } else if subgroups == refd-subgroup {
      ref-styling(it)
    } else if type(subgroups) == "array" and subgroups.contains(refd-subgroup) {
      ref-styling(it)
    } else {
      it
    }
  }
  content
}

// Reset theorem group counter to zero.
#let thm-reset-counter(group) = {
  counter(thm-selector(group)).update(c => 0)
}

// Create a concatenated function from
// a list of functions (with one argument)
// starting with the last function:
// concat-fold((f1, f2, fn))(x) = f1(f2(f3(x)))
#let concat-fold(functions) = {
  functions.fold((c => c), (f, g) => (c => f(g(c))))
}

// TODO: rename
// Reset counter of specified theorem group
// on headings of the specified level
#let figure-counter-reset-at(
  group,
  level,
  content
) = {
  show heading.where(level: level): it => {
    thm-reset-counter(group)
    it
  }
  content
}

// TODO: rename
// Reset counter of specified theorem group
// on headings with at most the specified level.
#let thm-reset-on-heading(
  group,
  max-level,
  content
) = {
  let rules = range(1, max-level + 1).map(
    k => figure-counter-reset-at.with(group, k)
  )
  show: concat-fold(rules)
  content
}

// Utility function to display a counter
// at the given position.
#let display-counter-at(loc, counter) = {
  locate(current-loc => {
    let current-state = counter.at(current-loc)
    let other-state = counter.at(loc)

    counter.update((..) => other-state)
    counter.display()
    counter.update((..) => current-state)
  })
}

//
// Some default styles.
//

// Numbering function which combines
// heading number and theorem number
// with a dot: 1.1 and 2 -> 1.1.2
#let thm-numbering-heading(fig) = {
  if fig.numbering != none {
    display-counter-at(fig.location(), counter(heading))
    "."
    numbering(fig.numbering, ..fig.counter.at(fig.location()))
  }
}

// Numbering function which only
// returns the theorem number.
#let thm-numbering-linear(fig) = {
  if fig.numbering != none {
    numbering(fig.numbering, ..fig.counter.at(fig.location()))
  }
}

// Numbering function which takes
// the theorem number of the last
// theorem, but does not return it.
#let thm-numbering-proof(fig) = {
  if fig.numbering != none {
    fig.counter.update(n => n - 1)
  }
}

// Simple theorem style:
// thm-type n (name) body
#let thm-style-simple(
  thm-type,
  name,
  number,
  body
) = block[#{
  strong(thm-type) + " "
  if number != none {
    strong(number) + " "
  }

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
) = block[#{
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
// @thm -> Theorem n
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
  " " + thm-numbering(ref.element)
}])

// Creates new theorem functions and
// a styling rule from a mapping (subgroup: args)
// and the style parameters.
// The args of each subgroup will be passed
// into thm-styling and ref-styling.
#let new-theorems(
  group,
  subgroup-map,
  thm-styling: thm-style-simple,
  thm-numbering: thm-numbering-heading,
  ref-styling: thm-ref-style-simple,
  ref-numbering: none
) = {
  let helper-rule(subgroup, content) = {
    show thm-selector(
      group,
      subgroup: subgroup
    ): thm-style.with(
      thm-styling.with(subgroup-map.at(subgroup)),
      thm-numbering
    )

    let numbering = if ref-numbering != none {
      ref-numbering
    } else {
      thm-numbering
    }

    show: thm-ref-style.with(
      group,
      subgroups: subgroup,
      ref-styling.with(subgroup-map.at(subgroup), numbering)
    )
    content
  }

  let rules(content) = {
    show: concat-fold(subgroup-map.keys().map(sg => helper-rule.with(sg)))
    content
  }

  let result = (:)
  for (sg, _) in subgroup-map {
    result.insert(sg, new-thm-func(group, sg))
  }
  result.insert("rules", rules)

  return result
}

// Create a default set of theorems based
// on the language and given styling.
#let default-theorems(
  group,
  lang: "en",
  thm-styling: thm-style-simple,
  proof-styling: thm-style-proof,
  thm-numbering: thm-numbering-heading,
  ref-styling: thm-ref-style-simple,
  max-reset-level: 2
) = {
  let translations = (
    "en": (
      "theorem": "Theorem",
      "lemma": "Lemma",
      "corollary": "Corollary",
      "remark": "Remark",
      "proposition": "Proposition",
      "example": "Example",
      "proof": "Proof"
    ),
    "de": (
      "theorem": "Satz",
      "lemma": "Lemma",
      "corollary": "Korollar",
      "remark": "Bemerkung",
      "proposition": "Proposition",
      "example": "Beispiel",
      "proof": "Beweis"
    )
  )
  let (proof, ..subgroup-map) = translations.at(lang)

  let (rules: rules-theorems, ..theorems) = new-theorems(
    group,
    subgroup-map,
    thm-styling: thm-styling,
    thm-numbering: thm-numbering
  )

  let (rules: rules-proof, proof) = new-theorems(
    group,
    (proof: translations.at(lang).at("proof")),
    thm-styling: proof-styling,
    thm-numbering: thm-numbering-proof,
    ref-numbering: thm-numbering
  )

  return (
    ..theorems,
    proof: proof,
    rules: concat-fold((
      thm-reset-on-heading.with(group, max-reset-level),
      rules-theorems,
      rules-proof
    ))
  )
}
