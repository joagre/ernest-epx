# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first, then the table of milestones; the milestones to come follow in order. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The first cut is built and released as 0.1.0, 2026-10-20: `Epx` with twenty functions over epx's pixmaps, its design in `design.md`, the manual page under `docs/man/`, and three examples, the ray tracer among them, milestone 4. `sub` and `scroll` are milestone 2's, and the area functions are epx's exactly.

The second cut is built, 2026-10-20, and the window that shows, 2026-10-21: `Epx.Gc`, five drawing functions, the clock face, `Epx.Window`, and the word `show` on every example. Whitted's spheres, the slow tracer, is built, 2026-10-21, the fifth example, and the collage of the five pictures heads the README, 2026-10-21.

What waited on Ernest's MVP 3.28 is taken, 2026-10-22, milestone 6. epx's fixes are in the pin, 2026-10-23, and the library follows them. What is left: milestone 2's items 3 and 5, `sub`, `scroll`, the rounded rectangle and the polygon; the release 0.2.0, milestone 3b, once Ernest 0.5.0 is out, carrying them; then milestone 9, what epx has not fixed, each defect going as epx fixes it. With that the library is done: a 2-D library of pixmaps, pixels and the drawing functions, with its five examples, and nothing more is planned.

## Milestones

| | What | Done | Where its reasons are |
|---|---|---|---|
| Milestone 1 | the design and the first cut | 2026-10-20 | the log's *epx and tree_db as submodules*, *The first cut*, *The first cut built*, *The clip correction dropped* |
| Milestone 3 | the release 0.1.0 | 2026-10-20 | the log's *The release review* |
| Milestone 4 | the ray tracer | 2026-10-20 | the log's *The ray tracer*, *The ray tracer built* |
| Milestone 5 | Whitted's spheres, the slow tracer | 2026-10-21 | the log's *Whitted's spheres decided*, *Cook's Sampling*, *Whitted's spheres built* |
| Milestone 6 | what Ernest's MVP 3.28 brought: the foreign answers declared `Unit`, `Test.faults`, the doc examples under `ern test`, the rules read from Ernest's installation, `Epx.Window` named for itself, `List.mapFold` in Whitted's row, and the Makefile's `--libs-dir lib` with Ernest's libraries off `make lib` | 2026-10-22 | the log's *The window named for itself*, *What MVP 3.28 brought* |
| Milestone 8 | a window that shows, `Epx.Window` | 2026-10-21 | the log's *A Window That Shows*, *The window decided*, *The window built*, *The window named for itself* |

## Milestone 2: what epx must fix first, and the next cut

1. **The clip correction**: decided 2026-10-20, dropped (the log's *The clip correction dropped*), the five area functions epx's exactly and a source rectangle that begins outside the clip landing as epx landed it; closed 2026-10-23 the other way by epx's fix of report 6, a cut rectangle landing at its place, which §4 states with no exception (the log's *The pin moved*).
2. **The reports filed with epx and the pin moved**: filed 2026-10-23, fixed by epx's author the same day at 23a0ed2 and verified here, 15 fixed and 6 in part (the log's *The fixes verified*); the submodule moved to 02a0eaf, which builds plain, 2026-10-23, the design and the library following the fixes, and `epx_bugs.md` keeping what remains (the log's *The pin moved*).
3. **`sub` and `scroll`**, their fixes 1 to 3 in the pin since 2026-10-23: `sub(pixmap, x, y, width, height)` over `pixmap_sub_pixmap/5`, a pixmap that shares the pixels of a rectangle of another, and `scroll(source, target, horizontal, vertical, rotate, color)` over `pixmap_scroll/6`, `rotate` a type of two named constructors (shape rule 9); their edges tried first, §2 to §5 stating them before the build.
4. **The next cut**: decided 2026-10-20, its proposal's seven decisions as recommended (the log's *The second cut*), and built the same day (the log's *The second cut built*): `Epx.Gc` with eight keys and `Style`, the type `Epx.Context` in `Epx`, five drawing functions, the border placed inside, and `examples/clock_face.ern`.
5. **The rounded rectangle and the polygon**, their fixes 13 and 14 in the pin since 2026-10-23, the polygon's fill among them: `drawRoundedRectangle` over `pixmap_draw_roundrect/8` and `drawPolygon` over `pixmap_draw_poly/3`, their edges tried first and §9 and §10 stating them before the build. `close` stays `window_adjust`, decided 2026-10-23 (the log's *The pin moved*), `Rgba` and `Abgr` are shown since the pin moved, and a window's close button closes nothing until Ernest decides how a foreign message is checked (its feedback 137).
6. **A wide line's band**: decided 2026-10-20 with the user, kept in Ernest since epx's own band wrote past the clip and the pixmap (report 9); reversed 2026-10-23 with the pin, epx's band being the design's rule and within the clip, so that `drawLine` is epx's own (the log's *The pin moved*).
7. **The release that carries items 3 and 5**: 0.2.0 where the pin has moved before Ernest 0.5.0 is out, milestone 3b; otherwise 0.3.0 after it, the release as `release.md` says, the readers again over what the items add, the tag and the archive. Decided 2026-10-23 (the log's *The release waits on Ernest alone*).

## Milestone 3b: the release 0.2.0

After milestone 6, once Ernest 0.5.0 is released, since `make release` refuses a development build of `ern`, and on nothing of epx's: the pin moved 2026-10-23, so the release carries milestone 2's rest, items 3 and 5 built after it, and the readers run again over what they add. The release raises the floor to 0.5, `ERN_VERSION` in the Makefile, as the template then does. Decided 2026-10-22 and 2026-10-23 (the log's *What MVP 3.28 brought*, *The last milestone*, *The release waits on Ernest alone*).

The release as [`release.md`](release.md) says, the two readers over the new pages, `Epx.Gc` and `Epx.Window`, the drawing functions and the examples' windows among them, `make man` with the three pages, the tag `v0.2.0` and the archive with `THIRD_PARTY_LICENSES`, its notes naming epx's commit and the platform the NIF was built on. Decided 2026-10-20 with the user.

The window was tried by hand on a screen 2026-10-22, every example with the word `show`, `release.md`'s step 2. Before the tag, while the release waits, two items in order.

1. **The docs tool holds the design's citations**: every `design §n` in `src/` and `examples/` names a section `design.md` has, and every section is named by a test, so that a section inserted in the middle cannot pass unseen; built in the template's `tools/docs.ern` first and copied here, done 2026-10-22 (the log's *The proposals' reading*).
2. **The five proposals read with the user and gone**, done 2026-10-22 (the log's *The proposals' reading*, *What epx offers that the library leaves*): each as CLAUDE.md's rule for a built proposal says, what no owner holds yet going to `design.md` or the log first, and the table's rows and milestone 2's items naming the log alone; milestone 1's section goes with them, a finished milestone being a row of the table; the README's line for `docs/proposals/` then says the directory holds the next proposal. Decided 2026-10-22 (the log's *The proposals' reading*).

## Milestone 9: what epx has not fixed, after 0.2.0

The defects of `epx_bugs.md` that epx's fix commit leaves, which the library documents around and ships 0.2.0 with: 12's ring at its top and bottom, 23's extra pixel on an even ellipse, 25's first pixel of a diagonal line, 24's first picture of a window, and 5, 7, 8 and 19 beyond the library's bounds.

Each goes as a commit of epx's fixes it and the pin moves; a fix that changes what the design states changes the design first, §9 or §11, then the page and the test. Nothing is asked of epx's author for them. Decided 2026-10-23 (the log's *The release waits on Ernest alone*).
