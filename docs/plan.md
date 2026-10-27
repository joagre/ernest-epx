# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The first cut is built and released as 0.1.0, 2026-10-20: `Epx` with twenty functions over epx's pixmaps, its design in `design.md`, the manual page under `docs/man/`, and three examples, the ray tracer among them, milestone 4. The area functions are epx's exactly.

The second cut is built, 2026-10-20, and the window that shows, 2026-10-21: `Epx.Gc`, five drawing functions, the clock face, `Epx.Window`, and the word `show` on every example. Whitted's spheres, the slow tracer, is built, 2026-10-21, the fifth example, and the collage of the five pictures heads the README, 2026-10-21.

What waited on Ernest's MVP 3.28 is taken, 2026-10-22, milestone 6. epx's fixes are in the pin, 2026-10-23, the library follows them, and `sub`, `scroll`, the rounded rectangle and the polygon are built the same day, milestone 2 done; `sub` is held back from 0.2.0, since epx's `flip` and `copyTo` corrupt memory through one (milestone 9). Ernest 0.5.0 is tagged 2026-10-25 and the floor is 0.5, and 0.6 since 2026-10-27, Ernest 0.6.0 tagged the same night; the release 0.2.0 is out the same day, milestone 3b, its archive beside its tag.

What is left: milestone 9, what epx has not fixed, `sub` returning as `subPixmap` with two of its fixes and each other defect going as epx fixes it. With that the library is done: a 2-D library of pixmaps, pixels and the drawing functions, with its five examples, and nothing more is planned; a release after 0.2.0 follows a commit of epx's that moves the pin, as `release.md` says.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| Milestone 1 | the design and the first cut | 2026-10-20 | the log's *epx and tree_db as submodules*, *The first cut*, *The first cut built*, *The clip correction dropped* |
| Milestone 2 | what epx must fix first, and the next cut: the clip correction dropped and then closed by epx's fix, `Epx.Gc` and the drawing functions, the wide line's band kept and then epx's, the reports filed, fixed and verified, the pin moved, and `sub`, `scroll`, the rounded rectangle and the polygon | 2026-10-23 | the log's *The clip correction dropped*, *The second cut*, *The second cut built*, *The reports verified*, *The fixes verified*, *The pin moved*, *The four functions* |
| Milestone 3 | the release 0.1.0 | 2026-10-20 | the log's *The release review* |
| Milestone 3b | the release 0.2.0, with the floor 0.5, the docs tool holding the design's citations, the proposals read and gone, and `release.md`'s round | 2026-10-25 | the log's *The release review of 0.2.0*, *The proposals' reading*, *What epx offers that the library leaves*, *The floor is 0.5*, *The release 0.2.0* |
| Milestone 4 | the ray tracer | 2026-10-20 | the log's *The ray tracer*, *The ray tracer built* |
| Milestone 5 | Whitted's spheres, the slow tracer | 2026-10-21 | the log's *Whitted's spheres decided*, *Cook's Sampling*, *Whitted's spheres built* |
| Milestone 6 | what Ernest's MVP 3.28 brought: the foreign answers declared `Unit`, `Test.faults`, the doc examples under `ern test`, the rules read from Ernest's installation, `Epx.Window` named for itself, `List.mapFold` in Whitted's row, and the Makefile's `--libs-dir lib` with Ernest's libraries off `make lib` | 2026-10-22 | the log's *The window named for itself*, *What MVP 3.28 brought* |
| Milestone 8 | a window that shows, `Epx.Window` | 2026-10-21 | the log's *A Window That Shows*, *The window decided*, *The window built*, *The window named for itself* |

## Milestone 9: what epx has not fixed, after 0.2.0

The defects of `epx_bugs.md` that epx's fix commit leaves, which the library documents around and ships 0.2.0 with: 12's ring at its top and bottom, 23's extra pixel on an even ellipse, 25's first pixel of a diagonal line, 24's first picture of a window, 5, 7, 8 and 19 beyond the library's bounds, and 26 to 35, found trying the edges of `sub`, `scroll`, the rounded rectangle and the polygon, which the design states as epx has them.

`sub` returns as `subPixmap`, its design as the log's *The four functions* has it and its code in the history before the release 0.2.0, once epx's `pixmap_flip` and `pixmap_copy_to` take a sub's width, `epx_bugs.md` 36 and 37, and the pin moves; decided 2026-10-25 (the log's *The release 0.2.0*).

Each other defect goes as a commit of epx's fixes it and the pin moves; a fix that changes what the design states changes the design first, §9 or §11, then the page and the test. Nothing is asked of epx's author for them. Decided 2026-10-23 (the log's *The release waits on Ernest alone*).
