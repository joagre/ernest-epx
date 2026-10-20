# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The first cut is built and released as 0.1.0, 2026-10-20: `Epx` with twenty functions over epx's pixmaps, its design in `design.md`, the manual page under `docs/man/`, and three examples, the ray tracer among them, milestone 4. `sub` and `scroll` wait on epx, milestone 2, and the area functions are epx's exactly.

The second cut is built, 2026-10-20, and the window that shows, 2026-10-21: `Epx.Gc`, five drawing functions, the clock face, `Epx.Screen`, and the word `show` on every example. Whitted's spheres, the slow tracer, is built, 2026-10-21, the fifth example. What is left, in order: the collage of the pictures; what waits on Ernest's MVP 3.28, milestone 6, once the user says it is out; the release 0.2.0, milestone 3b, not before that word; and the last release, milestone 7, with `sub` and `scroll` once epx has its fixes.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| Milestone 1 | the design and the first cut | 2026-10-20 | the log's *epx and tree_db as submodules*, *The first cut*, *The first cut built*, *The clip correction dropped* |
| Milestone 3 | the release 0.1.0 | 2026-10-20 | the log's *The release review* |
| Milestone 4 | the ray tracer | 2026-10-20 | [`proposals/raytracer/`](proposals/raytracer/); the log's *The ray tracer*, *The ray tracer built* |
| Milestone 5 | Whitted's spheres, the slow tracer | 2026-10-21 | [`proposals/whitted/`](proposals/whitted/); the log's *Whitted's spheres decided*, *Cook's Sampling*, *Whitted's spheres built* |
| Milestone 8 | a window that shows, `Epx.Screen` | 2026-10-21 | [`proposals/window/`](proposals/window/); the log's *A Window That Shows*, *The window decided*, *The window built* |

## Milestone 1: the design

1. **What the library offers**: decided 2026-10-20, [`proposals/pixmap/proposal.md`](proposals/pixmap/proposal.md), its eight decisions as recommended (the log's *The first cut*): twenty pixmap operations, `Color` one record, `Int` coordinates, no flags, a channel outside its range faulting, the PPM writer the library's, one module `Epx`, and the build an agent's.
2. **How epx is found**: decided 2026-10-20 (the log's *epx and tree_db as submodules*). epx is a read-only git submodule under `erl/`, which `make lib` builds by its own `make` and links as `lib/epx/ebin` and `priv`, on the load path; tree_db went at the release review, unneeded (the log's *The release review*). Built into `ernest-template` as its `v0.2.0`.
3. **The first cut built**, 2026-10-20 (the log's *The first cut built*): `src/epx.ern`, `design.md` cited by its tests, the edges tried first and recorded in `epx_bugs.md`, `examples/mandelbrot.ern` and `examples/sierpinski.ern` with their README, built and run by `make test`; the doc blocks read back against shape rule 6. `sub` and `scroll` left out, milestone 2.

## Milestone 2: what epx must fix first, and the next cut

1. **The clip correction**: decided 2026-10-20, dropped (the log's *The clip correction dropped*). The five area operations are epx's functions exactly, and a source rectangle that begins outside the source's clip lands as epx lands it, documented in `design.md` §4 and each operation's doc block, until epx fixes `epx_clip_both` (`epx_bugs.md` 6).
2. **The reports of `epx_bugs.md` filed with epx**, by the user, and the submodule moved to a release that has the fixes; and a license asked for tree_db, whose repository states none, since the archive carries its compiled code.
3. **`sub` and `scroll`**, once epx's fixes 1 to 3 are in the submodule, as the proposal's section 2 has them, `scroll`'s `rotate` a type of two named constructors (shape rule 9).
4. **The next cut**: decided 2026-10-20, [`proposals/gc/proposal.md`](proposals/gc/proposal.md), its seven decisions as recommended (the log's *The second cut*), and built the same day (the log's *The second cut built*): `Epx.Gc` with eight keys and `Style`, the type `Epx.Context` in `Epx`, five drawing functions, the border placed inside, and `examples/clock_face.ern`.
7. **The rounded rectangle and the polygon**, once epx has the fixes of `epx_bugs.md` 13 and 14, as `sub` and `scroll` wait on 1 to 3; and the fill of a polygon once report 14's colors are gone. The window's `close` becomes `window_detach` once report 17 is fixed, `Rgba` and `Abgr` are shown once 18 is, and a window's close button closes nothing until Ernest decides how a foreign message is checked (its feedback 137) and epx's 16 is fixed.
8. **A wide line's band**: decided 2026-10-20 with the user, kept. `drawLine` of a width above 1, horizontal or vertical, fills its band through `pixmap_fill_area` in Ernest, since epx's own band writes past the clip and past the pixmap's memory (`epx_bugs.md` 9), at about 2.6 times epx's cost for such a line, 0.17 to 0.45 µs, and no cost for a diagonal or a one-pixel line; a band that writes outside memory is no band, and the cost stands in the log.
5. **What waits on Ernest**: the lines the library carried to Ernest's `language_feedback.md`, 123 to 132, decided in Ernest's plan; when Ernest has 123, a foreign function answering `ok` declared `Unit`, the fourteen dropped answers go, and with 124, a `Test` function for a fault, the tests' own helper.
6. **What waits on the template**: a tool that runs a doc block's `// =>` examples and holds the page to them, which every library wants and which the release review found nothing does here (Ernest's feedback 127).

## Milestone 3b: the release 0.2.0

After the clock face, the window that shows and Whitted's spheres, milestones 8 and 5, the collage, and milestone 6, since the release waits for the user's word that Ernest's MVP 3.28 is out and takes what it brings.

The release as [`release.md`](release.md) says, the two readers over the new pages, `Epx.Gc` and `Epx.Window`, the drawing functions and the examples' windows among them, `make man` with the second page, the tag `v0.2.0` and the archive with `THIRD_PARTY_LICENSES`, its notes naming epx's commit and the platform the NIF was built on. Decided 2026-10-20 with the user.
## Milestone 6: after Ernest's MVP 3.28, the end

When Ernest's MVP 3.28 is released, the parts of the library that wait on it are taken in one item: the fourteen dropped `Foreign.Term` answers become `Unit` declarations, the tests' own fault helper becomes `Test.faults`, the page's `// =>` lines are held by `ern test`, the copy of the style rules goes where Ernest installs them, Ernest's own libraries come off `make lib` once they are on the default load path, and `--libs lib` replaces the `--load-path` of each Erlang application's `ebin` in the Makefile, the launcher and the examples' headers, as the template then has it.

With that, and `sub` and `scroll` once epx has its fixes, the library is done: a 2-D library of pixmaps, pixels and the drawing functions, with its four examples, and nothing more is planned. Decided 2026-10-20 with the user.

## Milestone 7: the release 0.3.0, the last

After `sub` and `scroll`, once epx has its fixes: the release as `release.md` says, the readers again, the tag `v0.3.0` and the archive. Decided 2026-10-20 with the user.
