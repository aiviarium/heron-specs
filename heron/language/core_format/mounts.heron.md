# Mounts {#mounts}

A [mount](#language.core_format.mounts.mount) gives a subtree a prefix: files included inside a scope, or a folder included
by its name, put their nodes under that scope. A scope written `name.{ … }` is the
other way to reach a path from one place.

<term id="mount">
The node under which the files of a subtree are put: the scope an `include` is set in, or a
node named after a folder included as `"./name/"`. Names declared in the subtree get
the mount's path as their prefix.
</term>

<term id="scope_term">
`name.{ … }`: a body that amends the node at a path, creating every node of the path
that's missing. A path-less `.{ … }` is a group, whose members are flattened into the
current scope.
</term>

<rule id="folder_mounts" refs="system.checker">
<must>put the `index.heron` of an included folder under a node named after the folder, and the files that index includes under it in turn</must>
<example>`include = ["./disputes/"]`: `disputes/index.heron` mounted as `disputes`</example>
</rule>

<rule id="scoped_includes" refs="system.checker">
<must>[mount](#language.core_format.mounts.mount) the files an `include` inside a scope lists under that scope, where they see its names and the imports of the files around it</must>
</rule>

<rule id="mounted_names_prefixed" refs="system.checker">
<must>let names be seen into a [mount](#language.core_format.mounts.mount), from the files mounted there, and never out of it: a sibling reaches a mounted name through the mount's prefix</must>
<example>`orders.pet_lifecycle`, not `pet_lifecycle`, from a file beside the `orders` folder</example>
</rule>

<rule id="scopes_create" refs="system.checker">
<must>amend the node at a scope's path, creating each missing node of the path as an untyped node</must>
<then>unlike `name { … }`, a scope never reports a missing node</then>
</rule>

<rule id="groups_flatten" refs="system.checker">
<must>put the members of a path-less `.{ … }` into the current scope as if written there, with the group's annotations applying to each</must>
<example>`@profile(local) .{ … }`: every member inside is in the `local` [profile](#language.data.configuration.profile)</example>
</rule>
