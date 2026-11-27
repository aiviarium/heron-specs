<howto id="give_agents_the_spec" @lens="user" @display="Give an agent your spec">
An agent that builds or reviews your system reads the spec best as plain files sized for
it: an index it loads first, then the one file its task needs. ${cli.generate.name} writes
those files from the same tree as your docs, so they never drift from it.

<step id="write_the_export">
Run `heron generate agents` in the folder of your tree. It writes `.heron/agents/`:
`INDEX.md`, which says what the product is, how to read the files and which file holds
what, with each file's size; `llms.txt`, which points to it; and one Markdown file per
area of the tree, every requirement under a heading with its full id.
</step>

<step id="point_the_agent">
Tell the agent to read `.heron/agents/INDEX.md` first, in its instructions file or its
prompt, and to open a file only when its task leads there. An agent that should know one
part well gets a [context pack](#tools.docs.agents.context_pack) instead: `heron generate --pack orders` writes
`.heron/agents/packs/orders.md`, that part in full and one line for each thing it links.

<tip>`heron serve` serves the same files at `/agents/`, current with every edit, and
`heron generate docs` puts them in the site under `agents/`, with `llms.txt` at its root.</tip>
</step>

<step id="choose_what_it_reads">
To change what agents read, declare a lens named `agent` in your tree, written as
Markdown, as `std/docs`'s is: its `hide` and `show` lists choose the kinds, and `budget`
the size each file is split at.

<example id="own_agent_lens" @display="An agent lens of your own">
```heron
import = ["std/doc@1", "std/docs@1"]

agent: lens {
  title = "Agents"
  nav = LensNav.TREE
  format = LensFormat.MARKDOWN
  marks = false
  hide = [docs.authored, spec.example]
  budget = 4000
  prefix = "agents"
}
```
</example>
</step>
</howto>
