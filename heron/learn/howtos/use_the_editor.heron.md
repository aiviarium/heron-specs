<howto id="use_the_editor" @lens="user" @display="Use the editor">
${cli.serve.name} serves a browser editor for one tree: the files, a live preview
rendered as the docs are, and the checker's diagnostics where they are in the code.

<step id="start_it">
Run ${cli.serve.name} in the tree's folder. It prints the address it listens on,
${cli.serve.addr.default} unless you pass `--addr`; open it in a browser.
</step>

<step id="edit">
Pick a file and edit it. The preview beside it updates as you type, an error shows
in place on the line it's about, and completion, hover and rename work as in any
editor with a language server.
</step>

<step id="find_commands">
Open the command palette to find any command or file, and press its shortcut next
time: [the editor's commands](#tools.frontend.shell.commands) lists them.
</step>
</howto>
