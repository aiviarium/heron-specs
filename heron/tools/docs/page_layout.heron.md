# Page layout {#page_layout}

Every page has the same frame, after Fumadocs: the top bar, the navigation, the page
and a right column.

<rule id="frame" targets="tools.docs.page_layout" by="product.system.docs_generator">
<must>lay out a page as a top bar with the logo, the [site areas](#tools.docs.site.site_area), the lens switcher, search with its shortcut, the version switch and the theme switch; the navigation tree of its [site area](#tools.docs.site.site_area) on the left; a breadcrumb and the page in the middle; and on the right the page's outline, or an op's examples, sticky as the page scrolls</must>
</rule>

<rule id="lens_switcher" targets="tools.docs.page_layout" by="product.system.docs_generator">
<where>the site builds more than one [lens](#tools.docs.lenses.lens_kind)</where>
<must>show in the top bar a switcher with the `title` of each lens, in the order of the docs block's `lenses`, the current one selected, each a plain link that works without a script</must>
</rule>

<rule id="no_switcher_alone" targets="tools.docs.page_layout" by="product.system.docs_generator">
<where>the site builds one lens</where>
<mustNot>show a lens switcher</mustNot>
</rule>

<rule id="narrow_screens" targets="tools.docs.page_layout" by="product.system.docs_generator">
<when>the window is 1180 px wide or less</when>
<must>drop the right column below the page, and at 820 px or less collapse to one column with the navigation behind a button</must>
</rule>

<rule id="theme_before_paint" targets="tools.docs.page_layout" by="product.system.docs_generator">
<must>apply the theme the reader chose, kept in `localStorage` as `heron-theme`, before the page paints, and follow the system's light or dark preference until one is chosen</must>
</rule>
