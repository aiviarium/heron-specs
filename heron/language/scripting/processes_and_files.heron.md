# Processes and files {#processes_and_files}

Processes and files are funcs of `std/process` and `std/files` that reach the world
through the run's capabilities, so a run records what they did and a test can answer
them. [Seeding and exporting](#language.scripting.processes_and_files.scripting_processes)
shows both.

<term id="run_func">
`run(command, args?, env?, cwd?, stdin?, stdout?)` of `std/process`, which starts a
process, waits for it and returns a `Process` with `exit`, `stdout` and `stderr`. The
command is a program, `run("./scripts/seed-pets", args = […])`, or a script given as an
[embedded string](#language.grammar.strings.embedded.embedded_string), `run((sh)"""…""")`.
</term>

<term id="temp_func">
`temp(name)` of `std/files`, which returns a path named `name` in a directory that
belongs to the run.
</term>

<section id="processes">

<rule id="argv_only" targets="run_func" by="system.interpreter">
<mustNot>pass a command or its arguments through a shell</mustNot>
<instead>start the program with the list as its arguments, each value in its string form, and look the program up on `PATH` when it has no slash</instead>
<example>`run("./scripts/seed-pets", args = ["--count", count])` with `count = 2` starts the program with the two arguments `--count` and `2`</example>
</rule>

<rule id="scripts_run_by_language" targets="run_func" by="system.interpreter">
<where>the command is a [typed string](#language.data.typed_strings.typed_string)</where>
<must>run the program named by its language with `-c` and the text, and with the language's name and then `args` after it when `args` are given</must>
<then>inside the script, `$1` is the first of `args`, as `sh -c` passes them</then>
<example>`run((sh)"echo $name | tr a-z A-Z")` starts `sh` with `-c` and `echo 'a b' | tr a-z A-Z` for `name = "a b"`</example>
</rule>

<rule id="process_environment" targets="run_func" by="system.interpreter">
<must>give a process the run's environment followed by `env`'s entries in sorted order, the project's root or `cwd` joined to it as its working directory, and `stdin` as its input</must>
<then>an entry of `env` replaces an inherited variable of the same name</then>
</rule>

<rule id="pipes_are_params" targets="run_func" by="system.interpreter">
<must>pipe and redirect through parameters: `stdin = other` takes another `Process`'s `stdout` or any value's string form, and `stdout = path` writes the output to a file and leaves `stdout` of the result empty</must>
<example>`run("sort", stdin = run("ls"))`, `stdin = read(path)` and `stdout = temp("orders.csv")`</example>
</rule>

<rule id="nonzero_exit" targets="run_func" by="system.interpreter">
<if>a process exits with a status other than zero</if>
<must>throw `ProcessError` with the status as `exit` and a message naming the program, the status and the last line of its standard error</must>
<then>`attempt(run(…))` keeps the failure as a value, and an uncaught one fails the run</then>
</rule>

<rule id="cant_start" targets="run_func" by="system.interpreter">
<if>a program can't be started, as when it isn't found</if>
<must>throw `ProcessError` with `exit` set to `-1` and the reason as its message</must>
</rule>

<rule id="processes_recorded" targets="run_func" by="system.interpreter">
<must>record each process once it exits, with its program, arguments, status and output</must>
</rule>
</section>

<section id="quoting">
A value inserted into a script is the one place code meets a shell, so the language
says how a value is made safe there.

<rule id="sh_quoting" targets="run_func" by="system.interpreter">
<where>a language is declared with `@insert(Insert.QUOTE)` and is `sh`, `bash` or `zsh`, as `std/process`'s `sh` is</where>
<must>quote each value inserted into its embeds as one shell word: as written when it's non-empty and holds only letters, digits and `-_./:=@%+,`, and otherwise in single quotes, with each `'` written as `'\''`</must>
<example>`(sh)"rm $path"` with `path = "a b; rm -rf"` is `rm 'a b; rm -rf'`</example>
</rule>

<rule id="raw_inserts" targets="run_func" by="system.interpreter">
<where>`@insert<raw>` stands above the node whose code inserts the value, or above any node that encloses it</where>
<must>insert values into the embed as written</must>
<then>a script that builds its own command line opts out on purpose, where a reviewer sees it</then>
</rule>

<rule id="raw_embeds_static" targets="run_func" by="system.interpreter">
<must>take a raw embed, ```` (sh)```…``` ````, exactly as written, inserting nothing</must>
<then>values that belong inside code go in a quoted embed, through `$name` and `${expr}`</then>
</rule>
</section>

<section id="files">

<rule id="file_paths" targets="temp_func" by="system.interpreter">
<must>join a relative path given to `read`, `write`, `run`'s `cwd` or `stdout` to the project's root, and `write` the directories a file needs</must>
</rule>

<rule id="file_errors" targets="temp_func" by="system.interpreter">
<if>a file can't be read or written</if>
<must>throw `std/files`'s `FileError` with the path and the reason</must>
<then>`attempt(read(path))` keeps a missing file as a value with `error.path`, and `result.error is FileError` is true</then>
</rule>

<rule id="file_content" targets="temp_func" by="system.interpreter">
<must>write a value's string form, a typed string's text, and read a file as a `String`</must>
<example>`write("report.json", (json)"""…""")` writes the JSON text, its shared indentation removed as any multi-line string's is</example>
</rule>

<rule id="temp_files" targets="temp_func" by="system.interpreter">
<must>make one directory for the run on its first `temp(…)`, return a path in it named by the last part of `name`, and remove the directory with everything in it when the run ends</must>
<then>two calls with one name return the same path</then>
</rule>
</section>

<rule id="short_code" targets="language.scripting.processes_and_files" by="actors.author">
<should>keep a block to calls, with parsing, data processing and real control flow in a [foreign func](#language.interop.declaring.foreign_func), long pipelines in a script that `run` calls, and system behaviour in an op</should>
</rule>

<example id="scripting_processes" @display="Seeding and exporting">
```heron
import = ["std/process@1", "std/files@1", "std/json@1"]

seed_pets(count: Int, status: PetStatus): func(List(Pet)) do {
  let out = run(
    "./scripts/seed-pets",
    args = ["--count", count, "--status", status],
  )
  return json.decode(List(Pet), out.stdout)
}

export_orders(pet_id: Int): func(String) do {
  let path = temp("orders.csv")
  run(
    "./scripts/export-orders",
    env = { PET_ID = pet_id },
    stdout = path,
  )
  return path
}
```
</example>
