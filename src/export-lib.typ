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
  import "reset-counter.typ"
  reset-counter-heading = reset-counter.reset-counter-heading
  reset-counter = reset-counter.reset-counter
}

#let last-heading
#let select-group
#let select-default-group
#let select-default-proof-group
#let select-kind
#{
  import "selectors.typ"
  last-heading = selectors.last-heading
  select-group = selectors.select-group
  select-default-group = selectors.select-default-group
  select-default-proof-group = selectors.select-default-proof-group
  select-kind = selectors.select-kind
}
