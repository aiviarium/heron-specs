# Language client {#client}

<rule id="starts_the_server" refs="system.editor_extension">
<must>start `heron lsp --stdio` as its language client, from the `heron.path` setting when it's set and `heron` on `PATH` when it isn't, in the first workspace folder, for every `heron` and `heron-md` document saved as a file or not yet saved</must>
<while>the command starts</while>
<then>diagnostics, completion, hover, definition, references, rename, formatting, fixes and [semantic highlighting](#language.schemas.highlighting.semantic_highlighting) come from the language server</then>
</rule>

<rule id="starts_the_server_otherwise" refs="system.editor_extension">
<if>the command can't be started</if>
<must>show an error message that names the command it tried and the `heron.path` setting, with an action that opens the setting, and stay stopped until the server is restarted</must>
</rule>

<rule id="restart_command" refs="system.editor_extension">
<must>stop the language client and start it again on Heron: Restart Language Server, reading `heron.path` afresh, and do the same when `heron.path` changes</must>
</rule>
