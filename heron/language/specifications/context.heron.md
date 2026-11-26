# Features and context {#context}

A feature is a `section`: its intent in `|` text, then what it leaves out and its
requirements as children. Around the requirements stands what helps build them without
being required behaviour: the domain's words, hints for implementers and the
flags that let a reader find what cuts across features.

<term id="feature_section">
`name: section { … }` holding a feature: its `|` text says the intent, an
`outOfScope` says what's left out, and its rules, [lifecycles](#language.specifications.lifecycles.lifecycle) and qualities follow.
Sections nest and are referenced by path, as `refund_window.late_rejected`.
</term>

<term id="out_of_scope">
`name: outOfScope {{ … }}`, something a reader could reasonably expect the feature to
cover that's deliberately left out.
</term>

<term id="cross_cutting_section">
A section flagged `<security>`, `<privacy>` or `<operations>`. It holds requirements
like any other, and the flag lets reviews and deciders find it and load it on its own.
</term>

<term id="term_kind">
`name: term {{ … }}`, a word of the domain defined once, where its domain is. Its
name read as words is the phrase it defines, so `capture_date` defines "capture
date", and `aliases = […]` lists the synonyms it rules out. Prose links to it as
`[capture date](#capture_date)`, a checked reference.
</term>

<term id="guidance_kind">
`guidance(targets) {{ … }}`, hints for whoever builds its targets, such as an internal
API to use or a convention to follow.
</term>

<term id="passage">
A named span of wording, `<span name="window_wording">…</span>`, that [coverage](#language.specifications.traceability.coverage) can
point at when the wording itself must be covered.
</term>

<rule id="out_of_scope_not_built" targets="out_of_scope" by="product.actors.implementer">
<mustNot>build what a feature puts [out of scope](#language.specifications.context.out_of_scope)</mustNot>
</rule>

<rule id="out_of_scope_shown" targets="out_of_scope" by="product.system.docs_generator">
<must>show an `outOfScope` and a `guidance` as callouts labelled "[Out of scope](#language.specifications.context.out_of_scope)" and "Guidance", with their text</must>
</rule>

<rule id="flags_on_sections" targets="cross_cutting_section" by="product.system.linter">
<should>report [flag placement](#language.schemas.flags.diagnostics.flag_misplaced) at `<security>`, `<privacy>` or `<operations>` on anything but a section</should>
</rule>

<rule id="terms_linked" targets="term_kind" by="product.system.prose_linter">
<should>report [unlinked term](#language.specifications.quality_checks.diagnostics.unlinked_term) where prose outside the term uses its phrase without linking it, and [ruled-out synonym](#language.specifications.quality_checks.diagnostics.ruled_out_synonym) where it uses one of its [aliases](#language.data.values.alias)</should>
<then>a fix offered with it links the phrase, or replaces the [alias](#language.data.values.alias) with the linked term</then>
</rule>

<rule id="one_sense" targets="term_kind" by="product.system.prose_linter">
<should>report [two senses](#language.specifications.quality_checks.diagnostics.two_senses) at each of two terms that define one phrase, by name or by [alias](#language.data.values.alias)</should>
</rule>

<rule id="term_shown" targets="term_kind" by="product.system.docs_generator">
<must>show a term as an entry of a definition list, its name and its text</must>
</rule>

<rule id="guidance_not_required" targets="guidance_kind" by="product.system.linter">
<mustNot>count guidance as a requirement or as covered</mustNot>
</rule>

<rule id="stale_guidance" targets="guidance_kind" by="product.system.linter">
<if>guidance names a symbol of the code that no longer exists</if>
<should>report the name as a [dead link](#language.specifications.quality_checks.diagnostics.dead_link)</should>
</rule>

<rule id="values_in_surface" targets="feature_section" by="product.actors.author">
<should>keep the values code depends on in the surface or the data, as a type, a [value binding](#language.data.configuration.value_binding) or a quality, rather than in a rule's text</should>
<example>a rule mentions "30 days", and the value an implementation reads comes from a type</example>
</rule>

<rule id="out_of_scope_hint" targets="feature_section" by="product.system.linter">
<if>a section holds requirements and no `outOfScope`</if>
<may>give a hint that the section says nothing of what it leaves out</may>
</rule>
