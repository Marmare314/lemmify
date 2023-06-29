# Theoremify

Theoremify is a library for typesetting mathematical
theorems in typst.

## Basic Usage

To get started with Theoremify, follow these steps:

1. Import the Theoremify library:
```typst
#import "@preview/theoremify:0.1.0": *
```

2. Define the default styling for a few default theorem types:
```typst
#let (
  theorem, lemma, corollary
  remark, proposition, example
  proof, rules: thm-rules
) = default-theorems("thm-group", lang: "en")
```

3. Apply the generated styling:
```typst
#show: thm-rules
```

4. Create theorems, lemmas, and proofs using the defined styling:
```typst
#theorem(name: "Some theorem")[
  Theorem content goes here.
]<thm>

#proof[
  Complicated proof.
]<proof>
```

5. Customize the styling further using show rules. For example, to add a red box around examples:
```
#show thm-selector("thm-group", "example"): it => box(
  it,
  stroke: red + 1pt,
  inset: 1em
)
```

## Useful examples

If you do not want to reset the theorem counter on headings
you can use the `max-reset-level` parameter:

```typst
default-theorems("thm-group", max-reset-level: 0)
```

It specifies whats the highest level at which the counter is reset. To manually reset the counter you can use the
`thm-reset-counter` function.

---

By specifying `numbering: none` you can create unnumbered
theorems.

```typst
#example(numbering: none)[
  Some example.
]
```

To make all examples unnumbered you could use the following code:

```typst
#let example = example.with(numbering: none)
```

---

To create other types (or subgroups) of theorems you can use the
`new-theorems` function.

```typst
#let (note, rules) = new-theorems("thm-group", ("note": "Note"))
#show: rules
```

---

By varying the `group` parameter you can create independently numbered theorems:

```typst
#let (
  theorem, proof,
  rules: thm-rules-a
) = default-theorems("thm-group-a")
#let (
  definition,
  rules: thm-rules-b
) = thm-default-style("thm-group-b")

#show: thm-rules-a
#show: thm-rules-b
```

## Documentation

The two most important functions are:

`default-theorems`: Create a default set of theorems
based on the given language and styling.
- `group`: The group id.
- `lang`: The language to which the theorems are adapted.
- `thm-styling`, `thm-numbering`, `ref-styling`: Styling
parameters are explained in further detail in the
[Styling](#styling) section.
- `proof-styling`: Styling which is only applied to proofs.
- `max-reset-level`: The highest heading level on which
theorems are still reset.

`new-theorems`: Create custom sets of theorems with
the given styling.
- `group`: The group id.
- `subgroup-map`: Mapping from group id to some argument.
The simple styles use `thm-type` as the argument (ie
"Beispiel" or "Example" for group id "example")
- `thm-styling`, `thm-numbering`, 
`ref-styling`, `ref-numbering`: Styling which to apply
to all subgroups.

---

`use-proof-numbering`: Decreases the numbering of
a theorem function by one.
See [Styling](#styling) for more information.

---

`thm-selector`: Returns a selector for all theorems
of the specified group. If subgroup is specified, only the
theorems belonging to it will be selected.

---

There are also a few functions to help with resetting counters.

`thm-reset-counter`: Reset theorem group counter manually.
Returned content needs to added to the document.

`thm-reset-counter-heading-at`: Reset theorem group counter
at headings of the specified level. Returns a rule that
needs to be shown.

`thm-reset-counter-heading`: Reset theorem group counter
at headings of at most the specified level. Returns a rule
that needs to be shown.

## Styling
If possible the best way to adapt the look of theorems is to use show
rules as shown above, but this is not always possible.
For example if we wanted theorems to start
with `1.1 Theorem` instead of `Theorem 1.1`.
You can provide the following functions to adapt the look of the theorems.

----
`thm-styling`: A function: `(arg, name, number, body) -> content`, that
allows you to define the styling for different types of theorems.
Below only the `arg` will be specified.

Pre-defined functions
- `thm-style-simple(thm-type)`: **thm-type num** _(name)_ body
- `thm-style-proof(thm-type)`: **thm-type num** _(name)_ body □
- `thm-style-reversed(thm-type)`: **num thm-type** _(name)_ body

---

`thm-numbering`: A function: `figure -> content`, that determines how
theorems are numbered.

Pre-defined functions: (Assume heading is 1.1 and theorem count is 2)
- `thm-numbering-heading`: 1.1.2
- `thm-numbering-linear`: 2
- `thm-numbering-proof`: No visible content is returned, but the
counter is reduced by 1 (so that the proof keeps the same count as
the theorem).

---

`ref-styling`: A function: `(arg, thm-numbering, ref) -> content`, to style
theorem references.

Pre-defined functions:
- `thm-ref-style-simple(thm-type)`
  - `@thm -> thm-type 1.1`
  - `@thm[custom] -> custom 1.1`

## Roadmap

- More pre-defined styles.
- Support more languages.
- Better documentation.

If you are encountering any bugs, have questions or
are missing features, feel free to open an issue on
[Github](https://github.com/Marmare314/theoremify).
