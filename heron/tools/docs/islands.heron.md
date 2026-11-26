# Islands {#islands}

A page reads fully before any script runs. The islands are one classic script and one
data script, `data.js`, which holds the search index, the hover cards and the
islands' strings, because browsers refuse module scripts and fetches from `file://`.

| Island         | What it adds                                                                        |
| -------------- | ----------------------------------------------------------------------------------- |
| search         | a palette over the search index, on ⌘K, Ctrl+K or `/`                               |
| hover cards    | a term's definition or a type's signature, on hovering or focusing a link to it     |
| Try it         | sends an op's request to a server                                                   |
| diagram        | pan and zoom, a node's neighbours highlighted on hover, and its page on click       |
| diagram view   | the switch between a diagram and its [table](#heron.language.markup.components.table)                                          |
| tabs           | a union's variants and an example's languages, with arrow keys, Home and End        |
| examples       | the example picker of an op                                                         |
| copy           | the copy button of a code block                                                     |
| version switch | opens the same page in another released build                                       |
| theme          | switches between dark and light                                                     |

<rule id="islands_enhance" targets="tools.docs.islands" by="system.docs_generator">
<must>mark each interactive part with `data-island`, and let the script enhance the markup in place, mounting Solid components only for the overlays: the search palette, the hover cards and Try it</must>
<then>a page without its script still shows every part, and the overlays get the focus and dismissal behaviour of the UI SDK</then>
</rule>

<rule id="islands_work" targets="tools.docs.islands" by="system.docs_generator">
<must>make every island the [table](#heron.language.markup.components.table) lists work from `file://`, with no script error</must>
</rule>

<rule id="try_it" targets="tools.docs.islands" by="system.docs_generator">
<may>send an op's request to the server its reader configures, kept in `localStorage` and the page's origin unless set, with parameters from the selected example and authentication from the API's security schemes</may>
</rule>
