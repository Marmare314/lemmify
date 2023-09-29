#let theorem-kind = (link-to: 0, numbering: 0)

/// TODO
///
/// - name (content, str): The name of the #ref-type("theorem").
/// - link-to (label, selector, selector-function, none): Link the #ref-type("theorem")
///     to some other content. For #ref-type("label")s and #ref-type("selector")s the last
///     match before the #ref-type("theorem") is used.
/// - numbering (theorem-numbering-function, none): See #ref-type("theorem-numbering-function")
///    for more information. Can be set to #ref-type("none") for unnumbered #ref-type("theorem")s.
/// - body (content):
/// -> theorem
#let theorem-function(name: none, link-to: theorem-kind.link-to, numbering: theorem-kind.numbering, body) = 0

/// Create combined numberings from `theorem` and the content linked to it.
///
/// There are two pre-defined #ref-type("theorem-numbering-function")s: @@numbering-concat() and @@numbering-proof().
///
/// - thm (theorem): The `theorem` for which the numbering should be generated.
///     See also @@get-theorem-parameters(). 
/// - referenced (bool): This is false if
///     the numbering was requested from the `theorem` it belongs to.
///     Otherwise it is false. See @@numbering-proof() as an example.
/// -> content
#let theorem-numbering-function(thm, referenced) = 0

/// Defines how the #ref-type("theorem") will look. Use @@get-theorem-parameters() to get
/// all information stored in the #ref-type("theorem").
///
/// There are two pre-defined #ref-type("style-function")s: @@style-simple() and @@style-reversed().
///
/// - thm (theorem):
/// -> content
#let style-function(thm) = 0

/// Useful for more advanced queries. See @@last-heading() for an example.
///
/// - loc (location): When used in `link-to` parameter
///     of some #ref-type("theorem") its #ref-type("location")
///     will be passed when resolving the link with @@resolve-link().
/// -> content, none
#let selector-function(loc) = 0

/// A normal numbering function as described
/// in the #show-link("https://typst.app/docs/reference/meta/numbering/#parameters-numbering")[typst documentation].
///
/// - ..state (int):
/// -> content
#let numbering-function(..state) = 0
