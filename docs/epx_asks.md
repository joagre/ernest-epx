# What the library asks of epx

The reports of [`epx_bugs.md`](epx_bugs.md) still open at the commit the library pins, 02a0eaf, each as an issue for epx's tracker, with what is fixed of it left out and the library's own sentences left off; the numbers are the bug file's. `epx_bugs.md` is the owner, and this file is cut from it for epx's author and goes when nothing here is open. Nothing here is urgent: the library ships around each.

**12, what remains. An ellipse's ring is malformed at its top and bottom.** With a border of 1 or 2, and past a radius of 65535: a lone pixel outside the ring, the fill showing through below it, and the ring thicker there than at the sides. A 20 by 20 ring's second row is one pixel where the filled circle's is seven. The overflow and the double blending are fixed.

**5, what remains. `pixmap_get_pixels(P, 0, 0, 0, 0)` answers the pixmap's live memory**, padding included, changing as the pixmap is written. The crash is fixed; if the shortcut is intended, its documentation could say so.

**7, what remains. The area functions take their row stride as `int`**, `epx_fill_area(uint8_t*, int dst_wb, ...)`: `pixmap_create(600000000, 2, argb)` is accepted and `pixmap_fill_area(P, 0, 0, 1, 2, C)` segfaults. Allocation and addressing are fixed.

**8, what remains. `get_dim` converts with `(unsigned int) round(wf)`**, so a width that rounds to 2^32 or more, `pixmap_fill_area(P, 1, 0, 4294967295, 1, C)`, writes nothing. The 2^31 edge is fixed.

**19, what remains. A window wider than X takes is refused silently.** `window_create` with a width of 40000, 70000 or 16777216 answers a window; `window_attach`, `window_sync`, `pixmap_draw` and `window_detach` all answer `ok`, no window exists, and `window_info` reports the width asked. The hang is fixed, and 0 raises `badarg`.

**23. An ellipse of even width or height is one pixel larger.** `epx_ellipse.c` takes `x + 2*a` as the right edge: an ellipse 20 wide at `x` 1 covers columns 1 to 21, as one 21 wide does, and the same for the height.

**24. A window's copy off the screen is never cleared.** After a draw, the parts of the window not drawn into show whatever the X server's memory held.

**25. A diagonal line of width 1 leaves out its first pixel.** `pixmap_draw_line(P, Gc, 0, 0, 5, 3)` draws `1, 1`, `2, 1`, `3, 2`, `4, 2` and `5, 3` and not `0, 0`, whatever the style; a horizontal or vertical line keeps both ends, and `nfirst` and `nlast` change nothing for a single line.

**15, a note and no defect.** `[]` now means `none` for a line and a border style where it meant `solid`, and `none` reads back as `[]`. The library is fine with it; this only confirms it is intended.

**26. A sub-pixmap whose parent was collected crashes the VM when asked for its parent.** `pixmap_dtor` leaves `pixmap->res` pointing at the freed resource, and `pixmap_info(Sub, parent)` builds a term from it: with 200 subs whose parents were dropped and collected, the call crashed 3 of 3 runs. The pixels themselves are fine after the parent's collection.

**27. A scroll between two pixmaps by both amounts loses the vertical one.** `pixmap_scroll(Src, Dst, 1, 1, false, Fill)` with `Src` and `Dst` distinct writes what `(1, 0)` writes: the horizontal step reads `Src` again and overwrites the vertical result. On one pixmap both apply, vertical first.

**28. A scroll by 0 and 0 into another pixmap copies nothing**, where a wrap by a whole width or height copies the source into the target.

**29. `pixmap_draw_poly` applies a translation twice.** The `0`, `0` offset of `draw_poly/3` goes through the pixmap's transform as the vertices do: with the pixmap translated by `(2, 1)`, a square at `(2, 1)` landed at `(4, 2)`.

**30. A filled polygon scans every row of its height whatever the clip**, holding its scheduler meanwhile: a filled polygon 10 by 10^8 on a 16 by 16 pixmap took 8.8 s, about 88 ns a row, where its outline and a rounded rectangle of the same size return at once.

**31. A rounded rectangle's border placed inside is a row thicker at the top and the bottom than at the sides**, and its fill loses a row at each: with radii 0 on 12 by 9, a border of 1 measured 2 rows at the top against 1 at the left, 2 measured 3, and 3 measured 4, where `pixmap_draw_rectangle` with the same gc measured 1, 2 and 3; 12 by 8 with a border of 3 is drawn wholly in the border's color. The rasterizer is `epx_draw_rrect_ring`, which the ellipse's ring shares (12).

**32. A polygon's outline blends each vertex twice.** With a blended line style, a vertex came out as `{159, 0, 0, 191}` against `{191, 0, 0, 127}` mid-edge; the C carries `// FIXME: do not draw pixel twise!`.

**33. A color is taken where it should be refused.** `get_color` takes an unknown color name, `nosuchcolor`, as `{255, 0, 0, 0}`, and clamps a channel outside 0 to 255, `{300, -5, 2, 1}` stored as `{255, 0, 2, 1}`, wherever epx takes a color.

**34. `pixmap_draw_poly` with a list that is not one raises `function_clause`**, not `badarg` as every other wrong argument does.

**35. A polygon's diagonal edge leaves out its upper end, whichever end comes first.** `map_edge` orders each edge's ends by `y` before `epx_draw_line`, so the end of the smaller `y` is the line's first pixel and is left out (25): the outline of `[{0, 0}, {6, 0}, {6, 6}, {3, 3}, {0, 6}]` at width 1 lacks the vertex `3, 3`, and `[{0, 0}, {3, 3}]` and `[{3, 3}, {0, 0}]` draw the same three pixels without `0, 0`.
