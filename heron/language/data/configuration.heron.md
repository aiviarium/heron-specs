# Configuration {#configuration}

Configuration is data set on paths that packages declare: `ci.retries.staging = 0`
sets one key of a typed node, and a second file [layers](#heron.language.specifications.layers.layer) on the first. The amending rules
are the [core format](#language.core_format.amends)'s; this section says how they read
as configuration. [The base configuration](#language.data.configuration.data_configuration) sets `ci`, and [a second file](#language.data.configuration.data_layering)
[layers](#heron.language.specifications.layers.layer) on it.

<term id="value_binding">
`name = value`, which binds; a path amends, so `ci.retries.staging = 0` adds to
`ci.retries` without replacing it, while `ci.retries = { main = 0 }` drops what was
there.
</term>

<term id="profile">
`@profile(staging)` above a node or a `.{ … }` group keeps it only in that profile,
and an `if` expression chooses a value, as in
`timeout = if env.profile == "staging" { "30m" } else { "20m" }`.
</term>

<rule id="scopes_amend" targets="value_binding" by="system.checker">
<must>open the scope `ci` for `ci.{ … }`, creating it if it doesn't exist, and add to the same scope from a second `ci.{ … }` or a deeper `ci.retries.{ … }`</must>
</rule>

<rule id="maps_merge" targets="value_binding" by="system.checker">
<must>merge a map by key when a path into it is set, and replace a map or a list when it's assigned whole</must>
<then>`ci.retries.staging = 0` keeps `main` and `develop`, and `ci.retries = { main = 0 }` keeps only `main`</then>
</rule>

<rule id="layering" targets="value_binding" by="system.checker">
<must>apply a file's settings on top of the files it includes, in include order, and settings within a file top to bottom</must>
<then>`ci/local.heron`, including `./base.heron`, wins wherever both set a path</then>
</rule>

<rule id="locals_not_amended" targets="language.core_format.nodes.locals.local_term" by="system.checker">
<mustNot>let another file read or amend a `let` binding</mustNot>
<instead>keep a local in the file that declares it, so a base file's defaults can only be changed through the paths it sets</instead>
</rule>

<rule id="typed_configuration" targets="value_binding" by="system.checker">
<if>a path sets a key that the type of the node it amends doesn't declare</if>
<must>report [no field](#language.core_format.amends.errors.no_field) with the closest field</must>
<while>it's not the case that the node is an untyped `{ }` map, or another [open node](#language.core_format.amends.open_node)</while>
</rule>

<rule id="profiles" targets="profile" by="system.checker">
<must>keep a node or group under `@profile(name)` only when the tree is read in that [profile](#language.data.configuration.profile), chosen with `--profile` and `default` when none is given</must>
</rule>

<rule id="build_time_conditions" targets="profile" by="system.interpreter">
<must>evaluate an `if` that chooses a setting while the tree is read, from values known then, and report one whose condition reads a value only known when a task runs</must>
</rule>

<example id="data_configuration" @display="Configuration">
```heron
import = ["std/ci@1"]

let default_retries = 2

ci.{
  branches = [
    BranchPolicy(branch = "main",   tests = all,      where = remote),
    BranchPolicy(branch = `work/*`, tests = optional, where = local),
  ]
  retries = { main = 0, develop = default_retries }
}

// Amends ci and keeps everything else.
ci.retries.staging = 0
ci.timeout = "20m"
```
</example>

<example id="data_layering" @display="Layering a second file">
```heron
// ci/local.heron
import = ["std/ci@1", "std/env@1"]
include = ["./base.heron"]

ci.retries.develop = 5
ci.branches.append(BranchPolicy(branch = `work/*`, tests = optional, where = local))

@profile(local) .{
  ci.timeout.remove()
  db.pool_size = 2
}
```
</example>
