# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first; the milestones to come follow in order, and the table of the finished ones ends the page. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The library is done: a 2-D library of pixmaps, pixels and the drawing functions, with its six examples, and nothing more is planned. Its last release is 0.2.0, 2026-10-25. The floor is 0.9, and epx is pinned at `3fdacef`.

What is left waits outside the library: the release at Ernest's launch, milestone 11, and the defects epx has not fixed, milestone 9.

## Milestone 11: the release at Ernest's launch

The floor stays 0.9 through Ernest's layout stop and its 0.10.0, and rises to the launch's minor, 0.11 or 0.12 as Ernest names it, when the reviews of Ernest's MVP 4.4 begin. Ernest's release is tagged; the same week ernest-template releases, then this library, then ernest-httpd; and the site, which lists the library, goes live last. Each step comes on the user's word. The release does not wait on milestone 9. Decided 2026-11-05 (the log's *The release at the launch*).

At the rise the library takes what Ernest changed since 0.9, as Ernest's `CHANGES.md` lists it. Built against 0.10.0, the library, its tests and its examples pass unchanged, and `tools/docs.ern`, whose `Os.Command` 0.10.0 refuses, comes again from the template. The three tests that read a return through a spawn, a monitor and a receive take `Process.run`, E.21, and the comment on `limited` in `examples/boids.ern` cites E.9 for the zero vector's direction (the log's *The feedback checked against 0.10.0*).

## Milestone 9: what epx has not fixed, after 0.2.0

Each defect of `epx_bugs.md` left, 33's clamp of a channel and 39 to 41, goes as a commit of epx's fixes it and the pin moves; a fix that changes what the design states changes the design first, §4 or §5, then the page and the test. Nothing is asked of epx's author for them. Decided 2026-10-23 (the log's *The release waits on Ernest alone*). A release after the launch's follows a commit of epx's that moves the pin.

Done 2026-11-08: the fixes of `3fdacef` verified, its sentences written and the pin moved to it, and `subPixmap` built (the log's *The second fixes verified*, *The sentences for 3fdacef*, *The sentences for subPixmap*, *The subPixmap built*).

## Finished milestones

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
| Milestone 10 | the flock, `examples/boids.ern`, and the window at animation speed: no wait for the backend | 2026-11-06 | the log's *The flock* |
