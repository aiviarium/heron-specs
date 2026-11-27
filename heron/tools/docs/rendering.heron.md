# Rendering baseline {#rendering}

Every lens renders by the same baseline, `explore` included: a page reads as text, its
hierarchy comes from headings and the navigation, and structure shows only where the
data has it. How a rule's sentence is built is [the requirements' rendering](#language.specifications.requirements.ears_sentence); these
rules say how it and the nodes around it sit on the page.

<term id="small_table">
Data a page would show as a [table](#heron.language.markup.components.table) that has one [column](#heron.language.grammar.lexical.column), or fewer than three rows below
its header.
</term>

<rule id="rules_as_prose" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>render a rule as one paragraph holding its sentence, set in the docs body face at the size and level of the page's prose, starting at the left edge of the text [column](#heron.language.grammar.lexical.column)</must>
</rule>

<rule id="no_rule_columns" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<mustNot>render a rule's strength, conditions or consequences in a label [column](#heron.language.grammar.lexical.column), in a hanging indent, or in a smaller or fainter style than its sentence</mustNot>
</rule>

<rule id="formal_parts_on_hover" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>show a rule's path, targets, subject and strength's keyword in a hover card on its anchor, outside the `explore` lens, which shows them on the page</must>
</rule>

<rule id="target_chip" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<where>a target of a rule is the node the rule stands in, the section that holds it, or a node shown on the same page</where>
<mustNot>name that target beside the rule</mustNot>
<then>a rule names only the targets a reader couldn't tell from where it is</then>
</rule>

<rule id="chip_leads" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>name the other targets of a rule after its sentence, as a quiet line in the label size that reads "about" and a link to each, and never as a tag standing alone above the sentence</must>
</rule>

<rule id="term_definition" targets="tools.docs.rendering" by="system.docs_generator">
<must>render a term, outside the glossary, as a definition: the defined word in strong type as a `<dfn>` opening its first sentence, followed by a dash and the definition, at the term's anchor, with the term's icon in the gutter</must>
<then>a reader sees that a paragraph defines a word, never a word in a code pill above a paragraph</then>
</rule>

<rule id="gutter_marks" targets="tools.docs.rendering" by="system.docs_generator">
<where>the lens's `kinds` is `ICON`, as it is unless set</where>
<must>show beside each node a page renders inline as a block of its own, a rule, a goal, a term, a scenario, a use case, a transition or a diagnostic, the icon it shows in the left gutter, level with its first line: muted, in the [project colour](#tools.frontend.design_system.project_colour) on hover, with the node's kind and name as its tooltip and label, and as the link to the node's anchor; and on a narrow screen, before its text; and, before the name of a defined node that has a heading of its own, such as a [lifecycle](#language.specifications.lifecycles.lifecycle), its kind's icon</must>
<then>a reader tells the nodes a page defines from its descriptive prose at a glance, and the text never moves for the mark</then>
</rule>

<rule id="content_order" targets="tools.docs.rendering" by="system.docs_generator">
<must>render a node's children, outside the `explore` lens, in this order: its terms; then its rules, qualities and guidance; then the nodes rendered in full that are none of the others, such as examples, APIs and diagrams; then its sections; then its diagnostics, and a section that holds only diagnostics; each group in the order the tree writes it</must>
<then>a language page reads as its prose, the words it defines, the rules that use them, its contract, the concerns below it and, last, the errors it reports, as the intent, specification and contract [layers](#language.specifications.layers.layer) do, and `explore` keeps the tree's order</then>
</rule>

<rule id="intent_first" targets="tools.docs.rendering" by="system.docs_generator">
<must>render a node's goals and its other intent-layer children, outside the `explore` lens, right after its lead prose and before the groups of [the content order](#tools.docs.rendering.content_order), each as a block marked with its kind's icon, holding its text and its measure</must>
<then>an area reads from its goals down to its rules and then its contract, and a goal never reads as another child page</then>
</rule>

<rule id="goals_not_pages" targets="tools.docs.rendering" by="system.docs_generator">
<mustNot>give a goal a page, an entry in the navigation or a place in the previous and next sequence</mustNot>
<instead>show it on the page of the area or package it belongs to, the package's goals on its home page</instead>
</rule>

<rule id="rules_flow" targets="language.specifications.requirements.rule_kind" by="system.docs_generator">
<must>separate consecutive rules, terms and diagnostics of one section by the space between two paragraphs, with no border or rule line between them</must>
</rule>

<rule id="tables_for_tabular_data" targets="tools.docs.rendering" by="system.docs_generator">
<must>render as a [table](#heron.language.markup.components.table) only data of at least two [columns](#heron.language.grammar.lexical.column) and at least three rows below its header, such as the fields of a type, the options of a command or a status matrix</must>
</rule>

<rule id="small_tables_as_lines" targets="small_table" by="system.docs_generator">
<where>data the generator would render as a [table](#heron.language.markup.components.table) is a [small table](#tools.docs.rendering.small_table)</where>
<must>render each of its rows as one line, its first cell first and every other cell after the label its [column](#heron.language.grammar.lexical.column) has in the [string catalogue](#tools.frontend.writing.string_catalogue)</must>
<example>a command with one option shows `--addr` String, default `127.0.0.1:7340` on one line, not a [table](#heron.language.markup.components.table) of one row</example>
</rule>

<rule id="authored_tables_kept" targets="small_table" by="system.docs_generator">
<must>render a [table](#heron.language.markup.components.table) written in prose as the [table](#heron.language.markup.components.table) it is, whatever its size</must>
<then>a [small table](#tools.docs.rendering.small_table) in prose is the author's to fix, as [the guide](#guide.kinds.no_small_tables) asks</then>
</rule>

<rule id="lists_stay_lists" targets="tools.docs.rendering" by="system.docs_generator">
<must>render a list written in prose as a list, and a list of nodes, such as a section's terms or a diagnostics index, as a list of entries, never as a [table](#heron.language.markup.components.table) or a grid of cards</must>
</rule>

<rule id="diagnostics_compact" targets="language.specifications.contract.error_kind" by="system.docs_generator">
<must>list the diagnostics of the diagnostics page as compact entries grouped by code: a code with one diagnostic as its code and its message on one line with its fix, the first sentence of its prose, under it; a code with two or more as the code once, with each message and its fix under it</must>
</rule>

<rule id="one_indent" targets="tools.docs.rendering" by="system.docs_generator">
<must>indent a page's content at most one level from the left edge of its text [column](#heron.language.grammar.lexical.column), and show a node's depth by its heading's level and its place in the navigation</must>
</rule>

<rule id="content_width" targets="tools.docs.rendering" by="system.docs_generator">
<must>set every block of a page, prose, rules, callouts, lists, fields, code blocks, [tables](#heron.language.markup.components.table), examples and diagrams, to the page's one width, the measure of the [type scale](#tools.frontend.design_system.tokens.type_scale), whatever the page holds, and scroll a code block or a [table](#heron.language.markup.components.table) wider than that inside its own frame; an op's examples stand in the right [column](#heron.language.grammar.lexical.column), at its width</must>
<then>every block of a page shares one left and one right edge, and that width is the same on every page</then>
</rule>

<rule id="no_nested_boxes" targets="tools.docs.rendering" by="system.docs_generator">
<mustNot>draw a bordered box inside another, or indent a node's children under the node</mustNot>
</rule>
