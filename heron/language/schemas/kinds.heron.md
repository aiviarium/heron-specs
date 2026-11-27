# Kinds {#kinds}

A [schema](#language.schemas.kinds.schema) says which kinds, categories, flags,
annotations and embedded languages a package adds, and where each is valid. [Schemas](#language.schemas.kinds.schema) are
[Heron files](#language.core_format.files.heron_file) that import `std/schema`, so the
format describes its own packages, and they're how the system is extended: everything a
package adds is declared in one, and what needs code is implemented by an
[extension](#language.schemas.extensions.extension_process), so nothing needs a new
build of the `heron` binary.

| Kind         | Declares                                                       | Example                                               |
| ------------ | -------------------------------------------------------------- | ----------------------------------------------------- |
| `package`    | The root of a [schema](#language.schemas.kinds.schema) file, with its version and requirements   | `scenarios: package(version = "1.0")`                 |
| `category`   | An open set of kinds that bodies accept                        | `block: category`                                     |
| `kind`       | A node kind, valid in structure and as a tag in prose          | `scenario(on?: Ref(Any)): kind`                       |
| `accept`     | Inside a kind: what its body takes                             | `accept(kind = cases, max = 1)`                       |
| `flag`       | A flag and the kinds it attaches to                            | `slow: flag(on = [case])`                             |
| `annotation` | An annotation, its parameters and what it attaches to          | `status(code: Int): annotation(on = [types.variant])` |
| `language`   | An embedded language and the grammar to inject                 | `sh: language(grammar = "source.shell")`              |
| `extension`  | An external program that implements `@extern(…)` declarations  | `compliance: extension(command = […])`                |
| `lint`       | A check over the tree that `heron lint` runs                   | `no_plain_secrets: lint`                              |
| `resource`   | A resource whose instances a driver provides                   | `vault: resource(Secrets)`                            |
| `generator`  | A generation adapter for a target of `heron generate`          | `ts: generator(target = "ts")`                        |

<term id="schema">
A [Heron file](#language.core_format.files.heron_file) that imports `std/schema` and
declares what a package adds. Schemas drive checking, completion, the docs and
[semantic highlighting](#language.schemas.highlighting.semantic_highlighting).
</term>

<rule id="parsing_needs_no_schema" @targets="schema" @by="system.parser">
<mustNot>read a [schema](#language.schemas.kinds.schema), or any package, to parse a file</mustNot>
<instead>parse every file by the grammar alone, and leave what's valid where to the checker</instead>
</rule>

<section id="packages">
A package is a node of kind `package` at the root of its `package.heron`, named after
the package's last path segment, as `doc: package(version = "1.0")` in `std/doc`.

<rule id="package_version" @targets="language.schemas.kinds.packages" @by="system.checker">
<must>read a package's major version from its `version` argument, a dotted version such as `"1.0"`, and resolve an import `std/doc@1` only to a package whose major version is 1</must>
</rule>

<rule id="package_requires" @targets="language.schemas.kinds.packages" @by="actors.author">
<must>list in `requires` every package whose kinds or types the package's declarations use, by name and major version, and import the same packages in the file</must>
<example>`tech: package(version = "1.0", requires = ["std/doc@1", "std/spec@1"])`</example>
</rule>

<rule id="package_body" @targets="language.schemas.kinds.packages" @by="system.checker">
<must>accept any member in a package's body, as a file's root does</must>
</rule>
</section>

<section id="declaring">
A kind is declared like any node: its name, its parameters in `( )`, then `: kind`
with the kind's own arguments, then a body of `accept` entries and typed members.

<rule id="kind_params" @targets="language.schemas.kinds.declaring" @by="system.checker">
<must>read a kind's parameters as the arguments its instances take, checked as the [parameters and arguments](#language.core_format.nodes.params_and_args) of any call</must>
<example>`scenario(on?: Ref(Any)): kind` takes `scenario(on = payments)`</example>
</rule>

<rule id="required_params_first" @targets="language.schemas.kinds.declaring" @by="system.checker">
<if>a kind's or an annotation's declaration lists a required parameter after an optional or a variadic one</if>
<must>report "required parameter ‹name› follows ‹earlier›; declare required parameters first" at the parameter, coded `param-order`, so every node can give its required arguments positionally</must>
<example>`usecase(actor: Ref(actor), level?: UseCaseLevel): kind` takes `usecase(customer, level = USER)`, and `usecase(level?: UseCaseLevel, actor: Ref(actor)): kind` is reported</example>
</rule>

<rule id="kind_fields" @targets="language.schemas.kinds.declaring" @by="system.checker">
<must>read a typed member in a kind's body, as `metric?: Ref(metric)`, as a field its instances set in their bodies, checked like any typed value</must>
</rule>

<rule id="unknown_fields" @targets="language.schemas.kinds.declaring" @by="system.checker">
<if>an instance's body sets a name that's neither a field of its kind nor a child its kind accepts</if>
<must>report "‹node› has no field ‹name›" with the closest field, coded `unknown-field`</must>
</rule>

| Argument      | Type                 | Default | Means                                                                                     |
| ------------- | -------------------- | ------- | ----------------------------------------------------------------------------------------- |
| `in`          | `List(Ref(category))` | none    | The categories the kind joins                                                            |
| `heading`     | `Bool`               | `false` | A heading in a [prose file](#language.core_format.prose_layer.prose_file) becomes this kind |
| `typed`       | `Bool`               | `false` | The kind's instances are typed members: the expression after `:` is a type                |
| `args_from`   | `Ref(kind)`          | none    | Instances take the parameters of the nearest enclosing node of that kind as arguments     |
| `fields_from` | `Ref(kind)`          | none    | Instances take the parameters of the nearest enclosing node of that kind as fields        |
| `modes`       | `List(Mode)`         | all     | The [modes](#language.schemas.modes.parse_mode) the kind stands in                        |

<rule id="heading_kind" @targets="language.schemas.kinds.declaring" @by="system.checker">
<when>a [prose file](#language.core_format.prose_layer.prose_file) has a heading</when>
<must>make the heading a node of the innermost kind in scope declared with `heading = true`</must>
<example>`std/doc` declares `section: kind(in = [block], heading = true)`, so `## Payments` is a section</example>
</rule>

<rule id="typed_kind" @targets="language.schemas.kinds.declaring" @by="system.checker">
<must>read the expression after `:` as a type in a body whose kind accepts a kind declared with `typed = true`, and make each typed value there an instance of the first such kind it accepts</must>
<example>a member `amount: Money?` in a `type` body is a `types.member`</example>
</rule>

<rule id="infer_has_no_effect" @targets="typed_kind" @by="system.checker">
<must>accept `infer = true` on an `accept` entry and give it no effect: `typed = true` on the accepted kind alone makes a typed value its instance</must>
</rule>

<rule id="args_from" @targets="language.schemas.kinds.declaring" @by="system.checker">
<where>a kind is declared with `args_from = k`</where>
<must>check an instance's arguments against the parameters of its nearest enclosing node of kind `k`</must>
<example>in `std/scenarios`, `case(days_ago = 31)` under `late_request(days_ago: Int): scenario` is checked against `days_ago: Int`</example>
</rule>

<rule id="fields_from" @targets="language.schemas.kinds.declaring" @by="system.checker">
<where>a kind is declared with `fields_from = k`</where>
<must>accept as fields of an instance the parameters of its nearest enclosing node of kind `k`, each with its parameter's type</must>
<example>`std/types` declares `example: kind(fields_from = op)`, so an example under `get_pet(pet_id: Int): op` sets `pet_id`</example>
</rule>
</section>

<section id="refs">

<term id="ref_type" @display="Ref">
`Ref(K)` from `std/schema`: a reference to a node, written as its path, where `K`
names the kind the reference is meant to reach. A `Ref` argument such as
`on = payments` is checked as a path and highlighted as a link.
</term>

<rule id="refs_resolve" @targets="ref_type" @by="system.checker">
<must>resolve a value of type `Ref(K)` as a path to a node, report a path that names nothing as unresolved, and report a literal as "expected Ref, got ‹what the literal is›", coded `type`</must>
</rule>

<rule id="ref_kind_documents" @targets="ref_type" @by="system.checker">
<mustNot>report a reference whose target's kind differs from `K`</mustNot>
<instead>read `K` as documentation and as the completion filter of the language server</instead>
</rule>
</section>

`std/scenarios` below declares the kinds of the Testing tab with every part of a kind:
parameters, categories, `args_from`, `accept` entries with bounds, flags and an
annotation. `args_from = scenario` makes `case(days_ago = 31)` check against
`late_request(days_ago: Int)`.

<example id="std_scenarios_schema" @display="Example: std/scenarios">
```heron
import = ["std/schema@1", "std/doc@1", "std/types@1"]

scenarios: package(version = "1.0", requires = ["std/doc@1", "std/types@1"]) {
  slow: flag(on = [case])
  skip: flag(on = [case])
  generate: flag(on = [verification])

  scenario(on?: Ref(Any)): kind {
    accept(prose)
    accept(kind = cases, max = 1)
    accept(kind = before, max = 1)
    accept(kind = verification, max = 1)
  }

  /// Verification directed by an agent; its prose says what to probe.
  review(on?: Ref(Any)): kind {
    accept(prose)
  }

  cases: kind {
    accept(kind = case)
    accept(kind = each)
    accept(kind = csv)
  }

  case: kind(args_from = scenario)
  each: kind(args_from = scenario)
  csv(file: String): kind

  before: kind {
    accept(code)
  }

  verification: kind {
    accept(code)
  }

  expect(value: Bool): func
  judge(value: Any, rubric: Prose): func

  /// The spec nodes a scenario, review or example covers.
  covers(targets<variadic>: Ref(Any)): annotation<repeatable>(on = [scenario, review, types.example])

  generated(by: String, reviewed_by?: String): annotation(on = [scenario, verification])

  @insert(Insert.QUOTE)
  sh: language(grammar = "source.shell", env = Env.PARAMS)

  @insert(Insert.LITERAL)
  js: language(grammar = "source.js", env = Env.VARIABLES)
}
```
</example>

<rule id="schema_kinds_by_example" @targets="language.schemas.kinds" @by="actors.author">
<mustNot>import `std/schema` into Heron's own spec, which would make `kind`, `flag` and the other [schema](#language.schemas.kinds.schema) kinds part of the spec tree</mustNot>
<instead>show a standard package's declarations in examples, and link to one only from a file that imports its package, as [node links into imported packages](#language.markup.links.imported_declarations) allow</instead>
</rule>
