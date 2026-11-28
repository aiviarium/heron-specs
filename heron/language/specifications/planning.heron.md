# Open questions {#planning}

While a spec takes shape it has questions still to answer. An answered question becomes
the requirement it asked about, so the question itself would only put an old doubt in
front of an implementer; open questions are kept apart, in a
[planning tree](#language.specifications.planning.planning_tree) that imports the spec.

<term id="planning_tree">
A tree of its own, with an [entry point](#language.core_format.files.entry_point) such
as `planning/index.heron`, that imports the spec tree so its questions can link real
nodes.
</term>

<term id="open_kind">
`open(owner = "…") {{ … }}`, a question still to answer, asked in its text, which links
what it's about, with `owner` naming who answers it.
</term>

<rule id="open_view" refs="system.docs_generator">
<must>show an open question as a callout labelled "Open question", with its owner</must>
</rule>

<rule id="open_beside_flag" refs="actors.author">
<while>a file imports `std/types`, beside the core's `std/spec`</while>
<must>write an open question as `spec.open {{ … }}`</must>
<then>the name `open` can't resolve to the `<open>` flag `std/types` gives records, which "open is not a kind or a type" reports</then>
</rule>

<rule id="spec_never_imports_planning" refs="actors.author">
<must_not>import the [planning tree](#language.specifications.planning.planning_tree) from the spec tree</must_not>
<instead>let the [planning tree](#language.specifications.planning.planning_tree) import the spec, so the spec never loads its questions</instead>
</rule>

<rule id="resolving_translates" refs="actors.author">
<when>an open question is answered</when>
<must>write the requirement or the `nongoal` it was about, and delete the question</must>
</rule>

<rule id="planning_checks" refs="system.linter">
<should>report open questions whose prose links a node about to ship</should>
</rule>

<example id="specifications_planning" @display="A planning file">
```heron
// planning/refunds.heron
import = ["../refunds/"]

open(owner = "cf") {{
  Do partial refunds reset the [refund window](#refunds.refund_window)?
}}
```
</example>
