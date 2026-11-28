# Transports {#transports}

A transport carries an api's ops over a protocol. It's declared with the
`transport` kind of `std/apis` in a package, beside the annotations that bind ops to it, and
implemented by code built into `heron`, which the run registers.
The annotation is the binding: an op is carried by the transport of the package
whose annotation stands on it or on its api.

| Package     | Binds | Streams |
| ----------- | ----- | ------- |
| `std/http`  | `@http<method>(path)` on ops, with the method as a flag such as `<post>` and [path parameters](#language.apis.params.path_parameter) written `:name`, and `@http(base_path = …)` on apis. Parameters take `@path`, `@query`, `@header(name)` or `@body`. The core's `@status(code)` maps errors. | A streamed result is server-sent events. Streamed parameters aren't allowed. |
| `std/proto` | `@proto(package)` on an api makes it a gRPC service and each op a method, served over gRPC, gRPC-Web or Connect. Parameters become the [request message](#language.apis.grpc.request_message), numbered with `@field(n)` or in order, or travel as `@metadata`. `@code(NOT_FOUND)` maps errors. [gRPC and Connect](#language.apis.grpc) has the rules. | Result, parameter or both map to server, client and bidirectional streaming. |
| `std/jsonrpc` | `@jsonrpc(method)` on an api or op makes each op a JSON-RPC 2.0 method, and one with no result a notification. Parameters travel by name, by position or as `@params`. `@code(-32004)` maps errors. [JSON-RPC](#language.apis.jsonrpc) has the rules. | No streams: a method answers once. |
| `std/sparrow` | `@sparrow(facet)` on an api makes it a service of a [Sparrow facet](#language.apis.sparrow.sparrow_facet) and each op a method, called by id. Parameters become the [input struct](#language.apis.sparrow.input_struct), tagged with `@tag(n)` or in order. `@code(not_found)` maps errors, and an error without one gets a sigil of its own. [Sparrow](#language.apis.sparrow) has the rules. | Result, parameter or both are a stream of items, ended by `End`. |
| `std/ws`    | `@ws(path)` on an api or op opens a socket. Each op becomes a message type on it. | Streams in both directions are the socket's messages. |

<term id="transport_kind">
A protocol that carries ops, declared as `carrier: transport` in a package and
implemented in `heron` through the `Transport` interface of `std/apis`: `send(op, request)` sends one
request of an op and returns its response.
</term>

<term id="transport_binding">
An annotation on an op or its api, from a package that declares a transport, that sends
the op's calls through that transport, as `@wire.carried` on `shelf.find` sends
its calls through `wire.carrier`.
</term>

<rule id="binding_by_package" refs="system.interpreter">
<when>an op is called in a run</when>
<must>send the call through the one transport declared in the packages of the annotations on the op and on its api</must>
</rule>

<rule id="request_by_parameter" refs="system.interpreter">
<must>give the transport the op's path and its arguments by parameter name, and return what the transport answers as the call's result</must>
</rule>

<rule id="unbound_op" refs="system.interpreter">
<if>an op called in a run has no annotation from a package, on it or on its api</if>
<must>fail the call with "op ‹op› has no binding: annotate it or its api with a transport package's annotation"</must>
</rule>

<rule id="binding_without_transport" refs="system.interpreter">
<if>the packages of an op's annotations declare no transport</if>
<must>fail the call with "op ‹op› is bound by ‹annotations›, but no transport of those packages is declared"</must>
<example>an op with only `@http<get>` fails so until `std/http` has a transport</example>
</rule>

<rule id="several_transports" refs="system.interpreter">
<if>an op's annotations name packages that declare more than one transport</if>
<must>fail the call, naming the transports in sorted order</must>
<then>a binding is never a guess</then>
<example>an op bound to three transports fails with "… (twin.left, twin.right, wire.carrier); a run can't pick one"</example>
</rule>

<rule id="unimplemented_transport" refs="system.interpreter">
<if>the run has no implementation registered for the op's transport</if>
<must>fail the call with "op ‹op› is carried by transport ‹transport›, but nothing implements it"</must>
</rule>

<rule id="std_transports" refs="system.interpreter">
<must>implement transports for `std/http`, `std/proto`, `std/jsonrpc` and `std/ws` in `heron`, so the standard protocols work without a third-party package</must>
</rule>
