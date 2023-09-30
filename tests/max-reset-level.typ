#import "../src/export-lib.typ": default-theorems

#let (theorem, theorem-rules) = default-theorems(max-reset-level: 0, group: "a")
#show: theorem-rules
#let (lemma, theorem-rules) = default-theorems(max-reset-level: 1, group: "b")
#show: theorem-rules
#let (example, theorem-rules) = default-theorems(max-reset-level: 2, group: "c")
#show: theorem-rules
#let (corollary, theorem-rules) = default-theorems(max-reset-level: none, group: "d")
#show: theorem-rules
#set page(width: 300pt, height: auto, margin: 10pt)

#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))

= 1
#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))
== 2
#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))
=== 3
#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))

= 1
#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))
== 2
#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))
=== 3
#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))
==================== 20
#theorem(lorem(5))
#lemma(lorem(5))
#example(lorem(5))
#corollary(lorem(5))
