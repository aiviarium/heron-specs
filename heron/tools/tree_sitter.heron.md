# Tree-sitter grammar {#tree_sitter}

[The editor grammar](#system.editor_grammar): editors get [static highlighting](#language.schemas.highlighting.static_highlighting),
folding and structural selection from it without starting `heron`; everything semantic
comes from [the language server](#system.language_server).

## Query files {#query_files}

| Query             | Captures                                                                                                  |
| ----------------- | --------------------------------------------------------------------------------------------------------- |
| `highlights.scm`  | comments, `///` docs, strings, code spans, numbers, booleans, escapes, URLs, keywords, operators and punctuation, annotations, flags, tags, links, parameters, members and types; in prose only Markdown's list markers and emphasis marks, elements, links and code spans |
| `folds.scm`       | bodies, prose blocks, [prose lines](#language.core_format.prose_layer.prose_lines), `do` blocks, `///` docs, argument lists, lists and maps |
| `textobjects.scm` | a declaration or an entered node and its body as a class, a call and its arguments, a value or a set as an assignment, a parameter, a `do` block and its code as a function, prose and comments as comments, a link and a tag |

<rule id="queries_compile" targets="tools.tree_sitter.query_files" by="system.editor_grammar">
<must>keep every query compiling against the grammar and capturing something on a fixture</must>
</rule>

<rule id="short_links_captured" targets="tools.tree_sitter.query_files" by="system.editor_grammar">
<must>parse a [short link](#language.markup.links.short_link) and a prose escape in prose, and capture a [short_link], its brackets included, as a link</must>
</rule>

<rule id="elements_captured" targets="tools.tree_sitter.query_files" by="system.editor_grammar">
<must>parse a [kind element](#language.markup.tags.component_tag)'s attributes, an `@name` one included, and capture its name as a tag and an `@name` attribute as an annotation</must>
</rule>

<rule id="prose_words_plain" targets="tools.tree_sitter.query_files" by="system.editor_grammar">
<must>capture a [prose line](#language.core_format.prose_layer.prose_lines)'s words as text, never as a keyword, name, number or type, and its list marker and emphasis marks as Markdown's marks</must>
</rule>

<rule id="highlight_scope" targets="tools.tree_sitter.query_files" by="system.editor_grammar">
<must>register the grammar for the file type `heron` under the scope `source.heron`, with its highlight and fold queries</must>
</rule>
