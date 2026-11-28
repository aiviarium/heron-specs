# Commands {#commands}

| Command                                 | Runs                                         |
| --------------------------------------- | -------------------------------------------- |
| Heron: Check                            | `heron check`                                |
| Heron: Lint                             | `heron lint`                                 |
| Heron: Generate Docs                    | `heron generate docs`                        |
| Heron: Generate…                        | `heron generate` with the targets picked     |
| Heron: Open Preview to the Side         | the [preview](#tools.vscode.preview)         |
| Heron: Restart Language Server          | the [restart](#tools.vscode.client.restart_command) |

<rule id="cli_commands" refs="system.editor_extension">
<must>run the table's `heron` commands as a task in the first workspace folder's terminal, with the same command the language client starts, Generate… with the targets picked from the built-in ones `heron generate` lists, or with none when none is picked</must>
<then>a command's output and exit status read as on the command line</then>
</rule>
