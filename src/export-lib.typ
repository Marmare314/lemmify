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
