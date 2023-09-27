#import "selectors.typ": *

// Create a concatenated function from
// a list of functions (with one argument)
// starting with the last function:
// concat-fold((f1, f2, f3))(x) = f1(f2(f3(x)))
#let concat-fold(functions) = {
  functions.fold((c => c), (f, g) => (c => f(g(c))))
}

// Reset theorem group counter to zero.
#let reset-counter(group) = {
  counter(select-group(group)).update(c => 0)
}

// Reset counter of specified theorem group
// on headings with at most the specified level.
#let reset-counter-heading(
  group,
  max-level,
  content
) = {
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
