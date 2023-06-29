#import "../lib.typ": *

#let (theorem, proof, rules: thm-rules) = thm-default-style()
#show: thm-rules

#let anmerkung = new-thm-func("theorems", "Anmerkung")

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
#anmerkung[
  Test
]
