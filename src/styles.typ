#import "theorem.typ": resolve-link, get-theorem-parameters, is-theorem
#import "numbered.typ": display-numbered, is-numbered
#import "types.typ": assert-type

/// If the linked content is numbered combine it with the numbering
/// of the theorem.
///
/// - thm (theorem):
/// - referenced (bool):
/// - seperator (content, str): The sepeartor is put between both numberings.
#let numbering-concat(thm, referenced, seperator: ".") = {
  assert-type(seperator, "seperator", content, str)
  let linked = resolve-link(thm)
  if linked != none and is-numbered(linked) {
    display-numbered(linked)
    seperator
  }
  display-numbered(thm)
}

/// Copy the numbering of a linked `theorem` if referenced.
/// Otherwise no numbering is returned.
///
/// - thm (theorem):
/// - referenced (bool):
#let numbering-proof(thm, referenced) = {
  let linked = resolve-link(thm)
  if referenced and linked != none {
    assert(is-theorem(linked), message: "can only link proof to theorem")
    let params = get-theorem-parameters(linked)
    (params.numbering)(linked, true)
  }
}

/// Simple theorem style. Check the documentation for images.
///
/// - thm (theorem):
/// - qed (bool): Select if a box should be shown at the end.
#let style-simple(thm, qed: false) = {
  assert-type(qed, "qed", bool)
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

/// Reverses numbering and `kind-name`.
///
/// - thm (theorem):
/// - qed (bool): Select if a box should be shown at the end.
#let style-reversed(thm, qed: false) = {
  assert-type(qed, "qed", bool)
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
