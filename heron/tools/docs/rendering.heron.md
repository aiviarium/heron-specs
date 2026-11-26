# Rendering baseline {#rendering}

Every lens renders by the same baseline, `explore` included: a page reads as text, its
hierarchy comes from headings and the navigation, and structure shows only where the
data has it. How a rule's sentence is built is [the requirements' rendering](#language.specifications.requirements.ears_sentence); these
rules say how it and the nodes around it sit on the page.

<term id="small_table">
Data a page would show as a table that has one column, or fewer than three rows below
its header.
</term>

<rule id="rules_as_prose" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>render a rule as one paragraph holding its sentence, set in the docs body face at the size and level of the page's prose, starting at the left edge of the text column</must>
</rule>

<rule id="no_rule_columns" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<mustNot>render a rule's strength, conditions or consequences in a label column, in a hanging indent, or in a smaller or fainter style than its sentence</mustNot>
</rule>

<rule id="formal_parts_on_hover" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>show a rule's path, targets, subject and strength's keyword in a hover card on its anchor, outside the `explore` lens, which shows them on the page</must>
</rule>

<rule id="target_chip" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<where>a target of a rule is the node the rule stands in, the section that holds it, or a node shown on the same page</where>
<mustNot>show that target as a chip beside the rule</mustNot>
<then>a chip shows only the targets a reader couldn't tell from where the rule is</then>
</rule>

<rule id="chip_leads" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>show a rule's target chips before its sentence, as a tag in the label size on the line above it, never after the sentence's last word</must>
</rule>

<rule id="content_order" targets="tools.docs.rendering" by="system.docs_generator">
<must>render a node's children, outside the `explore` lens, in this order: the nodes rendered in full that are none of the others, such as examples, APIs and diagrams; then its rules, qualities and guidance; then its terms; then its sections; then its diagnostics, and a section that holds only diagnostics; each group in the order the tree writes it</must>
<then>a language page reads as its prose, its rules, the words they use, the concerns below it and, last, the errors it reports, and `explore` keeps the tree's order</then>
</rule>

<rule id="rules_flow" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>separate consecutive rules, terms and diagnostics of one section by the space between two paragraphs, with no border or rule line between them</must>
</rule>

<rule id="tables_for_tabular_data" targets="tools.docs.rendering" by="system.docs_generator">
<must>render as a table only data of at least two columns and at least three rows below its header, such as the fields of a type, the options of a command or a status matrix</must>
</rule>

<rule id="small_tables_as_lines" targets="small_table" by="system.docs_generator">
<where>data the generator would render as a table is a [small table](#tools.docs.rendering.small_table)</where>
<must>render each of its rows as one line, its first cell first and every other cell after the label its column has in the [string catalogue](#tools.frontend.writing.string_catalogue)</must>
<example>a command with one option shows `--addr` String, default `127.0.0.1:7340` on one line, not a table of one row</example>
</rule>

<rule id="authored_tables_kept" targets="small_table" by="system.docs_generator">
<must>render a table written in prose as the table it is, whatever its size</must>
<then>a [small table](#tools.docs.rendering.small_table) in prose is the author's to fix, as [the guide](#guide.kinds.no_small_tables) asks</then>
</rule>

<rule id="lists_stay_lists" targets="tools.docs.rendering" by="system.docs_generator">
<must>render a list written in prose as a list, and a list of nodes, such as a section's terms or a diagnostics index, as a list of entries, never as a table or a grid of cards</must>
</rule>

<rule id="diagnostics_compact" targets="language.specifications.contract.error_kind" by="system.docs_generator">
<must>list the diagnostics of the diagnostics page as compact entries grouped by code: a code with one diagnostic as its code and its message on one line with its fix, the first sentence of its prose, under it; a code with two or more as the code once, with each message and its fix under it</must>
</rule>

<rule id="one_indent" targets="tools.docs.rendering" by="system.docs_generator">
<must>indent a page's content at most one level from the left edge of its text column, and show a node's depth by its heading's level and its place in the navigation</must>
</rule>

<rule id="content_width" targets="tools.docs.rendering" by="system.docs_generator">
<must>set a page's code blocks, tables, callouts, lists and fields to the width of its prose, the measure of the [type scale](#tools.frontend.design_system.tokens.type_scale), and scroll a code block or a table wider than that inside its own frame</must>
<then>every block of a page shares one left and one right edge</then>
</rule>

<rule id="no_nested_boxes" targets="tools.docs.rendering" by="system.docs_generator">
<mustNot>draw a bordered box inside another, or indent a node's children under the node</mustNot>
</rule>
