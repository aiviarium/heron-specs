# Categories {#categories}

A category is an open set of kinds. A body that accepts a category accepts every kind
in it, whichever package declares the kind, so a package adds blocks that `std/doc`'s
sections take without touching `std/doc`.

<term id="category_term" @display="Category">
A node of kind `category`, as `block: category`, that kinds join with `in` and bodies
accept with `accept(category = …)`.
</term>

<rule id="joining" refs="system.checker">
<must>put a kind in each category its `in` argument names, and in no other</must>
<example>`code(lang?: String, title?: String): kind(in = [block, inline])` is a block and an inline kind wherever `std/doc` is imported</example>
</rule>

<rule id="open_sets" refs="system.checker">
<must>admit, through a category entry, a kind of any package in `import` that joins the category, the importing tree's own kinds included</must>
</rule>

`std/doc` declares the categories prose and documentation are built from: `block`, for
what stands on a line of its own or as a block tag, and `inline`, for what stands inside
a sentence. `std/spec` adds `strength` and `condition`, `revised`, through which other
packages' kinds take `@rev`, and `touchable`, the spec kinds a contract surface's
references may name. `std/schema` declares `flow` and
`phrasing`, the sketch's names for the same two sets, which no standard kind joins.

<rule id="builtin_categories" refs="actors.author">
<should_not>put a kind in `schema.flow` or `schema.phrasing`</should_not>
<instead>put block kinds in `doc.block` and inline kinds in `doc.inline`, which every documentation body accepts</instead>
</rule>

An excerpt of `std/doc`: the categories, a heading kind, a kind that's a block and inline at
once, a callout and an inline kind.

<example id="std_doc_schema" @display="Example: std/doc">
```heron
import = ["std/schema@1"]

// An excerpt: the full component list is on the Markup tab.
doc: package(version = "1.0") {
  block: category
  inline: category

  section: kind(in = [block], heading = true) {
    accept(prose)
    accept(category = block)
    accept(category = inline)
  }

  /// A code block. Triple backticks in prose are its shorthand.
  code(lang?: String, title?: String): kind(in = [block, inline]) {
    accept(text = Verbatim)
  }

  tip: kind(in = [block]) {
    accept(prose)
    accept(category = inline)
  }

  kbd: kind(in = [inline]) {
    accept(prose)
  }
}
```
</example>
