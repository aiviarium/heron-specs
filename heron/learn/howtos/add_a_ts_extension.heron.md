<howto id="add_a_ts_extension" @lens="user" @display="Add a TS extension">
When a task needs a real language, write the function in TS and declare its
signature in Heron. Callers, the checker and the docs see an ordinary func.

<step id="declare_it">
Declare a `module` for the TS file, and bind a func to one of its exports.

<example id="foreign_func" @display="A func implemented in TS">
```heron
import = ["std/js@1"]

tools: module = js("./tools/orders.ts")

/// Writes every order of a pet to a CSV file and returns its path.
export_orders(pet_id: Int): func(String) = tools.exportOrders

export_pet_orders(pet_id: Int): task do {
  let path = export_orders(pet_id = pet_id)
  log("Wrote $path")
}
```
</example>
</step>

<step id="generate_bindings">
Add `@heron/runtime` to the project's dev dependencies, then run ${cli.generate.name}
with the target `ts`. It writes `.heron/types.ts` and `.heron/bindings.ts`, whose
`bind` has a typed member for each func bound to a module.
</step>

<step id="implement_it">
Implement the export with `bind`, so `tsc` checks it against the Heron signature.

```ts
// tools/orders.ts
import { writeFile } from "node:fs/promises";
import { bind } from "../.heron/bindings";

export const exportOrders = bind.export_orders(async ({ pet_id }, ctx) => {
  const path = ctx.temp("orders.csv");
  await writeFile(path, `pet,${pet_id}\n`);
  return path;
});
```
</step>

<step id="run_it">
Run the task as any other, `heron run export_pet_orders --pet-id 7`. Heron starts the
[js_host], calls the export with the arguments by name, and a failure in the TS code
comes back as an error the task can handle.
</step>
</howto>
