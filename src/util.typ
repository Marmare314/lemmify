// Creates a selector for all theorems of
// the specified group. If subgroup is
// specified, only the theorems belonging to it
// will be selected.
#let thm-selector(group, subgroup: none) = {
  if subgroup == none {
    figure.where(kind: group)
  } else {
    figure.where(kind: group, supplement: [#subgroup])
  }
}

#let new-thm-func(
  group,
  subgroup,
  numbering: "1",
  link-to: none
) = {
  return (name: none, numbering: numbering, link-to: link-to, content) => {
    figure(
      content + if link-to != none or numbering == none {
        counter(thm-selector(group)).update(n => n - 1)
      },
      caption: name,
      kind: group,
      supplement: subgroup,
      numbering: (..) => (
        numbering: numbering,
        link-to: link-to
      )
    )
  }
}

// Applies theorem
// numbering functions to theorem.
#let thm-numbering-style(
  thm-numbering,
  fig
) = {
  let (link-to,) = (fig.numbering)()
  if type(link-to) == "label" {
    let res = query(link-to, fig.location())
    if res.len() > 0 {
      thm-numbering-style(
        thm-numbering,
        res.first()
      )
    }
  } else if type(link-to) == "function" {
    let res = link-to(fig.location())
    if res != none {
      thm-numbering-style(thm-numbering, res)
    }
  } else {
    let (numbering,) = (fig.numbering)()
    thm-numbering(
      numbering,
      fig.counter,
      fig.location()
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
    thm-numbering-style(thm-numbering, fig),
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
#let display-heading-counter-at(loc) = {
  let locations = query(selector(heading).before(loc), loc)
  if locations.len() == 0 {
    [0]
  } else {
    let numb = query(selector(heading).before(loc), loc).last().numbering
    numbering(numb, ..counter(heading).at(loc))
  }
}

// Create a concatenated function from
// a list of functions (with one argument)
// starting with the last function:
// concat-fold((f1, f2, fn))(x) = f1(f2(f3(x)))
#let concat-fold(functions) = {
  functions.fold((c => c), (f, g) => (c => f(g(c))))
}
