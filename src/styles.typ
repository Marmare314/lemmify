#import "theorem.typ": *
#import "countable.typ": *

#let numbering-concat(thm, referenced, seperator: ".") = {
  let linked = resolve-link(thm)
  if linked != none {
    display-countable(linked)
    seperator
  }
  display-countable(thm)
}

#let numbering-proof(thm, referenced) = {
  let linked = resolve-link(thm)
  if referenced and linked != none {
    assert(is-theorem(linked), message: "can only link proof to theorem")
    let params = get-theorem-parameters(linked)
    (params.numbering)(linked, true)
  }
}

#let style-simple(thm, qed: false) = {
  let params = get-theorem-parameters(thm)
  block(width: 100%, breakable: true, {
    strong(params.kind-name)
    if params.numbering != none {
      " "
      strong((params.numbering)(thm, false))
    }
    if params.name != none {
      emph(" (" + params.name + ")")
    }
    "  "
    params.body
    if qed {
      h(1fr)
      box(scale(160%, origin: bottom + right, sym.square.stroked))
    }
  })
}

#let style-reversed(thm, qed: false) = {
  let params = get-theorem-parameters(thm)
  block(width: 100%, breakable: true, {
    if params.numbering != none {
      strong((params.numbering)(thm, false))
      " "
    }
    strong(params.kind-name)
    if params.name != none {
      emph(" (" + params.name + ")")
    }
    "  "
    params.body
    if qed {
      h(1fr)
      box(scale(160%, origin: bottom + right, sym.square.stroked))
    }
  })
}
