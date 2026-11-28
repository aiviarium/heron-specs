# Components {#components}

The components prose places are `std/doc`'s kinds. Block components stand on lines of
their own, or as children in structure; inline ones sit inside a sentence. Which is
which is the kind's `in` category, `block` or `inline`.

| Component                          | Placement     | Use                                                      |
| ---------------------------------- | ------------- | -------------------------------------------------------- |
| `section`                          | structure     | A titled part; nesting sets the level                    |
| `quote`                            | block         | A quotation, with an optional source                     |
| `code`                             | block, inline | Code, with `lang` and `title`                            |
| `table`                            | block         | A [table](#heron.language.markup.components.table) from an array of [records](#language.data.values.record_value) |
| `figure`, `image`, `caption`       | block         | An image with alt text and a caption                     |
| `note`, `tip`, `warning`, `danger` | block         | Callouts, one kind each                                  |
| `details`, `title`                 | block         | A collapsible block                                      |
| `tabs`, `tab`                      | block         | Alternatives, such as one example per language           |
| `definitions`                      | block         | A glossary built from terms in scope                     |
| `diagram`                          | block         | A [lifecycle](#language.specifications.lifecycles.lifecycle), flow or dependency graph drawn from nodes   |
| `toc`                              | block         | A [table](#heron.language.markup.components.table) of contents for the enclosing section            |
| `excerpt`                          | block         | Another node's text, by reference                        |
| `math`                             | block, inline | A formula                                                |
| `span`                             | inline        | Marked wording with no styling of its own                |
| `kbd`                              | inline        | A key or shortcut                                        |
| `abbr`                             | inline        | An abbreviation and what it stands for                   |
| `sub`, `sup`                       | inline        | Subscript and superscript                                |
| `footnote`                         | inline        | A note collected at the end of the section               |
| `if`, `else`, `for`                | block, inline | Text shown on a condition, or repeated for each item     |

<term id="table">
A Markdown table: a header row, a row of dashes and rows of cells, each line written between `|` bars, or the same rows as `<table>` with `<row>`s and `<cell>`s.
</term>

<term id="logic_tags">
`<if test={refunds.size > 0}>…</if>` with an optional `<else>` shows text on a
condition, and `<for each={changes} as="change">…</for>` repeats it, with `index` and
`last` in scope inside. A choice inside a sentence is an expression instead:
`$n ${if n == 1 { "change" } else { "changes" }}`.
</term>

<rule id="built_in_renderers" refs="system.docs_generator">
<must>render `note`, `tip`, `warning` and `danger` as callouts of their kind, `kbd` as a key, `em`, `strong` and `span` as inline text, and `details` as a collapsible block</must>
</rule>

<rule id="other_components" refs="system.docs_generator">
<must>render every other component in the [table](#heron.language.markup.components.table) by its use there, as `toc` with the enclosing section's headings to its `depth` and `footnote` collected at the section's end</must>
</rule>

<rule id="logic_rendering" refs="system.docs_generator">
<must>evaluate an `if` test or a `for` list where its names are known at generation time, and show the text it selects</must>
</rule>

<rule id="tag_or_structure" refs="system.checker">
<must>build the same node from a component written as a tag and in structure</must>
<example>`<tip>Text</tip>` and `tip { | Text }` are one node</example>
</rule>

<rule id="terms_are_nodes" refs="actors.author">
<must>declare a term as a node, `dispute: term =| …`, never as a tag</must>
<then>a link to it, `[dispute](#dispute)`, shows as a defined term, and the glossary finds it</then>
</rule>
