#import "../lib.typ": *

#let (theorem, proof, rules: thm-rules) = default-theorems("thm-group")
#show: thm-rules

#let (note, rules) = new-theorems("thm-group", ("note": "Note"))
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
