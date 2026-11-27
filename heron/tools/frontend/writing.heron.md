# Writing in the interface {#writing}

Pages and tools carry labels, values and structure, not explanations. Every sentence a
reader meets comes from a spec; what the tools add is a label from [the catalogue](#tools.frontend.writing.string_catalogue).
Some rules bind the tools, which a reader can check on every page; the rest bind the
implementer who writes the view and the reviewer of it.

<term id="string_catalogue" aliases={["string catalogue"]}>
The catalogue of every string the tools show that doesn't come from a spec, in
`strings.json`, keyed `<tool>.<group>.<name>`: the docs read `docs.*`, their islands
`docs.island.*`, and the app `app.*`.
</term>

## Visible text {#visible_text}

<rule id="docs_text_sourced" @targets="tools.frontend.writing.visible_text" @by="system.docs_generator">
<must>show on a docs page only words that come from the spec (its files, or the standard packages its kinds are declared in) or from the catalogue, besides numbers and punctuation</must>
</rule>

<rule id="app_text_sourced" @targets="tools.frontend.writing.visible_text" @by="system.editor">
<must>show on the [editor screen](#tools.frontend.screens.editor_screen) only text from the spec of the served tree and the standard packages it uses, or from the catalogue, in every label, input hint and title a person reads, the palette and the problems panel included</must>
<while>the shell itself draws the text, outside the code in the editor and Monaco's own widgets, such as the find widget's labels</while>
</rule>

<rule id="tools_text_in_widgets" @targets="tools.frontend.writing.visible_text" @by="system.editor">
<must>take what the tools put into Monaco's widgets from the spec or the catalogue: hover contents, diagnostics, code action titles, completion items and the problem hover, with Monaco's extra links removed from it</must>
</rule>

## Catalogue wording {#catalogue_wording}

<rule id="labels_not_sentences" @targets="tools.frontend.writing.catalogue_wording" @by="system.editor">
<mustNot>hold an entry that ends with a full stop</mustNot>
<then>the tools show no helper sentences, no intro lines saying what a page or panel shows, and no paragraphs in empty states</then>
</rule>

<rule id="no_generated_tells" @targets="tools.frontend.writing.catalogue_wording" @by="system.editor">
<mustNot>hold "seamless", "powerful", "effortless", "Let's", "Note that", "Learn more", "Powered by", "Auto-generated", "New", an exclamation mark, a question mark, an emoji or a sparkle</mustNot>
</rule>

<rule id="interface_style" @targets="tools.frontend.writing.catalogue_wording" @by="system.prose_linter">
<must>lint `strings.json` with a Vale style for interface text, as the prose lints lint the spec</must>
</rule>

## Composing text {#composing_text}

These bind whoever writes a view or a catalogue entry.

<rule id="empty_states" @targets="tools.frontend.writing.composing_text" @by="actors.implementer">
<must>show an empty state as a short label and, if there is one, the action</must>
</rule>

<rule id="meaningful_badges" @targets="tools.frontend.writing.composing_text" @by="actors.implementer">
<must>show a badge only where it changes what the reader does: the HTTP method, required, deprecated, not yet stable, and the version something was added or removed in</must>
<example>no "New", no "Auto-generated", no count of things already visible</example>
</rule>

<rule id="nothing_redundant" @targets="tools.frontend.writing.composing_text" @by="actors.implementer">
<mustNot>show a label that repeats its heading, an overview that restates the children, a tooltip that repeats the visible text, or a section for an empty field</mustNot>
<example>"Returns the order" under a return type of `Order` is redundant</example>
</rule>

<rule id="labels" @targets="tools.frontend.writing.composing_text" @by="actors.implementer">
<must>write labels short and in sentence case, buttons as verbs such as Run, Copy or Open, and an error as one line saying what's wrong and where, with the fix as an action when there is one</must>
</rule>

<rule id="tables_earn_their_place" @targets="tools.frontend.writing.composing_text" @by="actors.implementer">
<mustNot>lay out as a [table](#heron.language.markup.components.table) what has one [column](#heron.language.grammar.lexical.column) or fewer than three rows</mustNot>
<instead>write a list, or one line per row, and keep [tables](#heron.language.markup.components.table) for data with [columns](#heron.language.grammar.lexical.column) to compare, such as options with their types and defaults</instead>
</rule>

<rule id="no_closing_summary" @targets="tools.frontend.writing.composing_text" @by="actors.implementer">
<mustNot>close a page with a summary, ask a rhetorical question, or use a "Learn more" link that doesn't say where it goes</mustNot>
</rule>
