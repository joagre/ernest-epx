# Epx

An Ernest library over [epx](https://github.com/tonyrog/epx), the pixel library for Erlang, at https://github.com/joagre/ernest-epx: a 2-D library of pixmaps and their pixels, with a window that shows a pixmap on the screen and takes nothing back from it: nothing of epx's events. It is a library and not a program: a program adds it to its load path, as *Using it* says.

Its modules are `Epx`, over pixmaps and the drawing functions, `Epx.Gc`, over the graphics context they draw with, and `Epx.Window`, over the window that shows a pixmap, whose pages are [`docs/man/epx.md`](docs/man/epx.md), [`docs/man/epx/gc.md`](docs/man/epx/gc.md) and [`docs/man/epx/window.md`](docs/man/epx/window.md), which `make man` writes and a release commits. `main` is 0.2.0, ahead of the 0.1.0 released; [`docs/plan.md`](docs/plan.md) says where it stands.

![Five pictures the examples draw: Whitted's glass and mirror spheres, the Boing ball above a mirror floor, a clock face, the Mandelbrot set, and the Sierpinski gasket](assets/collage.png)

The five pictures are what [`examples/`](examples/README.md) draws, each a program of a page or two; [`assets/README.md`](assets/README.md) says how a picture is made from a program's output.

## Using it

A program outside this repository puts the library's build on its load path when it is compiled and when it is run, and the `ebin`s of epx and of tree_db, which epx's application depends on, when it is run, `<repo>` standing for this repository's path once `make` has built it:

```
ern build --load-path <repo>/build main.ern
ern run --load-path <repo>/build --libs-dir <repo>/lib main.erc
```

The archive `make release` writes, built on Linux x86-64 with the NIF compiled there, unpacks to the same layout, `build/` beside `lib/epx/` and `lib/tree_db/`, so that an operator names its directory in place of `<repo>`; it is published beside its tag, https://github.com/joagre/ernest-epx/releases/download/v0.1.0/epx-0.1.0.tar.gz for 0.1.0. A program begun from [`ernest-template`](https://github.com/joagre/ernest-template) that names the archive among its `DEPS` lists both applications among its own `ERL_DEPS` too, `ERL_DEPS = tree_db epx`, submodules under its `erl/`, since its load path reaches no `lib/` inside a dependency.

## Building

It needs [Ernest](https://github.com/joagre/ernest) on your `PATH`, the floor the Makefile names, `ern 0.5`; `make` says so where another floor is found, and where none is. `ERN=path/to/ern make` names another `ern`.

```
make            builds: lib/ filled, epx and then the library compiled
make test       the source's layout, ern format --check, the modules' tests, the documents, and examples/
make release    the archive, build/epx-VERSION.tar.gz
```

Clone with `--recursive`: epx and tree_db are git submodules under `erl/`, which `make lib` builds by their own `make`, its NIF among it, and links under `lib/epx/` and `lib/tree_db/` as `ebin` and `priv`. epx's NIF needs a C compiler and the X11 and xcb headers, and epx's own `make` prints warnings from its C and Erlang sources, which are expected. `make doc` writes the modules' pages under `build/`, `make man` copies them into `docs/man/`, `make format` lays the modules out, and `make clean` removes what the build and `make lib` wrote.

## The documents

- [`docs/design.md`](docs/design.md): how the library is arranged, the normative document of this repository, and the glossary of its names.
- [`docs/plan.md`](docs/plan.md): where the library stands and what comes next.
- [`docs/log.md`](docs/log.md): the dated rationale, never normative.
- [`docs/release.md`](docs/release.md): what a release runs to be ready.
- `docs/proposals/`: what is designed, a directory for each proposal while one is open; none is open.
- `language_feedback.md`, under `docs/` from its first line and absent while it is empty: what writing Ernest felt against the principles, a queue carried to Ernest by copy.
- [`CLAUDE.md`](CLAUDE.md): the working rules.
- [`docs/epx_bugs.md`](docs/epx_bugs.md): the defects found in epx, each a report for its tracker; [`docs/epx_asks.md`](docs/epx_asks.md), cut from it, is what is still asked of epx's author, and goes when nothing is.
- [`THIRD_PARTY_LICENSES`](THIRD_PARTY_LICENSES): epx's license and tree_db's standing, which the release archive carries with their compiled code.
- [`ACKNOWLEDGMENTS.md`](ACKNOWLEDGMENTS.md): the people this library stands on, by name alone.

The tests live in the modules they test, which `make test` runs; `tools/` holds the checker of the documents, and [`examples/`](examples/README.md) programs that use the library, which `make test` builds and runs too.

## License

Epx is released under the Zero-Clause BSD license, 0BSD, the terms in [`LICENSE`](LICENSE). epx itself is under the MIT license, carried with its notice in [`THIRD_PARTY_LICENSES`](THIRD_PARTY_LICENSES).
