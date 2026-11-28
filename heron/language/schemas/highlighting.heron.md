# Two layers of highlighting {#highlighting}

Highlighting comes in two [layers](#heron.language.specifications.layers.layer). The first needs only the grammar, so every file is
coloured before any package loads; the second comes from the [schemas](#language.schemas.kinds.schema) in `import` and
says what each name is.

<term id="static_highlighting">
Highlighting from the core grammar alone: names, `<flags>`, `@annotations`, strings
and raw strings, comments, brace counts, `$` invocations and `#` links. One TextMate
or tree-sitter grammar covers every file without loading a package.
</term>

<term id="semantic_highlighting">
Highlighting from the [schemas](#language.schemas.kinds.schema) in `import`: whether
a name is a known kind, flag or annotation and valid where it stands, whether
`name: X` names a kind or a type, whether a tag names a kind in scope, and which
grammar to inject into an embed. It maps onto LSP semantic tokens and language
injection.
</term>

<rule id="static_layer" refs="system.language_server">
<must>colour every file by one grammar of the language that reads no package, [the editor grammar](#system.editor_grammar)</must>
</rule>

| A name that resolves to | Token type   | Modifier                                |
| ----------------------- | ------------- | --------------------------------------- |
| a kind                  | `class`       | `defaultLibrary` when `std/` declares it |
| an enum                 | `enum`        | as above                                |
| an interface            | `interface`   | as above                                |
| a type or a primitive   | `type`        | as above                                |
| an annotation           | `decorator`   | as above                                |
| a flag                  | `modifier`    | as above                                |
| a func, task, op, macro or [hook](#language.scripting.code.hook) | `function` | as above                         |
| a section, package or api | `namespace` | as above                                |
| a variant of an enum    | `enumMember`  | as above                                |
| a name being declared   | its class     | `declaration`                           |
| words in `///` lines    | `comment`     | `documentation`                         |

<rule id="semantic_layer" refs="system.language_server">
<must>classify each name of a file by what it resolves to in the checked tree, as the [table](#heron.language.markup.components.table) gives, and leave a name that resolves to nothing to the static [layer](#heron.language.specifications.layers.layer)</must>
</rule>

<rule id="prose_tokens" refs="system.language_server">
<must>give prose words no token, and a heading's `#` and a `|` bar the token type `operator`, never `keyword`</must>
</rule>

<rule id="token_override" refs="system.language_server">
<while>a kind, flag, annotation or language is declared with `@highlight(token = t)`</while>
<should>give the names that resolve to it the token type `t` instead of the table's</should>
</rule>

<rule id="injection" refs="system.language_server">
<while>an [embedded string](#language.grammar.strings.embedded.embedded_string) or a raw body is [cast](#language.grammar.code.expressions.cast) to a `language` declared with `grammar = g`</while>
<should>inject the grammar `g` into its text, as `sh: language(grammar = "source.shell")` colours `(sh)"ls -la"` as shell</should>
</rule>

<rule id="insert_safety" refs="system.interpreter">
<while>`@insert(mode)` stands above a `language`</while>
<must>make values inserted into its embeds safe the way the mode says: `QUOTE` quotes each value for the language, `LITERAL` inserts it as written</must>
<while>the node that inserts keeps the language's insert mode</while>
<example>`@insert(QUOTE) sh: language(grammar = "source.shell")` makes `(sh)"rm ${path}"` safe for a path with spaces</example>
</rule>

<rule id="insert_safety_otherwise" refs="system.interpreter">
<while>`@insert<raw>` stands above the node that inserts</while>
<must>insert its values as written</must>
</rule>
