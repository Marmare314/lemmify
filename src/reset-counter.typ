#import "selectors.typ": select-group
#import "types.typ": assert-type

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
/// - kind-func (kind-function): The group is obtained from this kind function.
/// -> content
#let reset-counter(kind-func) = {
  assert-type(kind-func, "kind-func", function)
  return counter(select-group(kind-func)).update(c => 0)
}

/// Reset counter of theorem group
/// on headings with at most the specified level.
///
/// - kind-func (kind-function): The group is obtained from this kind function.
/// - max-level (int): Should be at least 1.
/// - content (content):
/// -> content
#let reset-counter-heading(
  kind-func,
  max-level,
  content
) = {
  assert-type(kind-func, "kind-func", function)
  assert-type(max-level, "max-level", int)
  assert(max-level >= 1, message: "max-level should be at least 1")

  let rules = range(1, max-level + 1).map(
    k => content => {
      show heading.where(level: k): it => {
        reset-counter(kind-func)
        it
      }
      content
    }
  )
  show: concat-fold(rules)
  content
}
