# LSP {#lsp}

What [the language server](#system.language_server) answers: one [session](#tools.lsp.session.lsp_session) per client,
over standard input and output from `heron lsp` and over the `/lsp` socket from
[the server](#system.server). It answers from the same checked tree as `heron check`
and `heron lint`, so an editor never disagrees with them.

## Session {#session}

A [session](#tools.lsp.session.lsp_session) holds the open documents as overlays of the loader, checks each in the tree
of its [owner entry](#tools.lsp.session.owner_entry), and rechecks everything open after an edit, with the check memo
making that cheap.

<term id="lsp_session" @display="LSP session">
One client's language server: its open documents, the analyses of their trees and the
diagnostics last published. Sessions on one server share the registry and nothing
else.
</term>

<term id="canonical_identity">
The one identity of a file, whatever URI reached it: percent-escapes, a `localhost`
host, `.` and `..` segments, symbolic links and trailing slashes all collapse to it.
A URI of another scheme, such as an untitled buffer, is its own identity, and
`heron:/std/<path>` names a standard package's embedded file.
</term>

<term id="owner_entry">
The [entry point](#language.core_format.files.entry_point) an open document is checked in: of the `index.heron` files in its
folder and every folder above it up to the workspace root, the outermost whose tree
includes the document, or the document itself when none does.
</term>

<rule id="one_identity" @targets="tools.lsp.session" @by="system.language_server">
<must>turn every document URI into the file's [canonical identity](#tools.lsp.session.canonical_identity), and keep one document per identity whichever URIs opened it</must>
<then>a file opened by two spellings is one document, closed when its last spelling closes</then>
</rule>

<rule id="overlay" @targets="tools.lsp.session" @by="system.language_server">
<must>make an open document's text the loader's overlay for its identity, never a second copy of the file, and drop the overlay when the document closes</must>
<then>every tree that includes or imports the file sees the unsaved text, and the file on disk again once it's closed</then>
</rule>

<rule id="outermost_entry" @targets="tools.lsp.session" @by="system.language_server">
<must>check an open document in its [owner entry](#tools.lsp.session.owner_entry), and find it again when its tree no longer includes the document</must>
<example>spec/language/grammar/lexical.heron is checked in spec/index.heron, not in spec/language/index.heron, so its links into the rest of spec/ resolve</example>
</rule>

<rule id="recheck_all_open" @targets="tools.lsp.session" @by="system.language_server">
<when>a document opens, changes, closes or is saved, a command runs, or a watched file changes on disk</when>
<must>recheck the [owner entry](#tools.lsp.session.owner_entry) of every open document, with the check memo serving unchanged files and nodes, and lint each tree with every lint and prose provider the registry holds</must>
<then>a break in an imported file shows in its importer, open or not</then>
</rule>

<rule id="debounce" @targets="tools.lsp.session" @by="system.language_server">
<when>an edit arrives</when>
<must>wait for the debounce, 150 ms unless `--debounce` or `Options.Debounce` sets another, before rechecking, and restart the wait on each further edit</must>
<while>only edits arrive during the wait</while>
</rule>

<rule id="debounce_otherwise" @targets="tools.lsp.session" @by="system.language_server">
<when>a request arrives during the wait</when>
<must>recheck at once</must>
</rule>

<rule id="watched_files" @targets="tools.lsp.session" @by="system.language_server">
<where>the client registers file watchers dynamically</where>
<must>register watchers for `**/*.heron`, `**/*.heron.md`, `**/.vale.ini`, `**/*.txt` and `**/*.yml` once initialized, and on a change reread every file that isn't open and find every [owner entry](#tools.lsp.session.owner_entry) again</must>
<then>a vocabulary or a Vale style edited outside the editor re-lints</then>
</rule>

<rule id="workspace_root" @targets="tools.lsp.session" @by="system.language_server">
<must>take the workspace roots from the `initialize` request's workspace folders, then its root URI, then its root path, then `Options.Dir`</must>
</rule>

## Diagnostics {#diagnostics}

Each diagnostic reaches the client with the name of what reported it, so the
editor's hover can say whether the checker, a lint or Vale found it.

| Reported by                   | Code sent        | Source         |
| ----------------------------- | ---------------- | -------------- |
| the type checker              | the check's code | `heron check`  |
| a prose provider such as Vale | `Vale.<check>`   | its name       |
| any other lint                | the lint's code  | `heron lint`   |

<rule id="publish_per_file" @targets="tools.lsp.diagnostics" @by="system.language_server">
<must>publish each file's diagnostics, sorted, after every recheck: to every URI the client opened it by, with the document's version, and to the file's canonical URI for files of the trees that aren't open</must>
<then>an editor shows problems in files nobody opened, such as an importer the edit broke</then>
</rule>

<rule id="clear_fixed" @targets="tools.lsp.diagnostics" @by="system.language_server">
<when>a URI that had diagnostics has none after a recheck</when>
<must>publish an empty list for it once</must>
</rule>

<rule id="no_std_diagnostics" @targets="tools.lsp.diagnostics" @by="system.language_server">
<mustNot>publish a diagnostic in a standard package's file</mustNot>
</rule>

<rule id="diagnostic_source" @targets="tools.lsp.diagnostics" @by="system.language_server">
<must>give each diagnostic the code and source the [table](#heron.language.markup.components.table) gives, its severity as error, warning or hint (info and hint both send hint), and its related sites as related information</must>
</rule>

## Completion {#completion}

Completion offers what fits where the cursor stands, from the [schemas](#language.schemas.kinds.schema) in scope.
It's triggered by `.`, `:`, `@`, `<`, `$`, `#`, `"`, `/` and `{`; in prose a plain word
never completes.

| Where the cursor is                    | Items                                                           |
| -------------------------------------- | --------------------------------------------------------------- |
| in an `import` string                  | the standard packages                                           |
| in an `include` string                 | the files and folders beside the including file                 |
| after `@`                              | the annotations in scope                                        |
| after `<`, or in a flag list           | the flags in scope                                              |
| after `name.`                          | the children of what `name` names                               |
| after `:` or in a type                 | the kinds the enclosing body accepts, and the types             |
| at the start of a member               | the fields the enclosing kind declares, then the names in scope |
| in prose, after `$` or `${`            | the names in scope                                              |
| in prose, in a link's `(#…)`           | the paths, segment by segment                                   |
| in prose, in a short link's `[…]`      | the paths, segment by segment                                   |
| in prose, after `<` or `</`            | the kinds in scope, as tags                                     |

<rule id="completion_items" @targets="tools.lsp.completion" @by="system.language_server">
<must>offer the items the [table](#heron.language.markup.components.table) gives for the cursor's place, each with its kind, its type or kind as detail and its `///` docs, replacing the word before the cursor</must>
</rule>

<rule id="completion_list" @targets="tools.lsp.completion" @by="system.language_server">
<mustNot>offer an item with an empty label, or two with one label</mustNot>
<instead>keep the first, and sort the fields of the enclosing kind before the names in scope</instead>
</rule>

<rule id="prose_word_quiet" @targets="tools.lsp.completion" @by="system.language_server">
<where>the cursor is in prose, outside a link target, a [short_link], an insert and a tag</where>
<mustNot>offer any item</mustNot>
</rule>

## Hover {#hover}

<rule id="hover_node" @targets="tools.lsp.hover" @by="system.language_server">
<where>the word under the cursor names a node</where>
<must>show the node's declaration as a Heron signature without its docs and body, then its `///` docs from every site as Markdown, then its kind, its path and the file it's declared in</must>
</rule>

<rule id="hover_local" @targets="tools.lsp.hover" @by="system.language_server">
<where>the word names a `let` or a parameter</where>
<must>show its declaration and whether it's a let or a parameter</must>
</rule>

<rule id="hover_file" @targets="tools.lsp.hover" @by="system.language_server">
<where>the cursor is on an `import` or `include` string</where>
<must>show the file it names, a standard file as `std/<path>`</must>
</rule>

## Definition {#definition}

<rule id="definition_target" @targets="tools.lsp.definition" @by="system.language_server">
<must>answer with where the target is declared: a node's declaring member, a local's declaration, or the start of the file an `import` or `include` string names</must>
</rule>

<rule id="definition_short_link" @targets="tools.lsp.definition" @by="system.language_server">
<where>the cursor is on a [short link](#language.markup.links.short_link)'s path</where>
<must>answer definition and hover as on any path, for the node the link resolves to</must>
</rule>

<rule id="definition_element" @targets="tools.lsp.definition" @by="system.language_server">
<where>the cursor is on a [kind element](#language.markup.tags.component_tag)'s name, or on the target of a `<ref to="…">`</where>
<must>answer definition and hover for the kind the element names, or the node the reference resolves to</must>
</rule>

<rule id="definition_into_std" @targets="tools.lsp.definition" @by="system.language_server">
<where>the target is declared in a standard package</where>
<must>answer with its `heron:/std/<path>` URI, whose text the client reads with [heron/source](#tools.lsp.extensions.source_request)</must>
<example>go to definition on `"std/doc@1"`, or on `section`, opens heron:/std/doc/package.heron</example>
</rule>

## References {#references}

<rule id="references_everywhere" @targets="tools.lsp.references" @by="system.language_server">
<must>list every word that names the node: its declaration, every amend, every path and every link and insert in prose, across the trees of the open documents and the local packages they import</must>
</rule>

## Rename {#rename}

<rule id="rename_by_path" @targets="tools.lsp.rename" @by="system.language_server">
<must>rename a node by its path: replace every word [references](#tools.lsp.references.references_everywhere) lists, in one workspace edit</must>
</rule>

<rule id="rename_refused" @targets="tools.lsp.rename" @by="system.language_server">
<if>the word isn't a node's name, the node is declared in a standard package, the new name isn't an identifier, or the node's parent already has a member of the new name</if>
<must>refuse it with an invalid-parameters error that says which, as "nothing to rename here" or "‹parent› already has a member ‹name›"</must>
</rule>

<rule id="prepare_rename" @targets="tools.lsp.rename" @by="system.language_server">
<must>answer `prepareRename` with the word's range and the word as the [placeholder](#language.core_format.expressions.placeholder), or the refusal `rename` would give</must>
</rule>

## Formatting {#formatting}

<rule id="format_whole_file" @targets="tools.lsp.formatting" @by="system.language_server">
<must>answer with one edit that replaces the whole text by `heron fmt`'s output, or no edit when the text is already formatted</must>
<while>the file parses</while>
</rule>

<rule id="format_whole_file_otherwise" @targets="tools.lsp.formatting" @by="system.language_server">
<if>the file has a syntax error</if>
<must>answer no edit</must>
</rule>

## Semantic tokens {#semantic_tokens}

The legend's token types are `namespace`, `type`, `class`, `enum`, `interface`, `struct`,
`typeParameter`, `parameter`, `variable`, `property`, `enumMember`, `event`, `function`,
`method`, `macro`, `keyword`, `modifier`, `comment`, `string`, `number`, `regexp`,
`operator` and `decorator`, in that order; its modifiers are `declaration`,
`definition`, `readonly`, `documentation` and `defaultLibrary`.

<rule id="full_tokens" @targets="language.schemas.highlighting.semantic_highlighting" @by="system.language_server">
<must>answer `semanticTokens/full` with the legend above, classifying names as [the semantic layer](#language.schemas.highlighting.semantic_layer) says, and keywords, strings, numbers, comments, `@`, prose marks and link and tag punctuation by their token</must>
</rule>

## Symbols {#symbols}

<rule id="document_symbols" @targets="tools.lsp.symbols" @by="system.language_server">
<must>answer with the file's named nodes as a tree, each with its kind or type as detail and a symbol kind: `Class` for a kind, `Enum`, `Interface`, `Struct` for a type, function for a func, task or op, property for a value and namespace for a heading or section</must>
</rule>

## Folding {#folding}

<rule id="folding_ranges" @targets="tools.lsp.folding" @by="system.language_server">
<must>fold every body, prose block, `do` block, map, list, parameter list, argument list, run of [prose lines](#language.core_format.prose_layer.prose_lines) and fence that spans more than one line, and `///` docs as a comment</must>
</rule>

## Code actions {#code_actions}

<rule id="fixes_as_quick_fixes" @targets="tools.lsp.code_actions" @by="system.language_server">
<must>offer each fix of each diagnostic in the range as a `quickfix` with its edits, marking the first preferred unless it's a [suggestion](#tools.prose.vale.suggestion_fix)</must>
<then>an editor's "fix all" never applies a guess</then>
</rule>

<rule id="vocabulary_actions" @targets="tools.lsp.code_actions" @by="system.language_server">
<where>a diagnostic is a Vale alert on a single word</where>
<must>also offer, per vocabulary the .vale.ini names, to accept the word or reject it, as the commands `heron.vale.accept` and `heron.vale.reject`</must>
</rule>

## Commands {#commands}

<rule id="run_command" @targets="tools.lsp.commands" @by="system.language_server">
<when>`workspace/executeCommand` names a vocabulary command</when>
<must>run it through [the prose package](#tools.prose.vale.vocabulary_edit), then recheck and publish before answering</must>
<then>the word's alert is gone when the command returns</then>
</rule>

<rule id="sync_command" @targets="tools.lsp.commands" @by="system.language_server">
<when>`workspace/executeCommand` names `heron.sync`</when>
<must>do nothing beyond the recheck every request makes, and answer null</must>
<then>a client that waits for the answer has every diagnostic published so far</then>
</rule>

## Extensions {#extensions}

Beyond the protocol, a session answers one request and serves one URI scheme.

<rule id="source_request" @targets="tools.lsp.extensions" @by="system.language_server">
<when>a client sends `heron/source` with a `uri`</when>
<must>answer `{ "text": … }` with the file's current text: the open document, the file as last loaded, or the disk</must>
<while>the file exists</while>
<example>an editor opens heron:/std/doc/package.heron read-only from the text `heron/source` returns</example>
</rule>

<rule id="source_request_otherwise" @targets="tools.lsp.extensions" @by="system.language_server">
<if>there is no such file</if>
<must>answer an invalid-parameters error "no file {uri}"</must>
</rule>

<rule id="std_scheme" @targets="tools.lsp.extensions" @by="system.language_server">
<must>name a standard package's embedded file `heron:/std/<package>/<file>`, and read `heron:std/<path>` as the same file</must>
</rule>

<rule id="workspace_uris" @targets="tools.lsp.extensions" @by="system.language_server">
<must>name each file of the workspace by its `file:` URI under the workspace's root URI, which [the server API's `workspace`](#tools.server_api.spec_server.workspace) answers as `root_uri`, in every location and diagnostic it sends, each standard file by its `heron:/std/` URI, and a workspace file in hover text by its path relative to the workspace</must>
<then>a client maps a URI to the file's workspace path by taking the root URI off it, and needs no copy of the server's folders</then>
</rule>

<rule id="capabilities" @targets="tools.lsp.extensions" @by="system.language_server">
<must>announce UTF-16 positions, incremental sync with open, close and save, the completion triggers, hover, definition, references, rename with prepare, formatting, document symbols, folding, quick-fix code actions, the commands and full semantic tokens, and serve nothing else</must>
</rule>
