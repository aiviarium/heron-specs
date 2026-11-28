# Agent export {#agents}

The [agent export](#tools.docs.agents.agent_export) is the tree written for agents to read: plain Markdown files
an agent opens by path, a small index it loads first and one file per area it opens when
the task leads there. It's a lens like any other, the standard [`agent` lens](#tools.docs.standard_lenses.agent_lens)
in Markdown, so what it shows is decided by the same lists and marks as the site's
pages, and a package changes it by declaring a lens of that name.

Agents read a spec as files: a short index first, then only the file a task needs, each
small enough to read whole and plain enough to quote. So the export holds no page chrome,
no diagram and no script, gives every requirement its full id where a search finds it, and
says the same thing in the same place in every file.

<term id="agent_export" aliases={["agent export"]}>
The Markdown files the [`agent` lens](#tools.docs.standard_lenses.agent_lens) writes of a tree: its
[agent index](#tools.docs.agents.agent_index), its `llms.txt`, one [area file](#tools.docs.agents.area_file) per area and
the [context packs](#tools.docs.agents.context_pack) asked for.
</term>

<term id="area_file" aliases={["area file"]}>
One Markdown file of the [agent export](#tools.docs.agents.agent_export): the nodes of one feature, section, [folder scope](#guide.layout.folder_scope), command or api, or one part
of them, ordered by [layer](#language.specifications.layers.layer).
</term>

<term id="agent_index" aliases={["agent index"]}>
`INDEX.md`, the file of the [agent export](#tools.docs.agents.agent_export) an agent reads first: what the product is, how
to read the files and a map of them.
</term>

<term id="stable_id" aliases={["stable id"]}>
A node's [path](#language.core_format.naming.node_path) inside its package, as
`language.apis.grpc.numbering.unique_numbers`, or its path in the tree for a node of no
package: the name the export gives a node in its heading, its file's name and every link to it.
</term>

<term id="approximate_tokens" aliases={["approximate tokens"]}>
The size of a file in tokens as the export counts it: its length in bytes divided by four,
rounded up.
</term>

<term id="size_budget" aliases={["size budget"]}>
The [approximate tokens](#tools.docs.agents.approximate_tokens) an [area file](#tools.docs.agents.area_file) may hold: the lens's `budget`, `6000` unless it sets one,
small enough for an agent to read the file whole in one step.
</term>

<term id="context_pack" aliases={["context pack"]}>
One Markdown file of one subtree, written on request beside the [agent export](#tools.docs.agents.agent_export): the subtree
in full and the surface of what it links, for a task that needs that part alone.
</term>

## Files {#files}

<rule id="export_lens" refs="system.docs_generator">
<must>write the [agent export](#tools.docs.agents.agent_export) through the lens named `agent` in scope, keeping, summing up and leaving out each node as [what a lens shows](#tools.docs.lenses.what_a_lens_shows) says</must>
<then>a tree that declares its own `agent` lens changes what agents read, as an override of any lens does</then>
</rule>

<rule id="export_files" refs="system.docs_generator">
<must>write the [agent index](#tools.docs.agents.agent_index), an `llms.txt` and an [area file](#tools.docs.agents.area_file) for each section and [folder scope](#guide.layout.folder_scope) less than the lens's `depth` levels down, the docs block's `depth` where the lens sets none, and for each feature, command and api at any depth, that the lens keeps something of, named by its [stable id](#tools.docs.agents.stable_id) and `.md`, as `language.apis.grpc.md`, all in one folder; and write the nodes at the top of the tree, outside every such section, in `_root.md`</must>
<then>a file's path is its node's id, so an agent and a link can rely on it from one version to the next</then>
</rule>

<rule id="budget_split" refs="system.docs_generator">
<while>an [area file](#tools.docs.agents.area_file) would hold more [approximate tokens](#tools.docs.agents.approximate_tokens) than the lens's [size budget](#tools.docs.agents.size_budget)</while>
<must>give each section and [folder scope](#guide.layout.folder_scope) it holds a file of its own; and where it's still over the budget and holds no section, split it into parts at the boundaries between its nodes, in order, each within the budget, the first named by the id and the others by the id, a dot and the part's number from 2, as `language.apis.grpc.2.md`</must>
<then>only a file of one node larger than the budget is over it, and the same tree always splits the same way</then>
</rule>

<rule id="deterministic_export" refs="system.docs_generator">
<must>write the same bytes for the same tree and lens on every run and every machine, with `\n` line ends and every list in the order this section gives it</must>
<then>a checked-in export changes only where the tree does, and an unchanged file isn't rewritten</then>
</rule>

<rule id="plain_markdown" refs="system.docs_generator">
<must_not>write HTML, a diagram, an image, a script or the site's navigation into a file of the [agent export](#tools.docs.agents.agent_export)</must_not>
<instead>write headings, paragraphs, lists, code blocks and links alone, the prose of each node as Markdown with its links resolved</instead>
</rule>

<rule id="relative_links" refs="system.docs_generator">
<must>write a link to a node the [agent export](#tools.docs.agents.agent_export) holds as a relative Markdown link to the file that holds it, with the node's [stable id](#tools.docs.agents.stable_id) as its fragment, and a link to a node it doesn't hold as the link's text followed by the node's id in code</must>
<example>`[field number](language.apis.grpc.md#language.apis.grpc.field_number)`</example>
</rule>

## Index {#index}

<rule id="index_contents" refs="system.docs_generator">
<must>write in the [agent index](#tools.docs.agents.agent_index), in this order: the site's title; what the product is, from its intent: the prose of the tree's top and each of its goals and of what it leaves out, one line each; how to read the files: the order of the [layers](#language.specifications.layers.layer) in a file, the form of a heading and its [stable id](#tools.docs.agents.stable_id), the strengths, the links and the mark on [derived lists](#language.specifications.layers.derived_list); and the map of the top areas alone, the [area files](#tools.docs.agents.area_file) with no other [area file](#tools.docs.agents.area_file) above them, each as a link to its path with its title, the first sentence of its node's prose as plain text, cut at a word to 100 characters, and its size in [approximate tokens](#tools.docs.agents.approximate_tokens), in the order of the tree; and last a part `Features` that groups the tree by [feature](#language.specifications.context.feature_kind): each feature, nested as they nest, as a link to the file that holds it with its title and the number of its requirements, those it holds and those that reference it</must>
<then>the index grows with the number of top areas and features, not with the number of files, and an agent goes down from it one area or one feature at a time</then>
</rule>

<rule id="child_maps" refs="system.docs_generator">
<while>other [area files](#tools.docs.agents.area_file) stand directly below an [area file](#tools.docs.agents.area_file)</while>
<must>end the first part of that [area file](#tools.docs.agents.area_file) with a Files below part mapping those files as the index maps the top areas, in the order of the tree</must>
<then>any file is reached from the index through the maps of the areas above it</then>
</rule>

<rule id="llms_txt" refs="system.docs_generator">
<must>write `llms.txt` as the llms.txt convention lays it out: the site's title as its heading, the first sentence of the tree's top prose as a quote, then a list linking the [agent index](#tools.docs.agents.agent_index) first and every [area file](#tools.docs.agents.area_file) after it, each with its title</must>
</rule>

## File content {#content}

An [area file](#tools.docs.agents.area_file) reads from why to what to exactly how: the context of its sections, then the
goals and actors, then what the product guarantees, then the exact surface.

<rule id="file_order" refs="system.docs_generator">
<must>write an [area file](#tools.docs.agents.area_file) as its node's title and id as its heading; a line linking the [agent index](#tools.docs.agents.agent_index) and, for a part, the parts before and after it; its node's prose; a part `Sections` with each section it holds, its heading, its id and its prose, or a link where it has a file of its own; then the parts `Intent`, `Specification` and `Contract`, each with the file's nodes of that [layer](#language.specifications.layers.layer) in the order the tree writes them; then `Notes`, with its nodes of no [layer](#language.specifications.layers.layer); and last `Terms used here`</must>
<then>whatever file an agent opens, the reasons come first and the exact bytes last</then>
</rule>

<rule id="node_headings" refs="system.docs_generator">
<must>write each node of a part under a heading of its own, its kind's name and its full [stable id](#tools.docs.agents.stable_id), as `### rule language.apis.grpc.numbering.unique_numbers`, and the parts a node is written with, such as a rule's conditions or a command's options, inside its own text</must>
<then>an agent finds any requirement by searching its id, and the heading says what kind of statement it is</then>
</rule>

<rule id="requirement_form" refs="system.docs_generator">
<must>write a rule, a constraint or a quality as its strength's keyword first, then its sentence with its conditions in the order `where`, `while`, `when` and `if`, its subject and its behaviour, as the docs' sentence reads; then each `then`, `instead` and example as a line of its own after its kind's name; then a line of its references, each a link after the word its kind gives it: `by` its subject, `serves` its goals and qualities, `relies on` its assumptions, `asked by` its actors and `joins` the features it references</must>
<example>`must: If two fields of a message, or two values of an enum, have one number, the checker must report number used twice at the second.`</example>
</rule>

<rule id="contract_signatures" refs="system.docs_generator">
<must>write an op as its signature, its name with each parameter's name, type, place and whether it's optional, and its result; then each of its bindings, its HTTP method and path, its gRPC method, its JSON-RPC method and its [Sparrow method](#language.apis.sparrow.sparrow_method) with its id, shape, input, output and flags; then each error it answers with the effective code of each binding, its HTTP status, [gRPC code](#language.apis.grpc.status_codes.grpc_code), JSON-RPC code, [Sparrow code](#language.apis.sparrow.status_codes.sparrow_code) or sigil, each marked derived or explicit; write an api with its bindings, its [Sparrow service](#language.apis.sparrow.sparrow_service) and facet with their ids and the facet hash among them; write an error node the same way, with its id, status, severity, title and members; and write a command as its usage line, its arguments, its options with their defaults, and its exits with their statuses</must>
<then>an agent reads the whole boundary of an op or a command from one place</then>
</rule>

<rule id="types_compact" refs="system.docs_generator">
<must>write a type, an enum, a union or an interface as its doc text, then its declaration as written, in a `heron` code block without its doc comments</must>
</rule>

<rule id="examples_compact" refs="system.docs_generator">
<must>write an example node as its code blocks, as written, with its prose before them, and an example inside a rule as one line of the rule</must>
</rule>

<rule id="summarized_nodes" refs="system.docs_generator">
<while>the lens sums a node up</while>
<must>write its heading and one line: a rule's sentence, or else the first sentence of its prose</must>
</rule>

<rule id="other_kinds" refs="system.docs_generator">
<while>a node's kind has no form this section gives, as a kind a package declares</while>
<must>write its heading, its prose and each field and argument it sets as a line, `name: value`, written in the form of the core kind it extends where it extends one</must>
</rule>

<rule id="terms_per_file" refs="system.docs_generator">
<must>list under `Terms used here` each term the file's nodes link that the file doesn't define, once, in the order of their words, each a link with the first sentence of its definition</must>
<then>a file explains its words without the agent opening another</then>
</rule>

## Context packs {#packs}

<rule id="pack_file" refs="system.docs_generator">
<must>write the [context pack](#tools.docs.agents.context_pack) of a node to `packs/` in the export's folder, named by its [stable id](#tools.docs.agents.stable_id) and `.md`, as one [area file](#tools.docs.agents.area_file) of its whole subtree, its sections in its parts and never split; then a part `Linked from here`, with each node outside the subtree that its nodes link, once, in the order of the tree, as its heading and its one line, as the export [summarizes](#tools.docs.agents.content) a node</must>
<then>an agent working on one area loads one file, and the links out of it still lead into the export</then>
</rule>

## Where it's written {#written}

<rule id="agents_target" refs="system.generator">
<must>write the [agent export](#tools.docs.agents.agent_export) to `.heron/agents/` for the `agents` target, removing the files of its last run there that this run doesn't write, as the [docs site](#tools.docs.site) removes its own stale pages</must>
</rule>

<rule id="site_carries_export" refs="system.docs_generator">
<must>write the [agent export](#tools.docs.agents.agent_export) into the documentation site too, in the folder the `agent` lens's `prefix` names, and an `llms.txt` at the site's root whose links lead into that folder</must>
<then>a published site serves its export beside its lenses, as `agents/INDEX.md`, and `llms.txt` where agents look for it</then>
</rule>
