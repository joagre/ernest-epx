# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The first cut is built and released as 0.1.0, 2026-10-20: `Epx` with twenty functions over epx's pixmaps, its design in `design.md`, two examples, and the manual page under `docs/man/`. `sub` and `scroll` of the proposal wait on epx, milestone 2, and the area operations are epx's exactly, a source rectangle that begins outside the clip landing as epx lands it. The ray tracer is built, milestone 4, so the examples are three. Milestone 2 waits on epx, on Ernest and on the template; the next cut, `Epx.Gc`, is its item 4 and begins with a proposal.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| Milestone 1 | the design and the first cut | 2026-10-20 | the log's *epx and tree_db as submodules*, *The first cut*, *The first cut built*, *The clip correction dropped* |
| Milestone 3 | the release 0.1.0 | 2026-10-20 | the log's *The release review* |
| Milestone 4 | the ray tracer | 2026-10-20 | [`proposals/raytracer/`](proposals/raytracer/); the log's *The ray tracer*, *The ray tracer built* |

## Milestone 1: the design

1. **What the library offers**: decided 2026-10-20, [`proposals/pixmap/proposal.md`](proposals/pixmap/proposal.md), its eight decisions as recommended (the log's *The first cut*): twenty pixmap operations, `Color` one record, `Int` coordinates, no flags, a channel outside its range faulting, the PPM writer the library's, one module `Epx`, and the build an agent's.
2. **How epx is found**: decided 2026-10-20 (the log's *epx and tree_db as submodules*). epx is a read-only git submodule under `erl/`, which `make lib` builds by its own `make` and links as `lib/epx/ebin` and `priv`, on the load path; tree_db went at the release review, unneeded (the log's *The release review*). Built into `ernest-template` as its `v0.2.0`.
3. **The first cut built**, 2026-10-20 (the log's *The first cut built*): `src/epx.ern`, `design.md` cited by its tests, the edges tried first and recorded in `epx_bugs.md`, `examples/mandelbrot.ern` and `examples/sierpinski.ern` with their README, built and run by `make test`; the doc blocks read back against shape rule 6. `sub` and `scroll` left out, milestone 2.

## Milestone 2: what epx must fix first, and the next cut

1. **The clip correction**: decided 2026-10-20, dropped (the log's *The clip correction dropped*). The five area operations are epx's functions exactly, and a source rectangle that begins outside the source's clip lands as epx lands it, documented in `design.md` §4 and each operation's doc block, until epx fixes `epx_clip_both` (`epx_bugs.md` 6).
2. **The reports of `epx_bugs.md` filed with epx**, by the user, and the submodule moved to a release that has the fixes.
3. **`sub` and `scroll`**, once epx's fixes 1 to 3 are in the submodule, as the proposal's section 2 has them, `scroll`'s `rotate` a type of two named constructors (shape rule 9).
4. **The next cut**: decided 2026-10-20, [`proposals/gc/proposal.md`](proposals/gc/proposal.md), its seven decisions as recommended (the log's *The second cut*): `Epx.Gc`, the context as a resource with ten typed keys and one `Style`, seven drawing functions in `Epx`, epx's defaults, and `examples/clock_face.ern`; built by an agent from it, the edges of its section 6 tried first, `design.md` gaining its sections, the pages read back here, and the version 0.2.0.
5. **What waits on Ernest**: the lines the library carried to Ernest's `language_feedback.md`, 123 to 132, decided in Ernest's plan; when Ernest has 123, a foreign function answering `ok` declared `Unit`, the fourteen dropped answers go, and with 124, a `Test` function for a fault, the tests' own helper.
6. **What waits on the template**: a tool that runs a doc block's `// =>` examples and holds the page to them, which every library wants and which the release review found nothing does here (Ernest's feedback 127).

## Milestone 5: Whitted's spheres

`examples/whitted.ern`, after the clock face: the classic scene of several spheres over a checkered floor, with reflection and refraction, traced as `raytracer.ern` traces, the workers and the one pixmap the same, so that a richer picture costs a few dozen lines of the pure half and nothing of the acting half.

Decided 2026-10-20 with the user, who also decided where the library stops: a 2-D library of pixmaps and pixels, no mesh, no image reading and no window; a mesh is a library's work, and drawing on the screen is a windows library's, with the tracer's rows arriving on screen as its first example when one exists (the log's *Where the Library Stops*).

## Milestone 6: after Ernest's MVP 3.28, the end

When Ernest's MVP 3.28 is released, the parts of the library that wait on it are taken in one item: the fourteen dropped `Foreign.Term` answers become `Unit` declarations, the tests' own fault helper becomes `Test.faults`, the page's `// =>` lines are held by `ern test`, and the copy of the style rules and the load-path flags follow what the template then does.

With that, and `sub` and `scroll` once epx has its fixes, the library is done: a 2-D library of pixmaps, pixels and the drawing functions, with its four examples, and nothing more is planned. Decided 2026-10-20 with the user.
