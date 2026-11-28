# Server {#server}

What `heron serve` serves on one address: the frontend, the spec browser, the editor's
language server socket and the API.

## Serving {#serving}

| Path              | Serves                                                                   |
| ----------------- | ------------------------------------------------------------------------ |
| `/api/v1/…`       | [the server API](#tools.server_api.spec_server)                         |
| `/api/v1/lsp`     | the language server, over a websocket                                    |
| `/docs/…`         | the spec browser: the docs site of the tree, rendered live               |
| `/docs/_assets/…` | the docs' stylesheet and script, which style a preview in any client     |
| `/agents/…`       | the [agent export](#tools.docs.agents.agent_export) of the tree, rendered live                  |
| anything else     | the frontend, with `index.html` for every path it has no file for        |

The API is JSON over HTTP: each request and response body is one JSON object, a stream is
server-sent events with one JSON object per `data:` line, and the language server speaks
JSON-RPC over the websocket; no op of the server reads or writes CBOR.

<rule id="address" refs="system.server">
<must>listen on `--addr`, `127.0.0.1:7340` unless given, where port 0 picks a free one, serve the tree of the [entry point](#language.core_format.files.entry_point) given as the argument, a file or a folder with an index.heron (`.` unless given), and print the address as `http://<addr>/`</must>
<while>the [entry point](#language.core_format.files.entry_point) exists and the address can be listened on</while>
</rule>

<rule id="spa_fallback" refs="system.server">
<must>serve the files of the frontend, and `index.html` for any other path outside `/api/`, `/docs/` and `/agents/`</must>
<then>the app's own routes load from a deep link</then>
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
<where>a request for a file of the frontend or of `/docs/_assets/` accepts gzip</where>
<must>answer it gzip-compressed, from the file's `.gz` sibling, compressed ahead of time, where one exists, with `Content-Encoding: gzip` and `Vary: Accept-Encoding`</must>
</rule>

<rule id="loopback_default" refs="system.server">
<must>listen on the loopback address unless `--addr` names another, and authenticate no request: whoever reaches the address reads and writes the workspace</must>
<then>a server stays private to its machine unless someone binds it elsewhere on purpose</then>
</rule>

<rule id="non_loopback_warning" refs="system.server">
<when>`--addr` names an address other than a loopback one</when>
<must>print a warning to standard error that the server has no authentication and anyone who reaches the address can change the workspace</must>
</rule>

<rule id="same_origin" refs="system.server">
<if>a request under `/api/` carries an `Origin` other than the server's own and the ones `--allow-origin` names</if>
<must>refuse it with origin not allowed, the upgrade to a websocket included</must>
<then>a web page of another site can't drive a server on the reader's machine</then>
</rule>

<rule id="allowed_origins" refs="system.server">
<when>a request comes from an origin `--allow-origin` names, which may be given more than once</when>
<must>answer it and its preflight with `Access-Control-Allow-Origin` set to that origin, the methods and headers the API uses, and `Access-Control-Allow-Private-Network: true` where the preflight asks for private network access</must>
<then>a client served from elsewhere, as vscode.dev is, can reach a server on localhost once its origin is allowed</then>
</rule>

<rule id="spec_browser" refs="system.server">
<must>serve the docs site of the served tree under `/docs/`, rendered from the session's latest check by the same renderer as `heron generate docs`, with its assets under `/docs/_assets/`</must>
<then>what people read and what they edit never look different</then>
</rule>

<rule id="agent_export_served" refs="system.server">
<must>serve the [agent export](#tools.docs.agents.agent_export) of the served tree under `/agents/`, rendered from the session's latest check as `heron generate agents` writes it, each file as `text/markdown` or `text/plain` for `llms.txt`, with `/agents/` itself serving its [agent index](#tools.docs.agents.agent_index)</must>
<then>an agent next to a running server reads the spec being edited, as it stands</then>
</rule>

<rule id="docs_caching" refs="system.server">
<must>serve a docs asset requested with its content's version as immutable, and pages, `data.js` and assets requested without a version with an entity tag of their content, answering 304 when the request's `If-None-Match` matches it</must>
<then>a reader's browser keeps the theme between pages and refetches a page only when it changed</then>
</rule>

<rule id="lsp_socket" refs="system.server">
<must>upgrade `/api/v1/lsp` to a websocket and run one [language server session](#tools.lsp.session.lsp_session) over it, one JSON-RPC message per frame, rooted at the workspace, until either side closes</must>
<while>the shell has a language server</while>
</rule>

<rule id="lsp_socket_otherwise" refs="system.server">
<if>the shell has no language server</if>
<must>answer the upgrade with no language server</must>
</rule>

<rule id="one_session_per_socket" refs="system.server">
<mustNot>share a session's documents between two sockets</mustNot>
</rule>

## Ops {#ops}

What the ops of [the server API](#tools.server_api.spec_server) do beyond what their pages say.

<rule id="path_in_workspace" refs="system.server">
<must>take every file path as relative to the workspace's folder, with slashes, and refuse a path that is absolute or leaves it with not in workspace</must>
</rule>

<rule id="file_listing" refs="system.server">
<must>answer `list_files` with every file and folder under the folder asked for, the workspace's when none is, whether the tree reaches it or not, leaving out `.git` and `.heron`, each with its size, its modification time and whether the tree reaches it</must>
<then>a client shows a README, a configuration file or a file not yet included as any editor's file tree would</then>
</rule>

<rule id="file_versions" refs="system.server">
<must>answer `read_file`, `write_file`, `rename_file` and `make_dir` with the file's size, modification time and an entity tag that changes whenever its content does</must>
</rule>

<rule id="conditional_write" refs="system.server">
<if>a `write_file` names an `if_match` that isn't the file's current entity tag, or is empty while the file exists</if>
<must>leave the file as it is and answer file changed</must>
<then>a client never overwrites a change someone else made since it read the file</then>
</rule>

<rule id="file_changes" refs="system.server">
<must>delete a file or an empty folder with `delete_file`, move one with `rename_file`, refusing a target that exists with file exists, create a folder and its parents with `make_dir`, and answer no such file for a path that doesn't exist</must>
</rule>

<rule id="binary_content" refs="system.server">
<must>read a file as base64 when `read_file` asks for `encoding = "base64"` or its content isn't valid UTF-8, saying which in `encoding`, and write a `write_file`'s text as base64 when its `encoding` is `base64`</must>
<then>a client opens and saves images and other binary files through the same ops as text</then>
</rule>

<rule id="workspace_events" refs="system.server">
<must>open the stream of `watch` with a `ready` event once the server watches, then send, while the client listens, a `file` event for each file of the workspace that is created, changed or removed, by the server or anyone else, within two seconds, a `problems` event whenever a file of the tree changes, and a `results` event when a run records a result</must>
<then>a client refreshes its file tree, its open files, its problems and its gutter when they change, without polling</then>
</rule>

<rule id="std_sources" refs="system.server">
<must>list the standard packages' files with `std_files`, as `std/doc/package.heron`, and answer `std_source` with one's text, read-only</must>
</rule>

<rule id="preview_position" refs="system.server">
<must>read a `preview`'s cursor from its `position`, a 0-based line and a 0-based character offset in UTF-16 code units as the language server protocol counts, and from its `offset`, a 0-based offset in bytes of the UTF-8 text, only when it has no position</must>
</rule>

<rule id="preview_styling" refs="system.server">
<must>render a `preview`'s HTML with the markup of the docs' pages, styled by the docs' stylesheet, which the server serves at `/docs/_assets/docs.css`</must>
<then>any client styles a preview by loading that stylesheet beside it</then>
</rule>

<rule id="client_state" refs="system.server">
<mustNot>keep a client's settings or state, such as its open files, its layout or its theme</mustNot>
<instead>leave them to the client, which keeps them where it runs, because one server serves every client of the workspace and each person's state belongs to them and their device</instead>
</rule>

<rule id="unsaved_texts" refs="system.server">
<must>check `problems`, `outline`, `preview` and `generated` with the request's unsaved texts as overlays, through the workspace's one check session</must>
<then>the editor sees its unsaved state, and unchanged files and nodes are served from the memo</then>
</rule>

<rule id="task_runs" refs="system.server">
<must>stream a task's run from `run_task` as server-sent events, one JSON event per `data:` line, ending with its result</must>
<while>the task is idle</while>
</rule>

<rule id="task_runs_otherwise" refs="system.server">
<if>the task is already running</if>
<must>answer 409 "{path} is already running"</must>
</rule>

<rule id="agent_export_op" refs="system.server">
<must>answer `agent_export` with every file of the tree's [agent export](#tools.docs.agents.agent_export), its path and its text, in the order of its [agent index](#tools.docs.agents.agent_index)'s map after the index and `llms.txt`, or with the one file its `path` names, and with no such file when the export has no file at that path</must>
</rule>

<rule id="run_results" refs="system.server">
<must>answer `results` with each task's last run under the path, from the run records</must>
</rule>

## API {#api}

The server's API is a spec like any other: [`spec_server`](#tools.server_api.spec_server), with its types and its
errors beside it, in a folder that checks on its own. The server's handlers and every client
are generated from it.

<rule id="api_only" refs="system.frontend">
<must>send every request the frontend makes to the server through the client generated from `spec_server`, the language server's socket included, with no request to a path the API doesn't declare</must>
<then>the frontend is one client of the published API among others, and anything it needs is an API change first</then>
</rule>

<rule id="api_static_paths" refs="system.frontend">
<may>load the docs' assets under `/docs/_assets/` and the pages under `/docs/`, which the serving [table](#heron.language.markup.components.table) lists</may>
</rule>
