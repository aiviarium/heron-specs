# Standard lenses {#standard_lenses}

`std/docs` ships four lenses, declared in Heron like any other: `user`, for the people
who use what a tree describes; `developer`, for the people who write trees of their own;
`explore`, the whole tree; and `agent`, the whole spec in Markdown for agents. [The standard lenses](#tools.docs.standard_lenses.standard_lens_declarations)
are written out below as a file that declares them; a site chooses among them, and a package overrides one by
declaring a lens of the same name.

<example id="standard_lens_declarations" @display="The standard lenses">
```heron
import = ["std/doc@1", "std/grammar@1", "std/docs@1"]

user: lens {
  title = "User"
  default = true
  nav = LensNav.TASK
  show = [docs.authored, docs.step, spec.goal, spec.nongoal, spec.example, spec.term, spec.command, spec.error]
  hide = [spec.rule, spec.condition, production]
  depth = 2
  prefix = ""
}

developer: lens {
  title = "Developer"
  nav = LensNav.TOPIC
  summarize = [spec.rule, spec.constraint, spec.guidance]
  prefix = "dev"
}

explore: lens {
  title = "Explore"
  nav = LensNav.TREE
  prefix = "explore"
}

agent: lens {
  title = "Agents"
  nav = LensNav.TREE
  format = LensFormat.MARKDOWN
  marks = false
  hide = [docs.authored]
  budget = 6000
  prefix = "agents"
}
```
</example>

<rule id="declared_in_heron" refs="system.docs_generator">
<must>read `user`, `developer`, `explore` and `agent` from their declarations in `std/docs`, with the fields the standard lenses give them, and render them by the same rules as any lens</must>
<then>no lens is built into the generator, and an override of `user`, `developer` or `agent` changes what it shows</then>
</rule>

## User lens {#user_lens}

For a person who wants to use the product: compact and task first. It shows the pages
written for them and the facts they act on, and none of the rules that bind an
implementation. Its reference is shallow: a page per part of the tree, with the
terms, examples and errors of the concerns below it.

<rule id="user_shows" refs="system.docs_generator">
<must>render in full, in the `user` lens, the [authored pages](#language.markup.authored_pages.authored_page) with their steps, the goals and what they leave out, the examples, the terms, the commands with their arguments, options and the errors they exit with, and the errors</must>
</rule>

<rule id="user_hides" refs="system.docs_generator">
<must_not>render, in the `user` lens, a rule, a rule's conditions, a production, or the prose of a section of the tree that no [lens mark](#tools.docs.lenses.lens_mark) keeps for `user`</must_not>
</rule>

<rule id="diagnostics_as_errors" refs="system.docs_generator">
<must>show a diagnostic, in the `user` lens, as the error a person meets: its code and its message on one line, and the first sentence of its prose under it as the fix, without its severity, its related message or the part that reports it</must>
</rule>

<rule id="errors_gathered" refs="system.docs_generator">
<must>show each diagnostic, in the `user` lens, on its diagnostics page alone, at its anchor there, and leave it and a section holding only diagnostics off the page of the section that holds it</must>
<then>a page of the user's reference reads as its prose, terms and examples, with no Diagnostics heading under each section, and its errors are on one page</then>
</rule>

<rule id="user_first" refs="system.docs_generator">
<while>a site's `lenses` lists `user`</while>
<must>serve `user` at the site's root, as its `default` says</must>
</rule>

## Developer lens {#developer_lens}

For a person writing a tree of their own in the language: concise and navigable. It
shows the whole tree by topic, with the examples, APIs and diagrams first and each rule
on one line a reader opens when they need it.

<rule id="developer_summarizes" refs="system.docs_generator">
<must>render, in the `developer` lens, each rule, quality and guidance as a [summary line](#tools.docs.lenses.what_a_lens_shows.summary_line), in the place [rendering](#tools.docs.rendering) gives rules, and every other node in full</must>
</rule>

<rule id="developer_by_topic" refs="system.docs_generator">
<must>list the tree's sections in the `developer` lens's navigation as topics, as `LensNav.TOPIC` says</must>
</rule>

## Explore lens {#explore_lens}

The whole tree, every node in its place: what an implementer or a reviewer reads, and
where a link to something another lens leaves out opens. [The explore view](#tools.docs.explore)
says how it's rendered.

<rule id="explore_shows_all" refs="system.docs_generator">
<must>render every node of the tree in full in the `explore` lens, whatever its kind and whatever [lens marks](#tools.docs.lenses.lens_mark) it carries</must>
</rule>

<rule id="explore_by_name" refs="system.docs_generator">
<must>render every node in full in a lens named `explore` that a tree declares, whatever its lists, and take only its `title`, `nav`, `entry` and `prefix` from the override</must>
<then>no lens list and no [lens mark](#tools.docs.lenses.lens_mark) can keep a node out of the full view</then>
</rule>

## Agent lens {#agent_lens}

For an agent that builds, changes or reviews what the tree specifies: every requirement of
every [layer](#language.specifications.layers.layer), in full, as the plain Markdown files of the [agent export](#tools.docs.agents.agent_export). It reads no
[lens marks](#tools.docs.lenses.lens_mark), since the marks choose pages for the site's
audiences, and it leaves out the [authored pages](#language.markup.authored_pages.authored_page), which retell the spec for people.

<rule id="agent_shows" refs="system.docs_generator">
<must>write, in the `agent` lens, every node of the tree in full but the [authored pages](#language.markup.authored_pages.authored_page), whatever [lens marks](#tools.docs.lenses.lens_mark) it carries, as Markdown</must>
<then>a node another lens leaves out by a mark is still in the export, and the tutorials and how-tos aren't</then>
</rule>

<rule id="agent_not_switched" refs="system.docs_generator">
<must_not>list the `agent` lens in the lens switcher, or link a page of the site to it</must_not>
<instead>reach it from `llms.txt` at the site's root, where agents look</instead>
</rule>
