#let LEMMIFY-VERSION = "0.2.0"

#let theorem-kind
#let theorem-rules
#let default-theorems
#{
  import "lib.typ"
  theorem-kind = lib.theorem-kind
  theorem-rules = lib.theorem-rules
  default-theorems = lib.default-theorems
}

#let numbering-concat
#let numbering-proof
#let style-reversed
#let style-simple
#let qed-box
#{
  import "styles.typ"
  numbering-concat = styles.numbering-concat
  numbering-proof = styles.numbering-proof
  style-reversed = styles.style-reversed
  style-simple = styles.style-simple
  qed-box = styles.qed-box
}

#let reset-counter
#let reset-counter-heading
#{
  let tmp-reset-counter
  {
    import "reset-counter.typ"
    reset-counter-heading = reset-counter.reset-counter-heading
    tmp-reset-counter = reset-counter.reset-counter
  }
  reset-counter = tmp-reset-counter
}

#let last-heading
#let select-group
#let select-kind
#{
  import "selectors.typ"
  last-heading = selectors.last-heading
  select-group = selectors.select-group
  select-kind = selectors.select-kind
}

#let is-theorem
#let get-theorem-parameters
#let resolve-link
#{
  import "theorem.typ"
  is-theorem = theorem.is-theorem
  get-theorem-parameters = theorem.get-theorem-parameters
  resolve-link = theorem.resolve-link
}

#let is-numbered
#let display-numbered
#{
  import "numbered.typ"
  is-numbered = numbered.is-numbered
  display-numbered = numbered.display-numbered
}
