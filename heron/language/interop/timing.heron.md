# When foreign code runs {#timing}

Foreign code runs when Heron code calls it, and at no other time, except a
[pure func](#language.scripting.funcs_and_templates.pure_func), which may also run
while the tree is evaluated. What it holds onto lives as long as the run that called it.

<term id="run_scope">
The run a foreign call belongs to: a `heron run`, with an id that sorts by time, or the
session of a command such as `heron lint` that isn't a run. Every request carries its
run's id.
</term>

<rule id="run_time_anything" refs="system.interpreter">
<may>call a [foreign func](#language.interop.declaring.foreign_func) of any kind at run time, from tasks, funcs, [hooks](#language.scripting.code.hook) and the steps of a test</may>
</rule>

<rule id="evaluation_only_pure" refs="system.interpreter">
<while>the tree is [evaluated](#language.scripting.funcs_and_templates.evaluation)</while>
<must>run only [pure funcs](#language.scripting.funcs_and_templates.pure_func), each answered from the cache of its earlier results when its inputs were seen before</must>
<then>a build and the selection of tests stay reproducible</then>
</rule>

<rule id="foreign_calls_recorded" refs="system.interpreter">
<must>record every foreign call with its arguments, its result or error and how long it took by the run's clock</must>
</rule>

<rule id="replay_from_record" refs="system.interpreter">
<when>a run is replayed</when>
<must>answer each foreign call from the recorded result instead of calling the foreign code</must>
<then>the replay is deterministic whatever the foreign code would do now</then>
</rule>

<rule id="embedded_pure" refs="system.interpreter">
<may>run a pure JS func embedded, in QuickJS inside the binary, so evaluating a tree needs no Node</may>
</rule>

## Resources {#resources}

A resource's instance, such as a database client, belongs to one
[run](#language.interop.timing.run_scope), so two runs never share state through
foreign code.

<rule id="instance_per_run" refs="system.extension_host">
<must>set a resource up the first time its run uses it, from code or from `ctx.resource`, and give every later use in that run the same instance</must>
</rule>

<rule id="runs_apart" refs="system.extension_host">
<mustNot>give one run's instance to another run</mustNot>
</rule>

<rule id="teardown_at_end" refs="system.extension_host">
<when>a run ends</when>
<must>tear down every instance it set up, newest first, and refuse to set up another for it</must>
</rule>

<rule id="run_id_travels" refs="system.extension_host">
<must>send the run's id with each request of a run, and serve what foreign code asks back, `ctx.call` and `ctx.resource`, in the run whose id the request carries</must>
</rule>
