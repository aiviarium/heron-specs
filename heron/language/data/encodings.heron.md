# Encodings {#encodings}

A value has one model and several encodings. JSON is what `std/json` reads and writes
and what the extension protocol's debugging wire carries; CBOR is the protocol's default
wire, where every Heron type keeps its identity under a tag. Further wire formats are
packages of their own, whose annotations add what the format needs without changing
the types.

| Package     | Annotations and rules                                                                                     |
| ----------- | --------------------------------------------------------------------------------------------------------- |
| `std/json`  | Field names and casing with `@key(name)` and `@keys(case)`, the discriminator field of a union, and 64-bit integers written as strings |
| `std/cbor`  | Semantic tags, such as 0 and 1 for time or 2 and 3 for bignums, and integer map keys                     |
| `std/proto` | [Field numbers](#language.apis.grpc.field_number) `@field(3)`, `@reserved(4, 5)`, wire encodings `@field<sint>` and `@field<fixed>`, and an enum's zero value, as [gRPC and Connect](#language.apis.grpc.types) maps each type. `api` and `op` map to services and methods, and `Stream(T)` to streaming |
| `std/xml`   | `@xml(attribute = true)`, element names, namespaces, and wrapped or unwrapped lists. Mixed content maps to prose bodies |

<section id="json">
`json.encode(value)` writes a value as JSON text and `json.decode(Type, text)` reads one
back as the type.

| Heron value                  | JSON                                  |
| ---------------------------- | ------------------------------------- |
| `String`, `Bool`, `null`     | a string, `true` or `false`, `null`   |
| `Int`, `Float`               | a number                              |
| `List(T)`, `Set(T)`          | an array                              |
| `Map(String, V)`, a record   | an object, keyed by member name       |
| `Timestamp`                  | an RFC 3339 string                    |

<rule id="json_encode" @targets="language.data.encodings.json" @by="system.interpreter">
<must>write a value as one line of JSON by the [table](#heron.language.markup.components.table), with a map's keys in sorted order and `<`, `>` and `&` written as themselves, and throw `std/json`'s `EncodeError` for a value JSON can't hold</must>
</rule>

<rule id="json_decode" @targets="language.data.encodings.json" @by="system.interpreter">
<must>read JSON text as a value of the type given, building records of declared types inside lists and maps, with numbers kept exact, and throw `std/json`'s `DecodeError` with the parser's message where the text isn't JSON or a list is expected and something else is found</must>
</rule>


<rule id="json_names" @targets="language.data.encodings.json" @by="system.interpreter">
<must>write and read each field of a record by its name in JSON: a member's `@key(name)`, or else its name in the case its type's `@keys(case)` sets, `camel` for lower camel case, and its name as written for none</must>
<example>a value of `@keys(camel) Position: type { line_number: Int }` is written `{"lineNumber": 1}`, and `{"lineNumber": 1}` read back as one</example>
</rule>

<rule id="json_annotations" @targets="language.data.encodings.json" @by="system.interpreter">
<must>apply the rest of `std/json`'s annotations when a value is written or read: a union's discriminator field, and 64-bit integers as strings</must>
</rule>
</section>

<section id="cbor">
On the extension protocol's wire a value travels in Sparrow's schema-driven CBOR: a
value of `Any` as the [Value](#language.interop.data_mapping.value_union) union, whose
variant says its type, so Sparrow's two tags, 1 and 37, are the only ones on the wire.

| Heron value       | `Value` variant                                     |
| ----------------- | --------------------------------------------------- |
| `Timestamp`       | `time`, an RFC 3339 string with nanoseconds          |
| `Int` beyond 64 bits | `bigint`, decimal text; `uint` above 64-bit signed |
| `Decimal`, `Money`'s amount | `decimal`, its text with the exponent kept |
| `Set(T)`          | `set`, a list                                       |
| a union's variant | `variant`, `[name, value]`                          |
| `Duration`        | `duration`, whole milliseconds                      |
| `Prose`           | `prose`, an mdast root                              |
| `Ref(K)`          | `ref`, a [node path](#language.core_format.naming.node_path) as a string     |

<rule id="cbor_tags" @targets="language.data.encodings.cbor" @by="system.extension_host">
<must>write each value as the variant the [table](#heron.language.markup.components.table) gives it, require that variant when reading one back as its type, and write integers in their shortest form and a map's entries in the order of their keys</must>
<then>a value crosses the wire with its type, and a Duration loses whatever is below a millisecond</then>
</rule>
</section>

<rule id="encodings_keep_types" @targets="language.data.encodings" @by="actors.author">
<mustNot>let an encoding package's annotations change the types they annotate</mustNot>
<then>one model encodes to every format</then>
</rule>
