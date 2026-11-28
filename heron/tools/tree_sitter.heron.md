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

<rule id="queries_compile" refs="system.editor_grammar">
<must>keep every query compiling against the grammar and capturing something on a fixture</must>
</rule>

<rule id="short_links_captured" refs="system.editor_grammar">
<must>parse a [short link](#language.markup.links.short_link) and a prose escape in prose, and capture a [short_link], its brackets included, as a link</must>
</rule>

<rule id="elements_captured" refs="system.editor_grammar">
<must>parse a [kind element](#language.markup.tags.component_tag)'s attributes, an `@name` one included, and capture its name as a tag and an `@name` attribute as an annotation</must>
</rule>

<rule id="prose_words_plain" refs="system.editor_grammar">
<must>capture a [prose line](#language.core_format.prose_layer.prose_lines)'s words as text, never as a keyword, name, number or type, and its list marker and emphasis marks as Markdown's marks</must>
</rule>

<rule id="highlight_scope" refs="system.editor_grammar">
<must>register the grammar for the file type `heron` under the scope `source.heron`, with its highlight and fold queries</must>
</rule>

## TextMate grammar {#textmate}

A TextMate grammar for [Heron files](#language.core_format.files.heron_file) and [prose files](#language.core_format.prose_layer.prose_file), for editors that read TextMate grammars,
such as VS Code and the editors built on it, published with the tree-sitter grammar.

<rule id="textmate_published" refs="system.editor_grammar">
<must>publish `heron.tmLanguage.json`, scope `source.heron`, and `heron-md.tmLanguage.json`, scope `text.heron.markdown`, generated from one list of token kinds, each mapped to a standard scope name, and keep the published files equal to what the generator writes</must>
</rule>

<rule id="textmate_scopes" refs="system.editor_grammar">
<must>scope comments, `///` docs, strings with their escapes and `${…}` inserts, code spans, numbers, keywords, annotations, types, names and punctuation in structure, and in prose only its links, `$` inserts, kind elements with their attributes, code spans and Markdown's marks, with TextMate's standard scope names</must>
<then>a theme colours Heron as it colours other languages, and prose keeps the text colour</then>
</rule>
