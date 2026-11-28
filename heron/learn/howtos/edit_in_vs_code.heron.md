<howto id="edit_in_vs_code" @lens="user" @display="Edit in VS Code">
The [Heron extension](#tools.vscode) for VS Code, and the editors built on it such as Cursor
and VSCodium, colours Heron, reports the checker's diagnostics where they are in the code and
shows a live preview rendered as the docs are.

<step id="install">
Install the extension's `.vsix` file with Extensions: Install from VSIX…, and put the `heron`
binary on your `PATH`, or set `heron.path` to it.
</step>

<step id="edit">
Open the tree's folder and a `.heron` file. Errors show in place on the line they're about,
and completion, hover, go to definition, rename and fixes work as in any editor with a
language server.
</step>

<step id="preview">
Run Heron: Open Preview to the Side. The preview beside the code shows the node under the
cursor as its docs page shows it, and follows as you type and move.
</step>

<step id="read_the_site">
To read the whole site as it stands, run ${cli.serve.name} in the tree's folder and open the
address it prints; reload a page to see your latest edits.
</step>
</howto>
