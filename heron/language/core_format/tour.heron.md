# Format tour {#tour}

Every construct of the core in one file, [the format tour](#language.core_format.tour.format_tour).
`section`, `term`, `note`, `widget`, `marker`, `task`, the `large` flag and
`@source` stand for whatever packages define. Reading it line by line:

- `title` and `import` are set on the [implicit root](#language.core_format.files.implicit_root), which is open, and `docs` is a
  local that never reaches the output.
- `overview` is a section with `|` lines: inline Markdown, a link to `tour_term`, an
  inserted value, an interpolated link and a `note` tag.
- `gauge` is declared with the `large` kind flag, kind arguments, an annotation and
  `///` documentation; `marker(…)` creates an anonymous node.
- `scale(steps: Int = 10)` declares a parameter, and `is_large` is a func written as
  one expression.
- `check_gauge` is a task whose body is code, run top to bottom.
- The last `gauge { … }` enters the gauge declared above and amends one field.

<example id="format_tour" @display="The tour file">
```heron
title = "Format tour"
import = ["std/doc@1", "acme/widgets@1"]

let docs = "https://example.com/docs"

overview: section {
  | Prose lines start with `|` and use Markdown inline, with **bold**, *italic* and `code`.
  | A [term](#tour_term) links to a node, $gauge.size inserts a value,
  | and [this page](${docs}/gauges) points elsewhere.
  |
  | <note kind="tip">Tags are nodes too, written inside the text.</note>

  tour_term: term =| A word the glossary defines once.

  details: section {{
    A body that is all prose needs no prefixes.
    It ends at the closing brace on its own line.
  }}
}

/// A gauge with a printed label.
@source(file = "gauges.csv")
gauge: widget<large>(size = 3, unit = "mm") {
  | Prose inside a structural node is its own text.

  label =| Printed under the gauge.
  marker(color = Color.RED)
  limits = (Set)[(u8)10, (u8)20]
  owner = { team = "core", contact = `ops@core.example` }
}

scale(steps: Int = 10): widget {
  ticks = [0, steps / 2, steps]
}

is_large(size: Int): func(Bool) = size > 5

// This comment is kept and belongs to the next member.
check_gauge: task do {
  let size = gauge.size

  if is_large(size) {
    log("$gauge.label is large: ${size} mm")
  }

  for limit in gauge.limits {
    expect(limit <= 20)
  }
}

gauge {
  owner.team = "platform"
}
```
</example>
