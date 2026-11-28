# Site {#site}

A site is a home page, one page per [page node](#tools.docs.site.page_node), and the pages that gather one kind
across the tree, once for each [lens](#tools.docs.lenses.lens_kind) it builds. Every other node shows on the page of its
nearest ancestor that has one, at its own anchor, and a page and an anchor have the same
name in every lens, so a link can switch lens and land on the same node.

<term id="page_node">
A node that gets a page of its own: a section or a documented [folder scope](#guide.layout.folder_scope) less than
`depth` levels down, `2` unless the [docs block](#tools.docs.extending.docs_block) sets it; at any depth, an api, an op, a type
declaration of the tree, a part, a command, a use case, a screen and an
[authored page](#language.markup.authored_pages.authored_page).
</term>

<term id="site_area">
A top-level part of the site, a tab in the top bar with its own navigation tree: Docs,
Reference when the tree has an api or a type, and Glossary when it has a term.
</term>

<rule id="page_files" refs="system.docs_generator">
<must>write each page of a lens as a file in the lens's folder named by its node's [path](#language.core_format.naming.node_path), as `orders.ordering.html`, the lens's home page as `index.html` and its gathered pages as `_glossary.html` and `_diagnostics.html`, with the default lens's folder the site's root and every other lens's folder its `prefix`, as `dev/orders.ordering.html`; and write the assets once, under `_assets/` at the root</must>
<then>every link is relative and the site opens from disk</then>
</rule>

<rule id="stale_pages" refs="system.docs_generator">
<must>list the files each run writes in a `.manifest` file of the site's folder, remove the files the previous run's manifest lists that this run doesn't write, and keep every file that manifest doesn't list</must>
<then>a page whose node is gone or moved leaves no stale copy, and files someone else put in the folder stay</then>
</rule>

<rule id="lens_data" refs="system.docs_generator">
<must>write each lens's search index, hover cards and island strings into a `data.js` of the lens's own folder, holding only the nodes that lens keeps</must>
<then>searching in a lens finds what that lens shows</then>
</rule>

<rule id="stable_anchors" refs="system.docs_generator">
<must>give a node the same page file name and the same anchor, its [path](#language.core_format.naming.node_path), in every lens that keeps it</must>
<then>a link to a node in one lens becomes a link to it in another by changing only the folder</then>
</rule>

<rule id="lens_switch_target" refs="system.docs_generator">
<must>link each entry of the lens switcher to the same page in that lens where it keeps the page, else to the page of the page's nearest ancestor it keeps, else to its home page, with the anchor kept when the target page holds it</must>
</rule>

<rule id="page_nodes" refs="system.docs_generator">
<must>give every [page node](#tools.docs.site.page_node) a lens keeps in full a page in that lens, and show every other node the lens keeps on the page of its nearest ancestor that has one</must>
</rule>

<rule id="site_title" refs="system.docs_generator">
<must>title the site with the root project's [display name](#language.core_format.naming.display_name), or the entry file's folder when the tree declares no project</must>
</rule>

<rule id="gathered_pages" refs="system.docs_generator">
<must>gather, in each lens, the terms it keeps on a glossary page and the diagnostics it keeps by code on a diagnostics page, each only when the lens keeps one</must>
</rule>

<rule id="pages_follow_tree" refs="system.docs_generator">
<must>render features with their rules, terms with hover cards wherever a term is used, qualities with their metrics, and APIs and types as the [reference screens](#tools.docs.screens) say, all cross-linked</must>
</rule>

<rule id="sentences_from_spec" refs="system.docs_generator">
<must_not>add a sentence of its own to a page</must_not>
<instead>add headings, labels, navigation and values from the [string catalogue](#tools.docs.writing.string_catalogue), and show a kind with no prose as its structure alone</instead>
</rule>
