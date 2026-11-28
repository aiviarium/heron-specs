<section id="guide" @lens="explore">
This package is the specification of Heron, written in Heron. It's the source of truth:
an implementation that disagrees with it is a bug in one of the two. It's written so that
an implementer can build or change any part of the system from the part's subtree alone,
and it says what the system does, never how it's built.

<section id="layout">
The tree is split by [spec domain](#guide.layout.spec_domain), then by concern. Each [spec domain](#guide.layout.spec_domain) is a folder at the top, each
folder holds an index file and one file per concern, and a concern with parts of its own
is a folder again.

| Folder       | Holds                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------ |
| the top      | The vision and the package's goals, its actors and its parts, in `index.heron`, `actors.heron` and `system.heron` |
| `language/`  | The core format, the grammar, [schemas](#language.schemas.kinds.schema), markup, data, APIs, specifications, scripting, interop and the standard packages |
| `cli/`       | One command reference per subcommand of the `heron` command                                |
| `tools/`     | What the language server, prose linting, the docs, the server and the frontend do          |
| `learn/`     | The pages for people who use Heron: getting started, the how-tos and the concepts           |

<term id="spec_domain" aliases={["spec domain"]}>
A top-level folder of the spec: one area of the system with its own readers, such as the
language or the command line.
</term>

<term id="folder_scope" aliases={["folder scope"]}>
The scope a folder becomes when it's included as `./name/`: its nodes' paths start with
the folder's name, so `language/grammar/lexical.heron` declares nodes under
`language.grammar`.
</term>

<term id="concern_file" aliases={["concern file"]}>
A file that holds one concern of its folder, as one section or one command.
</term>

<rule id="folder_index" refs="actors.author">
<must>give every folder an `index.heron` that opens with one prose line saying what its scope specifies, and includes the folder's files and folders in reading order</must>
</rule>

<rule id="one_concern_per_file" refs="actors.author">
<must>keep one concern in a file, and split a file into a folder once it holds parts a reader would load apart</must>
</rule>

<rule id="folders_included_as_folders" refs="actors.author">
<must>include every folder as `./name/`, so its name is its [folder scope](#guide.layout.folder_scope) and its index is mounted under it</must>
<then>a node's path says where its file is, as `language.grammar.lexical`</then>
</rule>

<rule id="acronym_display_names" refs="actors.author">
<where>a folder's name is an acronym, as `cli/`</where>
<must>give its scope a [display name](#language.core_format.naming.display_name) with `@display` in the index that includes the folder, right after the include list, as `@display("CLI") cli {}`</must>
</rule>

<rule id="prose_in_markdown" refs="actors.author">
<must>write a concern whose content is mostly prose, terms and plain rules, their conditions and strengths in words, in a [prose file](#language.core_format.prose_layer.prose_file), with `<term>`, `<rule>` and the other [kind elements](#language.markup.tags.component_tag) where a node needs its kind, and keep in [Heron files](#language.core_format.files.heron_file) the package's indexes and includes, its configuration and its functional content: grammar productions, commands with their arguments, options and exits, APIs, [schemas](#schema), diagnostics, and rules whose arguments need lists or expressions</must>
<then>a folder mixes both, its `index.heron` including `.heron.md` files beside `.heron` ones: `learn/`, this guide and the prose concerns of `language/` and `tools/` are [prose files](#language.core_format.prose_layer.prose_file), while `cli/`, the grammar, the standard packages, the screens and every concern with a `diagnostics` section stay in Heron</then>
</rule>

<rule id="folder_lenses" refs="actors.author">
<where>a folder is for some [lenses](#tools.docs.lenses.lens_kind) of the docs alone</where>
<must>mark its scope with `@lens` in the index that includes the folder, right after the include list, as `@lens(developer) tools {}`</must>
<then>the tools are marked `@lens(developer)`, and the guide, a file, carries `@lens(explore)` on its section</then>
</rule>

<rule id="page_depth" refs="actors.author">
<must>set `docs { depth = 3 }` in the spec's [entry point](#language.core_format.files.entry_point), so the third level of sections gets pages of its own</must>
</rule>

<rule id="folder_names" refs="actors.author">
<must>name a folder with lower-case words joined by underscores</must>
<then>the folder's name is a valid scope name, the start of every path below it</then>
</rule>

<rule id="one_command_per_file" refs="actors.author">
<must>specify each subcommand of the binary as one `command` in a file of its own under `cli/`</must>
</rule>
</section>

<section id="kinds">
Everything is written in the kind that says it, so the checker, the lints and the
renderer can read it. Prose carries context and reasons, never a behaviour on its own.

| To state                          | Write                                                               |
| --------------------------------- | ------------------------------------------------------------------- |
| What an area is for               | a `goal` it opens with, with its `measure`                          |
| Who crosses the boundary          | an `actor`, once, at the package top                                |
| What's deliberately left out      | a `nongoal`                                                         |
| A behaviour                       | a `rule(subject, goal)` with one strength and its conditions        |
| A limit with an outside reason    | a `constraint` with its `reason`                                    |
| A party inside that rules bind    | a `part`, at the package top                                        |
| A [lifecycle](#language.specifications.lifecycles.lifecycle)                       | `states` and `transition`                                           |
| A word                            | a `term`, once, where its domain is                                 |
| An interaction                    | a `usecase` with its numbered steps and extensions                  |
| A case of a rule                  | a `scenario(rule)`                                                   |
| A measured quality                | a `quality` and a quality `scenario(quality)` with its `measure`     |
| A subcommand                      | a `command` with its usage, arguments, options and errors           |
| Syntax                            | a `grammar` of `production` and `token` nodes, from `std/grammar`   |
| A problem the product reports     | an `error` with its id, title, fields, projections and a link to its rule |
| A screen                          | a `screen` of nested `region` nodes                                 |
| An example a reader can run       | an `example` with a complete code block                             |

<rule id="behaviour_in_kinds" refs="actors.author">
<mustNot>state a behaviour in prose alone</mustNot>
<instead>state it as a rule, a use case step or a transition, with the prose around it giving the reasons</instead>
</rule>

<rule id="rules_name_subject" refs="actors.author">
<should>name the subject of a rule, an actor or a part, as its first reference, wherever the rule doesn't bind the system as a whole</should>
</rule>

<rule id="params_are_particular" refs="actors.author">
<must>declare as a kind's parameters the properties particular to that kind, as its variadic references, after its main positional parameters, what its nodes state a fact about, and as an annotation only a value more than one kind shares, as a [revision](#language.specifications.layers.revisions.revision) or the projections of one surface</must>
<then>a reference has no name of its own: `rule(desk, checkout)` binds the part `desk` and serves the goal `checkout` because of the kinds they are</then>
</rule>

The references of a spec follow four principles. Terms are vocabulary: a node mentions a term
in its prose, through a [short link](#heron.language.markup.links.short_link), and never references it. A reference is hard or soft:
a hard one is what a node states a fact about or carries out, counted by [coverage](#heron.language.specifications.traceability.coverage) and the gap
checks, and each one means what the kind it names makes it mean. A rule is a leaf that references
its subject, the goals and qualities it serves and the assumptions it relies on, and never
another rule, in its signature or its prose. References, the [short links](#heron.language.markup.links.short_link) in prose included,
run up or across the [layers](#heron.language.specifications.layers.layer) and never come back to where they start.

<rule id="references_in_constructor" refs="actors.author">
<should>write a node's [hard references](#language.specifications.layers.references.hard_reference) in its constructor, after its main positional parameters, as `rule(desk, self_service)`, `command("heron check", checks_tree)` and `op(Refund, refund_window)`, and write them with `@touch` only on a kind whose constructor takes none, as a type</should>
<then>`@touch` stays valid on any kind, beside or instead of the constructor's references, for an author who prefers to split them out; a reference is never in both</then>
</rule>

<rule id="soft_references_rare" refs="actors.author">
<should>link what a node is about in its prose, and write `@see`, a [soft reference](#language.specifications.layers.references.soft_reference), only for a reference the prose can't carry</should>
<example>`@see(refund_window)` above `Refund: type { … }` lists the type under "See also" on the rule's page, and [coverage](#heron.language.specifications.traceability.coverage) doesn't count it</example>
</rule>

<rule id="required_is_parameter" refs="actors.author">
<must>declare a required property as a parameter and never as an annotation, with the required parameters first, so a node can give them positionally</must>
<example>`usecase(customer, level = USER)` gives the required `actor` first, and `error("refund.WINDOW_EXPIRED")` its id</example>
</rule>

<rule id="diagnostics_section" refs="actors.author">
<must>write each problem the system reports as an `error` node of its own, in an `errors` section of the concern that reports it, with its prose linking the rule that says when it's reported, and keep the ids the command line prints</must>
<then>one id such as `conflict` can name more than one error, and the docs list them all on one page by id</then>
</rule>

An error is a result, not a party: it never names who reports it, with a reference. The
raiser names it, as an op's `@throws` or a command holding it, or the rule its prose links names the
raiser as its subject. The spec kinds and their annotations are part of the core, so a spec
imports `std/doc` for its sections and terms and nothing for its rules and errors.

<rule id="layer_placement" refs="actors.author">
<must>place each statement in the [layer](#heron.language.specifications.layers.layer) its test puts it in: what the people it's for want is intent, what the product guarantees at its boundary in the domain's words is the specification, and the exact bytes, flags, fields or screens of the boundary are the contract</must>
<then>an HTTP status, a field name or a flag in a rule's text belongs in the contract, as an error, an op or a command</then>
</rule>

<rule id="one_canonical_way" refs="actors.author">
<must>write each concept in the one core kind for it, and declare a kind of a package's own only for a concept no core kind holds, extending the core kind it's closest to</must>
</rule>

<rule id="examples_complete" refs="actors.author">
<must>write every code block of an `example` as a complete tree or file, so an implementation can extract the examples as its parser and checker fixtures</must>
</rule>

<rule id="no_small_tables" refs="actors.author">
<mustNot>write a [table](#heron.language.markup.components.table) in prose with one [column](#heron.language.grammar.lexical.column) or fewer than three rows below its header</mustNot>
<instead>write the rows as a list or a sentence, and keep [tables](#heron.language.markup.components.table) for data with [columns](#heron.language.grammar.lexical.column) to compare</instead>
</rule>

<rule id="user_pages" refs="actors.author">
<must>write what a person who uses Heron reads as [authored pages](#language.markup.authored_pages.authored_page) under `learn/`, each marked `@lens(user)`</must>
</rule>

<rule id="facts_inserted" refs="actors.author">
<where>an [authored page](#language.markup.authored_pages.authored_page) states a fact a node of the spec holds, such as the name of a command, the default of an option or the message of a diagnostic</where>
<must>insert it from that node, as `${cli.serve.addr.default}`, rather than copy it</must>
</rule>

<guidance id="named_instances">
A kind instance with a body and no arguments is written with a name, as
`saved: scenario { … }`: without one, `scenario { … }` enters a node that must
already exist. Names also give each scenario and step an anchor to link and verify.
</guidance>
</section>

<section id="reading">
An [implementer](#actors.implementer) loads one subtree and the surface of what
its rules target; everything else is loaded when a link leads there. A subtree is
complete when that's enough to build it.

<rule id="subtree_is_enough" refs="actors.author">
<must>write each section and command so that its subtree, the terms it links and the surface of its targets are all an implementer needs</must>
</rule>
</section>

<section id="changing">
The spec's authors design; an implementation builds what a version of the package states
and can't amend it. A behaviour the spec doesn't state is a finding for the authors, not a
choice for the implementer.

<rule id="unstated_behaviour_is_a_finding" refs="actors.implementer">
<when>building needs a behaviour the spec doesn't state</when>
<mustNot>decide that behaviour on the spec's behalf</mustNot>
<instead>report it to the spec's authors as a finding</instead>
</rule>

<rule id="versioned_changes" refs="actors.author">
<must>change the package's version with every change an implementation would see: the patch for a correction, the minor for a new behaviour, the major for a behaviour removed or changed</must>
</rule>

<rule id="in_place_before_release" refs="actors.author">
<while>the package is unreleased, before its first version is tagged or published</while>
<must>change it in place, so the tree and its docs describe only the current language, as if it had always been so, without deprecation marks, migration notes or diagnostics for kinds and syntax it has dropped</must>
<then>compatibility handling, such as deprecations and migration advice, starts with the first release and covers only versions that were released</then>
</rule>

<rule id="tree_stays_green" refs="actors.author">
<must>pass `heron check`, `heron lint` and `heron fmt --check`, and render as the documentation site, after every change</must>
</rule>
</section>
</section>
