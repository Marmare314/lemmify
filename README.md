# Theoremify

Project description

## Basic Usage

To get started with Theoremify, follow these steps:

1. Import the Theoremify library:
```typst
#import "@preview/theoremify:0.1.0": *
```

2. Define the default styling for theorems and other mathematical statements:
```typst
#let (
  theorem, lemma, corollary
  remark, proposition, example
  proof, rules: default-thm-rules, selector: default-thm-selector
) = default-theorems(lang: "en")
```

3. Apply the generated styling:
```typst
#show: default-thm-rules
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
#show default-thm-selector("example"): it => box(
  it,
  stroke: red + 1pt,
  inset: 1em
)
```

## Useful examples

If you do not want to reset the theorem counter on headings
you can use the `max-reset-level` paramter:

```typst
default-theorems(lang: "en", max-reset-level: 0)
```

It specifies whats the highest level at which the counter is reset.

By specifying `numbering: none` we can create unnumbered
theorems.

```typst
#example(numbering: none)[
  Some example.
]
```

To make all examples unnumbered we could use the following code:

```typst
#let example = example.with(numbering: none)
```

To create other kinds (or subgroups) of theorems you can use the
`new-thm-func`.
It is important to note that `"theorems"` is the default group
used by `thm-default-style`.

```typst
#let note = new-thm-func("theorems", subgroup: "Note")
```

If you want to modify the styling or apply show rules to the new subgroup,
you need to use its subgroup name in the selector. For example:

```typst
#show default-thm-selector("Note"): it => ...
```

Note that using the subgroup name respects translations for default subgroups.
For instance, if the language is set to `"de"`, `"example"` will be internally 
converted to `"Beispiel"`.

By varying the `group` parameter you can create independently numbered theorems:

```typst
#let (
  theorem, proof,
  rules: thm-rules-a, selector: thm-selector-a
) = thm-default-style(group: "theorems-a", lang: "en")
#let (
  definition,
  rules: thm-rules-b, selector: thm-selector-b
) = thm-default-style(group: "theorems-b", lang: "en")

#show: thm-rules-a
#show: thm-rules-b
```

## Advanced Styling
If possible the best way to adapt the look of theorems is to use show
rules as shown above, but this is not always possible.
For example if we wanted theorems to start
with `1.1 Theorem` instead of `Theorem 1.1`.
You can provide the following functions to adapt the look of the theorems.

----
`thm-styling`: A function: `(subgroup, name, number, body) -> content`, that
allows you to define the styling for different types of theorems.

Pre-defined functions
- `thm-style-simple`: (image)
- `thm-style-proof`: (image)

---

`thm-numbering`: A function: `figure -> content`, that determines how
theorems are numbered.
Pre-defined functions:
- `thm-numbering-heading`: image
- `thm-numbering-linear`: image
- `thm-numbering-proof`: image

---

`ref-styling`: A function: `(thm-numbering, ref) -> content`, to style
theorem references.
There is currently only `thm-ref-style-simple`.
(image)

---

There is a fourth argument `proof-styling` which is he same as `thm-styling`, 
but only applies to the subgroup `"proof"`.

## Advanced usage

Theorems are implemented through figures. The theorem group corresponds
to the figure kind. The subgroup is stored in the figures supplement,
and the caption is considered as the name. The functions `new-thm-func` and
`new-proof-func` are factory functions that make it easier to create
functions which create the figures.

To select specific theorems there is a helper function `thm-selector`.

To combine `thm-styling` and `thm-numbering` into a rule that
can be applied to figures, use `thm-style`. 
Similarly, `thm-ref-style` allows you to apply `ref-styling`
to theorem references.

```typst
#let theorem = new-thm-func("theorems", "Theorem")
#let proof = new-proof-func("theorems", "Proof")

#show thm-selector("theorems"): thm-style.with(
  thm-style-simple,
  thm-numbering-heading
)
#show thm-selector("theorems", subgroup: "Proof"): thm-style.with(
  thm-style-simple,
  thm-numbering-proof
)
#show: thm-ref-style.with(
  "theorems",
  thm-ref-style-simple.with(thm-numbering-heading)
)
#show: figure-counter-reset.with("theorems", 1)
```

## Roadmap

- More pre-defined styles
- Support more languages

I'm open to any suggestions on missing features.
Feel free to open an issue at [...].
