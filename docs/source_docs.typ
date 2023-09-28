#import "@preview/tidy:0.1.0": parse-module, show-module

#let lib-parsed = parse-module(read("../src/lib.typ"))
#let reset-counter-parsed = parse-module(read("../src/reset-counter.typ"))
#let selectors-parsed = parse-module(read("../src/selectors.typ"))
#let styles-parsed = parse-module(read("../src/styles.typ"))
#let numbered-parsed = parse-module(read("../src/numbered.typ"))
#let theorem-parsed = parse-module(read("../src/theorem.typ"))

= Documentation

#show-module(lib-parsed)

== Styles

There are a few pre-defined `style-function`s and `theorem-numbering-function`s.

#show-module(styles-parsed)

== Selectors

The selectors can be used in show-rules to
customize the `theorem`s styling as well as
with the `link-to` parameter.

#show-module(selectors-parsed)

== Resetting counters

#show-module(reset-counter-parsed)

== Theorem utilities

The functions in the remaining two sections are only needed when defining custom style or
theorem-numbering-functions.

#show-module(theorem-parsed)

== Numbered utilities

#show-module(numbered-parsed)
