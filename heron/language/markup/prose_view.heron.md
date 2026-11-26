# Prose view {#prose_view}

Text linters can't read [Heron files](#language.core_format.files.heron_file), but the
core knows exactly which parts of a file are prose, because [schemas](#language.schemas.kinds.schema) are mode-aware.
The [prose linter](#system.prose_linter) projects them into regions a text linter
reads, feeds the regions to Vale and the spec-aware lints, and maps what comes back onto
the source.

<term id="prose_projection">
The document of a tree's prose: every [prose text](#language.markup.writing.prose_text) of the files the tree reads itself,
not of its packages, split into regions, with headings, list items, quotes and code
blocks kept as blocks.
</term>

<term id="prose_region">
One block of the [projection](#language.markup.prose_view.prose_projection): a paragraph, a heading, a list item, a quote or a code block,
with its text, its [masked spans](#language.markup.prose_view.masked_span) and its [source map](#language.markup.prose_view.source_map), and the node it belongs to.
</term>

<term id="masked_span">
A range of a region's text that a linter must not read as words. It keeps its source
text, so offsets stay true, and it's listed beside the text with what it masks.
</term>

<term id="source_map">
A region's list of segments, each tying a run of its text to the bytes of the file it
came from. A segment is exact where characters map one to one.
</term>

<term id="prose_lint_provider">
An [extension point](#language.interop.declaring.extension_point) that takes [regions](#language.markup.prose_view.prose_region) and returns findings and fixes against
their text, which the core maps back onto the source.
</term>

<rule id="what_is_projected" targets="prose_projection" by="system.prose_linter">
<must>project `|` lines, `{{ }}` bodies, `=|` values, `///` docs, strings typed `Prose` and [prose files](#language.core_format.prose_layer.prose_file), in file order and then source order</must>
</rule>

<rule id="what_is_not_projected" targets="prose_projection" by="system.prose_linter">
<mustNot>project `do` blocks, code, the values of other types, or the text of a node whose kind accepts `text = Verbatim`</mustNot>
</rule>

<rule id="verbatim_docs" targets="prose_projection" by="system.prose_linter">
<where>a node's kind accepts `text = Verbatim`, as a grammar's `production` does</where>
<must>project the node's `///` docs, though not its text</must>
</rule>

<rule id="regions" targets="prose_region" by="system.prose_linter">
<must>start a region at each paragraph, each line that starts a list item (`-`, `*`, `+`, or a number and `.` or `)`, with an optional `[ ]` or `[x]`), each run of lines starting `>`, each heading of a [prose file](#language.core_format.prose_layer.prose_file) and each fenced block, and end it at an empty line or the next block</must>
<then>a line of three or more `-`, `*` or `_` alone ends the block and isn't projected</then>
</rule>

<rule id="region_context" targets="prose_region" by="system.prose_linter">
<must>give every region its file, its byte range, the path and kind of the node its text belongs to, and where the text was written: `prose`, `block`, `value`, `doc`, `string` or `file`</must>
<then>a provider can scope its checks, such as treating `example` bodies or `nongoal` differently</then>
</rule>

<rule id="element_regions" targets="prose_region" by="system.prose_linter">
<must>give the text of an element that declares a node to that node, in a region of its own, as its text in a [Heron file](#language.core_format.files.heron_file) belongs to it</must>
<then>a term's definition in `<term id="x">…</term>` doesn't ask to link the term, and `should` in a rule's `<must>` is a must's</then>
</rule>

<rule id="masked_spans" targets="masked_span" by="system.prose_linter">
<must>mask inline code, escapes, inserts, [node links](#language.markup.links.node_link) whole, a tag's head with its attributes and its closing tag, and fenced blocks, as `code`, `insert`, `link` or `tag`</must>
<then>no linter reads a name, a path or an attribute as a word</then>
</rule>

<rule id="projected_text" targets="prose_region" by="system.prose_linter">
<must>project the text of a [URL link](#language.markup.links.url_link) and the content of a tag as words, and keep emphasis markers and [table](#heron.language.markup.components.table) cells as the text written</must>
<example>in `<abbr title="simply">Simply a tip</abbr>` the head is masked and `Simply a tip` is read</example>
</rule>

<rule id="no_titles" targets="prose_region" by="system.prose_linter">
<mustNot>project a section's title, since it comes from a name</mustNot>
<while>the section is declared in a [Heron file](#language.core_format.files.heron_file)</while>
</rule>

<rule id="exact_map" targets="source_map" by="system.prose_linter">
<must>map every character of a region's text, in order, to its byte range in the file, and map the space that joins two lines to the whole line break between them, prefix and indentation included</must>
<then>a finding lands on the exact words, and one across a joined break covers the break</then>
</rule>

<rule id="fixes_exact" targets="source_map" by="system.linter">
<must>keep a provider's fix only when its range maps exactly and touches no [masked span](#language.markup.prose_view.masked_span)</must>
<then>an automatic fix never rewrites code, a path or a joined line break</then>
</rule>

<rule id="regions_cached" targets="prose_region" by="system.linter">
<must>cache a provider's findings by the region's content hash, which covers its text and its context, and send a provider only the regions with no cached result</must>
<then>an edit re-lints only the paragraph that changed, and findings of unchanged regions still land where their text now is</then>
</rule>

<rule id="html_projection" targets="prose_projection" by="system.prose_linter">
<must>render regions as one HTML document whose headings, paragraphs, lists, quotes and code blocks keep their elements and whose [masked spans](#language.markup.prose_view.masked_span) are `<code>`, and map each offset of it back to a region and an offset of its text</must>
<then>Vale reads Heron's prose as markup and its ranges come back exact</then>
</rule>

<rule id="providers_in_pipeline" targets="prose_lint_provider" by="system.linter">
<must>report a provider's findings as lints coded with the provider's name and its rule, through the ordinary lint pipeline</must>
<then>`heron lint`, CI and the language server show them without a special case, and `@lint(allow = ["Vale.Spelling"])` suppresses one as it does any lint</then>
</rule>
