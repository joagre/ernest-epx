# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The first cut is built, 2026-10-20: `Epx` with twenty operations over epx's pixmaps, its design in `design.md`, and two examples. `sub` and `scroll` of the proposal wait on epx, milestone 2, and the cost of the area operations' clip correction is milestone 2's decision 1. Next is milestone 2.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|

## Milestone 1: the design

1. **What the library offers**: decided 2026-10-20, [`proposals/pixmap/proposal.md`](proposals/pixmap/proposal.md), its eight decisions as recommended (the log's *The first cut*): twenty pixmap operations, `Color` one record, `Int` coordinates, no flags, a channel outside its range faulting, the PPM writer the library's, one module `Epx`, and the build an agent's.
2. **How epx is found**: decided 2026-10-20 (the log's *epx and tree_db as submodules*). epx and tree_db are read-only git submodules under `erl/`, which `make lib` builds by their own `make` and links as `lib/<app>/ebin` and `priv`, on the load path; a pixmap was made, filled and read through the NIF from a scratch Ernest program. Built into `ernest-template` as its `v0.2.0`.
3. **The first cut built**, 2026-10-20 (the log's *The first cut built*): `src/epx.ern`, `design.md` cited by its tests, the edges tried first and recorded in `epx_bugs.md`, `examples/mandelbrot.ern` and `examples/sierpinski.ern` with their README, built and run by `make test`; the doc blocks read back against shape rule 6. `sub` and `scroll` left out, milestone 2.

## Milestone 2: what epx must fix first, and the next cut

1. **The clip correction's cost**, a decision for the user: the five area operations read the source's clip before each call, which puts each pixel where the design says, where epx would misplace a rectangle that begins outside the clip (`epx_bugs.md` 6), and which about doubles a small area operation's cost, 96 to 253 ms for 200,000 one-pixel copies. Recommended: kept until epx fixes `epx_clip_both`, then removed, the cost standing in the log meanwhile.
2. **The reports of `epx_bugs.md` filed with epx**, by the user, and the submodule moved to a release that has the fixes.
3. **`sub` and `scroll`**, once epx's fixes 1 to 3 are in the submodule, as the proposal's section 2 has them, `scroll`'s `rotate` a type of two named constructors (shape rule 9).
4. **The next cut**: the drawing functions with the graphics context, `Epx.Gc`, as the proposal's section 2 leaves them, designed in a proposal of their own.
