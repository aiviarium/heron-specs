# heron-specs

[![CI](https://github.com/aiviarium/heron-specs/actions/workflows/ci.yml/badge.svg)](https://github.com/aiviarium/heron-specs/actions/workflows/ci.yml)

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

It checks, lints (with the prose lints and Vale, configured by each package's `.vale.ini`)
and format-checks the workspace and each package, and renders each package's docs under
`<package>/.heron/docs/`, its agent export (the package as Markdown files for agents, see
`heron/tools/docs/agents.heron.md`) under `<package>/.heron/docs/agents/` with `llms.txt`
at the site's root. Vale is installed from the Go proxy when it isn't on `PATH`.

GitHub Actions runs the same script on every push and pull request to `main`
(`.github/workflows/ci.yml`), with heron built from `aiviarium/heron`'s `main` checked out
beside this repository and Vale required. The spec rendered from this package, at the
version the implementation pins, is published with the implementation's site, at
[aiviarium.github.io/heron/spec](https://aiviarium.github.io/heron/spec/).

## Examples are fixtures

Every `example` node's code block is a complete tree or file. The implementation extracts
its parser and checker fixtures from the package's examples, so changing an example
changes what the implementation is tested against. Nothing in this repository checks them
against a copy.
