<howto id="describe_an_rpc_api" @lens="user" @display="Describe an RPC API">
An api in Heron describes operations, never a protocol, so the same api can be a gRPC
service, a Connect API that browsers call with JSON, a set of JSON-RPC methods and an
HTTP API at once. You write each op once, with its parameters, its result and its
errors, and add a binding for each protocol it's served over. The docs then show one
page per op with a switch between its bindings, and generate the files other tools read.

<step id="write_the_ops">
Write the api and its ops as for any API: typed parameters, a result, and `@throws` for
the errors. A `Stream(T)` makes an op stream: as its result the server streams, as a
parameter the client does, and as both the op streams both ways. An op without a result
returns nothing.
</step>

<step id="bind_to_grpc">
Import `std/proto` and put `@proto("acme.parcels.v1")` on the api, naming its protobuf
package. Every op becomes a method of one service, named after the api, here
`ParcelsService`, and served over gRPC. List `protocols = [grpc, grpc_web, connect]` to
serve it over gRPC-Web and Connect too, and add `@server("https://parcels.example.com")`
of `std/apis` to say where it runs, which also turns on Try it for Connect in the docs.
On an op, `@proto(idempotency = no_side_effects)` marks it safe to retry, which lets
Connect serve it with GET.
</step>

<step id="number_fields">
Leave the [field numbers](#language.apis.grpc.field_number) out while you design: each message numbers its fields in the
order you write them. Once clients depend on the service, number every field of a type
with `@field(n)` and keep numbers you drop in `@reserved(…)`, so adding or moving a field
never changes the wire. Each method's [request](#language.apis.grpc.request_message) and [response messages](#language.apis.grpc.response_message), as
`GetParcelRequest`, are made for you from the op's parameters and result.
</step>

<step id="give_errors_codes">
Give each error its HTTP status, `@status(404)`: the code it travels with on every other
binding is [derived](#language.specifications.contract.codes.derived_code) from it, as
`NOT_FOUND` for gRPC and Connect and -32004 for JSON-RPC. Only where a [derived code](#heron.language.specifications.contract.codes.derived_code) doesn't
fit, override it with `@proto.status(…)` or `@jsonrpc.code(…)`. ${cli.lint.name} warns about
an override that sets the code its status derives anyway.
</step>

<step id="add_jsonrpc">
For JSON-RPC, import `std/jsonrpc` and put `@jsonrpc("parcels.get")` on an op, or a bare
`@jsonrpc` on the api for all of its ops, each named after its op unless it says
otherwise. An op without a result is a notification. A language-server style api takes
each method's params as one record, marked `@params`, frames its messages with
`@jsonrpc(framing = content_length)`, and names its fields in lower camel case with
`@keys(camel)` of `std/json`.

<example id="rpc_howto_example" @display="One api, four protocols">
```heron
import = ["std/types@1", "std/apis@1", "std/http@1", "std/proto@1", "std/jsonrpc@1"]

@server("https://parcels.example.com")
@http(base_path = "/v1")
@proto("acme.parcels.v1", protocols = [grpc, connect])
parcels: api {
  @http<get>("/parcels/:id")
  @jsonrpc("parcels.get")
  @proto(idempotency = no_side_effects)
  @throws(ParcelNotFound)
  get_parcel(@path id: String): op(Parcel) {
    | Returns one parcel.

    found: example {
      id = "p_1"
      returns = Parcel(id = "p_1", status = "in transit")
    }
  }

  watch_parcel(id: String): op(Stream(Parcel)) {
    | Streams a parcel's changes as they happen.

    moving: example {
      id = "p_1"
      returns = [Parcel(id = "p_1", status = "in transit"), Parcel(id = "p_1", status = "delivered")]
    }
  }
}

Parcel: type {
  id: String
  status: String
}

@status(404)
ParcelNotFound: type(Error) {
  message: String = "No parcel has this id."
}
```
</example>
</step>

<step id="generate_descriptions">
Run ${cli.check.name}, then ${cli.generate.name} with the target `docs` for the site, `proto`
for the `.proto` files under `.heron/proto/`, which `buf` and `protoc` read, and
`openrpc` for an OpenRPC document of the JSON-RPC methods under `.heron/openrpc/`. The
generated files are never read back: the api stays their one source.
</step>
</howto>
