#import "@preview/tidy:0.1.0": parse-module, show-module, styles

#let custom-type-colors = (
  "theorem-function": rgb("#f9dfff"),
  "theorem-numbering-function": rgb("#f9dfff"),
  "numbering-function": rgb("#f9dfff"),
  "style-function": rgb("#f9dfff"),
  "selector-function": rgb("#f9dfff"),
  "theorem": rgb("#fff173"),
  "numbered": rgb("#bfb3ff")
)

#let type-colors = (
  "content": rgb("#a6ebe6"),
  "color": rgb("#a6ebe6"),
  "str": rgb("#d1ffe2"),
  "none": rgb("#ffcbc4"),
  "auto": rgb("#ffcbc4"),
  "bool": rgb("#ffedc1"),
  "int": rgb("#e7d9ff"),
  "float": rgb("#e7d9ff"),
  "ratio": rgb("#e7d9ff"),
  "length": rgb("#e7d9ff"),
  "angle": rgb("#e7d9ff"),
  "relative-length": rgb("#e7d9ff"),
  "fraction": rgb("#e7d9ff"),
  "symbol": rgb("#eff0f3"),
  "array": rgb("#eff0f3"),
  "dictionary": rgb("#eff0f3"),
  "arguments": rgb("#eff0f3"),
  "selector": rgb("#eff0f3"),
  "module": rgb("#eff0f3"),
  "stroke": rgb("#eff0f3"),
  "function": rgb("#f9dfff"),
  ..custom-type-colors
)

#let get-type-color(type) = type-colors.at(type, default: rgb("#eff0f3"))

#let link-color = blue.darken(50%)

#let ref-type(type, text-color: link-color) = {
  if type in custom-type-colors {
    link(label(type + "()"), text(text-color, raw(type)))
  } else {
    text(text-color, raw(type))
  }
}

#let show-link(url, txt) = {
  link(url)[#text(link-color, txt)]
}

#let show-type(type) = { 
  h(2pt)
  box(outset: 2pt, fill: get-type-color(type), radius: 2pt, ref-type(type, text-color: black))
  h(2pt)
}

#let style = (
  show-type: show-type,
  show-outline: styles.default.show-outline,
  show-function: styles.default.show-function,
  show-parameter-list: styles.default.show-parameter-list,
  show-parameter-block: styles.default.show-parameter-block
)

#let parse-module-params = (
  scope: (
    ref-type: ref-type,
    show-link: show-link
  )
)

#let show-module-params = (
  style: style,
  show-module-name: false,
  show-outline: false,
  sort-functions: none,
)

#let lib-parsed = parse-module(read("../src/lib.typ"), ..parse-module-params)
#let reset-counter-parsed = parse-module(read("../src/reset-counter.typ"), ..parse-module-params)
#let selectors-parsed = parse-module(read("../src/selectors.typ"), ..parse-module-params)
#let styles-parsed = parse-module(read("../src/styles.typ"), ..parse-module-params)
#let numbered-parsed = parse-module(read("../src/numbered.typ"), ..parse-module-params)
#let theorem-parsed = parse-module(read("../src/theorem.typ"), ..parse-module-params)
#let function-types-parsed = parse-module(read("function-types.typ"), ..parse-module-params)

= Documentation

#show-module(lib-parsed, ..show-module-params)

== Function types

#show-module(function-types-parsed, ..show-module-params)

== theorem
#label("theorem()")

A #ref-type("theorem") is a #ref-type("figure") with some additional
information stored in one of its parameters.

#show-module(theorem-parsed, ..show-module-params)

== numbered
#label("numbered()")

A #ref-type("numbered") is a #ref-type("heading"), #ref-type("page"),
#ref-type("math.equation") or #ref-type("figure") that is already embedded
in the document (that means it was obtained by a query). The `numbering`
also has to be different from #ref-type("none").

#show-module(numbered-parsed, ..show-module-params)

== Styles

#show-module(styles-parsed, ..show-module-params)

== Selectors

The selectors can be used in show-rules to
customize the #ref-type("theorem")s styling as well as
with the `link-to` parameter.

#show-module(selectors-parsed, ..show-module-params)

== Resetting counters

#show-module(reset-counter-parsed, ..show-module-params)
