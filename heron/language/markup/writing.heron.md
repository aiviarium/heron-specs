# Writing {#writing}

Prose is written in five places, and all five hold the same text: [`|` lines](#language.core_format.prose_layer.prose_lines),
a [`{{ }}` body](#language.core_format.prose_layer.prose_body), a prose value after `=|` or `= {{`, [`///` doc lines](#language.core_format.prose_layer.doc_lines),
and a whole [prose file](#language.core_format.prose_layer.prose_file). A string literal is a sixth where a field is typed
`Prose`, with less read in it.

| Written as         | Belongs to                                | Prefix  |
| ------------------ | ----------------------------------------- | ------- |
| `\|` lines         | the node they stand in, as its own text   | `\|`    |
| `{{ }}` body       | the node it's the body of                 | none    |
| `=\|` or `= {{ }}` | the field it's the value of               | `\|` or none |
| `///` lines        | the member after them, as its `@doc`      | `///`   |
| `.heron.md` file   | the section its headings open             | none    |

<term id="prose_text">
The text of a node or a value written in markup, whichever of the places above holds
it. Its prefixes and the common indentation of a `{{ }}` body are not part of it.
</term>

<rule id="same_text" refs="system.parser">
<must>read the same inline forms, text, escapes, code spans, links, inserts, tags and fenced blocks, in every place prose is written</must>
<then>moving text from `|` lines into a `{{ }}` body, or from a value into a doc comment, never changes what it says</then>
</rule>

<rule id="one_prose_syntax" refs="system.parser">
<must>read [prose text](#language.markup.writing.prose_text) as one syntax, Heron-flavored Markdown: Markdown's forms and [kind elements](#language.markup.tags.component_tag) freely mixed, the same in `|` lines, a `{{ }}` body and a [prose file](#language.core_format.prose_layer.prose_file), and Markdown inside an element read as Markdown</must>
<then>a [prose file](#language.core_format.prose_layer.prose_file) of elements alone is a [prose_file] like any other, and `<em>text</em>` and `*text*` build the one `std/doc` node</then>
</rule>

<rule id="markup_strings" refs="system.prose_linter">
<while>a string literal is the value of a field or node typed `Prose`</while>
<must>read its inserts and project it as prose, with its inline code masked</must>
</rule>

<rule id="paragraphs" refs="system.prose_linter">
<must>read a line break inside a paragraph as a space, and an empty line, a bare `|` or an empty `///`, as the end of the paragraph</must>
<then>a word split across two lines is found by a linter as the two words it is, and a phrase across a break as one phrase</then>
</rule>

<rule id="doc_lines_end" refs="system.parser">
<must>end a run of `///` lines at the first line that doesn't start with `///` after its indentation, an empty line included</must>
<then>a `///` comment separated from a member by a blank line documents nothing</then>
</rule>

<rule id="requirements_not_markup" refs="actors.author">
<must_not>write a rule's conditions, outcome and examples as markup in its text</must_not>
<instead>write them as the rule's child nodes, which the docs render as one sentence</instead>
</rule>
