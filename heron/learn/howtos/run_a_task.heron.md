<howto id="run_a_task" @lens="user" @display="Run a task">
A task is code the tree runs by its path: setting up a repository, seeding a
database, releasing. Its parameters become the command's options.

<step id="write_the_task">
Declare the task with its parameters and a `do` block, and document it with `///`.

<example id="greet_task" @display="A task with a parameter">
```heron
/// Greets someone by name.
greet(name: String = "world"): task do {
  log("Hello, $name")
}
```
</example>
</step>

<step id="run_it">
Run ${cli.run.name} with the task's path and its parameters as options, as
`heron run greet --name Ada`. The task's options come after its path, and the
command's own, such as `--json`, before it.
</step>

<step id="order_and_confirm">
Mark a task `@needs(other)` to run `other` first, and `<confirm>` to be asked before
it runs; `--yes` answers for you in a script.
</step>
</howto>
