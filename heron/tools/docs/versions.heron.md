# Versions {#versions}

<rule id="working_build" refs="system.docs_generator">
<must>write `heron generate docs` into `.heron/docs/` under the working directory, with `versions.json` listing the released builds under `.heron/docs/v/<version>/`</must>
</rule>

<rule id="version_switch" refs="system.docs_generator">
<where>`versions.json` lists a released build</where>
<must>offer it in the top bar's version switch, which opens the same page in that build</must>
</rule>

<rule id="released_builds" refs="system.docs_generator">
<when>a version is released</when>
<must>write that version's build under `.heron/docs/v/<version>/`</must>
</rule>
