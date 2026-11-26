# Encodings {#encodings}

A value has one model and several encodings. JSON is what `std/json` reads and writes
and what the extension protocol's debugging wire carries; CBOR is the protocol's default
wire, where every Heron type keeps its identity under a tag. Further wire formats are
packages of their own, whose annotations add what the format needs without changing
the types.

| Package     | Annotations and rules                                                                                     |
| ----------- | --------------------------------------------------------------------------------------------------------- |
| `std/json`  | Field names and casing, the discriminator field of a union, and 64-bit integers written as strings       |
| `std/cbor`  | Semantic tags, such as 0 and 1 for time or 2 and 3 for bignums, and integer map keys                     |
| `std/proto` | Field numbers `@field(3)`, `@reserved(4, 5)`, wire encodings such as `sint` and `fixed`, and an enum's zero value. `api` and `op` map to services and rpcs, and `Stream(T)` to streaming |
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

<rule id="json_encode" targets="language.data.encodings.json" by="system.interpreter">
<must>write a value as one line of JSON by the table, with a map's keys in sorted order and `<`, `>` and `&` written as themselves, and throw `std/json`'s `EncodeError` for a value JSON can't hold</must>
</rule>

<rule id="json_decode" targets="language.data.encodings.json" by="system.interpreter">
<must>read JSON text as a value of the type given, building records of declared types inside lists and maps, with numbers kept exact, and throw `std/json`'s `DecodeError` with the parser's message where the text isn't JSON or a list is expected and something else is found</must>
</rule>

<rule id="json_wire" targets="language.data.encodings.json" by="system.extension_host">
<where>the extension protocol runs with `--wire json`</where>
<must>write a value with no JSON form as an object with one `$` key: `{"$decimal": "40.00"}`, `{"$set": […]}`, `{"$variant": name, "value": …}`, `{"$duration": ms}`, `{"$prose": mdast}` and `{"$ref": path}`</must>
<then>a peer that reads them back gets plain maps, since JSON has no tags</then>
</rule>

<rule id="json_annotations" targets="language.data.encodings.json" by="system.interpreter">
<must>apply `std/json`'s annotations when a value is written or read: field names and casing, a union's discriminator field, and 64-bit integers as strings</must>
</rule>
</section>

<section id="cbor">
On the CBOR wire a value is tagged by its type. The standard tags are used where they
exist; the rest take [Heron tags](#language.interop.data_mapping.heron_tags) in the IANA registry's first-come range, not yet
registered.

| Heron value       | CBOR                                                |
| ----------------- | --------------------------------------------------- |
| `Timestamp`       | tag 0, an RFC 3339 string with nanoseconds; tag 1 is read too |
| `Int` beyond 64 bits | tag 2, or tag 3 for a negative one, a bignum      |
| `Decimal`, `Money`'s amount | tag 4, a decimal fraction `[exponent, mantissa]` |
| `Set(T)`          | tag 258, an array                                   |
| a union's variant | tag 1214603777, `[name, value]`                     |
| `Duration`        | tag 1214603778, whole milliseconds                  |
| `Prose`           | tag 1214603779, an mdast root                       |
| `Ref(K)`          | tag 1214603780, a [node path](#language.core_format.naming.node_path) as a string     |

<rule id="cbor_tags" targets="language.data.encodings.cbor" by="system.extension_host">
<must>write each value under the tag the table gives it, require the tag when reading one back, and write integers in their shortest form and map keys in canonical order</must>
<then>a value crosses the wire with its type, and a Duration loses whatever is below a millisecond</then>
</rule>
</section>

<rule id="encodings_keep_types" targets="language.data.encodings" by="actors.author">
<mustNot>let an encoding package's annotations change the types they annotate</mustNot>
<then>one model encodes to every format</then>
</rule>
