# Generics {#generics}

A type can take types as parameters, as `Page(T: Any): type`, and its members are read
through the arguments it's used with. `Patch(T)` from `std/types` is the one generic the
checker knows by name: every member of `T`, each optional.

<rule id="generic_members" targets="language.schemas.generics" by="product.system.checker">
<must>check a value of a [generic type](#language.data.types.generic_type) against its members with each type parameter replaced by the argument in its place</must>
<example>in a `Page(Refund)`, `first` is checked as a `Refund` and `items` as a `List(Refund)`</example>
</rule>

<rule id="patch" targets="language.schemas.generics" by="product.system.checker">
<must>check a value of `Patch(T)` as a map whose keys are members of `T`, each optional, of its member's type or `null` to clear it</must>
<example>`Patch(Refund) = { amount = 3 }` and `{ id = null }` check; `{ amout = 3 }` reports "Refund has no member amout"</example>
</rule>

<rule id="patch_needs_map" targets="language.schemas.generics" by="product.system.checker">
<if>a value of `Patch(T)` isn't a map</if>
<must>report "expected Patch, got ‹what the value is›", coded `type`</must>
<example>`p: Patch(Refund) = 3` reports "expected Patch, got a number"</example>
</rule>
