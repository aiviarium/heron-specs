# Preview {#preview}

The preview shows the node under the cursor as its docs page shows it, from the
language server's [heron/preview](#tools.lsp.extensions.preview_request) request, so it needs no
server of its own and always sees the text as typed.

<rule id="preview_to_the_side" refs="system.editor_extension">
<must>open on Heron: Open Preview to the Side a webview beside the active Heron editor that shows `heron/preview` of its cursor, styled by the stylesheet the first answer carries, and ask again 100 ms after the last edit or cursor move in that editor, or at once when another Heron editor becomes active</must>
<then>the preview follows the edits and the cursor as the author types</then>
</rule>

<rule id="preview_error_in_place" refs="system.editor_extension">
<if>an answer carries an `error`</if>
<must>keep the last page and show the error above it</must>
</rule>

<rule id="preview_csp" refs="system.editor_extension">
<must>give the webview a content security policy of `default-src 'none'`, styles and its one script only by a nonce made afresh for each webview, images only from the extension's own files and `data:`, and no network; and leave every link of the preview inert</must>
<then>markup from a tree can't run code or reach the network from the preview</then>
</rule>
