# OpenRPC {#openrpc}

An extra for outside tooling, like [AsyncAPI](#tools.asyncapi): an OpenRPC document of
each api with [JSON-RPC methods](#language.apis.jsonrpc.jsonrpc_method), generated on
demand, which the OpenRPC playground, its client generators and its mock servers read.

<rule id="openrpc_target" targets="tools.openrpc" by="system.generator">
<must>write, for `heron generate openrpc`, one OpenRPC 1.3 document per api that has [JSON-RPC methods](#language.apis.jsonrpc.jsonrpc_method), as `.heron/openrpc/<api path>.json`, with the api's servers</must>
</rule>

<rule id="openrpc_methods" targets="tools.openrpc" by="system.generator">
<must>describe each method by its wire name with its params, by name or by position as its [params structure](#language.apis.jsonrpc.params_structure) says and a `@params` record's fields as the params, its result, none for a [notification](#language.apis.jsonrpc.jsonrpc_notification), its errors with their codes and messages, and its [examples](#language.apis.examples.op_example) as pairings of params and result</must>
</rule>

<rule id="openrpc_schemas" targets="tools.openrpc" by="system.generator">
<must>describe every type the methods name as a JSON-Schema object under the document's components, with its docs as the description and its optional fields left out of `required`</must>
</rule>

<rule id="openrpc_extra" targets="tools.openrpc" by="system.generator">
<mustNot>generate the document unless asked for its target, or read it back</mustNot>
</rule>
