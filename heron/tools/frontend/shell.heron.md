# Shell {#shell}

The app shell's slots, which the editor's parts hang their views on, and the commands of
the palette. Every part registers through the same calls, so the shell never knows which
parts exist: the problems view is a panel, and run results are a gutter provider.

| Slot              | Registered with          | Shows                                                          |
| ----------------- | ------------------------ | -------------------------------------------------------------- |
| panel             | `registerPanel`          | a tab in the bottom bar or under the preview                   |
| gutter provider   | `registerGutterProvider` | marks beside the nodes of the file shown, with an action       |
| command           | `registerCommand`        | an action in the palette, with its group and shortcut          |
| renderer per kind | `registerRenderer`       | a node of the kind in the preview, enhanced from the server's HTML |

<rule id="slots_registered" refs="system.editor">
<must>show every registered panel in its slot, every gutter provider's marks beside the nodes they name, every command in the palette while its `when` holds, and a kind's preview through its registered renderer</must>
<while>every kind the preview shows has a renderer</while>
</rule>

<rule id="slots_registered_otherwise" refs="system.editor">
<where>a kind has no renderer</where>
<must>show the server's HTML for it in the preview as it is</must>
</rule>

<rule id="unique_ids" refs="system.editor">
<if>a panel, provider, command or renderer registers with an id, or a kind, already registered</if>
<must>throw `"‹id›" is registered twice`</must>
</rule>

<rule id="unregister" refs="system.editor">
<must>return from each registration a function that removes it</must>
</rule>

<rule id="generated_client" refs="system.editor">
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

<rule id="builtin_commands" refs="system.editor">
<must>register the table's commands through `registerCommand`, with their shortcuts, and the problems panel and the run provider through the same calls</must>
</rule>

<rule id="palette_keys" refs="system.editor">
<must>open the palette on ⌘K or Ctrl+K, also inside the code, filter its commands and files as one types, run the chosen one on Enter, clear the filter on the first Escape and close on the second</must>
</rule>
