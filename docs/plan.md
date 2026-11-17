# Plan

The roadmap: what will be built, in what order, and what is built already. Why anything is the way it is belongs to [`log.md`](log.md), and how the program is arranged to [`design.md`](design.md).

Read *Where we are* first; the milestones to come follow in order, and the table of the finished ones ends the page. A gap stands in the milestone whose item closes it, and a decision the user must make stands in its milestone as a named decision, never as "open".

## Where we are

The library is done: a 2-D library of pixmaps, pixels and the drawing functions, with its six examples, and no more of it is planned. Its last release is 0.2.0, 2026-10-25. The floor is 0.10, and epx is pinned at `3fdacef`.

What is left: the release at Ernest's launch, milestone 11, with the sentences for the report's §6.5; and the defects epx has not fixed, milestone 9.

## Milestone 11: the release at Ernest's launch

The floor rises to the launch's minor, 0.11 or 0.12 as Ernest names it, when the reviews of Ernest's MVP 4.4 begin. Ernest's release is tagged; the same week ernest-template releases, then this library, then ernest-httpd; and the site, which lists the library, goes live last. Each step comes on the user's word. The release does not wait on milestone 9. Decided 2026-11-05 (the log's *The release at the launch*). The release is 0.3.0, since it adds `subPixmap`. Decided 2026-11-11 (the log's *The release read for readiness*).

With the floor's rise, the sentences for the report's §6.5, which the launch's release brings. A pixmap, a context and a window each live while "a process of its node" holds it, in the design's §2, §7 and §11 and on the three pages. §5, §10 and §12 state that a function given one the host has freed faults with epx's `badarg` in the cause, citing §6.5. A test on two nodes holds both. Decided 2026-11-17 (the log's *A pixmap across nodes and under load*).

Done 2026-11-10: the floor is 0.10, with the template's `v0.10.0` (the log's *The floor is 0.10*).

## Milestone 9: what epx has not fixed, after 0.2.0

Each defect of `epx_bugs.md` left, 33's clamp of a channel and 39 to 44, goes as a commit of epx's fixes it and the pin moves; a fix that changes what the design states changes the design first, §4, §5, §9, §11 or §12, then the page and the test. Nothing is asked of epx's author for them. Decided 2026-10-23 (the log's *The release waits on Ernest alone*). A release after the launch's follows a commit of epx's that moves the pin.

42, a clip read half set, is asked of epx's author: the user carries it to epx's tracker, since it alone writes outside a pixmap within the library's bounds. Its fix changes §2, §4 and §11 first. Decided 2026-11-17 (the log's *A pixmap across nodes and under load*). The report is carried as `epx_bugs.md` has it since milestone 12, a read and two sets among what it names (the log's *The calls from many processes*).

44, two first shows of one pixmap that end the node, is asked of epx's author too: the user carries it to epx's tracker with 42, since it ends the node within the library's bounds. Its fix changes §12 first. Decided 2026-11-17 (the log's *The calls from many processes*). 43, a context's key read twice by one draw, writes wrong pixels alone and is not asked for.

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
| Milestone 12 | the calls from many processes, run under the address sanitizer: the clip against each function that reads one, a context's setters against a draw, and a pixmap shown and dropped; 42 found wider, and 43 and 44 reported | 2026-11-17 | the log's *A pixmap across nodes and under load*, *The calls from many processes* |
| Milestone 10 | the flock, `examples/boids.ern`, and the window at animation speed: no wait for the backend | 2026-11-06 | the log's *The flock* |
