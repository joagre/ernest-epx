# Epx

An Ernest library over [epx](https://github.com/tonyrog/epx), the pixel library for Erlang: a 2-D library of pixmaps and their pixels, with a window that shows a pixmap on the screen and takes nothing back from it: nothing of epx's events. Its one module is `Epx`, whose page is [`docs/man/epx.md`](docs/man/epx.md), which `make man` writes and a release commits. It is a library and not a program: a program adds it to its load path, as *Using it* says. Its first cut is written; [`docs/plan.md`](docs/plan.md) says where it stands.

![Three pictures the examples draw: the Sierpinski gasket, the Boing ball above a mirror floor, and the Mandelbrot set](assets/collage.png)

The three pictures are what [`examples/`](examples/README.md) draws, each a program of a page or two; [`assets/README.md`](assets/README.md) says how a picture is made from a program's output.

## Using it

A program outside this repository puts the library's build on its load path when it is compiled and when it is run, and epx's `ebin` when it is run, `<repo>` standing for this repository's path once `make` has built it:

```
ern build --load-path <repo>/build main.ern
ern run --load-path <repo>/build --load-path <repo>/lib/epx/ebin main.erc
```

The archive `make release` writes, built on Linux x86-64 with the NIF compiled there, unpacks to the same layout, `build/` beside `lib/epx/`, so that an operator names its directory in place of `<repo>`. A program begun from [`ernest-template`](https://github.com/joagre/ernest-template) that names the archive among its `DEPS` lists epx among its own `ERL_DEPS` too, a submodule under its `erl/`, since its load path reaches no `lib/` inside a dependency.

## Building

It needs [Ernest](https://github.com/joagre/ernest) on your `PATH`, the floor the Makefile names, `ern 0.4`; `make` says so where another is found, and where none is. `ERN=path/to/ern make` names another `ern`.

```
make            builds: lib/ filled, epx and then the library compiled
make test       the layout, the module's tests, the documents, and examples/
make release    the archive, build/epx-VERSION.tar.gz
```

Clone with `--recursive`: epx is a git submodule under `erl/`, which `make lib` builds by its own `make`, its NIF among it, and links under `lib/epx/` as `ebin` and `priv`. epx's NIF needs a C compiler and the X11 and xcb headers. `make doc` writes the module's page under `build/`, `make man` copies it into `docs/man/`, `make format` lays the modules out, and `make clean` removes what the build and `make lib` wrote.

## The documents

- [`docs/design.md`](docs/design.md): how the library is arranged, the normative document of this repository, and the glossary of its names.
- [`docs/plan.md`](docs/plan.md): where the library stands and what comes next.
- [`docs/log.md`](docs/log.md): the dated rationale, never normative.
- [`docs/release.md`](docs/release.md): what a release runs to be ready.
- [`docs/style.md`](docs/style.md): the rules an Ernest program is written by, Ernest's own, copied and not edited here.
- `docs/proposals/`: what is designed, a directory for each proposal, from the first one on.
- `language_feedback.md`, under `docs/` from its first line: what writing Ernest felt against the principles, a queue carried to Ernest by copy.
- [`CLAUDE.md`](CLAUDE.md): the working rules.
- [`docs/epx_bugs.md`](docs/epx_bugs.md): the defects found in epx, each a report for its tracker.
- [`THIRD_PARTY_LICENSES`](THIRD_PARTY_LICENSES): epx's license, which the release archive carries with epx's compiled code.
- [`ACKNOWLEDGMENTS.md`](ACKNOWLEDGMENTS.md): the people this library stands on, by name alone.

The tests live in the modules they test, which `make test` runs; `tools/` holds the checker of the documents, and [`examples/`](examples/README.md) programs that use the library, which `make test` builds and runs too.

## License

Epx is released under the Zero-Clause BSD license, 0BSD, the terms in [`LICENSE`](LICENSE). epx itself is under the MIT license, carried with its notice in [`THIRD_PARTY_LICENSES`](THIRD_PARTY_LICENSES).
