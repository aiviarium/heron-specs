# Fixing a problem {#fixing}

<usecase id="fix_a_diagnostic" actor="actors.author" success="A file of the tree with no problem left, and the Problems view no longer lists it." minimal="The file is unchanged, or changed only by the author's edits.">
The extension is installed and a folder of the tree is open.

1. [system.editor_extension] underlines the problem the language server reported and lists it in the Problems view.
2. [actors.author] hovers the underline, and [system.editor_extension] shows the problem, its source and its fixes.
3. [actors.author] chooses a fix, and [system.editor_extension] applies its edits.
4. [system.language_server] rechecks within its debounce and clears the underline.

- 1a. The language server isn't running:
  [system.editor_extension] shows why, with an action that opens the `heron.path` setting. Fails.
- 2a. The problem has no fix:
  [actors.author] edits the text by hand. Back to 4.
- 3a. The problem is a Vale alert on a word:
  [actors.author] accepts the word in the vocabulary. Back to 4.
</usecase>
