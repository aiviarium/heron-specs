# Explore view {#explore}

The `explore` lens is the full information of the tree, the view an implementer, a
reviewer or an agent reads: every node, its formal parts, and which lenses each node is
for. It's denser than the other lenses and follows the same
[rendering baseline](#tools.docs.rendering).

<rule id="formal_parts" targets="tools.docs.explore" by="system.docs_generator">
<must>show, in the `explore` lens, under each rule's sentence one line of its facts: its path, its targets, its subject and its strength's keyword, each as inline code</must>
<then>the formal parts the other lenses keep for a rule's hover are on the page in `explore`</then>
</rule>

<rule id="marks_shown" targets="tools.docs.lenses.lens_mark" by="system.docs_generator">
<must>show, in the `explore` lens, beside each node and [prose run](#language.markup.lens_marks.prose_run) that carries a [lens mark](#tools.docs.lenses.lens_mark), the `title` of each lens the mark names, as quiet tags in one row at the start of what's marked, in the mark's order</must>
</rule>

<rule id="kinds_shown" targets="tools.docs.explore" by="system.docs_generator">
<must>show, in the `explore` lens, every node's kind beside its name, rules and diagnostics included</must>
</rule>

<rule id="every_anchor" targets="tools.docs.explore" by="system.docs_generator">
<must>give every named node an anchor in the `explore` lens, at its path on the page of its nearest [page node](#tools.docs.site.page_node)</must>
<then>every link to a node that another lens leaves out has a place to open</then>
</rule>
