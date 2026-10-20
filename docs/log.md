# Decisions

The dated rationale for the design and the plan, newest last, and what was rejected. Never normative: the design says what the program is, and the plan what is built when. An entry says what was decided, the principle of the report's §0 that decided it, and what would change it.

## Begun from the template

*2026-10-20.* The repository was begun from `ernest-template` at its tag `v0.1.0`, whose `CLAUDE.md`, `docs/style.md` and `tools/docs.ern` are refreshed from there and not edited here. The way of working is the template's; a change to it goes to the template first. The library is the first repository begun from the template, so what the copy teaches about the template goes back to it: the first lesson is that a dependency that is Erlang, epx itself, is not what `make lib` fetches, which the entry below decides.

## epx and tree_db as submodules

*2026-10-20.* epx and tree_db are read-only git submodules under `erl/`, pinned to a commit each, built by their own `make` and linked under `lib/` as `ebin` and `priv`, so that the load path, which `ern run` adds to the host's code path, lets the host find epx's NIF from `priv/` beside `ebin/`. A copy of the trees was rejected: it loses where the code came from and drags epx's C into this repository. A fetch by rebar3 was rejected: epx's build is its own Makefile, its port configuration is rebar2's, its tree_db dependency is unpinned, and rebar3 is not on the machine. Principle 2, one way to bring in Erlang, the host's own, and the template's `lib/` kept as the one place a program loads from. Tried before being written: a pixmap made, filled red and read as `#(255, 255, 0, 0)` from a scratch program. What would change it: a dependency tool of Ernest's, the template's proposal's fourth ask of the language.
