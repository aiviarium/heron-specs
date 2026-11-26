<tutorial id="getting_started" @lens="user" @display="Getting started">
Install `heron`, write a first tree, check it and build its documentation site, in a few
minutes and four steps.

<step id="install">
Heron is one command, `heron`, with the checker, the formatter, the linter, the task
runner, the docs generator and the editor in it. Put the `heron` binary on your `PATH`,
then run ${cli.help.name}: it lists the commands you have.
</step>

<step id="first_file">
Make an empty folder and write this as `index.heron` in it. The folder's
`index.heron` is where every command starts reading. Its `import` brings in the
standard packages whose kinds the file uses: `section` and `term` from `std/doc`,
`rule` from `std/spec` and `actor` from `std/product`.

<example id="first_tree" @display="index.heron">
```heron
import = ["std/doc@1", "std/spec@1", "std/product@1"]

shopper: actor {{ Someone who buys from the shop. }}

checkout: section {
  | How a shopper pays for an order.

  total: term {{ The sum of an order's lines, with tax, in the order's currency. }}

  total_shown: rule(checkout, by = shopper) {
    must {{ see the order's [total](#checkout.total) before paying }}
  }
}
```
</example>
</step>

<step id="check">
Run ${cli.check.name} in the folder. It prints nothing and exits with status 0: the
tree checks. Now change `by = shopper` to `by = shoper` and run it again. It prints one
line, the file, line and column, then the message ${language.core_format.naming.diagnostics.unknown_name.message}
with the closest name it found, and exits with status 1. Put the name back.
</step>

<step id="docs">
Run ${cli.generate.name} with the target `docs`. It writes the documentation site under `.heron/docs/`;
open `.heron/docs/index.html` in a browser. The pages are plain files, so they open
from disk and can be published on any static host.

To edit the tree with the pages updating as you type, [use_the_editor].
</step>
</tutorial>
