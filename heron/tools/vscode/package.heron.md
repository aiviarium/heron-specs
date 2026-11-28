# Package {#package}

<rule id="one_bundle" refs="system.editor_extension">
<must>build the extension with esbuild into one bundle for the desktop and one for the browser, and package it as one `.vsix` file with the grammars, the language configuration and a README of its install, settings and features</must>
</rule>

<rule id="not_published" refs="actors.implementer">
<mustNot>publish the extension to a marketplace from the build</mustNot>
<instead>leave the `.vsix` as the build's output, and publishing to whoever owns the product</instead>
</rule>
