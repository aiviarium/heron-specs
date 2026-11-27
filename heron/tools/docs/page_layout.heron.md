# Page layout {#page_layout}

Every page has the same frame, after Fumadocs: the top bar, the navigation, the page
and a right [column](#heron.language.grammar.lexical.column).

<rule id="frame" targets="tools.docs.page_layout" by="system.docs_generator">
<must>lay out a page as a top bar with the logo, the [site areas](#tools.docs.site.site_area), the lens switcher, search with its shortcut, the version switch and the theme switch; the navigation tree of its [site area](#tools.docs.site.site_area) on the left; a breadcrumb and the page in the middle; and on the right the page's outline, or an op's examples, sticky as the page scrolls</must>
</rule>

<rule id="nav_pages_only" targets="tools.docs.page_layout" by="system.docs_generator">
<must>list in the navigation only pages, the nodes with a page of their own at the lens's depth, and never a node that's an anchor on a page, in every lens and on the project's site</must>
</rule>

<rule id="outline_nested" targets="tools.docs.page_layout" by="system.docs_generator">
<must>show in a page's outline its headings and, under a heading of a node with no subheadings of its own, the nodes the page shows inside that node with an anchor, or on a page without headings the nodes it shows with an anchor and theirs, two levels deep in all, and mark the entry of what's in view as the page scrolls</must>
<example>a page's outline lists its sections, and under each section the use cases and scenarios it holds</example>
</rule>

<rule id="nav_scroll_kept" targets="tools.docs.page_layout" by="system.docs_generator">
<must>keep the navigation's place from one page of a site to the next, for each lens's site and each of its areas apart, in `sessionStorage`, and restore it before the page paints: the entry the reader followed where it was on screen when the navigation can scroll that far, and otherwise the scroll position; where nothing is kept, scroll the current page's entry into view</must>
<then>following a link far down the navigation leaves the navigation where it was</then>
</rule>

<rule id="lens_switcher" targets="tools.docs.page_layout" by="system.docs_generator">
<where>the site builds more than one [lens](#tools.docs.lenses.lens_kind)</where>
<must>show in the top bar a switcher with the `title` of each lens, in the order of the docs block's `lenses`, the current one selected, each a plain link that works without a script</must>
</rule>

<rule id="no_switcher_alone" targets="tools.docs.page_layout" by="system.docs_generator">
<where>the site builds one lens</where>
<mustNot>show a lens switcher</mustNot>
</rule>

<rule id="narrow_screens" targets="tools.docs.page_layout" by="system.docs_generator">
<when>the window is 1180 px wide or less</when>
<must>drop the right [column](#heron.language.grammar.lexical.column) below the page, and at 820 px or less collapse to one [column](#heron.language.grammar.lexical.column) with the navigation behind a button</must>
</rule>

<rule id="theme_before_paint" targets="tools.docs.page_layout" by="system.docs_generator">
<must>apply the theme the reader chose, kept in `localStorage` as `heron-theme`, before the page paints, follow the system's light or dark preference until one is chosen, and declare the page's colour schemes and set the canvas to the theme's page colour in the page's head, so the canvas takes the theme before the stylesheet loads, in every browser</must>
</rule>

<rule id="stable_frame" targets="tools.docs.page_layout" by="system.docs_generator">
<must>start the content at the same distance from the window's left edge on every page that has the navigation, whatever the right side of the page holds, and paint a page whole, never before its frame, the navigation, the page and what stands beside it, is parsed</must>
<then>moving between pages never slides the content sideways or shows a half-built page</then>
</rule>

<rule id="pages_in_place" targets="tools.docs.page_layout" by="system.docs_generator">
<where>a script runs and the page is served over HTTP</where>
<must>show a page that a link, the search or going back or forward leads to within the same lens's site in place: fetch it and swap in its top bar and frame in one step, without loading a new document, and update the address, the title and the history, while every link stays a plain link that works without a script</must>
<then>moving between pages never shows a blank or light canvas between two pages, in any browser</then>
</rule>

<rule id="page_transitions" targets="tools.docs.page_layout" by="system.docs_generator">
<while>the reader allows motion</while>
<must>move between pages of a site with a view transition that keeps the top bar and the navigation in place, where the browser has one: a same-document transition for a page shown in place, and a cross-document one for a page loaded whole</must>
</rule>

<rule id="quiet_scrollers" targets="tools.docs.page_layout" by="system.docs_generator">
<must>keep the scroll areas inside a page, the navigation, the right [column](#heron.language.grammar.lexical.column), code blocks and wide [tables](#heron.language.markup.components.table), quiet: a thin scrollbar that shows only while the pointer or focus is on its area, never a scrollbar at rest; and show a long example in a panel by its start with a button for the rest, rather than as a scroll area inside the scrolling [column](#heron.language.grammar.lexical.column)</must>
</rule>

<rule id="steps_joined" targets="tools.docs.page_layout" by="system.docs_generator">
<must>join the number of each step of an [authored page](#language.markup.authored_pages.authored_page)'s steps to the next step's number with a vertical line, as a stepper does</must>
</rule>

<rule id="asset_versions" targets="tools.docs.page_layout" by="system.docs_generator">
<must>link the theme's stylesheet and script with a version of their content in the URL, so a changed asset has a new URL</must>
</rule>

<rule id="prefetch_links" targets="tools.docs.page_layout" by="system.docs_generator">
<should>prefetch a page of the same site as the reader is about to follow a link to it</should>
</rule>
