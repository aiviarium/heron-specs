# Cross-cutting annotations {#cross_cutting}

What holds for many ops at once, such as who may call them, how often, how their
results are paged and whether a retry is safe, is written as an annotation on the ops
or on their api. The standard packages declare none of these: a package declares the
ones its system needs, as ordinary annotations, and the tools carry them as they're
written.

| Concern       | Written as, in a package of the system's own                       |
| ------------- | ------------------------------------------------------------------ |
| Auth          | `@auth(scopes = ["refunds:write"])` on an api or an op              |
| Rate limits   | `@rate_limit(per_minute = 60)` on an api or an op                   |
| Pagination    | a `Page(T)` [result type](#language.apis.responses.result_type) and a `@query cursor?: String` parameter    |
| Idempotency   | `@idempotent` on an op, with the key as a `@header` parameter; a gRPC method's idempotency level is its `@proto(idempotency)` |

<term id="cross_cutting_annotation">
An annotation on an op or its api that isn't the op's binding, errors or transitions:
`@http`, `@ws`, `@proto`, `@jsonrpc`, `@server`, `@throws`, `@performs`, `@display`,
`@doc` and `@lint` are the op's own, and every other annotation is cross-cutting.
</term>

<rule id="declared_in_packages" targets="cross_cutting_annotation" by="actors.author">
<should>declare a cross-cutting concern as an annotation `on = [types.api, types.op]` in a package of the system, and put it on the api when it holds for every op</should>
</rule>

<rule id="api_annotations_apply" targets="cross_cutting_annotation" by="system.docs_generator">
<must>apply a cross-cutting annotation on an api to each of its ops, after the op's own</must>
</rule>

<rule id="shown_as_facts" targets="cross_cutting_annotation" by="system.docs_generator">
<must>show each cross-cutting annotation of an op as a fact named after the annotation in sentence case, with its flags and arguments, or as `@name` when it has neither</must>
<example>`@rate_limit(per_minute = 60)` shows as "Rate limit" with `(per_minute = 60)`, and `@idempotent` as "Idempotent" with `@idempotent`</example>
</rule>
