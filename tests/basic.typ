#import "../src/export-lib.typ": default-theorems

#let (theorem, proof, theorem-rules) = default-theorems(
  max-reset-level: 2
)
#set page(width: 500pt, height: auto, margin: 10pt)
#show: theorem-rules

#set heading(numbering: "1.1")
= Heading

#theorem[Short Body]<a>
#theorem(numbering: none, lorem(200))
#theorem(numbering: none, name: "Name")[$ e^(i pi) = -1 $]
#theorem(name: $sqrt(C)"omplicated Name"$)[Body4]<b>

#proof(link-to: <a>)[Short Body]<p>

@a @b @p @z @a[theorem]

= Heading

@a @b @p @z

#theorem[Body6]

== Heading

#theorem[Body7]
#proof(name: "Named proof")[$ a^2+b^2=c^2 $]

=== Heading

#theorem[Body8]<z>
#proof(lorem(200))
