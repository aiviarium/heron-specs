# Lens marks {#lens_marks}

A [lens mark](#tools.docs.lenses.lens_mark), `@lens(names…)`, says which [lenses](#tools.docs.lenses.lens_kind) of the docs a node or a piece of prose
is for. On a node it's an annotation like any other; on prose it marks one [prose run](#language.markup.lens_marks.prose_run),
so a section can say one thing to its users and another to its implementers. Every
element accepts it as an attribute, so in a [prose file](#language.core_format.prose_layer.prose_file) a marked paragraph is
`<p @lens="user, developer">…</p>`, or the same mark on any element that wraps it.
[A marked prose run](#language.markup.lens_marks.marked_prose_example) shows both.

<term id="prose_run">
One run of a node's own text: consecutive `|` lines, up to the first member that isn't
one, one `{{ }}` body, or one block of a [prose file](#language.core_format.prose_layer.prose_file). A [lens mark](#tools.docs.lenses.lens_mark) on the line above a run applies to the whole run,
its paragraphs included.
</term>

<rule id="mark_attaches" targets="prose_run" by="product.system.parser">
<must>attach an annotation on the lines directly above a run of `|` lines, or on a `{{ }}` body, to that [prose run](#language.markup.lens_marks.prose_run), as the annotations of any member attach</must>
</rule>

<rule id="mark_splits_run" targets="prose_run" by="product.system.parser">
<must>end a run of `|` lines at an annotation line, and start a new [prose run](#language.markup.lens_marks.prose_run) with the `|` lines after it</must>
<then>two marked blocks can follow each other with nothing between them but the second's mark</then>
</rule>

<rule id="one_text_still" targets="prose_run" by="product.system.checker">
<must>join a node's [prose runs](#language.markup.lens_marks.prose_run) into its one text, in the order written, as paragraphs</must>
<then>a mark changes which lenses show a block, never what the node's text is</then>
</rule>

<rule id="mark_checked_on_prose" targets="prose_run" by="product.system.checker">
<must>check a [lens mark](#tools.docs.lenses.lens_mark) on a [prose run](#language.markup.lens_marks.prose_run) as one on a node, reporting [unknown lens](#tools.docs.lenses.diagnostics.unknown_lens) and [not a lens](#tools.docs.lenses.diagnostics.not_a_lens) at the name</must>
</rule>

<rule id="element_marks" targets="prose_run" by="product.system.checker">
<where>an element that declares no node has an `@lens` attribute, as `<p @lens="user, developer">…</p>`</where>
<must>read it as a [lens mark](#tools.docs.lenses.lens_mark) on the element's content, checked as one on a [prose run](#language.markup.lens_marks.prose_run)</must>
<then>a prose file's block that is such an element is a marked [prose run](#language.markup.lens_marks.prose_run), as `|` lines under `@lens(user, developer)` are</then>
</rule>

<rule id="element_marks_shown" targets="prose_run" by="product.system.docs_generator">
<where>an element inside a [prose run](#language.markup.lens_marks.prose_run) carries a [lens mark](#tools.docs.lenses.lens_mark)</where>
<must>render its content only in the lenses the mark names, and in explore with the mark's lenses beside it, as a marked run renders</must>
</rule>

<rule id="only_lens_on_prose" targets="prose_run" by="product.system.linter">
<if>a [prose run](#language.markup.lens_marks.prose_run) carries an annotation other than `@lens`</if>
<should>report [annotation placement](#language.schemas.annotations.diagnostics.annotation_misplaced) at it</should>
</rule>

<example id="marked_prose_example" @display="A marked prose run">
```heron
import = ["std/doc@1", "std/docs@1"]

refunds: section {
  @lens(user)
  | Open the payment and press **Refund**. A refund can't be undone.

  @lens(developer, explore)
  | A refund moves the payment from `captured` to `refunded`, and the ledger records
  | it once the provider confirms.
}

docs {
  lenses = [user, developer, explore]
}
```
</example>
