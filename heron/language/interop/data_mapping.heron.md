# Data across the boundary {#data_mapping}

Values cross the boundary as their Heron types, encoded as CBOR, so integers stay
exact, bytes stay binary and dynamic values need no wrapper types. Heron's types become
CBOR tags, the standard ones where they exist and the [Heron tags](#language.interop.data_mapping.heron_tags) for the rest; `…777` to `…780` below are the last three digits of theirs. The Heron
[schema](#language.schemas.kinds.schema) is the only interface definition.

| Heron                         | CBOR                                                   | TS                                                       |
| ----------------------------- | ------------------------------------------------------ | -------------------------------------------------------- |
| `Bool`, `String`, `Float`     | simple value, text string, float                       | `boolean`, `string`, `number`                            |
| `Int`                         | integer, or bignum tags 2 and 3 beyond 64 bits         | `number`, and `bigint` beyond the safe integers          |
| `Bytes`                       | byte string                                            | `Uint8Array`                                             |
| `Money` and other decimals    | decimal fraction, tag 4: `[exponent, mantissa]`        | `Decimal`, with `parse` and `toString`                   |
| `Timestamp`                   | date and time, tag 0 as written by heron, 0 or 1 read  | `Date`                                                   |
| `Duration`                    | whole milliseconds under tag `…778` | `Duration`, with `ms`                                    |
| [record](#language.data.values.record_value) types | map                                     | interfaces                                               |
| enums                         | text string, the variant's name                        | string literal unions                                    |
| unions                        | `[variant, value]` under tag `…777`          | `Variant`, with `name` and `value`                       |
| `T?`                          | the value or null                                      | `T \| null`                                              |
| `List`, `Set`, `Map`          | array, array under tag 258, map                        | `Array`, `Set`, `Map`                                    |
| `Prose`                       | an mdast root under tag `…779`               | an mdast tree, so remark and the unified ecosystem work on it |
| `Ref(kind)`                   | a [node path](#language.core_format.naming.node_path) under tag `…780` | `Ref`, with `path`                                       |
| `@throws` types               | an error carrying the error value                      | generated error classes; anything else thrown becomes `ForeignError` |

<term id="heron_tags">
One of the four CBOR tags Heron gives its own types, in the range the IANA registry
assigns first come, first served: 1214603777 for a union's variant, 1214603778 for a
duration, 1214603779 for prose and 1214603780 for a reference. They aren't registered
yet.
</term>

## Wire {#wire}

<rule id="cbor_libraries" targets="heron_tags" by="system.extension_host">
<must>encode and decode frames on both sides, the host and the JS runtime, each with an encoder and a decoder registered for every tag the [table](#heron.language.markup.components.table) gives a value</must>
</rule>

<rule id="standard_tags" targets="heron_tags" by="system.extension_host">
<must>encode times with tag 0, integers past 64 bits with tags 2 and 3, decimal fractions with tag 4 and sets with tag 258, and decode each back to the same type</must>
</rule>

<rule id="own_tags" targets="heron_tags" by="system.extension_host">
<must>encode a variant, a duration, prose and a reference under their [Heron tags](#language.interop.data_mapping.heron_tags), and decode each back to the same type</must>
</rule>

<rule id="ts_values" targets="heron_tags" by="system.extension_host">
<must>decode the same tags in TS to `Variant`, `Duration`, `Decimal`, `Ref`, `Set` and mdast trees, and encode them back with their tags</must>
</rule>

<rule id="decimals_exact" targets="heron_tags" by="system.extension_host">
<must>keep a decimal as its mantissa and exponent, so `"40.00"` reads back as `40.00`, never as a float</must>
</rule>

<rule id="json_tags" targets="heron_tags" by="system.extension_host">
<where>the JSON wire is used</where>
<must>write each tagged value as an object with one `$` key naming its type: `$variant` with `value`, `$duration`, `$prose`, `$ref`, `$set` and `$decimal` as text</must>
</rule>

<rule id="canonical_maps" targets="heron_tags" by="system.extension_host">
<must>write map keys in the canonical order of the CBOR standard</must>
<then>equal values encode to equal bytes, which a hash of a call's inputs can rely on</then>
</rule>

## Interpreter {#interpreter}

What the interpreter hands the protocol today is narrower than the [table](#heron.language.markup.components.table): its own
values are Heron's [data values](#language.data.values) without the tagged types.

<rule id="plain_values" targets="heron_tags" by="system.interpreter">
<must>pass a record as a map of its fields, an enum value as its name, a [typed string](#language.data.typed_strings.typed_string) as its text, a type as its name and a node reference as its path in text, and read a map back as a map and a whole number as an `Int`</must>
</rule>

<rule id="typed_values" targets="heron_tags" by="system.interpreter">
<must>pass a `Timestamp`, a `Duration`, a decimal, a set, a union's variant, prose and a reference with the tag of their type, and give a record read back the type its declaration names</must>
</rule>

<rule id="streamed_results" targets="heron_tags" by="system.interpreter">
<where>a [foreign func](#language.interop.declaring.foreign_func) returns an `AsyncIterable`</where>
<must>give code each item as it arrives through `$/stream`, as a `Stream(T)`</must>
</rule>

## Errors {#errors}

<rule id="thrown_values" targets="heron_tags" by="system.extension_host">
<must>send a [thrown error](#language.scripting.code.thrown_error) as an error with code `-32001`, its type as `type` and its fields as `data`</must>
</rule>
