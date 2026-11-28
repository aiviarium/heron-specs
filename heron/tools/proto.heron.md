# Protobuf {#proto}

An extra for outside tooling, like [AsyncAPI](#tools.asyncapi): the `.proto` files of the
tree's gRPC services, generated on demand, so `buf`, `protoc` and the code generators built
on them read a Heron api as they read any protobuf package. Every name and number in them
is the one [gRPC and Connect](#language.apis.grpc) gives, the same the docs show.

<rule id="proto_target" refs="system.generator">
<must>write, for `heron generate proto`, one file per protobuf package of the tree's services, at `.heron/proto/` and then the package's path with its dots as folders and its last segment that isn't a version as the file's name, and beside them a `buf.yaml` that lints with the `STANDARD` rules of `buf`</must>
<example>`acme.parcels.v1` is written to `.heron/proto/acme/parcels/v1/parcels.proto`</example>
</rule>

<rule id="proto_contents" refs="system.generator">
<must>write each file as `proto3` with its `package`, an import of each well-known type it uses, every service of the package with its methods, their streams and idempotency levels, and every message and enum the methods reach, in the order they're first reached, each with its docs as comments</must>
</rule>

<rule id="proto_lint_clean" refs="system.generator">
<must>write files that `buf build` compiles and `buf lint` passes with the `STANDARD` rules, but the package's version suffix, which is the author's</must>
</rule>

<rule id="proto_extra" refs="system.generator">
<mustNot>generate the files unless asked for their target, or read them back</mustNot>
<then>the tree stays the one source of the service</then>
</rule>
