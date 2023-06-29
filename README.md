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

It specifies whats the highest level at which the counter is reset.

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

To create other types (or subgroups) of theorems you can use the
`new-theorems` function.

```typst
#let (note) = new-theorems("thm-group", ("note": "Note"))
```

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

<!-- There is only one function that was not mentioned yet.

`thm-group-styling`: Used to apply a base styling to the
theorem group.

It takes a `group` identifier and optional
styling parameters `thm-styling`, `thm-numbering`, `ref-styling`
and `max-reset-level`.
The `max-reset-level` parameter specifies up to what heading level
the group counter is reset. The other parameters will be explained 
below. Returns a function which applies the specified styling to its
content.

--- -->

`new-subgroups`: Used to generate theorem functions and/or apply
styling to subgroups.

<!-- It also takes a `group` and optional styling
parameters `thm-styling`, `thm-numbering`, `ref-styling`.
But there is also the `subgroup-map` parameter, which
should specify a map `(group-id: arg)`. Then `arg` will be
passed to `thm-styling`. -->

---

`default-theorems`: Used to generate quickly create a default theorem set.

<!-- Also takes `group`, `thm-styling`, `thm-numbering`,
`ref-styling` and `max-reset-level`. There is a special `proof-styling`
parameter which will be only be applied to proofs. The `lang` parameter
is used to specify the display language of the theorems. -->

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

- More pre-defined styles
- Support more languages

I'm open to any suggestions on missing features.
Feel free to open an issue at [...].
