# AsyncAPI {#asyncapi}

An extra for outside tooling: an AsyncAPI description of each api of a tree, generated on
demand. The docs stay the reference; the description lets tools that read AsyncAPI, such as
code generators and mock servers, read a Heron api too.

<rule id="asyncapi_target" refs="system.generator">
<must>write, for `heron generate asyncapi`, one AsyncAPI 3.0 document per api of the tree, as `.heron/asyncapi/<api path>.json`</must>
</rule>

<rule id="asyncapi_channels" refs="system.generator">
<must>describe each op as a channel at its path, base path included, with a `send` operation whose message is its request body and a `receive` operation whose message is its response, a stream's elements each as one message and a socket's messages in both directions</must>
</rule>

<rule id="asyncapi_schemas" refs="system.generator">
<must>describe every type the ops name as a JSON-Schema object under the document's components, with its docs as the description, its optional fields left out of `required`, and its errors as messages of the operations that throw them</must>
</rule>

<rule id="asyncapi_extra" refs="system.generator">
<mustNot>generate the description unless asked for its target, or read it back</mustNot>
<then>it never drifts into a second source of truth</then>
</rule>
