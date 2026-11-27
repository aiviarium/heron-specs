# RPC bindings {#rpc}

An RPC binding carries an op as a method of a service. The op stays the contract: its
parameters, its [result type](#language.apis.responses.result_type) and its errors are
written once, and the binding says only how a call travels. `std/proto` binds an api to a
gRPC service, served over gRPC, gRPC-Web or Connect, as [gRPC and Connect](#language.apis.grpc)
specifies, `std/jsonrpc` binds an api or single ops to JSON-RPC 2.0 methods, as
[JSON-RPC](#language.apis.jsonrpc) does, and `std/sparrow` binds an api to a service of a
[Sparrow facet](#language.apis.sparrow.sparrow_facet), as [Sparrow](#language.apis.sparrow) does. One op may carry an HTTP route,
a gRPC method, a method of JSON-RPC and a [Sparrow method](#language.apis.sparrow.sparrow_method) at once, and it's still one op with
one page in the docs.

The [parcels example](#language.apis.rpc.rpc_example) binds one api to HTTP, gRPC and
Connect, with one op also served over JSON-RPC, and streams in all four ways; the example
in the repository binds it to a [Sparrow facet](#language.apis.sparrow.sparrow_facet) too.

<term id="rpc_method" @display="RPC method">
An op as an RPC binding carries it: its name on the wire, the request it takes, the
response it answers with and the errors it fails with, each projected from the op's
parameters, its [result type](#language.apis.responses.result_type) and its `@throws`.
</term>

<term id="streaming_kind">
How an [RPC method](#language.apis.rpc.rpc_method) streams, read from where `Stream(T)`
stands in the op: unary with no stream, server streaming for a streamed result, client
streaming for a streamed parameter, and bidirectional for both.
</term>

<term id="rpc_code" @display="RPC code">
An error's projection on an RPC binding, as `@status` is its projection on HTTP: a gRPC
status code from `std/proto`, `@code(NOT_FOUND)`, a JSON-RPC error code from
`std/jsonrpc`, `@code(-32004)`, or a Sparrow core status code from `std/sparrow`,
`@code(not_found)`. It stands on a type that implements `Error` or on an
`error` node, so the error keeps one identity on every binding.
</term>

<term id="server_url" @display="Server URL">
Where an api is served: `@server("https://parcels.example.com")` of `std/apis`, on the api,
written once for every binding, and more than once for more than one server.
</term>

<rule id="streaming_kinds" @targets="streaming_kind" @by="system.checker">
<must>give each op the [streaming kind](#language.apis.rpc.streaming_kind) its `Stream(T)` parameters and result make, whatever binds it</must>
<example>`navigate(positions: Stream(Position)): op(Stream(Instruction))` is bidirectional, and `upload_scans(scans: Stream(Scan)): op(ScanSummary)` is client streaming</example>
</rule>

<rule id="stream_example_values" @targets="streaming_kind" @by="system.checker">
<must>check an example's value for a streamed parameter or result as a list of the stream's element type, the messages in the order they're sent</must>
<example>`returns = [ParcelEvent(…), ParcelEvent(…)]` in an example of `watch_parcel` is two messages the server sends</example>
</rule>

<rule id="qualified_codes" @targets="rpc_code" @by="actors.author">
<where>a file imports more than one of `std/proto`, `std/jsonrpc` and `std/sparrow`</where>
<must>write each [RPC code](#language.apis.rpc.rpc_code) qualified by its package, as `@proto.code(NOT_FOUND)`, `@jsonrpc.code(-32004)` and `@sparrow.code(not_found)`, and likewise `@proto.reserved` and `@sparrow.reserved`, since an unqualified `@code` is [ambiguous](#language.core_format.nodes.annotations.ambiguous_annotations)</must>
</rule>

<rule id="servers_shown" @targets="server_url" @by="system.docs_generator">
<must>show an api's [server URLs](#language.apis.rpc.server_url) on its page, and write the first in its request examples and fill it into Try it in place of `$BASE_URL`</must>
</rule>

<example id="rpc_example" @display="The parcels api">
```heron
import = ["std/types@1", "std/apis@1", "std/http@1", "std/proto@1", "std/jsonrpc@1"]

@server("https://parcels.example.com")
@http(base_path = "/v1")
@proto("acme.parcels.v1", protocols = [grpc, connect])
parcels: api {
  // Unary, over HTTP, gRPC, Connect and JSON-RPC at once.
  @http<get>("/parcels/:id")
  @jsonrpc("parcels.get")
  @proto(idempotency = no_side_effects)
  @throws(ParcelNotFound)
  get_parcel(@path id: String, @header("Tenant") tenant?: String): op(Parcel)

  // Server streaming: server-sent events over HTTP, a server stream over gRPC.
  @http<get>("/parcels/:id/events")
  watch_parcel(@path id: String): op(Stream(ParcelEvent))

  // Client streaming and bidirectional: gRPC and Connect alone.
  upload_scans(scans: Stream(Scan)): op(ScanSummary)
  navigate(positions: Stream(Position)): op(Stream(Instruction))
}

Parcel: type {
  id: String
  status: ParcelStatus
  weight_grams: Int(bits = 32)
}

ParcelStatus: enum {
  LABELLED: Self
  IN_TRANSIT: Self
  DELIVERED: Self
}

ParcelEvent: type {
  status: ParcelStatus
  at: Timestamp
}

Scan: type {
  parcel_id: String
  at: Timestamp
}

ScanSummary: type {
  accepted: Int
}

Position: type {
  lat: Float
  lng: Float
}

Instruction: type {
  text: String
}

@status(404)
@proto.code(NOT_FOUND)
@jsonrpc.code(-32004)
ParcelNotFound: type(Error) {
  message: String = "No parcel has this id."
  id: String
}
```
</example>
