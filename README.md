# Epx

An Ernest library over [epx](https://github.com/tonyrog/epx), the pixel library for Erlang: pixmaps and their pixels, drawing into them, and the windows and the events of a backend. It is a library and not a program: a program adds it to its load path, as `make lib` of a repository begun from [`ernest-template`](https://github.com/joagre/ernest-template) does. It is not written yet; [`docs/plan.md`](docs/plan.md) says where it stands.

## Building

It needs [Ernest](https://github.com/joagre/ernest) on your `PATH`, the floor the Makefile names, `ern 0.4`; `make` says so where another is found. `ERN=path/to/ern make` names another `ern`.

```
make            builds: lib/ filled, each dependency and then the program compiled
make test       the layout, every module's tests, the documents, and test/ where it exists
make release    the archive, build/epx-VERSION.tar.gz, which a program names as a dependency
```

`make lib` fills `lib/` with Ernest's own libraries the Makefile's `LIBS` names, linked from the installation, and each dependency `DEPS` names by the URL of its release archive, fetched and unpacked once. Everything the library loads beyond the standard library stands under `lib/<name>/build`, which is the whole load path. How epx itself, Erlang with a NIF, is found is the first milestone's decision. `make doc` writes each module's documentation under `build/`, `make format` lays the modules out, and `make clean` removes what the build and `make lib` wrote.

## The documents

- [`docs/design.md`](docs/design.md): how the program is arranged, the normative document of this repository, and the glossary of its names.
- [`docs/plan.md`](docs/plan.md): where the program stands and what comes next.
- [`docs/log.md`](docs/log.md): the dated rationale, never normative.
- [`docs/release.md`](docs/release.md): what a release runs to be ready.
- [`docs/style.md`](docs/style.md): the rules an Ernest program is written by, Ernest's own, copied and not edited here.
- `docs/proposals/`: what is designed, a directory for each proposal, from the first one on.
- `language_feedback.md`, from its first line: what writing Ernest felt against the principles, carried to Ernest by copy.
- [`CLAUDE.md`](CLAUDE.md): the working rules.

The tests live in the modules they test, which `make test` runs; `tools/` holds the checker of the documents, which `make test` runs too.
