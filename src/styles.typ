#import "theorem.typ": resolve-link, get-theorem-parameters, is-theorem
#import "numbered.typ": display-numbered, is-numbered
#import "types.typ": assert-type, None

/// If the linked content is numbered combine it with the numbering
/// of the #ref-type("theorem").
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

/// Copy the numbering of a linked #ref-type("theorem") if referenced.
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

/// A box for convenience. (Not a function but a constant.)
#let qed-box = box(scale(160%, origin: bottom + right, sym.square.stroked))

/// Simple theorem style. The theorem gets represented as a breakable block of the form
/// `kind-name-style(kind-name) number-style(numbering) name-style(name) seperator body`.
///
/// - thm (theorem):
/// - kind-name-style (function): A function `str -> content` to change the look of the `kind-name`.
/// - number-style (function): A function `content -> content` to change the look of the generated numbering.
/// - name-style (function): A function `content -> content` to change the look of the `name`.
/// - seperator (content, str): How to seperate the theorem header and its body.
/// - qed (content, none): Select what content to show at the end of the theorem.
#let style-simple(
  thm,
  kind-name-style: strong,
  number-style: strong,
  name-style: name => emph("(" + name + ")"),
  seperator: "  ",
  qed: none
) = {
  assert-type(kind-name-style, "kind-name-style", function)
  assert-type(number-style, "number-style", function)
  assert-type(name-style, "name-style", function)
  assert-type(seperator, "seperator", content, str)
  assert-type(qed, "qed", content, None)

  let params = get-theorem-parameters(thm)
  block(width: 100%, breakable: true, {
    kind-name-style(params.kind-name)
    if params.numbering != none {
      " "
      number-style((params.numbering)(thm, false))
    }
    if params.name != none {
      " "
      name-style(params.name)
    }
    seperator
    params.body
    if qed != none {
      h(1fr)
      qed
    }
  })
}

/// Reverses numbering and `kind-name`, otherwise the same as @@style-simple().
///
/// - thm (theorem):
/// - kind-name-style (function):
/// - number-style (function):
/// - name-style (function):
/// - seperator (content, str):
/// - qed (content, none):
#let style-reversed(
  thm,
  kind-name-style: strong,
  number-style: strong,
  name-style: name => emph("(" + name + ")"),
  seperator: "  ",
  qed: none
) = {
  assert-type(kind-name-style, "kind-name-style", function)
  assert-type(number-style, "number-style", function)
  assert-type(name-style, "name-style", function)
  assert-type(seperator, "seperator", content, str)
  assert-type(qed, "qed", content, None)

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
    if qed != none {
      h(1fr)
      qed
    }
  })
}
