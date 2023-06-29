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
    fig.supplement,
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

#let thm-reset-on-heading = none
#{
  // Create a concatenated function from
  // a list of functions (with one argument)
  // starting with the last function:
  // concat-fold((f1, f2, fn))(x) = f1(f2(f3(x)))
  let concat-fold(functions) = {
    functions.fold((c => c), (f, g) => (c => f(g(c))))
  }

  // Reset counter of specified theorem group
  // on headings of the specified level
  let figure-counter-reset-at(
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

  // Reset counter of specified theorem group
  // on headings with at most the specified level.
  let reset-on-heading(
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

  thm-reset-on-heading = reset-on-heading
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
// subgroup n (name) body
#let thm-style-simple(
  subgroup,
  name,
  number,
  body
) = block[#{
  strong(subgroup) + " "
  if number != none {
    strong(number) + " "
  }

  if name != none {
    emph[(#name)] + " "
  }
  " " + body
}]

// Simple proof style:
// subgroup n (name) body □
#let thm-style-proof(
  subgroup,
  name,
  number,
  body
) = block[#{
  strong(subgroup) + " "
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
    ref.element.supplement
  }
  " " + thm-numbering(ref.element)
}])

// TODO: comment
#let thm-default-style(
  group: "theorems",
  lang: "en",
  thm-styling: thm-style-simple,
  proof-styling: thm-style-simple,
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

  let rules(content) = {
    show thm-selector(group): thm-style.with(
      thm-styling,
      thm-numbering
    )
    show thm-selector(
      group,
      subgroup: translations.at(lang).at("proof")
    ): thm-style.with(
      thm-styling,
      thm-numbering-proof
    )
    show: thm-ref-style.with(
      group,
      ref-styling.with(thm-numbering)
    )
    show: thm-reset-on-heading.with(group, max-reset-level)

    content
  }

  let selector(subgroup: none) = {
    if subgroup != none {
      thm-selector(group, subgroup: translations.at(lang).at(subgroup))
    } else {
      thm-selector(group)
    }
  }

  return (
    theorem: new-thm-func(group, translations.at(lang).at("theorem")),
    lemma: new-thm-func(group, translations.at(lang).at("lemma")),
    corollary: new-thm-func(group, translations.at(lang).at("corollary")),
    remark: new-thm-func(group, translations.at(lang).at("remark")),
    proposition: new-thm-func(group, translations.at(lang).at("proposition")),
    example: new-thm-func(group, translations.at(lang).at("example")),
    proof: new-proof-func(group, translations.at(lang).at("proof")),
    rules: rules,
    selector: selector
  )
}
