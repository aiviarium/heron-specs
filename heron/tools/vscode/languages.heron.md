# Languages {#languages}

| Language   | Files         | Grammar                                                  |
| ---------- | ------------- | -------------------------------------------------------- |
| `heron`    | `.heron`      | `heron.tmLanguage.json`, scope `source.heron`            |
| `heron-md` | `.heron.md`   | `heron-md.tmLanguage.json`, scope `text.heron.markdown`  |

<rule id="languages_contributed" refs="system.editor_extension">
<must>contribute the table's languages with the [TextMate grammars](#tools.tree_sitter.textmate) as the generator writes them, copied into the extension when it's built, and mark the Heron code a `heron-md` file holds as the embedded `heron` language</must>
<then>a file is coloured the moment it opens, before the language server answers</then>
</rule>

<rule id="language_configuration" refs="system.editor_extension">
<must>configure both languages with `//` line comments, the brackets `{{ }}`, `{ }`, `[ ]` and `( )`, auto-closing of `{`, `[`, `(`, `"` and a backtick outside strings and comments, folding by indentation, and words as `[A-Za-z_][A-Za-z0-9_]*`</must>
</rule>

<rule id="web_highlighting" refs="system.editor_extension">
<while>the editor runs in a browser, as VS Code for the Web does, where no process can be started</while>
<must>still contribute the languages and their grammars, and answer the commands that need `heron` with a message that they need the desktop editor</must>
</rule>
