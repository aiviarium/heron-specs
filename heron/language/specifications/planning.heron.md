# Open questions {#planning}

While a spec takes shape it has questions still to answer. An answered question becomes
the requirement it asked about, so the question itself would only put an old doubt in
front of an implementer; open questions are kept apart, in a
[planning tree](#language.specifications.planning.planning_tree) that imports the spec.

<term id="planning_tree">
A tree of its own, with an [entry point](#language.core_format.files.entry_point) such
as `planning/index.heron`, that imports the spec tree so its questions can name real
targets.
</term>

<term id="open_kind">
`name: open(targets, owner = …) {{ … }}`, a question still to answer about its
targets, asked in its text, with `owner` naming who answers it.
</term>

<rule id="open_view" targets="open_kind" by="system.docs_generator">
<must>show an open question as a callout labelled "Open question", with its owner and its targets</must>
</rule>

<rule id="open_beside_flag" targets="open_kind" by="actors.author">
<where>a file imports `std/types` beside `std/spec`</where>
<must>write an open question as `spec.open(…)`</must>
<then>the name `open` can't resolve to the `<open>` flag `std/types` gives records, which "open is not a kind or a type" reports</then>
</rule>

<rule id="spec_never_imports_planning" targets="planning_tree" by="actors.author">
<mustNot>import the [planning tree](#language.specifications.planning.planning_tree) from the spec tree</mustNot>
<instead>let the [planning tree](#language.specifications.planning.planning_tree) import the spec, so the spec never loads its questions</instead>
</rule>

<rule id="resolving_translates" targets="open_kind" by="actors.author">
<when>an open question is answered</when>
<must>write the requirement or the `nongoal` it was about, and delete the question</must>
</rule>

<rule id="planning_checks" targets="planning_tree" by="system.linter">
<should>report open questions on targets about to ship</should>
</rule>

<example id="specifications_planning" @display="A planning file">
```heron
// planning/refunds.heron
import = ["std/spec@1", "../refunds/"]

open(refunds.refund_window, owner = "cf") {{
  Do partial refunds reset the window?
}}
```
</example>
