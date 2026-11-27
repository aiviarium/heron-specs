# Sparrow {#sparrow}

An extra for outside tooling, like [Protobuf](#tools.proto): the tree's Sparrow RPC facets,
generated on demand, as the canonical CBOR a Sparrow peer publishes and hashes, so a server
built on Sparrow's reference library serves a Heron api as it's described, and a client checks it
against the facet hash the docs show. Every name, id and tag in them is the one
[Sparrow](#language.apis.sparrow) gives.

<rule id="sparrow_target" targets="tools.sparrow" by="system.generator">
<must>write, for `heron generate sparrow`, each facet of the tree as `.heron/sparrow/<facet>.sparrow`, the facet's canonical CBOR, beside `<facet>.json`, and every facet together, as Sparrow's `schema` document, as `schema.sparrow` and `schema.json`</must>
<example>`acme.parcels` is written to `.heron/sparrow/acme.parcels.sparrow`</example>
</rule>

<rule id="sparrow_contents" targets="tools.sparrow" by="system.generator">
<must>write each `.sparrow` file in Sparrow's Core Deterministic encoding of the canonical facet, or of the canonical `schema` document, without the self-described CBOR tag, so its bytes decode to the facet and hash to the facet hash the docs show</must>
</rule>

<rule id="sparrow_json" targets="tools.sparrow" by="system.generator">
<must>write each facet's JSON as its id, name, version and facet hash in hex, its services with their methods' ids, shapes, inputs, outputs, error sigils and flags, its types by TypeId with their fields by tag, its sigils and its retired ids, and `schema.json` as the document's name, version and hash in hex and its facets with their hashes</must>
</rule>

<rule id="sparrow_extra" targets="tools.sparrow" by="system.generator">
<mustNot>generate the files unless asked for their target, or read them back</mustNot>
<then>the tree stays the one source of the facet</then>
</rule>
