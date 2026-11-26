<concept id="writing_prose" @lens="user, developer" @display="Writing prose">
Prose in Heron is Markdown with kind elements: `*emphasis*`, lists, tables and code
fences where Markdown has a form, and an element in HTML's form where a node needs its
kind, as `<warning>…</warning>` or `<step id="install">…</step>`. Both build the same
tree, so `<em>now</em>` and `*now*` are one node, and the two mix freely in `|` lines,
in a `{{ }}` body and in a `.heron.md` file.

An element names a kind, its quoted attributes are the kind's arguments, and an `id`
makes it a node with a path, an anchor and, where the lens gives it one, a page. An
attribute that starts with `@` is an annotation, as `@lens="user"`. A name in brackets,
`[refund_window]`, links to a node, and `<ref to="refund_window"/>` is the same link
written as an element.

Code stays in `.heron` files: a task's `do` block has no element form. A file of prose,
headings and elements alone is a `.heron.md` file, included like any other.

<example id="prose_with_elements" @display="Prose with elements">
```heron.md
~~~heron
import = ["std/doc@1", "std/docs@1"]
~~~

# Refunds {#refunds}

How support refunds a payment. Every refund follows the [window].

<warning>A refund can't be undone.</warning>

<howto id="refund_a_payment">
Refund a payment from the console.

<step id="open">
Open the payment and press <kbd>R</kbd>.
</step>
</howto>

~~~heron
window: term {{ The 30 days after a payment is captured. }}
~~~
```
</example>
</concept>
