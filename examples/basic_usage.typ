#import "../src/lib.typ": *

#let my-styling = (
  thm-styling: thm-style-reversed
)

#let (theorem, proof, rules: thm-rules) = default-theorems("thm-group", ..my-styling)
#show: thm-rules

#let (note, rules) = new-theorems("thm-group", ("note": text(red)[Note]), ..my-styling)
#show: rules

#set heading(numbering: "1.1")
= Section
#theorem(name: "Some theorem")[

]
#proof[
  Complicated proof.
]<proof>

== Subsection
#theorem(numbering: none)[
  $e^(i pi) = -1$
]

#theorem(name: "Some related theorem")[
]<related>

= Section
#theorem(name: "Some similar theorem")[

]
#proof[
  @proof is similar enough that this is clear.
  Or use @related[theorem].
]
#note[
  Test
]
