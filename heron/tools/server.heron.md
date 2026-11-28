# Server {#server}

What `heron serve` serves on one address: the spec browser, the [agent export](#tools.docs.agents.agent_export) and the API,
whose one op returns that export as JSON.

## Serving {#serving}

| Path              | Serves                                                                   |
| ----------------- | ------------------------------------------------------------------------ |
| `/api/v1/…`       | [the server API](#tools.server_api.spec_server)                         |
| `/docs/…`         | the spec browser: the docs site of the tree, rendered live               |
| `/docs/_assets/…` | the docs' stylesheet and script                                          |
| `/agents/…`       | the [agent export](#tools.docs.agents.agent_export) of the tree, rendered live                  |
| `/`               | a redirect to `/docs/`                                                   |

The API is JSON over HTTP: each request and response body is one JSON object; no op of the
server reads or writes CBOR.

<rule id="address" refs="system.server">
<must>listen on `--addr`, `127.0.0.1:7340` unless given, where port 0 picks a free one, serve the tree of the [entry point](#language.core_format.files.entry_point) given as the argument, a file or a folder with an index.heron (`.` unless given), and print the address as `http://<addr>/`</must>
<while>the [entry point](#language.core_format.files.entry_point) exists and the address can be listened on</while>
</rule>

<rule id="root_redirect" refs="system.server">
<must>redirect `/` to `/docs/`, and answer not found for any other path outside `/api/`, `/docs/` and `/agents/`</must>
<then>the printed address opens the spec browser</then>
</rule>

<rule id="unknown_op" refs="system.server">
<if>a request under `/api/` matches no op</if>
<must>answer it with no op</must>
<then>the server routes only the ops the API declares</then>
</rule>

<rule id="json_wire" refs="system.server">
<must>read and write every op's request and response body as JSON, with `Content-Type: application/json`, and an error as `{"error": message, "code": id}` with the error's HTTP status</must>
</rule>

<rule id="compressed_assets" refs="system.server">
<while>a request for a file of `/docs/_assets/` accepts gzip</while>
<must>answer it gzip-compressed, with `Content-Encoding: gzip` and `Vary: Accept-Encoding`</must>
</rule>

<rule id="loopback_default" refs="system.server">
<must>listen on the loopback address unless `--addr` names another, and authenticate no request: whoever reaches the address reads the workspace</must>
<then>a server stays private to its machine unless someone binds it elsewhere on purpose</then>
</rule>

<rule id="non_loopback_warning" refs="system.server">
<when>`--addr` names an address other than a loopback one</when>
<must>print a warning to standard error that the server has no authentication and anyone who reaches the address can read the workspace</must>
</rule>

<rule id="same_origin" refs="system.server">
<if>a request under `/api/` carries an `Origin` other than the server's own</if>
<must>refuse it with origin not allowed</must>
<then>a web page of another site can't drive a server on the reader's machine</then>
</rule>

<rule id="spec_browser" refs="system.server">
<must>serve the docs site of the served tree under `/docs/`, rendered from the session's latest check by the same renderer as `heron generate docs`, with its assets under `/docs/_assets/`</must>
<then>a reload of a page shows the tree as it stands on disk, and what people read and what they edit never look different</then>
</rule>

<rule id="agent_export_served" refs="system.server">
<must>serve the [agent export](#tools.docs.agents.agent_export) of the served tree under `/agents/`, rendered from the session's latest check as `heron generate agents` writes it, each file as `text/markdown` or `text/plain` for `llms.txt`, with `/agents/` itself serving its [agent index](#tools.docs.agents.agent_index)</must>
<then>an agent next to a running server reads the spec being edited, as it stands</then>
</rule>

<rule id="docs_caching" refs="system.server">
<must>serve a docs asset requested with its content's version as immutable, and pages, `data.js` and assets requested without a version with an entity tag of their content, answering 304 when the request's `If-None-Match` matches it</must>
<then>a reader's browser keeps the theme between pages and refetches a page only when it changed</then>
</rule>

## Ops {#ops}

What the server does for the op of [the server API](#tools.server_api.spec_server) beyond what its page says.

<rule id="client_state" refs="system.server">
<must_not>keep a client's settings or state, such as its open files, its layout or its theme</must_not>
<instead>leave them to the client, which keeps them where it runs, because one server serves every client of the workspace and each person's state belongs to them and their device</instead>
</rule>

<rule id="agent_export_op" refs="system.server">
<must>answer `agent_export` with every file of the tree's [agent export](#tools.docs.agents.agent_export), its path and its text, in the order of its [agent index](#tools.docs.agents.agent_index)'s map after the index and `llms.txt`, or with the one file its `path` names, and with no such file when the export has no file at that path</must>
</rule>

## API {#api}

The server's API is a spec like any other: [`spec_server`](#tools.server_api.spec_server), with its types and its
errors beside it, in a folder that checks on its own. The server's handlers are generated
from it.
