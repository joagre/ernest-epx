# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Begun from `ernest-template` on 2026-10-20; epx and tree_db build and load, milestone 1's item 2, and nothing of the library is written yet. Next is the library's design, item 1, discussed in a proposal before a function is declared.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|

## Milestone 1: the design

1. **What the library offers**, discussed in a proposal under `docs/proposals/`: which of epx's operations, pixmaps and pixels first, and in what Ernest shape, each a shim where epx's function does exactly its work and Ernest around it where not; then stated in `design.md`.
2. **How epx is found**: decided 2026-10-20 (the log's *epx and tree_db as submodules*). epx and tree_db are read-only git submodules under `erl/`, which `make lib` builds by their own `make` and links as `lib/<app>/ebin` and `priv`, on the load path; a pixmap was made, filled and read through the NIF from a scratch Ernest program. Built into `ernest-template` as its `v0.2.0`.
3. **The first module**, `Epx` with pixmaps, their tests and `make test` green.
