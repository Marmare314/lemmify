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
#{
  import "styles.typ"
  numbering-concat = styles.numbering-concat
  numbering-proof = styles.numbering-proof
  style-reversed = styles.style-reversed
  style-simple = styles.style-simple
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
#let assert-theorem
#let get-theorem-parameters
#let resolve-link
#{
  import "theorem.typ"
  is-theorem = theorem.is-theorem
  assert-theorem = theorem.assert-theorem
  get-theorem-parameters = theorem.get-theorem-parameters
  resolve-link = theorem.resolve-link
}

#let is-countable
#let assert-countable
#let get-countable-parameters
#let display-countable
#{
  import "countable.typ"
  is-countable = countable.is-countable
  assert-countable = countable.assert-countable
  get-countable-parameters = countable.get-countable-parameters
  display-countable = countable.display-countable
}
