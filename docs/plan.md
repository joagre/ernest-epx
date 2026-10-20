# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

Begun from `ernest-template` on 2026-10-20; epx and tree_db build and load, milestone 1's item 2, and nothing of the library is written yet. Next is the library's design, item 1, discussed in a proposal before a function is declared.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|

## Milestone 1: the design

1. **What the library offers**: decided 2026-10-20, [`proposals/pixmap/proposal.md`](proposals/pixmap/proposal.md), its eight decisions as recommended (the log's *The first cut*): twenty pixmap operations, `Color` one record, `Int` coordinates, no flags, a channel outside its range faulting, the PPM writer the library's, one module `Epx`, and the build an agent's.
2. **How epx is found**: decided 2026-10-20 (the log's *epx and tree_db as submodules*). epx and tree_db are read-only git submodules under `erl/`, which `make lib` builds by their own `make` and links as `lib/<app>/ebin` and `priv`, on the load path; a pixmap was made, filled and read through the NIF from a scratch Ernest program. Built into `ernest-template` as its `v0.2.0`.
3. **The first cut built**: `src/epx.ern` as the proposal's sections 2 to 5 say, its doc blocks as Appendix E.0's shape rule 6 has them, `design.md`'s sections stated from the proposal and each cited by a test, the edges of section 4 tried before the `Errors` sections are written, `examples/mandelbrot.ern` with `examples/README.md`, built and run by `make test`; the doc blocks read back against shape rule 6 before the item closes.
