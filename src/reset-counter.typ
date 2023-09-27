#import "selectors.typ": select-group
#import "types.typ": assert-type

// Create a concatenated function from
// a list of functions (with one argument)
// starting with the last function:
// concat-fold((f1, f2, f3))(x) = f1(f2(f3(x)))
#let concat-fold(functions) = {
  functions.fold((c => c), (f, g) => (c => f(g(c))))
}

// Reset theorem group counter to zero.
#let reset-counter(group) = {
  assert-type(group, "group", str)
  counter(select-group(group)).update(c => 0)
}

// Reset counter of specified theorem group
// on headings with at most the specified level.
#let reset-counter-heading(
  group,
  max-level,
  content
) = {
  assert-type(group, "group", str)
  assert-type(max-level, "max-level", int)
  assert(max-level >= 1, message: "max-level should be at least 1")

  let rules = range(1, max-level + 1).map(
    k => content => {
      show heading.where(level: k): it => {
        reset-counter(group)
        it
      }
      content
    }
  )
  show: concat-fold(rules)
  content
}
