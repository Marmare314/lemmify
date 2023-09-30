#import "selectors.typ": select-group
#import "types.typ": assert-type, None

// Create a concatenated function from
// a list of functions (with one argument)
// starting with the last function:
// concat-fold((f1, f2, f3))(x) = f1(f2(f3(x)))
#let concat-fold(functions) = {
  functions.fold((c => c), (f, g) => (c => f(g(c))))
}

/// Reset theorem group counter to zero.
/// The result needs to be added to the document.
///
/// - thm-func (theorem-function): The group is obtained from this argument.
/// -> content
#let reset-counter(thm-func) = {
  assert-type(thm-func, "thm-func", function)
  return counter(select-group(thm-func)).update(c => 0)
}

/// Reset counter of theorem group
/// on headings with at most the specified level.
///
/// - thm-func (theorem-function): The group is obtained from this argument.
/// - max-level (int, none): Should be at least 1.
/// - content (content):
/// -> content
#let reset-counter-heading(
  thm-func,
  max-level,
  content
) = {
  assert-type(thm-func, "thm-func", function)
  assert-type(max-level, "max-level", int, None)
  if max-level != none { assert(max-level >= 0, message: "max-level should be at least 0") }

  if max-level == none {
    show heading: it => {reset-counter(thm-func); it}
    content
  } else {
    let rules = range(1, max-level + 1).map(k => content => {
      show heading.where(level: k): it => {reset-counter(thm-func); it}
      content
    })
    show: concat-fold(rules)
    content
  }
}
