# Exports {#exports}

A package puts nodes into a tree that imports it only by exporting them. `std/ci`
declares `development<export>`, as [the export example](#language.core_format.exports.export_example) shows, so importing it [mounts](#language.core_format.mounts.mount)
`development` at the importing tree's root, once however often it's imported, and the
tree enters it with `development { … }`.

<rule id="import_mounts_exports_only" targets="language.core_format.imports.import_term" by="product.system.checker">
<must>put none of a package's nodes into the tree except those flagged `<export>`, each mounted at the root of the tree that imports it</must>
</rule>

<rule id="exports_once" targets="language.core_format.imports.import_term" by="product.system.checker">
<must>[mount](#language.core_format.mounts.mount) an exported node once, whatever the number of files that import its package</must>
</rule>

<rule id="export_conflict" targets="language.core_format.imports.import_term" by="product.system.checker">
<if>two packages export the same name, or the tree declares a name a package exports</if>
<must>report [exported twice](#language.core_format.conflicts.diagnostics.exported_twice) or [exported and declared](#language.core_format.conflicts.diagnostics.exported_and_declared)</must>
</rule>

<example id="export_example" @display="Exporting a node">
```heron
Development: type {
  commits: Commits
}

/// The repository's one development process.
development<export>: Development
```
</example>
