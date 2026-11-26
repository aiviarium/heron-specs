# Renderers {#renderers}

Renderers per kind are an [extension point](#language.interop.declaring.extension_point) the docs and the live preview share:
a scenario or a prompt shows properly once its extension is installed, and as a plain node
before that.

<rule id="renderer_per_kind" targets="tools.docs.renderers" by="system.docs_generator">
<must>render a node through the renderer registered for its kind's declaration path, such as `spec.rule`, with the latest registration winning</must>
<while>a renderer is registered for the kind</while>
</rule>

<rule id="renderer_per_kind_otherwise" targets="tools.docs.renderers" by="system.docs_generator">
<where>no renderer is registered for a kind</where>
<must>show its nodes as their title, prose, fields and children</must>
</rule>

<rule id="tag_renderers" targets="language.markup.tags.component_tag" by="system.docs_generator">
<must>render a markup tag through the renderer registered for its kind, with its attributes typed by the kind's parameters, or else through the built-in components of `std/doc`</must>
</rule>

<term id="ts_renderer" @display="TS renderer">
A renderer written in TS: an export of a module the [docs block](#tools.docs.extending.docs_block) names in `renderers`,
made with `defineRenderer(kind, render)` from `@heron/runtime`, run through the
[JS host](#language.interop.host.js_host) when the docs are generated.
</term>

<rule id="ts_renderer_contract" targets="tools.docs.renderers.ts_renderer" by="system.docs_generator">
<must>register one renderer per kind a module's handshake reports, and call its `render` with plain data: the node's path, name, kind, title, heading level, anchor, rendered prose and children, its kind's arguments as typed attributes, and the components of its kind's other slots by name; for a markup tag, its rendered body and its attributes instead of a path</must>
<then>`render` returns HTML, or HTML with whether a tag is a block and which built-in islands it uses</then>
</rule>

<rule id="ts_renderer_fallback" targets="tools.docs.renderers.ts_renderer" by="system.docs_generator">
<must>keep the built-in renderer, or the generic view, for every kind a module doesn't render</must>
</rule>

<rule id="heron_template_renderers" targets="tools.docs.renderers" by="system.docs_generator">
<may>take renderers and islands written as Heron templates</may>
</rule>
