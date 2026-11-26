# Text {#text}

Inside [prose text](#language.markup.writing.prose_text), emphasis is Markdown's, code is
verbatim, and a backslash keeps a character from starting a form. The docs render each;
the prose view keeps the words and masks the code.

<rule id="emphasis" targets="language.markup.writing.prose_text" by="system.docs_generator">
<must>render `**text**` as strong, and `*text*` or `_text_` as emphasis where the markers don't touch a letter or digit on their outer side</must>
<then>`snake_case_name` and `2*3*4` stay as written</then>
</rule>

<rule id="strike" targets="language.markup.writing.prose_text" by="system.docs_generator">
<must>render `~~text~~` as struck-through text</must>
</rule>

<rule id="code_span_verbatim" by="system.docs_generator">
<must>render a code span as inline code holding exactly the characters between its backticks</must>
<then>`` `$limit` `` shows the dollar sign and the name, never the value</then>
</rule>

<rule id="entities" targets="language.markup.writing.prose_text" by="system.docs_generator">
<must>read `&amp;`, `&lt;`, `&gt;` and `&quot;` in [prose_text] and in quoted attributes as `&`, `<`, `>` and `"`, and any other `&` as itself</must>
</rule>

<rule id="escapes_render" targets="language.grammar.prose.inline_forms.prose_escapes" by="system.docs_generator">
<must>render an escape as the character it keeps, without its backslash</must>
<example>`\$literal` renders as `$literal`</example>
</rule>

<rule id="fenced_code_verbatim" targets="language.grammar.prose.inline_forms.fences" by="system.docs_generator">
<must>render a fenced block as a code block titled by its info string, holding its lines with their common indentation, and the space after a `|` prefix, removed</must>
<then>`$`, `<`, `[` and `}}` inside a fence are text, so a fence shows Heron, JSON or shell exactly as written</then>
</rule>

<rule id="heron_fence_title" targets="language.grammar.prose.inline_forms.fences" by="actors.author">
<should>fence code with three backticks, and use `~~~` only for a fence inside a fenced example whose own fence uses backticks</should>
</rule>
