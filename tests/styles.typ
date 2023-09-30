#import "../src/export-lib.typ": theorem-kind, theorem-rules, style-simple, style-reversed, numbering-concat, numbering-proof, qed-box

#let a = theorem-kind("a")
#let b = theorem-kind("b", style: style-simple.with(qed: qed-box))
#let c = theorem-kind("c", style: style-reversed)
#let d = theorem-kind("d", style: style-reversed.with(qed: qed-box))
#let e = theorem-kind("e", numbering: numbering-concat.with(seperator: ""))
#let f = theorem-kind("f", numbering: numbering-concat.with(seperator: text(red, "-")))
#set page(width: 200pt, height: auto, margin: 10pt)
#show: theorem-rules

#a(lorem(5))
#b(lorem(5))
#c(lorem(5))
#d(lorem(5))
#e(lorem(5))
#f(lorem(5))

#set heading(numbering: "1.1")
= Heading

#a(lorem(5))
#e(lorem(5))
#f(lorem(5))

#set heading(numbering: "1.")
= Heading

#a(lorem(5))
#e(lorem(5))
#f(lorem(5))
