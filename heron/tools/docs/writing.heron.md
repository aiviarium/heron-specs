# Writing in the interface {#writing}

Pages and tools carry labels, values and structure, not explanations. Every sentence a
reader meets comes from a spec; what the tools add is a label from [the catalogue](#tools.docs.writing.string_catalogue).
Some rules bind the tools, which a reader can check on every page; the rest bind the
implementer who writes the view and the reviewer of it.

<term id="string_catalogue" aliases={["string catalogue"]}>
The catalogue of every string the tools show that doesn't come from a spec, in
`strings.json`, keyed `<tool>.<group>.<name>`: the docs read `docs.*` and their islands
`docs.island.*`.
</term>

## Visible text {#visible_text}

<rule id="docs_text_sourced" refs="system.docs_generator">
<must>show on a docs page only words that come from the spec (its files, or the standard packages its kinds are declared in) or from the catalogue, besides numbers and punctuation</must>
</rule>

## Catalogue wording {#catalogue_wording}

<rule id="labels_not_sentences" refs="system.docs_generator">
<mustNot>hold an entry that ends with a full stop</mustNot>
<then>the docs show no helper sentences, no intro lines saying what a page or panel shows, and no paragraphs in empty states</then>
</rule>

<rule id="no_generated_tells" refs="system.docs_generator">
<mustNot>hold "seamless", "powerful", "effortless", "Let's", "Note that", "Learn more", "Powered by", "Auto-generated", "New", an exclamation mark, a question mark, an emoji or a sparkle</mustNot>
</rule>

<rule id="interface_style" refs="system.prose_linter">
<must>lint `strings.json` with a Vale style for interface text, as the prose lints lint the spec</must>
</rule>

## Composing text {#composing_text}

These bind whoever writes a view or a catalogue entry.

<rule id="empty_states" refs="actors.implementer">
<must>show an empty state as a short label and, if there is one, the action</must>
</rule>

<rule id="meaningful_badges" refs="actors.implementer">
<must>show a badge only where it changes what the reader does: the HTTP method, required, deprecated, not yet stable, and the version something was added or removed in</must>
<example>no "New", no "Auto-generated", no count of things already visible</example>
</rule>

<rule id="nothing_redundant" refs="actors.implementer">
<mustNot>show a label that repeats its heading, an overview that restates the children, a tooltip that repeats the visible text, or a section for an empty field</mustNot>
<example>"Returns the order" under a return type of `Order` is redundant</example>
</rule>

<rule id="labels" refs="actors.implementer">
<must>write labels short and in sentence case, buttons as verbs such as Run, Copy or Open, and an error as one line saying what's wrong and where, with the fix as an action when there is one</must>
</rule>

<rule id="tables_earn_their_place" refs="actors.implementer">
<mustNot>lay out as a [table](#heron.language.markup.components.table) what has one [column](#heron.language.grammar.lexical.column) or fewer than three rows</mustNot>
<instead>write a list, or one line per row, and keep [tables](#heron.language.markup.components.table) for data with [columns](#heron.language.grammar.lexical.column) to compare, such as options with their types and defaults</instead>
</rule>

<rule id="no_closing_summary" refs="actors.implementer">
<mustNot>close a page with a summary, ask a rhetorical question, or use a "Learn more" link that doesn't say where it goes</mustNot>
</rule>
