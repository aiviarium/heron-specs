# Rendering baseline {#rendering}

Every lens renders by the same baseline, `explore` included: a page reads as text, its
hierarchy comes from headings and the navigation, and structure shows only where the
data has it. How a rule's sentence is built is [the requirements' rendering](#language.specifications.requirements.ears_sentence); these
rules say how it and the nodes around it sit on the page.

<term id="small_table">
Data a page would show as a [table](#heron.language.markup.components.table) that has one [column](#heron.language.grammar.lexical.column), or fewer than three rows below
its header.
</term>

<rule id="rules_as_prose" refs="system.docs_generator">
<must>render a rule as one paragraph holding its sentence, set in the docs body face at the size and level of the page's prose, starting at the left edge of the text [column](#heron.language.grammar.lexical.column)</must>
</rule>

<rule id="no_rule_columns" refs="system.docs_generator">
<must_not>render a rule's strength, conditions or consequences in a label [column](#heron.language.grammar.lexical.column), in a hanging indent, or in a smaller or fainter style than its sentence</must_not>
</rule>

<rule id="formal_parts_on_hover" refs="system.docs_generator">
<must>show a rule's path, its subject, its strength's keyword and the goals, qualities and assumptions it references in a hover card on its anchor, outside the `explore` lens, which shows them on the page</must>
</rule>

<rule id="term_definition" refs="system.docs_generator">
<must>render a term, outside the glossary, as a definition: the defined word in strong type as a `<dfn>` opening its first sentence, followed by a dash and the definition, at the term's anchor, with the term's icon in the gutter</must>
<then>a reader sees that a paragraph defines a word, never a word in a code pill above a paragraph</then>
</rule>

<rule id="gutter_marks" refs="system.docs_generator">
<while>the lens's `kinds` is `ICON`, as it is unless set</while>
<must>show beside each node a page renders inline as a block of its own, a rule, a goal, a term, a scenario, a use case, a transition or a diagnostic, the icon it shows in the left gutter, level with its first line: muted, in the [project colour](#tools.docs.design_system.project_colour) on hover, with the node's kind and name as its tooltip and label, and as the link to the node's anchor; and on a narrow screen, before its text; and, before the name of a defined node that has a heading of its own, such as a [lifecycle](#language.specifications.lifecycles.lifecycle), its kind's icon</must>
<then>a reader tells the nodes a page defines from its descriptive prose at a glance, and the text never moves for the mark</then>
</rule>

<rule id="content_order" refs="system.docs_generator">
<must>render a node's children, outside the `explore` lens, in this order: its terms; then its rules, qualities and guidance; then the nodes rendered in full that are none of the others, such as examples, APIs and diagrams; then its sections; then its diagnostics, and a section that holds only diagnostics; each group in the order the tree writes it</must>
<then>a language page reads as its prose, the words it defines, the rules that use them, its contract, the concerns below it and, last, the errors it reports, as the intent, specification and contract [layers](#language.specifications.layers.layer) do, and `explore` keeps the tree's order</then>
</rule>

<rule id="intent_first" refs="system.docs_generator">
<must>render a node's goals and its other intent-layer children, outside the `explore` lens, right after its lead prose and before the groups of its other children, each as a block marked with its kind's icon, holding its text and its measure</must>
<then>an area reads from its goals down to its rules and then its contract, and a goal never reads as another child page</then>
</rule>

<rule id="goals_not_pages" refs="system.docs_generator">
<must_not>give a goal a page, an entry in the navigation or a place in the previous and next sequence</must_not>
<instead>show it on the page of the area or package it belongs to, the package's goals on its home page</instead>
</rule>

<rule id="rules_flow" refs="system.docs_generator">
<must>separate consecutive rules, terms and diagnostics of one section by the space between two paragraphs, with no border or rule line between them</must>
</rule>

<rule id="tables_for_tabular_data" refs="system.docs_generator">
<must>render as a [table](#heron.language.markup.components.table) only data of at least two [columns](#heron.language.grammar.lexical.column) and at least three rows below its header, such as the fields of a type, the options of a command or a status matrix</must>
</rule>

<rule id="small_tables_as_lines" refs="system.docs_generator">
<while>data the generator would render as a [table](#heron.language.markup.components.table) is a [small table](#tools.docs.rendering.small_table)</while>
<must>render each of its rows as one line, its first cell first and every other cell after the label its [column](#heron.language.grammar.lexical.column) has in the [string catalogue](#tools.docs.writing.string_catalogue)</must>
<example>a command with one option shows `--addr` String, default `127.0.0.1:7340` on one line, not a [table](#heron.language.markup.components.table) of one row</example>
</rule>

<rule id="authored_tables_kept" refs="system.docs_generator">
<must>render a [table](#heron.language.markup.components.table) written in prose as the [table](#heron.language.markup.components.table) it is, whatever its size</must>
<then>a [small table](#tools.docs.rendering.small_table) in prose is the author's to fix, as [the guide](#guide.kinds) asks</then>
</rule>

<rule id="lists_stay_lists" refs="system.docs_generator">
<must>render a list written in prose as a list, and a list of nodes, such as a section's terms or a diagnostics index, as a list of entries, never as a [table](#heron.language.markup.components.table) or a grid of cards</must>
</rule>

<rule id="diagnostics_compact" refs="system.docs_generator">
<must>list the diagnostics of the diagnostics page as compact entries grouped by code: a code with one diagnostic as its code and its message on one line with its fix, the first sentence of its prose, under it; a code with two or more as the code once, with each message and its fix under it</must>
</rule>

<rule id="one_indent" refs="system.docs_generator">
<must>indent a page's content at most one level from the left edge of its text [column](#heron.language.grammar.lexical.column), and show a node's depth by its heading's level and its place in the navigation</must>
</rule>

<rule id="content_width" refs="system.docs_generator">
<must>set every block of a page, prose, rules, callouts, lists, fields, code blocks, [tables](#heron.language.markup.components.table), examples and diagrams, to the page's one width, the measure of the type scale of the [design tokens](#tools.docs.design_system.tokens), whatever the page holds, and scroll a code block or a [table](#heron.language.markup.components.table) wider than that inside its own frame; an op's examples stand in the right [column](#heron.language.grammar.lexical.column), at its width</must>
<then>every block of a page shares one left and one right edge, and that width is the same on every page</then>
</rule>

<rule id="no_nested_boxes" refs="system.docs_generator">
<must_not>draw a bordered box inside another, or indent a node's children under the node</must_not>
</rule>
