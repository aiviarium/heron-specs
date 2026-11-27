# Page layout {#page_layout}

Every page has the same frame, after Fumadocs: the top bar, the navigation, the page
and a right [column](#heron.language.grammar.lexical.column).

<rule id="frame" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>lay out a page as a top bar with the logo, the [site areas](#tools.docs.site.site_area), the lens switcher, search with its shortcut, the version switch and the theme switch; the navigation tree of its [site area](#tools.docs.site.site_area) on the left; a breadcrumb and the page in the middle; and on the right the page's outline, or an op's examples, sticky as the page scrolls</must>
</rule>

<rule id="nav_pages_only" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>list in the navigation only pages, the nodes with a page of their own at the lens's depth, and never a node that's an anchor on a page, in every lens and on the project's site</must>
</rule>

<rule id="outline_nested" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>show in a page's outline its headings and, under a heading of a node with no subheadings of its own, the nodes the page shows inside that node with an anchor, or on a page without headings the nodes it shows with an anchor and theirs, two levels deep in all, in the order the page shows them, and mark the entry of what's in view as the page scrolls, its marker drawn on the outline's rail</must>
<example>a page's outline lists its sections, and under each section the use cases and scenarios it holds</example>
</rule>

<rule id="nav_tree" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>write the navigation of a [site area](#tools.docs.site.site_area) as a tree on every page: every page's entry, each branch a disclosure whose label links to its page and whose chevron opens and closes it in place without leaving the page, the current page's ancestors open, so that every entry is a link away without a script</must>
<then>moving between pages never closes a branch, so an entry followed stays where it was</then>
</rule>

<rule id="nav_tree_keyboard" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>let the keyboard move through the navigation's tree as the WAI-ARIA tree view pattern does: one tab stop, the up and down arrows between the entries in view, the right arrow to open a branch or enter it, the left arrow to close a branch or leave it, Home and End, and type-ahead by an entry's first letters</must>
</rule>

<rule id="nav_scroll_kept" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>keep the navigation as the reader left it, from one page of a site to the next and across a reload, for each lens's site and [site area](#tools.docs.site.site_area) apart: the branches open again, kept in `localStorage`, and the entry the reader followed where it was on screen, or else the scroll position, kept in `sessionStorage`, restored before the page paints; where nothing is kept, scroll the current page's entry into view</must>
<then>following a link far down the navigation leaves the navigation where it was</then>
</rule>

<rule id="lens_switcher" @targets="tools.docs.page_layout" @by="system.docs_generator">
<where>the site builds more than one [lens](#tools.docs.lenses.lens_kind)</where>
<must>show in the top bar, right beside the version switch, a dropdown captioned as the view, its options the `title` of each lens in the order of the docs block's `lenses`, the current one selected, each a plain link that works without a script, drawn as the version switch's select once a script runs</must>
</rule>

<rule id="no_switcher_alone" @targets="tools.docs.page_layout" @by="system.docs_generator">
<where>the site builds one lens</where>
<mustNot>show a lens switcher</mustNot>
</rule>

<rule id="narrow_screens" @targets="tools.docs.page_layout" @by="system.docs_generator">
<when>the window is 1180 px wide or less</when>
<must>drop the right [column](#heron.language.grammar.lexical.column) below the page, and at 820 px or less collapse to one [column](#heron.language.grammar.lexical.column) with the navigation behind a button</must>
</rule>

<rule id="theme_before_paint" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>apply the theme the reader chose, kept in `localStorage` as `heron-theme`, before the page paints, follow the system's light or dark preference until one is chosen, and declare the page's colour schemes and set the canvas to the theme's page colour in the page's head, so the canvas takes the theme before the stylesheet loads, in every browser</must>
</rule>

<rule id="frame_uses_window" @targets="tools.docs.page_layout" @by="system.docs_generator">
<where>the window is wider than 1180 px</where>
<must>lay the frame out as three [columns](#heron.language.grammar.lexical.column) inside the window's width, up to a maximum of 1920 px and centred beyond it: the navigation at the frame's left edge, the right [column](#heron.language.grammar.lexical.column) at its right edge, each as wide on every page at a given window width, the right one whether it holds an outline, an op's examples or nothing; and the page in the space between them, at one width that depends only on the window, clamped between about 560 and 760 px, centred in that space</must>
<then>the content has the same width and the same x on every page at a given window width, so moving between pages never changes it, and the room on either side of it is equal</then>
</rule>

<rule id="stable_frame" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>give the content the same width and start it at the same distance from the window's left edge on every page that has the navigation, whatever the page or the right side of it holds, and paint a page whole, never before its frame, the navigation, the page and what stands beside it, is parsed</must>
<then>moving between pages never slides the content sideways or shows a half-built page</then>
</rule>

<rule id="pages_in_place" @targets="tools.docs.page_layout" @by="system.docs_generator">
<where>a script runs and the page is served over HTTP</where>
<must>show a page that a link, the search or going back or forward leads to within the same lens's site in place: fetch it and swap in its top bar and frame in one step, without loading a new document, and update the address, the title and the history, while every link stays a plain link that works without a script</must>
<then>moving between pages never shows a blank or light canvas between two pages, in any browser</then>
</rule>

<rule id="page_transitions" @targets="tools.docs.page_layout" @by="system.docs_generator">
<while>the reader allows motion</while>
<must>move between pages of a site with a view transition that keeps the top bar and the navigation in place, where the browser has one: a same-document transition for a page shown in place, and a cross-document one for a page loaded whole</must>
</rule>

<rule id="quiet_scrollers" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>keep the scroll areas inside a page, the navigation, the right [column](#heron.language.grammar.lexical.column), code blocks and wide [tables](#heron.language.markup.components.table), quiet: a thin scrollbar that shows only while the pointer or focus is on its area, never a scrollbar at rest, the navigation's at its [column](#heron.language.grammar.lexical.column)'s outer edge, the whole height under the top bar, clear of its entries and their chevrons; and show a long example in a panel by its start with a button for the rest, rather than as a scroll area inside the scrolling [column](#heron.language.grammar.lexical.column)</must>
</rule>

<rule id="controls_look_like_controls" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>make every control of the top bar read as one at rest, not only on hover: the [site areas](#tools.docs.site.site_area) as tabs with a mark in the [project colour](#tools.frontend.design_system.project_colour) under the current one, the lens switcher and the version switch as selects drawn in the theme, with a visible edge, that the keyboard opens and moves through, search as a field with a frame, a prompt and its shortcut in a key cap, and the theme switch as a button with a visible edge; and give each a focus ring on keyboard focus</must>
</rule>

<rule id="steps_joined" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>join the number of each step of an [authored page](#language.markup.authored_pages.authored_page)'s steps to the next step's number with a vertical line, as a stepper does</must>
</rule>

<rule id="asset_versions" @targets="tools.docs.page_layout" @by="system.docs_generator">
<must>link the theme's stylesheet and script with a version of their content in the URL, so a changed asset has a new URL</must>
</rule>

<rule id="prefetch_links" @targets="tools.docs.page_layout" @by="system.docs_generator">
<should>prefetch a page of the same site as the reader is about to follow a link to it</should>
</rule>
