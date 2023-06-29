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
