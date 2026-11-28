# Mixing {#mixing}

Prose and structure mix in both directions, and packages mix with each other, through
one content model: what a body accepts is its kind's [schema](#language.schemas.kinds.schema), and the same kinds stand as
children in structure and as tags in prose.

<term id="implied_kinds">
Kinds the [schema](#language.schemas.kinds.schema) implies where none is written. A kind with `heading = true` is what a
heading in a [prose file](#language.core_format.prose_layer.prose_file) becomes; one
with `typed = true` reads the expression after `:` as a type, so `amount: Money?` in a
type's body is a `member`. A scope has no kind of its own: it amends what its path
names.
</term>

<rule id="both_directions" refs="system.checker">
<must>admit an accepted kind as a child in structure and as a tag in prose alike, with the same arguments and children</must>
<example>`tip { | Text }` and `<tip>Text</tip>`: the same node</example>
</rule>

<rule id="heron_file_root" refs="system.checker">
<must>let a [Heron file](#language.core_format.files.heron_file)'s root hold any member, of any kind of the packages in its `import`</must>
</rule>

<rule id="prose_file_root" refs="system.checker">
<must>let a [prose file](#language.core_format.prose_layer.prose_file)'s root hold prose, tags of `block` and `inline` kinds, headings and `heron` fences</must>
</rule>

<rule id="extend_from_own_side" refs="system.checker">
<must>let a package join another package's category with `in`, and attach its flags and annotations to another package's kinds with `on`, valid only where the extending package is in `import`</must>
<example>`std/http` attaches `@body` and `@path` to `types.param` without touching `std/types`</example>
</rule>
