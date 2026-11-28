# Diagrams {#diagrams}

Diagrams are laid out by the docs generator when the docs are generated and written as SVG coloured
from the theme's tokens, so they work without a script.

<rule id="svg_layout" refs="system.docs_generator">
<must>place a diagram's nodes in [layers](#heron.language.specifications.layers.layer) by their distance from the roots, rows in the order the tree writes them, draw forward edges as curves from right to left sides and edges back or within a [layer](#heron.language.specifications.layers.layer) as arcs below the boxes, behind a faint dot grid</must>
</rule>

<rule id="diagram_style" refs="system.docs_generator">
<must>draw states as bordered boxes on the raised colour, mark initial and final states by their shape, label transitions with their name and the op that performs them in the [project colour](#tools.docs.design_system.project_colour), and mark a transition nothing performs in the warning colour</must>
</rule>

<rule id="table_view" refs="system.docs_generator">
<must>give every diagram a [table](#heron.language.markup.components.table) with the same information, and a switch between the two</must>
</rule>

<rule id="task_graph" refs="system.docs_generator">
<while>a node holds tasks and one of them `@needs` another</while>
<must>show its tasks and their needs as a dependency graph</must>
</rule>

<rule id="package_graph" refs="system.docs_generator">
<while>a tree imports a local package</while>
<must>show the packages the tree imports, with their own imports, as a dependency graph on the home page</must>
</rule>

<rule id="coverage_graph" refs="system.docs_generator">
<when>the tree has proofs linking its rules to tests</when>
<must>show what covers each rule as a graph</must>
</rule>
