# Style

The rules an Ernest program is written by, cut without change from Ernest's `docs/style.md` as of Ernest 0.4.0 (`git` tag `v0.4.0`), its sections *Every language*, *Ernest* and the glossary's *Ernest* part. No application edits this file: a change is made in Ernest's and copied again, and an application's own names go in `docs/design.md`'s glossary. A rule marked *(tested)* is held by a test of Ernest's repository, and here by the reader.

## Every language

- A step of indentation is four spaces.
- No file holds a tab, but a Makefile *(tested)*.
- A line of code is at most 100 characters; prose in markdown may be longer *(tested)*.
- A name in a namespace shared with other code carries the repository's name: an Erlang module begins `ern` *(tested)*, an Emacs Lisp symbol `ernest-`.
- The spelling is American English, in prose, names and messages alike: `color`, `behavior`, `initialize`, `utilization`, `catalog`, `license`, `gray`, `center`. A name of the host's or of another system's keeps its own, `-behaviour`, `LICENSE`, `prefers-color-scheme`, and a quotation its author's. The test reads every tracked file of text but a proposal under `docs/proposals/`, a vendored file, `THIRD_PARTY_LICENSES` and `LICENSE` *(tested)*.

### Names

Code is read more often than written, mostly by someone else, so a name is written for that reader. These rules cover a variable, a parameter, a function, an Erlang record and its fields, and an Ernest type, constructor and field. Longer names make longer code, and that is accepted.

- **A name says what its value is or what its function does**, in the words of the domain: `Tokens`, `Descriptor`, `Namespace`, `parse_module`; not what the value is made of, `List`, `Map`, where that is not what it is.
- **One concept, one name, in every module**: a type's descriptor is `Descriptor` in the emitter, the boundary and the runtime alike, and two concepts never share a name. A concept the report names takes the report's name; where the code names one otherwise, or the report's name seems wrong for the code, the question goes to the user before anything is renamed. A value changing through a function is numbered, `Env1`, `Env2`, and a numbered name is nothing else; past two steps the function is split.
- **No abbreviation a reader must guess.** A well-known acronym is fine, `TCP`, `URL`, `UTF-8`, `JSON`, and so is an abbreviation the host or the report writes: `Pid`, `Ref`, `Fd`, and `Acc` for what a fold carries.
- **One letter only where the whole scope is one line that shows what it is**, as a comprehension's element or a one-line fun's parameter: `[size(Module) || Module <- Modules]`, not `[size(M) || M <- Ms]`, wherever the line does not show it.
- **A function that does something is a verb**, `compile`; one that gives a value is that value, a noun or, for the value made so, a past participle, `descriptor`, `armed`, `held`; a yes-or-no reads as the question, `is_link`, `isEmpty`.
- **A record, a type or a constructor names what it holds**, a type as a noun: `#emit_context{}`, not `#cx{}`; `Key(Terminal.Event)`, not `K`.
- **A name the report states** changes only through the report.

### Structure

- **A function reads on one screen**; a longer one is split into steps whose names say what they do.
- **How deep code nests is the writer's judgment**, bounded by the line: a construct that no longer reads within 100 characters becomes a function.
- **A module has one job**, which its first comment states.
- **A comment says why and cites the report section the code implements**, `%% Report §8.4: ...`, `// Report §11.2: ...`; the names say what it does.

## Ernest

For every Ernest source and every Ernest block of the report and the guide. The layout `ern format` writes, and what else it keeps and changes, is report §11.6's: `make test` holds every source to it, `make format` restores it, and the Emacs mode indents as it does ([`design/emacs_mode.md`](design/emacs_mode.md)). The writer decides the rest:

- **Top-down**: types, then the module's service bindings, then `main` or the exported functions, each followed directly by its helpers; a helper several share goes with its first user or in a utilities section at the bottom.
- **A block holds more than one statement**; one expression is written bare *(tested)*.
- **A blank line groups**, where the writer chooses. A declaration's comment or doc block stands directly above it.
- **Name a part of a long expression** where the formatter's split reads worse than a name.
- **A section's banner** is a line `//`, lines `// text`, and a line `//`, with a blank line before and after. A module with a doc block has no banner for the file; its `///` block is its header (report §2.2).
- **An exported function's parameters are named for their role**, since the shell and `ern doc` show the signature: `List.filter(list, keep)`; `xs` and `f` only where nothing more can be said.
- **A message type's constructors**: a request in the imperative, `Subscribe`; an event in the past tense, `Resized`.
- **A module of two words or more is a file of those words joined by `_`** (report §4.2): `kv_parser.ern` for `KvParser`, not `kvparser.ern`, which is the one word `Kvparser`.

Code in that layout:

    fn start(keys : Optional(Keys)) : Unit = {
        let reader = spawn(fn() = match keys {
            Some(k) -> readLoop(k)
          | None -> plainLoop()
        });
        loop(reader)
    }

    fn respond(request : Request,
               session : SessionId,
               cookies : List(Cookie),
               body : String,
               status : Int) : Bytes =
        Response(status = status, headers = [], body = body)
            |> withCookie("sid", sessionIdText(session))
            |> render

## Glossary

The names that recur across modules, one for each concept, in every module. The report is the authority: a concept it names takes its name. A name not here is the writer's, under the rules above.

**Ernest**

- A function's **subject** is named for its type, `list`, `text`, `map`, `set`, `bytes`, `path`, `table`, `process`. Not `xs`, `s`, `m`, `b`, `r`, `t`, `p`.
- A **callback** is named for its role: `keep` for a predicate that keeps, `test` for one asked of each element, as `any`, `all`, `find`, `span` and `partition` ask it, `step` for a fold's or a try's (E.0 rule 2), `wrap` for what delivers a message (E.0 shape rule 8); `f` only where nothing more can be said. Not `p`, `g`.
- **acc**: what a fold or a recursion carries. Not `done`.
- **reply**: a `Reply`. Not `r`.
- **index**: a position in a sequence (E.2, E.5); a place in a file is an `offset` (E.17). Not `at`, `i`, `from`, `start`.
- **end**: the index a slice stops before, which it leaves out, `String.slice(text, index, end)` (E.5, E.20). Not `to`, `stop`.
- **count**: how many. Not `n`, `length`.
- **ms**: milliseconds (E.23); a moment is a `time`. Not `wait`, `t`.
- **old, new**: what `replace` takes, in every module. Not `from`, `to`.
- **cause**: as above. Not `why`, `c`, `text`.
- **error**: an error a function answers, an `Io.Error` among them. Not `e`, `why`.
- **user**: the host's number for a user, the one a file belongs to, an `Fs.Entry`'s `user`, and the one the program runs as, `Os.user` (E.17, E.23). Not `owner`, which is a resource's process, nor `uid`.
- **char**: a `Char`. Not `c`, `ch`.
- **cursor**: the place in the line being typed, in the shell's editor, region and completion. Not `at`.
- **serial**: the number the shell gives an input, which its outcome carries, `Serial` in the Erlang. Not `run`, `n`.
- A **request** constructor is the function it serves, `Read` for `read`, and where that is a prelude name, what it asks for, `ListEntries` for `list`; an **event** is in the past tense, `Resized`. Not `Recv`, `Measure`, `FarEnd`, `Resize`.
- A prelude name, `Down`, `answer`, `kill`, is not bound to another concept.
