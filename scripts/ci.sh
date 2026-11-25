#!/usr/bin/env bash
# Local CI for the spec workspace: check, lint, format and render the docs of
# every package. No hosted CI is used.
#
# The heron binary comes from $HERON_BIN, or is built from a sibling checkout
# of the implementation: ../heron, falling back to ../specs-v0.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

step() { printf '\n== %s\n' "$*"; }

heron="${HERON_BIN:-}"
if [ -z "$heron" ]; then
  src=""
  for d in ../heron ../specs-v0; do
    if [ -f "$d/cmd/heron/main.go" ]; then src="$(cd "$d" && pwd)"; break; fi
  done
  if [ -z "$src" ]; then
    echo "no heron binary: set HERON_BIN, or check out the implementation at ../heron" >&2
    exit 1
  fi
  step "build heron from $src"
  mkdir -p .heron/bin
  heron="$root/.heron/bin/heron"
  (cd "$src" && go build -o "$heron" ./cmd/heron)
fi
echo "heron: $heron"

# Vale, for the prose lints: pinned, from the Go proxy. heron lint fails
# rather than skipping when it's missing.
export PATH="$PATH:$(go env GOPATH)/bin"
command -v vale >/dev/null || go install github.com/vale-cli/vale/v3/cmd/vale@v3.28.1
export HERON_REQUIRE_VALE=1

# A package is a top-level folder whose index.heron declares one.
packages=()
for f in */index.heron; do
  if grep -qE '^[a-z_]+: package\(' "$f"; then packages+=("${f%/index.heron}"); fi
done
if [ ${#packages[@]} -eq 0 ]; then echo "no packages found" >&2; exit 1; fi

step "workspace"
"$heron" check .
"$heron" lint .

for p in "${packages[@]}"; do
  step "$p: check"
  "$heron" check "$p"
  step "$p: lint"
  "$heron" lint "$p"
  step "$p: fmt --check"
  "$heron" fmt --check "$p"
  step "$p: generate docs"
  (cd "$p" && "$heron" generate docs)
done

step "ok"
