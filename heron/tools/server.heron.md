# Server {#server}

What `heron serve` serves on one address: the frontend, the spec browser, the editor's
language server socket and the API, with the ops extensions declare mounted beside the
base ones.

## Serving {#serving}

| Path            | Serves                                                             |
| --------------- | ------------------------------------------------------------------ |
| `/api/v1/…`     | the base API and every mounted extension's ops                     |
| `/api/v1/lsp`   | the language server, over a websocket                              |
| `/docs/…`       | the spec browser: the docs site of the tree, rendered live         |
| anything else   | the frontend, with `index.html` for every path it has no file for  |

<rule id="address" targets="tools.server.serving" by="system.server">
<must>listen on `--addr`, `127.0.0.1:7340` unless given, where port 0 picks a free one, serve the tree of the [entry point](#language.core_format.files.entry_point) given as the argument, a file or a folder with an index.heron (`.` unless given), and print the address as `http://<addr>/`</must>
<while>it's not the case that there's no [entry point](#language.core_format.files.entry_point), which exits 2, or the address can't be listened on, which exits 1</while>
</rule>

<rule id="spa_fallback" targets="tools.server.serving" by="system.server">
<must>serve the files of the frontend, and `index.html` for any other path outside `/api/` and `/docs/`</must>
<then>the app's own routes load from a deep link</then>
</rule>

<rule id="unknown_op" targets="tools.server.serving" by="system.server">
<if>a request under `/api/` matches no op</if>
<must>answer 404 with `{"error": "no op at ‹method› ‹path›"}`</must>
</rule>

<rule id="spec_browser" targets="tools.server.serving" by="system.server">
<must>serve the docs site of the served tree under `/docs/`, rendered from the session's latest check by the same renderer as `heron generate docs`, with its assets under `/docs/_assets/`</must>
<then>what people read and what they edit never look different</then>
</rule>

<rule id="lsp_socket" targets="tools.server.serving" by="system.server">
<must>upgrade `/api/v1/lsp` to a websocket and run one [language server session](#tools.lsp.session.lsp_session) over it, one JSON-RPC message per frame, rooted at the workspace, until either side closes</must>
<while>it's not the case that the shell has no language server, which answers 503 "no language server is installed"</while>
</rule>

<rule id="one_session_per_socket" targets="tools.server.serving" by="system.server">
<mustNot>share a session's documents between two sockets</mustNot>
</rule>

## Extension point {#extension_point}

Server routes are an [extension point](#language.interop.declaring.extension_point): an extension declares its ops on `spec_server` in its
own [Heron files](#language.core_format.files.heron_file), their routes and client are generated from them, and the
extension [mounts](#language.core_format.mounts.mount) them. The shell itself doesn't change.

<rule id="mount_routes" targets="tools.server.extension_point" by="system.server">
<when>a tree [mounts](#language.core_format.mounts.mount) an extension with its generated routes and result providers</when>
<must>serve its routes beside the base API's, and add its providers' results to `results`</must>
</rule>

<rule id="route_clash" targets="tools.server.extension_point" by="system.server">
<if>two extensions, or an extension and the base API, [mount](#language.core_format.mounts.mount) one method and path</if>
<must>fail the [mount](#language.core_format.mounts.mount) with `server: ‹name› mounts ‹pattern›, which is already mounted`</must>
</rule>

## Ops {#ops}

The base API's ops, beyond the four of [the base API](#tools.server.api.base_api), are the editor's, [added the way an extension adds its own](#tools.server.api).

<rule id="path_in_workspace" targets="tools.server.ops" by="system.server">
<must>take every file path as relative to the workspace's folder, with slashes, and refuse a path that leaves it with 400 "‹path› is not a path in the workspace"</must>
</rule>

<rule id="unsaved_texts" targets="tools.server.ops" by="system.server">
<must>check `problems`, `outline`, `preview` and `generated` with the request's unsaved texts as overlays, through the workspace's one check session</must>
<then>the editor sees its unsaved state, and unchanged files and nodes are served from the memo</then>
</rule>

<rule id="task_runs" targets="tools.server.ops" by="system.server">
<must>stream a task's run from `run_task` as server-sent events, one JSON event per `data:` line, ending with its result</must>
<while>it's not the case that the task is already running, which answers 409 "‹path› is already running"</while>
</rule>

<rule id="run_results" targets="tools.server.ops" by="system.server">
<must>answer `results` with each task's last run under the path, from the run records, and every mounted provider's results</must>
</rule>

## API {#api}

The server's API is a spec like any other: `spec_server`, with its types beside it and
the editor's ops entered from another file the way an extension adds its own.

| Op          | Method and path            | Answers                                            |
| ----------- | -------------------------- | -------------------------------------------------- |
| `preview`   | `POST /api/v1/preview`     | a node or a file rendered as the docs render it    |
| `results`   | `GET /api/v1/results`      | the latest results of the nodes under a path       |
| `get_record`| `GET /api/v1/records/:id`  | one run record, or 404                             |
| `lsp`       | `/api/v1/lsp`, a websocket | the language server                                |
| `workspace` | `GET /api/v1/workspace`    | the [entry point](#language.core_format.files.entry_point), its files and its branch |
| `read_file` | `GET /api/v1/file`         | a file's text, or 404                              |
| `write_file`| `POST /api/v1/file`        | saves a file                                       |
| `problems`  | `POST /api/v1/problems`    | every diagnostic of the tree, with its source      |
| `run_task`  | `POST /api/v1/run`         | a task's run, streamed                             |
| `outline`   | `POST /api/v1/outline`     | a file's nodes, which of them run, and their lines |
| `generated` | `POST /api/v1/generated`   | the files generation would write                   |

<example id="base_api">
```heron
import = ["std/types@1", "std/http@1", "std/ws@1"]

@http(base_path = "/api/v1")
spec_server: api {
  @http<post>("/preview")
  preview(@body request: PreviewRequest): op(Preview)

  @http<get>("/results")
  results(@query path: String): op(NodeResults)

  @http<get>("/records/:id")
  get_record(@path id: String): op(Record)

  // The language server, for Monaco and the preview.
  @ws("/lsp")
  lsp(messages: Stream(LspMessage)): op(Stream(LspMessage))
}
```
</example>
