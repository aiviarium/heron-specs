# Standard lenses {#standard_lenses}

`std/docs` ships three lenses, declared in Heron like any other: `user`, for the people
who use what a tree describes; `developer`, for the people who write trees of their own;
and `explore`, the whole tree. [The standard lenses](#tools.docs.standard_lenses.standard_lens_declarations)
are written out below as a file that declares them; a site chooses among them, and a package overrides one by
declaring a lens of the same name.

<example id="standard_lens_declarations" @display="The standard lenses">
```heron
import = ["std/doc@1", "std/spec@1", "std/docs@1"]

user: lens {
  title = "User"
  default = true
  nav = LensNav.TASK
  show = [docs.authored, docs.step, spec.example, doc.term, spec.command, spec.argument, spec.option, spec.error]
  hide = [spec.rule, spec.condition, grammar.production]
  depth = 2
  prefix = ""
}

developer: lens {
  title = "Developer"
  nav = LensNav.TOPIC
  summarize = [spec.rule, spec.quality, spec.guidance]
  prefix = "dev"
}

explore: lens {
  title = "Explore"
  nav = LensNav.TREE
  prefix = "explore"
}
```
</example>

<rule id="declared_in_heron" targets="tools.docs.standard_lenses" by="system.docs_generator">
<must>read `user`, `developer` and `explore` from their declarations in `std/docs`, with the fields [the standard lenses](#tools.docs.standard_lenses.standard_lens_declarations) give them, and render them by the same rules as any lens</must>
<then>no lens is built into the generator, and an override of `user` or `developer` changes what it shows</then>
</rule>

## User lens {#user_lens}

For a person who wants to use the product: compact and task first. It shows the pages
written for them and the facts they act on, and none of the rules that bind an
implementation. Its reference is shallow: a page per part of the tree, with the
terms, examples and errors of the concerns below it.

<rule id="user_shows" targets="tools.docs.standard_lenses.user_lens" by="system.docs_generator">
<must>render in full, in the `user` lens, the [authored pages](#language.markup.authored_pages.authored_page) with their steps, the examples, the terms, the commands with their arguments, options and exit codes, and the diagnostics</must>
</rule>

<rule id="user_hides" targets="tools.docs.standard_lenses.user_lens" by="system.docs_generator">
<mustNot>render, in the `user` lens, a rule, a rule's conditions, a production, an invariant, or the prose of a section of the tree that no [lens mark](#tools.docs.lenses.lens_mark) keeps for `user`</mustNot>
</rule>

<rule id="diagnostics_as_errors" targets="tools.docs.standard_lenses.user_lens" by="system.docs_generator">
<must>show a diagnostic, in the `user` lens, as the error a person meets: its code and its message on one line, and the first sentence of its prose under it as the fix, without its severity, its related message or the part that reports it</must>
</rule>

<rule id="errors_gathered" targets="tools.docs.standard_lenses.user_lens" by="system.docs_generator">
<must>show each diagnostic, in the `user` lens, on its diagnostics page alone, at its anchor there, and leave it and a section holding only diagnostics off the page of the section that holds it</must>
<then>a page of the user's reference reads as its prose, terms and examples, with no Diagnostics heading under each section, and its errors are on one page</then>
</rule>

<rule id="user_first" targets="tools.docs.standard_lenses.user_lens" by="system.docs_generator">
<where>a site's `lenses` lists `user`</where>
<must>serve `user` at the site's root, as its `default` says</must>
</rule>

## Developer lens {#developer_lens}

For a person writing a tree of their own in the language: concise and navigable. It
shows the whole tree by topic, with the examples, APIs and diagrams first and each rule
on one line a reader opens when they need it.

<rule id="developer_summarizes" targets="tools.docs.standard_lenses.developer_lens" by="system.docs_generator">
<must>render, in the `developer` lens, each rule, quality and guidance as a [summary line](#tools.docs.lenses.what_a_lens_shows.summary_line), in the place [the content order](#tools.docs.rendering.content_order) gives rules, and every other node in full</must>
</rule>

<rule id="developer_by_topic" targets="tools.docs.standard_lenses.developer_lens" by="system.docs_generator">
<must>list the tree's sections in the `developer` lens's navigation as topics, as `LensNav.TOPIC` says</must>
</rule>

## Explore lens {#explore_lens}

The whole tree, every node in its place: what an implementer or a reviewer reads, and
where a link to something another lens leaves out opens. [The explore view](#tools.docs.explore)
says how it's rendered.

<rule id="explore_shows_all" targets="tools.docs.standard_lenses.explore_lens" by="system.docs_generator">
<must>render every node of the tree in full in the `explore` lens, whatever its kind and whatever [lens marks](#tools.docs.lenses.lens_mark) it carries</must>
</rule>

<rule id="explore_by_name" targets="tools.docs.standard_lenses.explore_lens" by="system.docs_generator">
<must>render every node in full in a lens named `explore` that a tree declares, whatever its lists, and take only its `title`, `nav`, `entry` and `prefix` from the override</must>
<then>no lens list and no [lens mark](#tools.docs.lenses.lens_mark) can keep a node out of the full view</then>
</rule>
