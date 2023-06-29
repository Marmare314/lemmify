#import "../src/lib.typ": *

#set heading(numbering: "1.1")

= Basic usage
#[
  #let (
    theorem, lemma, corollary,
    remark, proposition, example,
    proof, rules: thm-rules
  ) = default-theorems("thm-group", lang: "en")

  #show: thm-rules

  #show thm-selector("thm-group", subgroup: "proof"): it => box(
    it,
    stroke: red + 1pt,
    inset: 1em
  )

  #theorem(name: "Some theorem")[
    Theorem content goes here.
  ]<thm>

  #proof[
    Complicated proof.
  ]<proof>

  @proof @thm[Some thoerem]
]

= Useful examples
#[
  // Reset settings
  #let (theorem, rules) = default-theorems("thm-group", max-reset-level: 0)
  #show: rules

  == Sect
  #theorem[Test]

  == Sect
  #theorem[Test]

  // Unnumbered theorems
  #theorem(numbering: none)[Test]

  #let theorem = theorem.with(numbering: none)
  #theorem[Test]

  // New theorem type
  #let (note, rules) = new-theorems("thm-group", ("note": text(red)[Note]))
  #show: rules

  #note[Test]

  // Styling dict
  #let my-styling = (
    thm-styling: thm-style-simple,
    thm-numbering: thm-numbering-linear,
    ref-styling: thm-ref-style-simple
  )

  #let (note, rules) = new-theorems("thm-group", ("note": "Note"), ..my-styling)
  #show: rules

  #note[Test]
]

= Independent numbering

#[
  #let (
    theorem, proof,
    rules: thm-rules-a
  ) = default-theorems("thm-group-a")
  #let (
    definition,
    rules: thm-rules-b
  ) = default-theorems("thm-group-b")

  #show: thm-rules-a
  #show: thm-rules-b

  #theorem[Test]
  #theorem[Test]
  #definition[Test]
]
