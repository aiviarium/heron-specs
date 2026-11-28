# Search {#search}

<rule id="search_index" refs="system.docs_generator">
<must>build the search index when the docs are generated, over every documented node with an anchor: terms by their word, sections, kinds' nodes, tasks, projects, examples and the fields of the tree's types as `Type.field`, each with its kind, its path, its URL, its page's title and up to 240 characters of its text, a rule's or quality's sentence first</must>
<then>an op, a type, a field or a rule is found by name and opens at its anchor</then>
</rule>

<rule id="hover_cards" refs="system.docs_generator">
<must>write a hover card for every term, with its definition, and for every type, with its signature</must>
</rule>
