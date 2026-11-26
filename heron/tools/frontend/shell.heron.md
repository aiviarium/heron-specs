# Shell {#shell}

The app shell's [extension points](#language.interop.declaring.extension_point): the slots extensions hang their views on, and
the commands of the palette. Built-in parts register through the same calls an
extension's frontend package uses, so the shell never knows which extensions exist: a test
dashboard or a prompt workbench is a panel, and test and prompt results are gutter
providers.

| Slot              | Registered with          | Shows                                                          |
| ----------------- | ------------------------ | -------------------------------------------------------------- |
| panel             | `registerPanel`          | a tab in the bottom bar or under the preview                   |
| gutter provider   | `registerGutterProvider` | marks beside the nodes of the file shown, with an action       |
| command           | `registerCommand`        | an action in the palette, with its group and shortcut          |
| renderer per kind | `registerRenderer`       | a node of the kind in the preview, enhanced from the server's HTML |

<rule id="slots_registered" targets="tools.frontend.shell" by="system.editor">
<must>show every registered panel in its slot, every gutter provider's marks beside the nodes they name, every command in the palette while its `when` holds, and a kind's preview through its registered renderer</must>
<while>it's not the case that a kind has no renderer, and then the preview shows the server's HTML as it is</while>
</rule>

<rule id="unique_ids" targets="tools.frontend.shell" by="system.editor">
<if>a panel, provider, command or renderer registers with an id, or a kind, already registered</if>
<must>throw `"‹id›" is registered twice`</must>
</rule>

<rule id="unregister" targets="tools.frontend.shell" by="system.editor">
<must>return from each registration a function that removes it</must>
</rule>

<rule id="generated_client" targets="tools.frontend.shell" by="system.editor">
<must>have a generated client call for every op of `spec_server`</must>
</rule>

## Commands {#commands}

| Command          | Shortcut      |
| ---------------- | ------------- |
| Save             | ⌘S            |
| Format           | Shift+Alt+F   |
| Toggle preview   | ⌘\            |
| Toggle theme     |               |
| Next problem     | F8            |
| Show problems    | ⌘Shift+M      |
| Reconnect        |               |

<rule id="builtin_commands" targets="tools.frontend.shell.commands" by="system.editor">
<must>register the table's commands through `registerCommand`, with their shortcuts, and the problems panel and the run provider through the same calls</must>
</rule>

<rule id="palette_keys" targets="tools.frontend.shell.commands" by="system.editor">
<must>open the palette on ⌘K or Ctrl+K, also inside the code, filter its commands and files as one types, run the chosen one on Enter, clear the filter on the first Escape and close on the second</must>
</rule>
