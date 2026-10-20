# Epx

An Ernest library over [epx](https://github.com/tonyrog/epx), the pixel library for Erlang: a 2-D library of pixmaps and their pixels, and nothing of epx's windows and events. It is a library and not a program: a program adds it to its load path, as `make lib` of a repository begun from [`ernest-template`](https://github.com/joagre/ernest-template) does. Its first cut is written, the module `Epx`; [`docs/plan.md`](docs/plan.md) says where it stands.

## Building

It needs [Ernest](https://github.com/joagre/ernest) on your `PATH`, the floor the Makefile names, `ern 0.4`; `make` says so where another is found. `ERN=path/to/ern make` names another `ern`.

```
make            builds: lib/ filled, each dependency and then the program compiled
make test       the layout, every module's tests, the documents, test/ where it exists, and examples/
make release    the archive, build/epx-VERSION.tar.gz, which a program names as a dependency
```

Clone with `--recursive`: epx and tree_db are git submodules under `erl/`, which `make lib` builds by their own `make`, epx's NIF among them, and links under `lib/` as `ebin` and `priv`; everything the library loads beyond the standard library stands under `lib/`, which is the whole load path. epx's NIF needs a C compiler and the X11 and xcb headers. `make doc` writes each module's documentation under `build/`, `make format` lays the modules out, and `make clean` removes what the build and `make lib` wrote.

## The documents

- [`docs/design.md`](docs/design.md): how the program is arranged, the normative document of this repository, and the glossary of its names.
- [`docs/plan.md`](docs/plan.md): where the program stands and what comes next.
- [`docs/log.md`](docs/log.md): the dated rationale, never normative.
- [`docs/release.md`](docs/release.md): what a release runs to be ready.
- [`docs/style.md`](docs/style.md): the rules an Ernest program is written by, Ernest's own, copied and not edited here.
- `docs/proposals/`: what is designed, a directory for each proposal, from the first one on.
- [`docs/language_feedback.md`](docs/language_feedback.md): what writing Ernest felt against the principles, carried to Ernest by copy.
- [`CLAUDE.md`](CLAUDE.md): the working rules.
- [`docs/epx_bugs.md`](docs/epx_bugs.md): the defects found in epx, each a report for its tracker.
- [`ACKNOWLEDGMENTS.md`](ACKNOWLEDGMENTS.md): the people this library stands on, by name alone.

The tests live in the modules they test, which `make test` runs; `tools/` holds the checker of the documents, and [`examples/`](examples/README.md) programs that use the library, which `make test` builds and runs too.
