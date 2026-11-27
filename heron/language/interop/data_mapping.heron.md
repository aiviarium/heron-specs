# Data across the boundary {#data_mapping}

Values cross the boundary as their Heron types, in Sparrow's schema-driven CBOR, so
integers stay exact, bytes stay binary and dynamic values need no wrapper types. A
value whose type the messages give, a record of the protocol, is a Sparrow struct; a
value of `Any`, as every argument and result of foreign code, is the
[Value](#language.interop.data_mapping.value_union) union, which says its Heron type
with its variant. The Heron [schema](#language.schemas.kinds.schema) is the only
interface definition.

| Heron                         | `Value` variant                                        | TS                                                       |
| ----------------------------- | ------------------------------------------------------ | -------------------------------------------------------- |
| null                          | 0 `null`                                               | `null`                                                   |
| `Bool`, `String`, `Float`     | 1 `bool`, 6 `string`, 5 `float`                        | `boolean`, `string`, `number`                            |
| `Int`                         | 2 `int`, 3 `uint` above 64-bit signed, 4 `bigint` as decimal text beyond 64 bits | `number`, and `bigint` beyond the safe integers |
| `Bytes`                       | 7 `bytes`                                              | `Uint8Array`                                             |
| `Money` and other decimals    | 8 `decimal`, its text with the exponent kept, as `"40.00"` | `Decimal`, with `parse` and `toString`              |
| `Timestamp`                   | 9 `time`, RFC 3339 with nanoseconds                    | `Date`                                                   |
| `Duration`                    | 10 `duration`, whole milliseconds                      | `Duration`, with `ms`                                    |
| [record](#language.data.values.record_value) types | 13 `map`, by member name          | interfaces                                               |
| enums                         | 6 `string`, the variant's name                         | string literal unions                                    |
| unions                        | 14 `variant`, `VariantValue` `[name, value]`           | `Variant`, with `name` and `value`                       |
| `T?`                          | the value or 0 `null`                                  | `T \| null`                                              |
| `List`, `Set`, `Map`          | 11 `list`, 12 `set`, 13 `map`                          | `Array`, `Set`, `Map`                                    |
| `Prose`                       | 16 `prose`, an mdast root as a map                     | an mdast tree, so remark and the unified ecosystem work on it |
| `Ref(kind)`                   | 15 `ref`, a [node path](#language.core_format.naming.node_path) | `Ref`, with `path`                              |
| `@throws` types               | an `Error` whose details carry the error value         | generated error classes; anything else thrown becomes `ForeignError` |

<term id="value_union">
The Sparrow union `Value`, defined in each facet of the
[protocol](#language.interop.protocol) beside the struct `VariantValue` (field 0
`name: string`, field 1 `value: Value`): its variants, by tag, are those of the
[table](#heron.language.markup.components.table), 0 `null: unit` through 16
`prose: map(string, Value)`, and a value of `Any` is always one of them. Sparrow
defines no tags of its own for Heron's types, and needs none.
</term>

## Wire {#wire}

<rule id="cbor_libraries" @targets="value_union" @by="system.extension_host">
<must>encode and decode values on both sides, the host and the JS runtime, with a Sparrow implementation's schema-driven codec, each `Any` as the [Value](#language.interop.data_mapping.value_union) union and every other type as the facet type the messages give it</must>
</rule>

<rule id="standard_tags" @targets="value_union" @by="system.extension_host">
<must>encode times, integers past 64 bits, decimals and sets with their own variants, `time`, `uint` or `bigint`, `decimal` and `set`, and decode each back to the same type</must>
</rule>

<rule id="own_tags" @targets="value_union" @by="system.extension_host">
<must>encode a union's variant, a duration, prose and a reference with their own variants, `variant`, `duration`, `prose` and `ref`, and decode each back to the same type</must>
</rule>

<rule id="ts_values" @targets="value_union" @by="system.extension_host">
<must>decode the same variants in TS to `Variant`, `Duration`, `Decimal`, `Ref`, `Set` and mdast trees, and encode them back as those variants</must>
</rule>

<rule id="decimals_exact" @targets="value_union" @by="system.extension_host">
<must>keep a decimal as its mantissa and exponent, so `"40.00"` reads back as `40.00`, never as a float</must>
</rule>

<rule id="canonical_maps" @targets="value_union" @by="system.extension_host">
<must>write a `map` variant's entries in the order of their keys</must>
<then>equal values encode to equal bytes, which a hash of a call's inputs can rely on</then>
</rule>

## Interpreter {#interpreter}

What the interpreter hands the protocol today is narrower than the [table](#heron.language.markup.components.table): its own
values are Heron's [data values](#language.data.values) without the tagged types.

<rule id="plain_values" @targets="value_union" @by="system.interpreter">
<must>pass a record as a map of its fields, an enum value as its name, a [typed string](#language.data.typed_strings.typed_string) as its text, a type as its name and a node reference as its path in text, and read a map back as a map and a whole number as an `Int`</must>
</rule>

<rule id="typed_values" @targets="value_union" @by="system.interpreter">
<must>pass a `Timestamp`, a `Duration`, a decimal, a set, a union's variant, prose and a reference as the variant of their type, and give a record read back the type its declaration names</must>
</rule>

<rule id="streamed_results" @targets="value_union" @by="system.interpreter">
<where>a [foreign func](#language.interop.declaring.foreign_func) returns an `AsyncIterable`</where>
<must>call it with `call_stream` and give code each item as it arrives, as a `Stream(T)`</must>
</rule>

## Errors {#errors}

<rule id="thrown_values" @targets="value_union" @by="system.extension_host">
<must>send a [thrown error](#language.scripting.code.thrown_error) as Sparrow's `Error(aborted)` whose details have code `-32001`, its type as `type` and its fields as `data`</must>
</rule>
