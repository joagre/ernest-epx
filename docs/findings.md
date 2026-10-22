# Findings

The two readers' findings of the release 0.2.0's review, 2026-10-22, each with its verdict: *fixed* in the review's commits, *planned* with the item that takes it, *dropped* with the reason, or *decision* where the user's word is waited for. The file goes when no line waits.

## The code reader

1. `window.ern`, `open`: the close button's message lands in the opening process's mailbox and `open`'s type says nothing of it. *Planned*: milestone 2 item 5, until Ernest decides how a foreign message is checked (its feedback 137) and epx's 16 is fixed; design §11 states the hazard.
2. The area functions land a rectangle one place short when its source begins outside the clip. *Dropped*: decided, milestone 2 item 1, the log's *The clip correction dropped*.
3. `open` faults where tree_db is not on the load path and §12 said nothing else faults. *Fixed*: §12 and `open`'s Errors.
4. Ten foreign functions still answer `Foreign.Term` and drop it. *Fixed*: declared `Unit`, milestone 6's count corrected in the log.
5. `copyTo`, `flip` and `epxLine` are pass-throughs where §1 says a `foreign fn` over epx's function. *Fixed*.
6. A line whose ends are one pixel is drawn horizontal, which §9 did not say. *Fixed*: §9's sentence and a test.
7. §12's refusals can be tested without a display. *Fixed*: the tests, and §11's waiver narrowed.
8. §11 said `showArea`'s cut is as an area function's source's, which it is not. *Fixed*: §11.
9. §1 said `Epx` names nothing of the other modules', which its doc examples do. *Fixed*: §1.
10. §9's width-0 diagonal and the unfilled triangle's width are untested. *Fixed*: the tests.
11. `rgb` beside `Rgb`, and `copy` beside `Copy`, differ in case alone. *Dropped*: `rgb` is the name every reader predicts (principle 1) and the doc block tells it from `Rgb`, which shape rule 10 asks; decided 2026-10-22.
12. `attach` writes one fault twice where an or-pattern holds it once. *Fixed*.
13. The bounds checks live in three modules. *Fixed*: §1 says each module checks with its own, since Ernest has no function private to a library; the window's gain their tests.
14. `place`, `size`, `withinReach(start, span)` in the window. *Fixed*: renamed.
15. `lineBetween`, `axialLine`, `band` draw and are nouns. *Fixed*: renamed.
16. `rawWidth`, `rawKey` beside `rawGetWidth`, `rawGetStyle`, one epx function named two ways. *Fixed*.
17. Locals shadowing the module's names. *Fixed*.
18. A test-citation comment in production code. *Fixed*.
19. Two comments above a blank line. *Fixed*: banners.
20. Three `// =>` lines past 100 columns. *Fixed*.
21. The doc's list of calls that take long is short of the truth. *Fixed*: every call that touches each pixel named.
22. `toPpm` is said to write a file. *Fixed*: it answers bytes.
23. `Epx`'s See also lacks `Epx.Window`. *Fixed*.
24. `show`'s example keeps no hold on its window. *Fixed*.

## The cold reader

1. The committed pages are stale and two of three missing; `release.md` has no `make man` step. *Fixed*: `make man` committed, the README's links, `release.md` step 5.
2. A released 0.4.0 passes the floor and cannot build the library. *Fixed*: the README says so.
3. The README names epx alone where tree_db is needed with it. *Fixed*: four places.
4. `make release` cannot succeed and the README does not say so. *Fixed*: the README names the plan's item.
5. Whether the archive may carry tree_db is unclear. *Fixed*: the file says the request stands open and no answer has come; decided 2026-10-22.
6. Whitted's header's commands take minutes unannounced. *Fixed*: the times in the header.
7. No URL for the archive or the repository. *Fixed*.
8. The archive's README has links to files not in it. *Fixed*: the README names the repository, where the links lead; the archive serves the operator (the template's rule).
9. The plan said tree_db went; `release.md`'s clone lacked `--recursive`. *Fixed*.
10. The headers' `$LOAD` splits in no zsh. *Fixed*: the flags written out.
11. The README names `language_feedback.md`, absent. *Fixed*: said absent while empty.
12. The close-button rule is hard to act on. *Fixed*: one sentence on the page.
13. `VERSION` is 0.1.0 while the pages say since 0.2.0. *Fixed*: 0.2.0, the tag waiting on Ernest 0.5.0.
14. The assets README names a command that does not exist. *Fixed*: the commands, and the collage said laid out by hand; decided 2026-10-22.
15. The usage lines name the program and not `ern run`. *Dropped*: the usage line names the program, as every program's does.
16. The write error is `Io.show`'s constructor. *Dropped*: the example shows the cause as Ernest gives it.
17. The headers' build leaves `examples/<name>.erc` where `make clean` does not reach. *Fixed*: built under `examples/build`.
18. "the layout" and "cuts" in the README. *Fixed*.
19. The first build's warnings. *Fixed*: one sentence.
20. `make test` reads as if window examples ran. *Dropped*: an example without `// =>` passes where it compiles, the report's rule.
21. The collage is 2.5 MB and the archive copies epx's whole `priv`. *Fixed* the collage, 681 by 511; *dropped* for `priv`, shipped whole since epx's backends read it and its layout is epx's; decided 2026-10-22.
22. Milestone 2's items jumped from 4 to 7; the table's order; the log's heading case. *Fixed* the numbering; *dropped* the rest, the table in milestone order and the headings history.
