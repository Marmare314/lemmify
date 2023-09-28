#import "../src/export-lib.typ": *

#let exported-functions = (
  default-theorems: default-theorems,
  theorem-kind: theorem-kind,
  theorem-rules: theorem-rules,
  select-kind: select-kind,
  select-group: select-group,
  get-theorem-parameters: get-theorem-parameters,
  reset-counter: reset-counter
)

#let eval-raws(..raws, scope: (:), export-setup: "") = {
  assert(raws.named().len() == 0)
  let code = raws.pos().map(x => x.text + "\n").sum()
  block(
    fill: gray.lighten(50%),
    inset: 1em,
    radius: 5pt,
    eval(code, mode: "markup", scope: scope)
  )
  [#metadata((code: "#import \"../../src/export-lib.typ\": " + scope.keys().join(", ") + "\n" + export-setup + "\n" + code)) <export>]
}

#let code-with-import(..imports, code: raw("")) = {
  assert(imports.named().len() == 0)

  let import-statement = "#import \"@preview/lemmify:" + LEMMIFY-VERSION + "\": " + imports.pos().join(", ") + "\n" + if code.text != "" { "\n" }
  code = raw(import-statement + code.text, lang: "typst")

  let scope = (:)
  for i in imports.pos() {
    scope.insert(i, exported-functions.at(i))
  }

  return (scope, code)
}

#show enum: it => [#it <export>]

= Lemmify <export>

Lemmify is a library for typesetting mathematical <export>
theorems in typst. It aims to be easy to use while <export>
trying to be as flexible and idiomatic as possible. <export>
This means that the interface might change with updates to typst <export>
(for example if user-defined element functions are introduced). <export>
But no functionality should be lost. <export>

== Basic usage <export>

1. Import the Lemmify library

#let (basic-usage-scope, step1) = code-with-import("default-theorems", "select-kind")

#step1 <export>

2. Generate some common theorem kinds with pre-defined styling

#let step2 =```typst
#let (
  theorem, lemma, corollary,
  remark, proposition, example,
  proof, theorem-rules
) = default-theorems(lang: "en")
```
#step2 <export>

3. Apply the generated styling

#let step3 = ```typst
#show: theorem-rules
```
#step3 <export>

4. Customize the styling using show rules. For example, to add a red box around proofs

#let step4 = ```typst
#show select-kind(proof): box.with(stroke: red + 1pt, inset: 1em)
```
#step4 <export>

5. Create theorems, lemmas, and proofs

#let step5 = ```typst
#theorem(name: "Some theorem")[
  Theorem content goes here.
]<thm>

#proof(link-to: <thm>)[
  Complicated proof.
]<proof>

@proof and @thm[theorem]
```
#step5 <export>

The result should now look something like this <export>

#eval-raws(
  step2, step3, step4, step5,
  scope: basic-usage-scope,
  export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
)

== Examples <export>

This example shows how corollaries can be numbered after the last theorem. <export>

#let example1 = ```
#let theorem = theorem-kind("Theorem")
#let corollary = theorem-kind(
  "Corollary",
  group: "CorollaryGroup",
  link-to: select-kind(theorem)
)
#show: theorem-rules
#show select-kind(theorem): it => {it; reset-counter(corollary)}

#theorem(lorem(5))
#corollary(lorem(5))
#corollary(lorem(5))
#theorem(lorem(5))
#corollary(lorem(5))
```

#let (example1-scope, example1-with-import) = code-with-import("theorem-rules", "theorem-kind", "select-kind", "reset-counter", code: example1)
#example1-with-import <export>

#eval-raws(
  example1,
  scope: example1-scope,
  export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
)

== Custom style example <export>

#let example2 = ```typst
#let my-style-func(thm, is-proof: false) = {
  let params = get-theorem-parameters(thm)
  let number = (params.numbering)(thm, false)
  let content = grid(
    columns: (1fr, 3fr),
    column-gutter: 1em,
    stack(spacing: .5em, strong(params.kind-name), number, emph(params.name)),
    params.body
  )

  if is-proof {
    block(inset: 2em, content)
  } else {
    block(inset: 1em, block(fill: gray, inset: 1em, radius: 5pt, content))
  }
}

#let my-style = (
  style: my-style-func,
  proof-style: my-style-func.with(is-proof: true)
)

#let (
  theorem, proof, theorem-rules
) = default-theorems(lang: "en", ..my-style)
#show: theorem-rules

#lorem(20)
#theorem(name: "Some theorem")[
  #lorem(40)
]
#lorem(20)
#proof[
  #lorem(30)
]
```

#let (example2-scope, example2-with-import) = code-with-import("default-theorems", "get-theorem-parameters", code: example2)
#example2-with-import <export>

#eval-raws(
  example2,
  scope: example2-scope,
  export-setup: "#set page(width: 500pt, height: auto, margin: 10pt)"
)

#include "source_docs.typ"

// If you are encountering any bugs, have questions or <export>
// are missing features, feel free to open an issue on <export>
// #link("https://github.com/Marmare314/lemmify")[GitHub] <export>
// . <export>
