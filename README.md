# heron-specs

The specs of the Heron system, authored and versioned apart from any implementation. Each
top-level folder is one spec package (`heron/` is the Heron language, product and command
line); more products' specs and packages shared across an organization sit beside it. A
package is sealed: an implementation such as `aiviarium/heron` imports it at a version and
adds only its own project tree (components, the tests that prove each rule, status and
releases), and can't amend the spec. Nothing here refers to implementation code.

## CI

```sh
scripts/ci.sh                         # builds heron from ../heron, or ../specs-v0
HERON_BIN=/path/to/heron scripts/ci.sh
```

It checks, lints and format-checks the workspace and each package, and renders each
package's docs under `<package>/.heron/docs/`. Sealed packages need a heron build with
sealed-package support.
