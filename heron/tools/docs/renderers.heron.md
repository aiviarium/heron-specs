# Renderers {#renderers}

Renderers per kind are built into `heron`, and the docs and the live preview share them:
a kind with a renderer shows properly, and any other kind as a plain node.

<rule id="renderer_per_kind" refs="system.docs_generator">
<must>render a node through the renderer registered for its kind's declaration path, such as `spec.rule`, with the latest registration winning</must>
<while>a renderer is registered for the kind</while>
</rule>

<rule id="renderer_per_kind_otherwise" refs="system.docs_generator">
<where>no renderer is registered for a kind</where>
<must>show its nodes as their title, prose, fields and children</must>
</rule>

<rule id="tag_renderers" refs="system.docs_generator">
<must>render a markup tag through the renderer registered for its kind, with its attributes typed by the kind's parameters, or else through the built-in components of `std/doc`</must>
</rule>

<rule id="heron_template_renderers" refs="system.docs_generator">
<may>take renderers and islands written as Heron templates</may>
</rule>
