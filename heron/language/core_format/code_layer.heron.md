# Code {#code_layer}

Code runs only inside `do { … }`, and nothing outside `do` ever runs. The surface is
deliberately small: code decides, combines and calls. Real work runs in the language a
system is built in, through foreign functions; the [Scripting](#language.scripting) and
[Interop](#language.interop) sections cover both.

<rule id="nothing_runs_outside_do" @targets="language.core_format.code_layer" @by="system.interpreter">
<mustNot>run anything outside a `do` block, except the calls in a body that yield its members at check time</mustNot>
</rule>

<rule id="fixed_statements" @targets="language.core_format.code_layer" @by="system.parser">
<must>accept only `let`, `if … else`, `for … in`, `return`, setting a field, and calls with an optional trailing block</must>
<then>there's no `while`, no closures and no nested declarations, and nothing is added to the set later</then>
</rule>

<rule id="code_reads_in_order" @targets="language.core_format.code_layer" @by="system.interpreter">
<must>run statements top to bottom, with a name usable only below the line that declares it</must>
</rule>

<rule id="do_needs_a_kind" @targets="language.core_format.code_layer" @by="system.checker">
<if>a node whose kind accepts no code has a `do` block</if>
<must>report [takes no do block](#language.schemas.accept.errors.takes_no_do_block)</must>
</rule>
