# Packaging and the SDK {#packaging}

A TS implementation is an ordinary module of the project or of an npm package, written
with `@heron/runtime` and checked by `tsc` against types generated from Heron. `std/apis`
declares [the `Transport` point](#language.interop.packaging.interop_transport), and a
package [implements it in TS](#language.interop.packaging.interop_transport_ts).

<term id="heron_runtime">
The npm package `@heron/runtime`: the SDK implementations import, its `./apis` entry for
transports, its `./protocol` entry with the generated messages, and the
[JS host](#language.interop.host.js_host), `dist/host-main.js`, also installed as the
command `heron-js-host`. A project adds it as a dev dependency.
</term>

<term id="define_functions">
The SDK's `defineFunc`, `defineMacro`, `defineTransport`, `defineLint`,
`defineResource`, `defineGenerator` and `defineRenderer`: each wraps an implementation
and tags it with its [extension point](#language.interop.declaring.extension_point).
</term>

<term id="generated_bindings">
The two files the `ts` target of `heron generate` writes under `.heron/`:
`types.ts`, with an interface for each record type and a union of names for each enum,
in namespaces by path, and `bindings.ts`, whose `bind` has one member per declaration
bound to a module, typed with its arguments, result and instance types.
</term>

<section id="sdk">

<rule id="tagged_implementations" @targets="define_functions" @by="system.extension_host">
<must>serve an export as the implementation of a declaration only when it was made with a `define…` function of the declaration's point, or is a plain function for a func</must>
</rule>

<rule id="wrong_point" @targets="define_functions" @by="system.extension_host">
<if>an export is tagged with another point than its declaration's, or stamped for another declaration</if>
<must>fail the handshake with `‹path› is declared as a ‹point› but implemented as a ‹point›`, or `‹path› is bound to the implementation generated for ‹other›`</must>
</rule>

<rule id="not_an_implementation" @targets="define_functions" @by="system.extension_host">
<if>the export a declaration names is missing or isn't an implementation</if>
<must>fail with `‹module›: export ‹name› isn't an implementation made with @heron/runtime`</must>
</rule>

<rule id="async_results" @targets="define_functions" @by="system.extension_host">
<must>accept a result returned, as a promise, or for a func as an `AsyncIterable` whose items are sent as `$/stream`</must>
</rule>

<rule id="ctx_signal" @targets="define_functions" @by="system.extension_host">
<must>abort `ctx.signal` of a call when heron cancels it or its time runs out</must>
</rule>

<rule id="renderer_modules" @targets="define_functions" @by="system.extension_host">
<must>serve a docs `renderers` module as every renderer its exports hold, by kind, and report those kinds in the handshake</must>
</rule>
</section>

<section id="types">

<rule id="ts_target" @targets="generated_bindings" @by="system.generator">
<must>write [the bindings](#language.interop.packaging.generated_bindings) as the `ts` target of `heron generate`, `heron generate ts`, with every type, enum and module binding of the tree and the packages it imports</must>
</rule>

<rule id="bindings_stamp" @targets="generated_bindings" @by="system.generator">
<must>make each member of `bind` wrap its implementation with its point's `define…` function and stamp it with the declaration's path</must>
<example>`export_orders: (fn: (args: { pet_id: number; orders?: Array<T.Order> }, ctx: Ctx) => string | Promise<string>) => stamp(defineFunc(fn), "export_orders")`</example>
</rule>

<rule id="heron_owns_signatures" @targets="generated_bindings" @by="system.generator">
<must>type the bindings from the Heron declarations alone, so `tsc` checks each implementation against them</must>
<then>a signature that drifts from its implementation is a compile error, not a runtime failure</then>
</rule>

<rule id="bindings_are_build_outputs" @targets="generated_bindings" @by="system.generator">
<must>list `.heron/` in the managed ignore block, so the bindings stay out of the repository</must>
</rule>

<rule id="bindings_on_setup" @targets="generated_bindings" @by="system.interpreter">
<must>write the bindings during `heron run setup` and again after every change to the tree</must>
</rule>
</section>

<section id="distribution">

<rule id="npm_packages" @targets="heron_runtime" @by="system.interpreter">
<must>resolve a package whose `package.json` has a `heron` field through the project's package manager and lockfile, and pin it in `heron.lock`</must>
</rule>

<rule id="heron_dev" @targets="generated_bindings" @by="system.command_line">
<when>`heron dev` runs</when>
<must>watch the specs and the TS sources together and regenerate the bindings as either changes</must>
</rule>

<rule id="testing_package" @targets="heron_runtime" @by="system.extension_host">
<must>offer `@heron/testing`, which gives Vitest a mock tree and `ctx`, so an implementation is tested without heron</must>
</rule>

Other runtimes follow the same protocol with their own SDKs, such as `py(…)` or
`go(…)` bindings, once there's a need: each needs a CBOR library, a generator over the
protocol's messages and about two hundred lines.
</section>

<example id="interop_transport" @display="The Transport point">
```heron
// std/apis declares the point
Transport: interface {
  /// Sends one request of an op and returns its response.
  send(op: Ref(op), request: Any): func(Response)
}

// a package binds an implementation
grpc: transport = js("@acme/heron-grpc")
```
</example>

<example id="interop_transport_ts" @display="A transport in TS">
```ts
import { defineTransport } from "@heron/runtime/apis";

export default defineTransport({
  async send(op, request, ctx) {
    const client = await ctx.resource("grpc_client");
    return client.unary(op.path, request);
  },
});
```
</example>
