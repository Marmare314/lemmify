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

#let export-code(code, setup, imports) = {
  imports = "#import \"../../src/export-lib.typ\": " + imports.join(", ")
  code = imports + "\n" + setup + "\n" + code

  [#metadata((code: code)) <generate-image>]
}

#let eval-raws(..raws, scope: (:), export-setup: "") = {
  assert(raws.named().len() == 0)
  let code = raws.pos().map(x => x.text + "\n").sum()
  [
    #block(
      fill: gray.lighten(50%),
      inset: 1em,
      radius: 5pt,
      eval(code, mode: "markup", scope: scope)
    ) <ignore-content>
  ]
  export-code(code, export-setup, scope.keys())
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

#let export-only(text) = [
  assert(type(text) == str)
  #metadata(text) <export>
]

#let combine-spaces(seq) = {
  let last-space = none
  let result = ()
  for child in seq.children {
    if child == [ ] and last-space != parbreak() {
      last-space = child
    } else if child.func() == parbreak {
      last-space = child
    } else if child.has("children") and child.children.len() == 0 {
      // ignore
    } else {
      if last-space != none {
        result.push(last-space)
        last-space = none
      }
      result.push(child)
    }
  }
  result
}

#let content-to-markdown(con) = {
  assert(type(con) == content)
  if con.has("children") {
    combine-spaces(con).map(content-to-markdown).join("")
  } else if con == [ ] {
    "\n"
  } else if con.func() == heading {
    "#" * con.level + " " + content-to-markdown(con.body)
  } else if con.func() == parbreak {
    "\n\n"
  } else if con.func() == text {
    con.text
  } else if con.func() == link {
    "[" + content-to-markdown(con.body) + "](" + con.dest + ")"
  } else if con.func() == enum.item {
    str(con.number) + ". " + content-to-markdown(con.body)
  } else if con.func() == raw {
    "```" + con.lang + "\n" + con.text + "\n" + "```"
  } else if con.func() == block {
    if con.has("label") and con.label == <ignore-content> {
      // ignore
    } else {
      panic("block without ignore-content label")
    }
  } else if con.func() == metadata {
    if con.has("label") and con.label == <generate-image> {
      "<GENERATE-IMAGE>" + con.value.code + "</GENERATE-IMAGE>"
    } else {
      panic("metadata without generate-image label")
    }
  } else {
    panic("conversion to text not implemented for " + repr(con.func()))
  }
}

#let export(con) = {
  con
  export-only(content-to-markdown(con))
}

#show raw: block.with(stroke: 1pt + gray, fill: gray.lighten(70%), inset: 1em, width: 100%, radius: 5pt)

#export[
  = lemmify

  Lemmify is a library for typesetting mathematical
  theorems in typst. It aims to be easy to use while
  trying to be as flexible and idiomatic as possible.
  This means that the interface might change with updates to typst
  (for example if user-defined element functions are introduced).
  But no functionality should be lost.

  If you are encountering any bugs, have questions or are missing
  features, feel free to open an issue on
  #link("https://github.com/Marmare314/lemmify")[GitHub].

  == Basic usage

  1. Import lemmify:

  #let (basic-usage-scope, step1) = code-with-import("default-theorems", "select-kind")

  #step1

  2. Generate some common theorem kinds with pre-defined style:

  #let step2 =```typst
  #let (
    theorem, lemma, corollary,
    remark, proposition, example,
    proof, theorem-rules
  ) = default-theorems(lang: "en")
  ```
  #step2

  3. Apply the generated style:

  #let step3 = ```typst
  #show: theorem-rules
  ```
  #step3

  4. Customize the theorems using show rules. For example, to add a block around proofs:

  #let step4 = ```typst
  #show select-kind(proof): block.with(
    breakable: true,
    width: 100%,
    fill: gray,
    inset: 1em,
    radius: 5pt
  )
  ```
  #step4

  5. Create theorems, lemmas, and proofs:

  #let step5 = ```typst
  #theorem(name: "Some theorem")[
    Theorem content goes here.
  ]<thm>

  #theorem(numbering: none)[
    Another theorem.
  ]

  #proof(link-to: <thm>)[
    Complicated proof.
  ]<proof>

  @proof and @thm[theorem]
  ```
  #step5

  The result should now look something like this:

  #eval-raws(
    step2, step3, step4, step5,
    scope: basic-usage-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  == Examples

  This example shows how corollaries can be numbered after the last theorem.

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
  #example1-with-import

  #eval-raws(
    example1,
    scope: example1-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  == Custom style example

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
  #example2-with-import

  #eval-raws(
    example2,
    scope: example2-scope,
    export-setup: "#set page(width: 500pt, height: auto, margin: 10pt)"
  )
]

#export-only("\nFor a full documentation of all functions check [readme.pdf](docs/readme.pdf)\n")

#include "source_docs.typ"
