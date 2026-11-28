# Inserts {#inserts}

`$name`, `$a.b`, `$f(args)` and `${expr}` insert a value into the text, in the same
[forms](#language.grammar.strings.inserts) a string uses. The checker resolves them; the
docs show what they insert.

<term id="insertion">
A `$` form in [prose text](#language.markup.writing.prose_text): a path, a call, or an expression in `${ }` where the end of a
path would be unclear, as in `${days}-day`.
</term>

<rule id="inserts_resolve" refs="system.checker">
<must>resolve an insertion's path, and the names of its arguments or expression, in the scope of the text it's written in, and report unknown name for one that resolves nowhere</must>
</rule>

<rule id="insert_ends" refs="system.parser">
<must>end a path [insertion](#language.markup.inserts.insertion) at the first character that can't continue the path, so a `.` that no name follows is text</must>
<example>`$order.status.` at the end of a sentence inserts `order.status` and keeps the full stop</example>
</rule>

<rule id="insert_prose" refs="system.docs_generator">
<while>an insertion's path names a node whose value is prose</while>
<must>render that prose in place, with its emphasis, links, tags and [insertions](#language.markup.inserts.insertion)</must>
</rule>

<rule id="insert_value" refs="system.docs_generator">
<while>an insertion's path names a node whose value is anything but prose</while>
<must>render the value's expression as inline code, highlighted as code</must>
<example>`$limit` with `limit = 30` renders `30`</example>
</rule>

<rule id="insert_node" refs="system.docs_generator">
<while>an insertion's path names a node with no value, such as a section</while>
<must>render it as a link to the node, with its path as inline code</must>
</rule>

<rule id="inserted_once" refs="system.docs_generator">
<must_not>read the text an inserted value renders to as markup again</must_not>
<then>a value holding `$` or `<` shows those characters</then>
</rule>

<rule id="insert_calls_not_run" refs="system.docs_generator">
<while>an [insertion](#language.markup.inserts.insertion) is a call or an expression, as `$data(diff)` or `${n + 1}`</while>
<must>render its result where the arguments are known at generation time, and its source as inline code where they aren't</must>
</rule>
