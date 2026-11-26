# Layout of a spec tree {#layout}

A spec is a tree of [Heron files](#language.core_format.files.heron_file) like any
other, so its layout is the core format's: an entry file includes the rest, and a
folder included as `./name/` becomes a scope of that name. What a spec adds is where
each kind goes, so that an implementer loads one subtree and the surface of what it
targets, and nothing else until a link leads there. Heron's own spec follows this
layout, as its [guide](#guide.layout) says.

<term id="feature_subtree">
A feature's section in its entry file, with its terms, guidance and scenarios in
sibling files the entry includes, as a feature's entry file
does, so a tool can load or leave out each part.
</term>

<rule id="entry_file_holds_section" targets="feature_subtree" by="actors.author">
<should>hold a feature's section in its folder's entry file, and its terms, guidance and scenarios in sibling files the entry includes</should>
</rule>

<rule id="one_subtree" targets="feature_subtree" by="actors.implementer">
<should>load one [feature subtree](#language.specifications.layout.feature_subtree) and the surface of its targets, and load anything else only when a link leads there</should>
</rule>

<rule id="planning_apart" targets="feature_subtree" by="actors.author">
<mustNot>put an open question where the [entry point](#language.core_format.files.entry_point) of an implementer reaches it on the way to the requirements</mustNot>
<instead>keep it in a [planning tree](#language.specifications.planning.planning_tree)</instead>
</rule>

<example id="specifications_feature_layout" @display="A feature's entry file">
```heron
// refunds/index.heron
include = [
  "./window.heron",      // refund_window and its requirements
  "./scenarios.heron",
  "./terms.heron",
  "./guidance.heron",
]
```
</example>
