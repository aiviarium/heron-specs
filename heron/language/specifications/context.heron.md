# Features and context {#context}

A feature is one capability of the product as its users see it, `feature(refs…)`: the
goals and qualities it serves and the actors it's for as its references, its intent in its
text, then what it leaves out and its requirements as children. Features nest, and a
section is markup only, a titled part of a page that groups nothing a reader or a tool
counts. Around the requirements stands what helps build them without being required
behaviour: the domain's words, hints for implementers and the flags that let a reader find
what cuts across features.

<term id="feature_kind">
`name: feature(refs…) { … }`, a capability of the product: its references name the goals
and qualities it serves and the actors it's for, its `|` text says the intent, a `nongoal`
says what's left out, and its rules, use cases, scenarios, [lifecycles](#language.specifications.lifecycles.lifecycle), terms and
guidance follow. Features nest and are referenced by path, as
`refunds.late_rejected`. A rule elsewhere joins a feature by referencing it.
</term>

<term id="optional_feature">
A feature with `optional = true`: one a product may leave out, as a plan or a build
configuration decides. A rule's `where` links the optional feature it applies with.
</term>

<term id="cross_cutting_feature">
A feature flagged `<security>`, `<privacy>` or `<operations>`. It holds requirements like
any other, and the rules of other features join it by referencing it; the flag lets reviews
and deciders find it and load it on its own.
</term>

<term id="term_kind">
`name: term {{ … }}`, a word of the domain defined once, where its domain is, from
`std/spec`. Its name read as words is the phrase it defines, so `capture_date` defines
"capture date", and `aliases = […]` lists the synonyms it rules out. Prose links to it as
`[capture date](#capture_date)`, a checked reference.
</term>

<term id="guidance_kind">
`guidance {{ … }}`, hints for whoever builds what its prose links, such as an internal API to
use or a convention to follow.
</term>

<term id="passage">
A named span of wording, `<span name="window_wording">…</span>`, that [coverage](#language.specifications.traceability.coverage) can
point at when the wording itself must be covered.
</term>

<rule id="feature_members" refs="system.checker">
<must>count among a feature's requirements the rules, constraints, use cases, scenarios and [lifecycles](#language.specifications.lifecycles.lifecycle) it holds, at any depth outside a nested feature, and the rules anywhere that reference it</must>
<then>a rule of the checker in the docs feature that references the security feature counts in both</then>
</rule>

<rule id="out_of_scope_not_built" refs="actors.implementer">
<must_not>build what a feature puts [leaves out](#language.specifications.intent.nongoal_kind)</must_not>
</rule>

<rule id="out_of_scope_shown" refs="system.docs_generator">
<must>show a `nongoal` and a `guidance` as callouts labelled "Not a goal" and "Guidance", with their text</must>
</rule>

<rule id="features_index" refs="system.docs_generator">
<must>render a Features page that lists every feature, nested as they nest, with its goals, an "Optional" mark on an [optional feature](#language.specifications.context.optional_feature), its flags and the number of its requirements, each linked to its page</must>
</rule>

<rule id="feature_page" refs="system.docs_generator">
<must>give each feature a page of its own with its text, the goals, qualities and actors it references as facts, its requirements, those it holds and those that reference it, grouped by kind, and their [coverage](#heron.language.specifications.traceability.coverage): the count of them a scenario, an example or a proof covers out of all of them, and the list of those none covers</must>
</rule>

<rule id="flags_on_features" refs="system.linter">
<should>report flag placement at `<security>`, `<privacy>` or `<operations>` on anything but a feature</should>
</rule>

<rule id="terms_linked" refs="system.prose_linter">
<should>report unlinked term where prose outside the term uses its phrase without linking it, and ruled-out synonym where it uses one of its [aliases](#language.data.values.alias)</should>
<then>a fix offered with it links the phrase, or replaces the [alias](#language.data.values.alias) with the linked term</then>
</rule>

<rule id="one_sense" refs="system.prose_linter">
<should>report two senses at each of two terms that define one phrase, by name or by [alias](#language.data.values.alias)</should>
</rule>

<rule id="term_shown" refs="system.docs_generator">
<must>show a term as an entry of a definition list, its name and its text</must>
</rule>

<rule id="guidance_not_required" refs="system.linter">
<must_not>count guidance as a requirement or as covered</must_not>
</rule>

<rule id="stale_guidance" refs="system.linter">
<if>guidance names a symbol of the code that no longer exists</if>
<should>report the name as a dead link</should>
</rule>

<rule id="values_in_surface" refs="actors.author">
<should>keep the values code depends on in the surface or the data, as a type, a [value binding](#language.data.configuration.value_binding) or a quality, rather than in a rule's text</should>
<example>a rule mentions "30 days", and the value an implementation reads comes from a type</example>
</rule>

<rule id="capabilities_as_features" refs="actors.author">
<should>write each capability of the product as a feature, and a section only to title a part of a page</should>
<then>a section that holds requirements groups them for reading alone, and the docs, the gaps and the [agent export](#heron.tools.docs.agents.agent_export) count them by the feature it stands in</then>
</rule>

<rule id="out_of_scope_hint" refs="system.linter">
<if>a feature holds requirements and no `nongoal`</if>
<may>give a hint that the feature says nothing of what it leaves out</may>
</rule>

<example id="feature_example" @display="A feature and a cross-cutting one">
```heron
import = ["std/doc@1"]

self_service: goal {{ Customers fix a wrong charge themselves. }}

customer: actor {{ Someone who paid with the shop. }}

payments_security: feature<security> {{ What keeps a payment and its refunds safe. }}

refunds: feature(self_service, customer) {
  | Customers refund a captured payment themselves, within the window.

  no_cash: nongoal {{ Refunds in cash at a store. }}

  late_rejected: rule(self_service) {
    if {{ a refund arrives more than 30 days after capture }}
    must {{ reject the request }}
  }

  card_only: rule(payments_security) {
    must {{ refund to the card the payment was captured from }}
  }

  gift_cards: feature(optional = true) {
    | Refunds to a gift card instead of the card.

    gift_card_limit: rule {
      where {{ [refunds.gift_cards] }}
      must {{ refund at most the payment's amount to one gift card }}
    }
  }
}
```
</example>
