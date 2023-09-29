#import "theorem.typ": create-theorem, is-theorem, get-theorem-parameters
#import "styles.typ": numbering-concat, style-simple, numbering-proof
#import "translations.typ": get-translation
#import "selectors.typ": last-heading
#import "reset-counter.typ": concat-fold, reset-counter-heading
#import "types.typ": assert-type, None

#let LEMMIFY-DEFAULT-THEOREM-GROUP = "LEMMIFY-DEFAULT-THEOREM-GROUP"
#let LEMMIFY-DEFAULT-PROOF-GROUP = "LEMMIFY-DEFAULT-PROOF-GROUP"

/// Creates a new #ref-type("theorem-function").
///
/// - kind-name (str): The name of the theorem kind. It also acts
///     as an identifier together with `group` when using `select-kind`,
///     so it should be unique.
/// - group (str): The group identifier. Each theorem group shares one counter.
/// - link-to (label, selector, selector-function, none): This parameter sets
///     what the #ref-type("theorem")s created by the #ref-type("theorem-function") will be linked to
///     by default.
/// - numbering (theorem-numbering-function, none): Specify a default value for
///     the `numbering` parameter of the #ref-type("theorem-function").
/// - subnumbering (numbering-function, str, none): The subnumbering is
///     needed to convert the #ref-type("theorem")s counter to content,
///     which is then used in the #ref-type("theorem-numbering-function").
/// - style (style-function): Specifies how the #ref-type("theorem")s will look. This will only be
///     visible once the @@theorem-rules() have been applied.
/// -> theorem-function
#let theorem-kind(
  kind-name,
  group: LEMMIFY-DEFAULT-THEOREM-GROUP,
  link-to: last-heading,
  numbering: numbering-concat,
  subnumbering: "1",
  style: style-simple
) = {
  assert-type(kind-name, "kind-name", str)
  assert-type(group, "group", str)
  assert-type(link-to, "link-to", label, selector, function, None)
  assert-type(numbering, "numbering", function, None)
  assert-type(subnumbering, "subnumbering", function, str, None)
  assert-type(style, "style", function)

  return (
    name: none,
    link-to: link-to,
    numbering: numbering,
    body
  ) => create-theorem(
    name,
    kind-name,
    group,
    link-to,
    numbering,
    subnumbering,
    style,
    body
  )
}

/// Apply the style of every #ref-type("theorem") and handle references to #ref-type("theorem")s.
///
/// - content (content):
/// -> content
#let theorem-rules(content) = {
  show figure: it => if is-theorem(it) {
    let params = get-theorem-parameters(it)
    if params.numbering == none {
      it.counter.update(n => n - 1)
    }
    (params.style)(it)
  } else {
    it
  }
  show ref: it => {
    if it.element == none or not is-theorem(it.element) {
      return it
    }

    let params = get-theorem-parameters(it.element)
    link(it.target, {
      if it.citation.supplement != none { it.citation.supplement } else { params.kind-name }
      " "
      (params.numbering)(it.element, true)
    })
  }
  content
}

/// Generate a few common theorem kinds in the specified language.
///
/// Returns a dictionary of the form
/// `(theorem, lemma, corollary, remark, proposition, example, definition, proof, theorem-rules)`.
/// The `theorem-rules` can be applied using a show statement. If `max-reset-level` is `none`
/// it will be the same as @@theorem-rules().
///
/// This function accepts all parameters of @@theorem-kind() once for proofs and
/// once for all kinds except for proofs.
///
/// - group (str):
/// - proof-group (str):
/// - lang (str): The language in which the theorem kinds are generated.
/// - style (style-function):
/// - proof-style (style-function):
/// - numbering (theorem-numbering-function, none):
/// - proof-numbering (theorem-numbering-function, none):
/// - link-to (label, selector, selector-function, none):
/// - proof-link-to (label, selector, selector-function, none):
/// - subnumbering (numbering-function, str, none):
/// - max-reset-level (int, none): If it is not none the theorem counter will
///                                be reset on headings below `max-reset-level`.
///                                And if `link-to` is set to `last-heading`
///                                higher levels will not be displayed in the numbering.
/// -> dictionary
#let default-theorems(
  group: LEMMIFY-DEFAULT-THEOREM-GROUP,
  proof-group: LEMMIFY-DEFAULT-PROOF-GROUP,
  lang: "en",
  style: style-simple,
  proof-style: style-simple.with(qed: true),
  numbering: numbering-concat,
  proof-numbering: numbering-proof,
  link-to: last-heading,
  proof-link-to: none,
  subnumbering: "1",
  max-reset-level: none
) = {
  assert-type(group, "group", str)
  assert-type(proof-group, "proof-group", str)
  assert-type(lang, "lang", str)
  assert-type(style, "style", function)
  assert-type(proof-style, "proof-style", function)
  assert-type(numbering, "numbering", function, None)
  assert-type(proof-numbering, "proof-numbering", function, None)
  assert-type(link-to, "link-to", label, selector, function, None)
  assert-type(proof-link-to, "proof-link-to", label, selector, function, None)
  assert-type(subnumbering, "subnumbering", function, str, None)
  assert-type(max-reset-level, "max-reset-level", int, None)

  let (proof: proof-translation, ..other-kinds) = get-translation(lang)

  if link-to == last-heading {
    link-to = last-heading.with(max-level: max-reset-level)
  }

  let theorems = (:)
  for (kind, translation) in other-kinds {
    theorems.insert(kind, theorem-kind(
      translation,
      group: group,
      numbering: numbering,
      subnumbering: subnumbering,
      style: style,
      link-to: link-to
    ))
  }

  theorems.insert("proof", theorem-kind(
    proof-translation,
    group: proof-group,
    numbering: proof-numbering,
    subnumbering: subnumbering,
    style: proof-style,
    link-to: proof-link-to
  ))

  let rules = if max-reset-level != none {
    concat-fold((
      theorem-rules,
      reset-counter-heading.with(theorems.theorem, max-reset-level),
      reset-counter-heading.with(theorems.proof, max-reset-level)
    ))
  } else {
    theorem-rules
  }
  return (
    ..theorems,
    theorem-rules: rules
  )
}
