# Expressions {#expressions}

One expression grammar is used after `:`, after `=`, in arguments, in annotations and in
code, as the [grammar](#language.grammar.code.expressions) gives it. Arguments take only
expressions, so free-form text belongs in prose.

<term id="placeholder">
A part of a string that a type fills in later, written `%name%`, as in
`"%major%.%minor%.%patch%"` or `"agent/%slug%"`. `%%` is a literal percent sign.
</term>

<rule id="references" targets="language.core_format.expressions" by="product.system.checker">
<must>read a path in a value as a reference to the node it names, resolved as names are, and check it against an expected `Ref(kind)` by the node's kind</must>
</rule>

<rule id="arithmetic" targets="language.core_format.expressions" by="product.system.interpreter">
<must>add, subtract, multiply and divide numbers, giving an `Int` when both are `Int` and dividing an `Int` by an `Int` towards zero, and give `%` the remainder; join two strings or two lists with `+`</must>
<example>`7 / 2` is `3`, `7 % 3` is `1`, `1.5 + 1` is `2.5`, `"a" + "b"` is `"ab"`, `[1] + [2]` is `[1, 2]`</example>
</rule>

<rule id="comparisons" targets="language.core_format.expressions" by="product.system.interpreter">
<must>compare numbers by value and strings by their characters, test `in` as membership in a list or a substring of a string, and test `is` as the value being of the type on its right</must>
<example>`2 in [1, 2]`, `"x" in "xyz"`, `"a" < "b"` and `result.error is ProcessError`: true</example>
</rule>

<rule id="method_calls" targets="language.core_format.expressions" by="product.system.interpreter">
<must>read `list.contains(x)` as `contains(list, x)`: a call after a value's `.` passes the value as the first argument</must>
</rule>

<rule id="casts_convert" targets="language.grammar.code.expressions.cast" by="product.system.checker">
<must>convert the value after a [cast](#language.grammar.code.expressions.cast) to the type in it, or tag it with the type when the type is a language or an encoding, and report a value the type can't take</must>
<example>`(Set)[1, 2]`: a set; `(u8)12`: a byte; `(sh)"ls"`: shell text</example>
</rule>

<rule id="structural_guards" targets="language.core_format.expressions" by="product.system.checker">
<must>check a type parameter's guard structurally, by the type's members</must>
<then>concrete types stay nominal after compilation, so tagged encodings carry their names</then>
</rule>
