# Two layers of highlighting {#highlighting}

Highlighting comes in two layers. The first needs only the grammar, so every file is
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

<rule id="static_layer" targets="static_highlighting" by="product.system.language_server">
<must>colour every file by one grammar of the language that reads no package, [the editor grammar](#product.system.editor_grammar)</must>
</rule>

| A name that resolves to | Token class   | Modifier                                |
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

<rule id="semantic_layer" targets="semantic_highlighting" by="product.system.language_server">
<must>classify each name of a file by what it resolves to in the checked tree, as the table gives, and leave a name that resolves to nothing to the static layer</must>
</rule>

<rule id="prose_tokens" targets="semantic_highlighting" by="product.system.language_server">
<must>give prose words no token, and a heading's `#` and a `|` bar the token class `operator`, never `keyword`</must>
</rule>

<rule id="token_override" targets="semantic_highlighting" by="product.system.language_server">
<where>a kind, flag, annotation or language is declared with `@highlight(token = t)`</where>
<should>give the names that resolve to it the token class `t` instead of the table's</should>
</rule>

<rule id="injection" targets="semantic_highlighting" by="product.system.language_server">
<where>an [embedded string](#language.grammar.strings.embedded.embedded_string) or a raw body is [cast](#language.grammar.code.expressions.cast) to a `language` declared with `grammar = g`</where>
<should>inject the grammar `g` into its text, as `sh: language(grammar = "source.shell")` colours `(sh)"ls -la"` as shell</should>
</rule>

<rule id="insert_safety" targets="semantic_highlighting" by="product.system.interpreter">
<where>`@insert(mode)` stands above a `language`</where>
<must>make values inserted into its embeds safe the way the mode says: `QUOTE` quotes each value for the language, `LITERAL` inserts it as written</must>
<unless>`@insert<raw>` stands above the node that inserts</unless>
<example>`@insert(QUOTE) sh: language(grammar = "source.shell")` makes `(sh)"rm ${path}"` safe for a path with spaces</example>
</rule>
