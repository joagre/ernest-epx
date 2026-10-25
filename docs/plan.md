# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The first cut is built and released as 0.1.0, 2026-10-20: `Epx` with twenty functions over epx's pixmaps, its design in `design.md`, the manual page under `docs/man/`, and three examples, the ray tracer among them, milestone 4. The area functions are epx's exactly.

The second cut is built, 2026-10-20, and the window that shows, 2026-10-21: `Epx.Gc`, five drawing functions, the clock face, `Epx.Window`, and the word `show` on every example. Whitted's spheres, the slow tracer, is built, 2026-10-21, the fifth example, and the collage of the five pictures heads the README, 2026-10-21.

What waited on Ernest's MVP 3.28 is taken, 2026-10-22, milestone 6. epx's fixes are in the pin, 2026-10-23, the library follows them, and `sub`, `scroll`, the rounded rectangle and the polygon are built the same day, milestone 2 done; `sub` is held back from 0.2.0, since epx's `flip` and `copyTo` corrupt memory through one (milestone 9). Ernest 0.5.0 is tagged 2026-10-25 and the floor is 0.5.

What is left: the release 0.2.0, milestone 3b, made with the released `ern`; then milestone 9, what epx has not fixed, each defect going as epx fixes it. With that the library is done: a 2-D library of pixmaps, pixels and the drawing functions, with its five examples, and nothing more is planned.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| Milestone 1 | the design and the first cut | 2026-10-20 | the log's *epx and tree_db as submodules*, *The first cut*, *The first cut built*, *The clip correction dropped* |
| Milestone 2 | what epx must fix first, and the next cut: the clip correction dropped and then closed by epx's fix, `Epx.Gc` and the drawing functions, the wide line's band kept and then epx's, the reports filed, fixed and verified, the pin moved, and `sub`, `scroll`, the rounded rectangle and the polygon | 2026-10-23 | the log's *The clip correction dropped*, *The second cut*, *The second cut built*, *The reports verified*, *The fixes verified*, *The pin moved*, *The four functions* |
| Milestone 3 | the release 0.1.0 | 2026-10-20 | the log's *The release review* |
| Milestone 4 | the ray tracer | 2026-10-20 | the log's *The ray tracer*, *The ray tracer built* |
| Milestone 5 | Whitted's spheres, the slow tracer | 2026-10-21 | the log's *Whitted's spheres decided*, *Cook's Sampling*, *Whitted's spheres built* |
| Milestone 6 | what Ernest's MVP 3.28 brought: the foreign answers declared `Unit`, `Test.faults`, the doc examples under `ern test`, the rules read from Ernest's installation, `Epx.Window` named for itself, `List.mapFold` in Whitted's row, and the Makefile's `--libs-dir lib` with Ernest's libraries off `make lib` | 2026-10-22 | the log's *The window named for itself*, *What MVP 3.28 brought* |
| Milestone 8 | a window that shows, `Epx.Window` | 2026-10-21 | the log's *A Window That Shows*, *The window decided*, *The window built*, *The window named for itself* |

## Milestone 3b: the release 0.2.0

After milestone 6 and milestone 2: Ernest 0.5.0 is tagged 2026-10-25 and the floor is 0.5 since, `ERN_VERSION` in the Makefile as the template's; the release carries `scroll`, the rounded rectangle and the polygon, `sub` held back (milestone 9), the readers run again over the pages they changed, and `make release` runs with the released `ern`, since it refuses a development build. Decided 2026-10-22 and 2026-10-23 (the log's *What MVP 3.28 brought*, *The last milestone*, *The release waits on Ernest alone*).

The release as [`release.md`](release.md) says: the two readers ran 2026-10-22 over the second cut's and the window's pages (the log's *The release review of 0.2.0*) and run again over what milestone 2 added since, `sub`, `scroll`, the rounded rectangle and the polygon; `make man` with the three pages, the tag `v0.2.0` and the archive with `THIRD_PARTY_LICENSES`, its notes naming epx's commit and the platform the NIF was built on. Decided 2026-10-20 with the user.

The window was tried by hand on a screen 2026-10-22, every example with the word `show`, `release.md`'s step 2. Two items were done before the tag, while the release waited:

1. **The docs tool holds the design's citations**: every `design §n` in `src/` and `examples/` names a section `design.md` has, and every section is named by a test, so that a section inserted in the middle cannot pass unseen; built in the template's `tools/docs.ern` first and copied here, done 2026-10-22 (the log's *The proposals' reading*).
2. **The five proposals read with the user and gone**, done 2026-10-22 (the log's *The proposals' reading*, *What epx offers that the library leaves*): each as CLAUDE.md's rule for a built proposal says, what no owner holds yet going to `design.md` or the log first, and the table's rows and milestone 2's items naming the log alone; milestone 1's section goes with them, a finished milestone being a row of the table; the README's line for `docs/proposals/` then says the directory holds the next proposal. Decided 2026-10-22 (the log's *The proposals' reading*).

## Milestone 9: what epx has not fixed, after 0.2.0

The defects of `epx_bugs.md` that epx's fix commit leaves, which the library documents around and ships 0.2.0 with: 12's ring at its top and bottom, 23's extra pixel on an even ellipse, 25's first pixel of a diagonal line, 24's first picture of a window, 5, 7, 8 and 19 beyond the library's bounds, and 26 to 35, found trying the edges of `sub`, `scroll`, the rounded rectangle and the polygon, which the design states as epx has them.

`sub` returns as `subPixmap`, its design as the log's *The four functions* has it and its code in the history before the release 0.2.0, once epx's `pixmap_flip` and `pixmap_copy_to` take a sub's width, `epx_bugs.md` 36 and 37, and the pin moves; decided 2026-10-25 (the log's *The release 0.2.0*).

Each other defect goes as a commit of epx's fixes it and the pin moves; a fix that changes what the design states changes the design first, §9 or §11, then the page and the test. Nothing is asked of epx's author for them. Decided 2026-10-23 (the log's *The release waits on Ernest alone*).
