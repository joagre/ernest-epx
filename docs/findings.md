# Findings

The two readers' findings of the release 0.2.0's second review, 2026-10-25, over what changed since the review of 2026-10-22, each with its verdict: *fixed* in the release's commits, *planned* with the item that takes it, or *dropped* with the reason. The file goes when no line waits.

## The cold reader

1. The README's first program gives no `export fn main`. *Fixed*: one sentence under *Using it*.
2. `Epx`'s page names epx's `ebin` alone where the README names tree_db's too. *Fixed*: the page says `Epx` needs epx's and `Epx.Window` tree_db's as well.
3. `make test`'s list of long paragraphs reads as a failure at the end of a green run. *Fixed*: the README's `make test` line says it lists without failing, here and in the template.
4. The examples' README says twice that the commands run from the root with `ern` on the path. *Fixed*: the second goes.
5. `copyArea`'s page carries no `since` though it changed. *Dropped*: what changed is epx's landing of a cut rectangle, not the function; its behavior is 0.1.0's as the design now states it.
6. The close button's paragraph opens with the prohibition and never says what a program that breaks it sees. *Fixed*: the cause first, then what the design says happens.

## The code reader

1. `flip` of a sub-pixmap corrupts memory and crashes the VM, epx taking the parent's row length for the sub's width. *Planned*: `epx_bugs.md` 36; `sub` held back from 0.2.0, returning as `subPixmap` once epx fixes 36 and 37, milestone 9; decided 2026-10-25.
2. `copyTo` into or from a sub-pixmap writes or reads outside it. *Planned*: `epx_bugs.md` 37; with 1.
3. The design says nothing of a source and a target that share pixels. *Dropped*: with `sub` gone no two pixmaps share pixels; §4's sentence returns with it.
4. A wrapped scroll in place allocates a buffer and writes nothing where it cannot. *Fixed*: §4 and `scroll`'s page say so, `epx_bugs.md` 38.
5. A filled polygon of one or two points is not what the design's sentence says. *Fixed*: §9 splits the filled and the unfilled case; the test gains width 3.
6. A rounded rectangle of width or height 1 is a line in a color the design did not name. *Fixed*: §9 names it.
7. Three changed sentences have no test: `scroll` ignoring the clip, the centered band, an ellipse past the old bound ending. *Fixed*: a test each.
8. §11 said `show` and `showArea` are tested where `show` refuses nothing. *Fixed*.
9. The glossary's fill, border and line named no rounded rectangle or polygon. *Fixed*.
10. The design gave two reasons. *Fixed*: both to the log, which had them.
11. §5 listed `sub` among allocations of pixels, which it makes none. *Dropped*: `sub` is gone from §5 with the rest.
12. Five regression tests did not name what they leave out. *Fixed*.
13. `sub` beside the constructor `Sub`, and a shortening of epx's name. *Planned*: `subPixmap` when it returns, milestone 9; decided 2026-10-25.
14. `Uncovered` is a participle and the amounts `horizontal` and `vertical` adjectives. *Fixed*: `Backfill`, and `right` and `down`; decided 2026-10-25.
15. A radius and a scroll amount past the bound fault with a width's and a coordinate's cause. *Fixed*: `a scroll's amount is beyond 16777216` and `a radius is beyond 16777216`; decided 2026-10-25.
16. The test `showRefused` tests `showArea` alone. *Fixed*: renamed.
17. The ring's sentence read as a third case. *Fixed*: at any border's width past the radius.
18. The clamp did not pair each radius with its side. *Fixed*.
19. "The lower height" in `scroll`'s page. *Fixed*: the smaller.
20. "Modulo the width and the height" named no owner. *Fixed*: the common area's.
21. §1's first paragraph ran past the measure with three turns. *Fixed*: broken after `Epx`'s.
