<howto id="split_spec_and_implementation" @lens="user" @display="Keep a spec apart from its implementation">
A spec can live in a repository of its own, versioned and released on its own, with
each implementation importing it at a version. The implementation can't change what
the spec states: it adds only what's about itself, such as the tests that prove each
rule.

<step id="seal_the_spec">
In the spec's repository, put the spec in a folder whose `index.heron` declares it
as a package, sealed, at its version.

<example id="spec_package" @display="The spec package">
```heron
import = ["std/schema@1", "std/doc@1"]

shop: package(version = "0.2.0", sealed = true) {
  shopper: actor {{ Someone who buys from the shop. }}

  checkout: section {
    @by(shopper)
    @targets(checkout)
    totals: rule {
      must {{ see the order's total before paying }}
    }
  }
}
```
</example>
</step>

<step id="release_it">
Tag each release of the spec `v` and its version, as `v0.2.0`, so implementations can
ask for it by major version.
</step>

<step id="import_it">
In the implementation's repository, import the package by its git address, the
folder after `//` and the major version after `@`, and declare at the root that the
tree implements it, at the spec version exactly. Run `heron run setup` to install it:
`heron.lock` pins the tag and the commit it resolved to.

```heron
import = ["std/project@1", "git+https://github.com/acme/shop-specs//spec@v0"]

shop_app: implements(shop, at = "0.2.0") {
  version = "0.2.0+build1"
}

proves(shop.checkout.totals) {
  verify("web/checkout.test.ts", test = "shows the total")
}
```
</step>

<step id="change_the_spec_first">
${cli.check.name} reports an amend of a spec node from the implementation as
${language.specifications.implementations.errors.sealed_node.title}. To change
a behaviour, change the spec, release it, and move the implementation to the new
version.
</step>
</howto>
