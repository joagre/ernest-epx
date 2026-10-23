# What the library asks of epx

The reports of [`epx_bugs.md`](epx_bugs.md) still open after epx's fix commit 23a0ed2, each as an issue for epx's tracker, with what the commit fixed of it left out and the library's own sentences left off; the numbers are the bug file's. `epx_bugs.md` is the owner, and this file is cut from it for epx's author and goes when nothing here is open. Only 22 is asked for now; the rest is for whenever.

**22. The build asks for `xdg-shell.xml`, which the repository does not ship.** With wayland-client, wayland-cursor and wayland-scanner installed, `c_src/Makefile` turns the Wayland backend on, and its rules for `xdg-shell-client-protocol.h` and `xdg-shell-protocol.c` name `xdg-shell.xml` as a bare prerequisite in `c_src/`. `make` stops with `No rule to make target 'xdg-shell.xml'`, and nothing builds, the X11 backend included. The file is wayland-protocols' own, `$(shell pkg-config --variable=pkgdatadir wayland-protocols)/stable/xdg-shell/xdg-shell.xml`, which the rules could name, or the repository could carry a copy.

**12, what remains. An ellipse's ring is malformed at its top and bottom.** With a border of 1 or 2, and past a radius of 65535: a lone pixel outside the ring, the fill showing through below it, and the ring thicker there than at the sides. A 20 by 20 ring's second row is one pixel where the filled circle's is seven. The overflow and the double blending are fixed.

**5, what remains. `pixmap_get_pixels(P, 0, 0, 0, 0)` answers the pixmap's live memory**, padding included, changing as the pixmap is written. The crash is fixed; if the shortcut is intended, its documentation could say so.

**7, what remains. The area functions take their row stride as `int`**, `epx_fill_area(uint8_t*, int dst_wb, ...)`: `pixmap_create(600000000, 2, argb)` is accepted and `pixmap_fill_area(P, 0, 0, 1, 2, C)` segfaults. Allocation and addressing are fixed.

**8, what remains. `get_dim` converts with `(unsigned int) round(wf)`**, so a width that rounds to 2^32 or more, `pixmap_fill_area(P, 1, 0, 4294967295, 1, C)`, writes nothing. The 2^31 edge is fixed.

**19, what remains. A window wider than X takes is refused silently.** `window_create` with a width of 40000, 70000 or 16777216 answers a window; `window_attach`, `window_sync`, `pixmap_draw` and `window_detach` all answer `ok`, no window exists, and `window_info` reports the width asked. The hang is fixed, and 0 raises `badarg`.

**23. An ellipse of even width or height is one pixel larger.** `epx_ellipse.c` takes `x + 2*a` as the right edge: an ellipse 20 wide at `x` 1 covers columns 1 to 21, as one 21 wide does, and the same for the height.

**24. A window's copy off the screen is never cleared.** After a draw, the parts of the window not drawn into show whatever the X server's memory held.

**25. A diagonal line of width 1 leaves out its first pixel.** `pixmap_draw_line(P, Gc, 0, 0, 5, 3)` draws `1, 1`, `2, 1`, `3, 2`, `4, 2` and `5, 3` and not `0, 0`, whatever the style; a horizontal or vertical line keeps both ends, and `nfirst` and `nlast` change nothing for a single line.

**15, a note and no defect.** `[]` now means `none` for a line and a border style where it meant `solid`, and `none` reads back as `[]`. The library is fine with it; this only confirms it is intended.
