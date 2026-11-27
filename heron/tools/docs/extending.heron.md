# Extending {#extending}

The generator is a set of parts a package can restyle, replace or add to, configured
once per tree by `std/docs`.

<term id="docs_block">
A tree's `docs { … }` block from `std/docs`: its [theme package](#tools.docs.extending.theme_package), its renderer modules, its
`depth`, the `lenses` its site builds, a `layout` per group of sections and its `slot`
nodes.
</term>

<term id="theme_package">
A package of design tokens, fonts, logo and CSS, `npm:<name>@<major>` found in a
`node_modules` folder at or above the file naming it, or a folder. Its
`heron-theme.json` lists a token file in the format of the design system's `tokens.json`, its font faces, its
logo and its stylesheets.
</term>

<rule id="theme_layer" @targets="tools.docs.extending.theme_package" @by="system.docs_generator">
<must>compose a [theme package](#tools.docs.extending.theme_package) into `_assets/theme/theme.css` in `@layer theme`, after the built-in theme in `@layer heron`, copy its fonts and logo beside it, and show its logo in place of the top bar's mark</must>
<then>a theme changes the look without touching structure</then>
</rule>

<rule id="layouts_per_section" @targets="tools.docs.extending" @by="system.docs_generator">
<must>give the sections a `layout` names, and the pages below them, that layout: `docs` (the default), `api` (the page joins the API reference), `changelog` (each child section is an entry on one page, in the order written) or `landing` (no sidebar, the prose as a lead and a tile per page below)</must>
</rule>

<rule id="changelog_entries" @targets="tools.docs.extending" @by="system.docs_generator">
<where>a section takes the `changelog` layout</where>
<must>show each child section as an entry, its title in the margin and its notes beside it</must>
</rule>

<rule id="release_notes" @targets="tools.docs.extending" @by="system.docs_generator">
<when>the tree records releases</when>
<must>render each project's release notes from its release records on the changelog page</must>
</rule>

<rule id="slots" @targets="tools.docs.extending" @by="system.docs_generator">
<must>show a `slot`'s prose and nodes, each through its kind's renderer, in the page `header`, the `sidebar`, or `before` and `after` the content; with `of = <kind>`, show `before` and `after` around every node of that kind, and hand its other names to the kind's renderer to place</must>
</rule>

<example id="docs_configuration">
```heron
docs {
  theme = "npm:@acme/heron-theme@2"

  layout("api") {
    sections = [store_api]
  }

  renderers = [js("./docs/renderers.ts")]
  lenses = [user, developer, explore]
}
```
</example>
