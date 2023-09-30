#import "../src/export-lib.typ": theorem-kind, default-theorems, select-kind, select-group

#let (theorem, lemma, proof, theorem-rules) = default-theorems(
  max-reset-level: 2
)
#let example = theorem-kind(group: "MyGroup", "Example")
#set page(width: 500pt, height: auto, margin: 10pt)
#show: theorem-rules

#show select-group(example): box.with(stroke: purple + 1pt, inset: 1em)
#show select-kind(lemma): box.with(stroke: blue + 1pt, inset: 1em)
#show select-group(theorem): box.with(stroke: green + 1pt, inset: 1em)
#show select-group(proof): box.with(stroke: red + 1pt, inset: 1em)

#theorem(lorem(20))
#lemma(lorem(20))
#proof(lorem(20))
#example(lorem(20))
