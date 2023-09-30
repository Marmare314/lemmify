#import "../src/export-lib.typ": *
#import "source-docs.typ": link-color, ref-type

#let exported-functions = (
  default-theorems: default-theorems,
  theorem-kind: theorem-kind,
  theorem-rules: theorem-rules,
  select-kind: select-kind,
  select-group: select-group,
  get-theorem-parameters: get-theorem-parameters,
  reset-counter: reset-counter,
  style-simple: style-simple
)

#let export-code(name, code, setup, imports) = {
  imports = "#import \"../../src/export-lib.typ\": " + imports.join(", ")
  code = imports + "\n" + setup + "\n" + code

  [#metadata((code: code, name: name)) <generate-image>]
}

#let eval-raws(..raws, name, scope: (:), export-setup: "") = {
  assert(raws.named().len() == 0)
  let code = raws.pos().map(x => x.text + "\n").sum()
  [
    #block(
      stroke: gray + 1pt,
      inset: 1em,
      radius: 5pt,
      breakable: false,
      {
        set heading(bookmarked: false)
        eval(code, mode: "markup", scope: scope)
        let (theorem, proof) = default-theorems()
        reset-counter(theorem)
        reset-counter(proof)
        place(heading[]) // hack to reset heading-level to 0
      }
    ) <ignore-content>
  ]
  export-code(name, code, export-setup, scope.keys())
}

#let code-with-import(..imports, code: raw("")) = {
  assert(imports.named().len() == 0)

  let import-statement = "#import \"@preview/lemmify:" + LEMMIFY-VERSION + "\": " + imports.pos().join(", ") + "\n" + if code.text != "" { "\n" }
  code = raw(import-statement + code.text, lang: "typst", block: true)

  let scope = (:)
  for i in imports.pos() {
    scope.insert(i, exported-functions.at(i))
  }

  return (scope, code)
}

#let export-only(text) = [
  #assert(type(text) == str)
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
  if con.has("children") { // check for sequence
    combine-spaces(con).map(content-to-markdown).join("")
  } else if con.has("child") { // check for styled
    content-to-markdown(con.child)
  } else if con == [ ] {
    "\n"
  } else if con.func() == heading {
    "#" * con.level + " " + content-to-markdown(con.body)
  } else if con.func() == parbreak {
    "\n\n"
  } else if con.func() == text {
    con.text
  } else if con.func() == link {
    if type(con.dest) == label {
      content-to-markdown(con.body)
    } else {
      "[" + content-to-markdown(con.body) + "](" + con.dest + ")"
    }
  } else if con.func() == enum.item {
    str(con.number) + ". " + content-to-markdown(con.body)
  } else if con.func() == raw {
    if con.has("block") and con.block {
      assert(con.lang == "typst", message: "only typst code blocks expected")
      "```" + con.lang + "\n" + con.text + "\n" + "```" 
    } else {
      "`" + con.text + "`"
    }
  } else if con.func() == block {
    if con.has("label") and con.label == <ignore-content> {
      // ignore
    } else {
      panic("block without ignore-content label")
    }
  } else if con.func() == metadata {
    if con.has("label") and con.label == <generate-image> {
      "<GENERATE-IMAGE:" + con.value.name + ">" + con.value.code + "</GENERATE-IMAGE>"
    } else {
      panic("metadata without generate-image label")
    }
  } else if con.func() == smartquote {
    if con.double {
      "\""
    } else {
      "'"
    }
  } else {
    panic("conversion to text not implemented for " + repr(con.func()))
  }
}

#let export(con) = {
  con
  export-only(content-to-markdown(con))
}

#let ref-function(name) = {
  name = name + "()"
  link(label(name), text(link-color, raw(name)))
}

#export[
  #show raw.where(block: true): block.with(stroke: 1pt + gray, fill: gray.lighten(70%), inset: 1em, width: 100%, radius: 5pt)

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
    "basic-usage",
    scope: basic-usage-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  == Examples

  By default theorems are reset on every heading. This can be changed with the
  `max-reset-level` parameter of #ref-function("default-theorems"). This also
  changes which heading levels will be used in the numbering. To not reset them
  at all `max-reset-level` can be set to 0.

  #let reset-example = ```
  #let (
    theorem, theorem-rules
  ) = default-theorems(max-reset-level: 2)
  #show: theorem-rules
  #set heading(numbering: "1.1")

  = Heading
  #theorem(lorem(5))
  == Heading
  #theorem(lorem(5))
  === Heading
  #theorem(lorem(5))
  ```
  #let (reset-scope, reset-with-import) = code-with-import("default-theorems", code: reset-example)
  #reset-with-import

  #eval-raws(
    reset-example,
    "reset-example",
    scope: reset-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  Each theorem belongs to a group and every group shares one counter. The theorems created
  by #ref-function("default-theorems") all belong to the same group, except for proofs.
  You can create seperate groups by passing a group parameter to #ref-function("default-theorems").
  The next example shows how to create seperately numbered examples.

  #let group-example = ```
  #let (theorem, theorem-rules) = default-theorems()
  #show: theorem-rules
  #let (
    example, theorem-rules
  ) = default-theorems(group: "example-group")
  #show: theorem-rules

  #theorem(lorem(5))
  #example(lorem(5))
  #example(lorem(5))
  #theorem(lorem(5))
  ```
  #let (group-scope, group-with-import) = code-with-import("default-theorems", code: group-example)
  #group-with-import

  #eval-raws(
    group-example,
    "group-example",
    scope: group-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  The link-to parameter can be used to link theorems to other content. By default
  theorems are linked to the last heading and proofs are linked to the last theorem.
  This example shows how corallaries can be linked to the last theorem.
  Note that it's fine to only apply the `theorem-rules` once here since both theorem-kinds belong to the same group.

  #let corollary-example = ```
  #let (theorem, theorem-rules) = default-theorems()
  #let (corollary,) = default-theorems(
    group: "corollary-group",
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

  #let (corollary-scope, corollary-with-import) = code-with-import("default-theorems", "select-kind", "reset-counter", code: corollary-example)
  #corollary-with-import

  #eval-raws(
    corollary-example,
    "corollary-example",
    scope: corollary-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  The best and easiest way to change the look of theorems is to use show-rules.
  The next example shows another way how the appearance of theorems can be changed.

  #let proof-example = ```
  #let (
    theorem, proof, theorem-rules
  ) = default-theorems(
    lang: "en",
    style: style-simple.with(seperator: ".  "),
    proof-style: style-simple.with(kind-name-style: emph, seperator: ".  ")
  )
  #show: theorem-rules

  #theorem(lorem(5))
  #proof(lorem(5))
  ```
  #let (proof-scope, proof-with-import) = code-with-import("default-theorems", "style-simple", code: proof-example)
  #proof-with-import

  #eval-raws(
    proof-example,
    "proof-example",
    scope: proof-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  Doing the same thing to remarks is a bit more complicated since the style parameter applies to both theorems and remarks.

  #let remark-example = ```
  #let (
    theorem, theorem-rules
  ) = default-theorems(
    lang: "en",
    style: style-simple.with(seperator: ".  ")
  )
  #let (remark,) = default-theorems(
    style: style-simple.with(kind-name-style: emph, seperator: ".  "),
    numbering: none
  )
  #show: theorem-rules

  #theorem(lorem(5))
  #remark(lorem(5))
  ```
  #let (remark-scope, remark-with-import) = code-with-import("default-theorems", "style-simple", code: remark-example)
  #remark-with-import

  #eval-raws(
    remark-example,
    "remark-example",
    scope: remark-scope,
    export-setup: "#set page(width: 300pt, height: auto, margin: 10pt)"
  )

  If the pre-defined styles are not customizable enough you can also provide your own style.
  
  #let style-example = ```
  #let custom-style(thm) = {
    let params = get-theorem-parameters(thm)
    let number = (params.numbering)(thm, false)
    block(
      inset: .5em,
      fill: gray,
      {
        params.kind-name + " "
        number
        if params.name != none { ": " + params.name }
      }
    )
    v(0pt, weak: true)
    block(
      width: 100%,
      inset: 1em,
      stroke: gray + 1pt,
      params.body
    )
  }

  #let (
    theorem, theorem-rules
  ) = default-theorems(lang: "en", style: custom-style)
  #show: theorem-rules

  #theorem(name: "Some theorem")[
    #lorem(40)
  ]
  ```

  #let (style-scope, style-with-import) = code-with-import("default-theorems", "get-theorem-parameters", code: style-example)
  #style-with-import

  #eval-raws(
    style-example,
    "custom-style-example",
    scope: style-scope,
    export-setup: "#set page(width: 500pt, height: auto, margin: 10pt)"
  )

  There is one other way to create #ref-type("theorem-function")s: the
  #ref-function("theorem-kind") function. It is used to create
  the theorem-functions returned by #ref-function("default-theorems")
  so it behaves almost the same. The only difference is that there is no
  `max-reset-level` parameter and that no `theorem-rules` are returned.
  A default rule which does not reset any theorem counters can be imported.

  #let kind-example = ```
  #let note = theorem-kind("Note")
  #show: theorem-rules

  #note(lorem(5))
  ```

  #let (kind-scope, kind-with-import) = code-with-import("theorem-kind", "theorem-rules", code: kind-example)
  #kind-with-import

  #eval-raws(
    kind-example,
    "kind-example",
    scope: kind-scope,
    export-setup: "#set page(width: 500pt, height: auto, margin: 10pt)"
  )
]

#export-only("\nFor a full documentation of all functions check the [pdf-version](docs/readme.pdf) of this readme.\n")

#include "source-docs.typ"
