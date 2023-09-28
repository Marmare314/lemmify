#import "../src/export-lib.typ": theorem-kind, theorem-rules, last-heading

#let theorem = theorem-kind("Theorem")
#set page(width: 200pt, height: auto, margin: 10pt)
#show: theorem-rules

#set heading(numbering: "1.1")
= Heading 1
=== Heading 3
==== Heading 4
#set heading(numbering: none)
===== Heading 5
#theorem(lorem(5))
#theorem(link-to: last-heading.with(ignore-unnumbered: true), lorem(5))
#theorem(link-to: last-heading.with(max-level: 2), lorem(5))
#theorem(link-to: last-heading.with(max-level: 3), lorem(5))
=== Heading 3
#theorem(link-to: last-heading.with(ignore-unnumbered: true), lorem(5))
