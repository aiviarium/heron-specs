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
| `product/`   | The vision, the actors and personas, the shared glossary, and the backlog of epics         |
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

<rule id="folder_index" targets="guide.layout" by="product.actors.author">
<must>give every folder an `index.heron` that opens with one prose line saying what its scope specifies, and includes the folder's files and folders in reading order</must>
</rule>

<rule id="one_concern_per_file" targets="guide.layout" by="product.actors.author">
<must>keep one concern in a file, and split a file into a folder once it holds parts a reader would load apart</must>
</rule>

<rule id="folders_included_as_folders" targets="guide.layout" by="product.actors.author">
<must>include every folder as `./name/`, so its name is its [folder scope](#guide.layout.folder_scope) and its index is mounted under it</must>
<then>a node's path says where its file is, as `language.grammar.lexical`</then>
</rule>

<rule id="acronym_display_names" targets="guide.layout.folder_scope" by="product.actors.author">
<where>a folder's name is an acronym, as `cli/`</where>
<must>give its scope a [display name](#language.core_format.naming.display_name) with `@display` in the index that includes the folder, right after the include list, as `@display("CLI") cli {}`</must>
</rule>

<rule id="prose_in_markdown" targets="guide.layout" by="product.actors.author">
<must>write a concern whose content is mostly prose, terms and plain rules, their conditions and strengths in words, in a [prose file](#language.core_format.prose_layer.prose_file), with `<term>`, `<rule>` and the other [kind elements](#language.markup.tags.component_tag) where a node needs its kind, and keep in [Heron files](#language.core_format.files.heron_file) the package's indexes and includes, its configuration and its functional content: grammar productions, commands with their arguments, options and exits, APIs, [schemas](#schema), diagnostics, and rules whose arguments need lists or expressions</must>
<then>a folder mixes both, its `index.heron` including `.heron.md` files beside `.heron` ones: `learn/`, this guide and the prose concerns of `language/` and `tools/` are [prose files](#language.core_format.prose_layer.prose_file), while `cli/`, the grammar, the standard packages, the screens and every concern with a `diagnostics` section stay in Heron</then>
</rule>

<rule id="folder_lenses" targets="guide.layout.folder_scope" by="product.actors.author">
<where>a folder is for some [lenses](#tools.docs.lenses.lens_kind) of the docs alone</where>
<must>mark its scope with `@lens` in the index that includes the folder, right after the include list, as `@lens(developer) tools {}`</must>
<then>the product, this spec's own backlog, is marked `@lens(explore)`, the tools `@lens(developer)`, and the guide, a file, carries `@lens(explore)` on its section</then>
</rule>

<rule id="page_depth" targets="guide.layout" by="product.actors.author">
<must>set `docs { depth = 3 }` in the spec's [entry point](#language.core_format.files.entry_point), so the third level of sections gets pages of its own</must>
</rule>

<rule id="folder_names" targets="guide.layout" by="product.actors.author">
<must>name a folder with lower-case words joined by underscores</must>
<then>the folder's name is a valid scope name, the start of every path below it</then>
</rule>

<rule id="one_command_per_file" targets="guide.layout" by="product.actors.author">
<must>specify each subcommand of the binary as one `command` in a file of its own under `cli/`</must>
</rule>
</section>

<section id="kinds">
Everything is written in the kind that says it, so the checker, the lints and the
renderer can read it. Prose carries context and reasons, never a behaviour on its own.

| To state                          | Write                                                               |
| --------------------------------- | ------------------------------------------------------------------- |
| A behaviour                       | a `rule` with one strength, its conditions and `by` for its subject |
| A bound on something measured     | a `metric` and a `quality`                                          |
| A [lifecycle](#language.specifications.lifecycles.lifecycle)                       | `states` and `transition`                                           |
| A word                            | a `term`, once, where its domain is                                 |
| A need                            | a `story` with `criterion` nodes in a product epic                  |
| An interaction                    | a `usecase` with numbered steps and its branches                    |
| A subcommand                      | a `command` with its usage, arguments, options and exit codes       |
| Syntax                            | a `grammar` of `production` and `token` nodes                       |
| A message a tool reports          | a `diagnostic` with its code, severity, message and `by`            |
| A screen                          | a `screen` of nested `region` nodes                                 |
| An example a reader can run       | an `example` with a complete code block                             |

<rule id="behaviour_in_kinds" targets="guide.kinds" by="product.actors.author">
<mustNot>state a behaviour in prose alone</mustNot>
<instead>state it as a rule, a criterion, an invariant or a transition, with the prose around it giving the reasons</instead>
</rule>

<rule id="rules_name_subject" targets="guide.kinds" by="product.actors.author">
<should>name the subject of a rule with `by`: an actor, a [system part](#product.system) or a term</should>
<unless>the rule binds the system as a whole</unless>
</rule>

<rule id="diagnostics_section" targets="guide.kinds" by="product.actors.author">
<must>write each message the system reports as a `diagnostic` node of its own, in a `diagnostics` section of the concern that reports it, with `by` naming the system part that reports it</must>
<then>one code such as `conflict` can name more than one diagnostic, and the docs list them all in one index by code</then>
</rule>

<rule id="examples_complete" targets="guide.kinds" by="product.actors.author">
<must>write every code block of an `example` as a complete tree or file, so an implementation can extract the examples as its parser and checker fixtures</must>
</rule>

<rule id="no_small_tables" targets="guide.kinds" by="product.actors.author">
<mustNot>write a table in prose with one column or fewer than three rows below its header</mustNot>
<instead>write the rows as a list or a sentence, and keep tables for data with columns to compare</instead>
</rule>

<rule id="user_pages" targets="guide.kinds" by="product.actors.author">
<must>write what a person who uses Heron reads as [authored pages](#language.markup.authored_pages.authored_page) under `learn/`, each marked `@lens(user)`</must>
</rule>

<rule id="facts_inserted" targets="guide.kinds" by="product.actors.author">
<where>an [authored page](#language.markup.authored_pages.authored_page) states a fact a node of the spec holds, such as the name of a command, the default of an option or the message of a diagnostic</where>
<must>insert it from that node, as `${cli.serve.addr.default}`, rather than copy it</must>
</rule>

<guidance id="named_instances" targets="guide.kinds">
A kind instance with a body and no arguments is written with a name, as
`saved: criterion { … }`: without one, `criterion { … }` enters a node that must
already exist. Names also give each criterion and step an anchor to link and verify.
</guidance>
</section>

<section id="reading">
An [implementer](#product.actors.implementer) loads one subtree and the surface of what
its rules target; everything else is loaded when a link leads there. A subtree is
complete when that's enough to build it.

<rule id="subtree_is_enough" targets="guide.reading" by="product.actors.author">
<must>write each section, command and epic so that its subtree, the terms it links and the surface of its targets are all an implementer needs</must>
</rule>
</section>

<section id="changing">
The spec's authors design; an implementation builds what a version of the package states
and can't amend it. A behaviour the spec doesn't state is a finding for the authors, not a
choice for the implementer.

<rule id="unstated_behaviour_is_a_finding" targets="guide.changing" by="product.actors.implementer">
<when>building needs a behaviour the spec doesn't state</when>
<mustNot>decide that behaviour on the spec's behalf</mustNot>
<instead>report it to the spec's authors as a finding</instead>
</rule>

<rule id="versioned_changes" targets="guide.changing" by="product.actors.author">
<must>change the package's version with every change an implementation would see: the patch for a correction, the minor for a new behaviour, the major for a behaviour removed or changed</must>
</rule>

<rule id="tree_stays_green" targets="guide.changing" by="product.actors.author">
<must>pass `heron check`, `heron lint` and `heron fmt --check`, and render as the documentation site, after every change</must>
</rule>
</section>
</section>
