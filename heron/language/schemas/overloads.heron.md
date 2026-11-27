# Overloads {#overloads}

One kind can have several signatures, each declared with `<overload>` on its name. A call
takes the first that fits, so `link` takes a URL or a node.

<term id="overload">
One of several signatures of a kind, each a declaration of the same name marked
`<overload>`, as `link<overload>(uri: String)` and `link<overload>(target: Ref(Any))`.
</term>

<rule id="overload_selection" @targets="overload" @by="system.checker">
<when>a kind with [overloads](#language.schemas.overloads.overload) is called</when>
<must>check the arguments against each signature in declaration order without reporting, and take the first with no errors</must>
<then>the instance's fields and children follow the chosen signature</then>
<example>`link("https://example.com")` and `link(uri = "https://example.com")` take the first signature, `link(overview)` and `link(target = overview)` the second</example>
</rule>

<rule id="paths_are_refs" @targets="overload" @by="system.checker">
<while>signatures are tried</while>
<must>read a path that names a declared node as a reference, never as a [scalar](#language.data.values.scalar)</must>
<example>`link(overview)` takes the `Ref` signature although a path could pass for a string</example>
</rule>

<rule id="no_overload_fits" @targets="overload" @by="system.checker">
<if>no signature fits</if>
<must>report the first signature's errors, as for a kind without [overloads](#language.schemas.overloads.overload)</must>
<example>`link(href = "x")` reports "link takes no argument href"</example>
</rule>

<rule id="overloads_together" @targets="overload" @by="actors.author">
<must>flag every signature of an overloaded kind `<overload>`, and declare them in one package</must>
A declaration without the flag is declared twice, which is a
conflict.
</rule>
