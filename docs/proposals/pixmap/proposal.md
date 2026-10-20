# Epx, the first cut: pixmaps and pixels

A proposal for the module `Epx`, Ernest over epx's pixmaps: a pixmap made, filled, read and written pixel by pixel and in areas, copied, scaled and blended, with no window and no event. It is the plan's milestone 1, item 1. Begun 2026-10-20.

## 1. What it is

A pixmap is a rectangle of pixels held outside any process, in epx's NIF, and changed in place: `fill`, `putPixel` and the area operations write into it, and every holder of it sees the change. It is not a value. A program that wants a picture as a value reads the pixels out, `getPixels`, and holds the bytes.

The module is a shim: an operation whose work epx's function does exactly is a `foreign fn` over that function, carrying its arguments, its edge cases and what it raises into the Ernest contract (Ernest's CLAUDE.md, *Shims*). Where epx's function almost does the work, Ernest closes the difference around a shim that is the host function exactly: a `Color` record becomes the tuple epx takes, a format becomes its atom. The module writes no Erlang.

## 2. What epx offers, and what the first cut takes

`epx.erl` has fifty-odd pixmap functions. The first cut takes those a 2-D library needs and leaves the rest named here, so that a later cut knows where it stands.

**Taken.**

| Ernest | epx | What it does |
|---|---|---|
| `create(width, height, format)` | `pixmap_create/3` | a new pixmap, its pixels unset |
| `copy(pixmap)` | `pixmap_copy/1` | a new pixmap with the same pixels |
| `sub(pixmap, x, y, width, height)` | `pixmap_sub_pixmap/5` | a pixmap that shares the pixels of a rectangle of another |
| `width(pixmap)`, `height(pixmap)`, `format(pixmap)` | `pixmap_info_/2` | what the pixmap is |
| `fill(pixmap, color)` | `pixmap_fill/2` | every pixel the color |
| `fillArea(pixmap, x, y, width, height, color)` | `pixmap_fill_area/6` | the rectangle the color |
| `getPixel(pixmap, x, y)` | `pixmap_get_pixel/3` | the color at a point |
| `putPixel(pixmap, x, y, color)` | `pixmap_put_pixel/4` | the color at a point |
| `getPixels(pixmap, x, y, width, height)` | `pixmap_get_pixels/5` | the rectangle's pixels as bytes, in the pixmap's format |
| `putPixels(pixmap, x, y, width, height, format, bytes)` | `pixmap_put_pixels/7` | the rectangle's pixels from bytes in that format |
| `copyTo(source, target)` | `pixmap_copy_to/2` | the source's pixels into the target |
| `copyArea(source, target, sourceX, sourceY, targetX, targetY, width, height)` | `pixmap_copy_area/8` | a rectangle from one into the other |
| `scale(source, target, width, height)` | `pixmap_scale/4` | the source scaled into the target |
| `flip(pixmap)` | `pixmap_flip/1` | upside down, in place |
| `scroll(source, target, horizontal, vertical, rotate, color)` | `pixmap_scroll/6` | shifted, the uncovered part the color or wrapped |
| `blendArea(source, target, alpha, ...)` | `pixmap_alpha_area/9` | the source blended into the target with an alpha |
| `fadeArea(source, target, fade, ...)` | `pixmap_fade_area/9` | the source faded into the target |
| `shadowArea(source, target, ...)` | `pixmap_shadow_area/8` | the source darkened into the target |
| `operationArea(source, target, operation, ...)` | `pixmap_operation_area/9` | a Porter-Duff or arithmetic operation of the source onto the target |
| `setClip(pixmap, x, y, width, height)` | `pixmap_set_clip/2` | the rectangle outside which writes are dropped |

**Left for a later cut**, each with its reason: `pixmap_draw_*`, the lines, rectangles, ellipses and polygons, since each takes a graphics context, `epx_gc`, a second foreign type with twenty settable keys, which is a module of its own; `pixmap_rotate_area`, `pixmap_filter_area`, `pixmap_add_color_area`, `pixmap_scale_area/11` and `pixmap_interp_pixel`, until a program asks; `pixmap_ltm_*`, the transformation matrix; `pixmap_attach`, `pixmap_detach` and `pixmap_draw`, which are the window's; `pixmap_dump`, a debugging print; and `epx_image`, which reads and writes PNG, JPEG, GIF and BMP through an Erlang record no Ernest type describes, and so needs an Erlang adapter, decided when it is wanted.

## 3. The types

```
export foreign type Pixmap

export type Format = Argb | Rgba | Abgr | Bgra | Rgb | Bgr

export type Color = Color(alpha : Int, red : Int, green : Int, blue : Int)

export type Operation = Clear | Src | Dst | SrcOver | DstOver | SrcIn | DstIn | SrcOut | DstOut
                      | SrcAtop | DstAtop | Xor | Copy | Add | Sub | SrcBlend | DstBlend
```

`Pixmap` is epx's resource, `#epx_pixmap{}`, which the host frees when nothing holds it: there is no `close`. `Format` is the six simple formats of `epx_pixel_format_simple()`, each crossing as its atom; epx's named and string formats, `"a8r8g8b8"` and its forty others, are left until a program asks. `Color` is the four channels, 0 to 255, crossing as epx's `{A, R, G, B}`; `getPixel` answers it. `rgb(red, green, blue)` makes one with alpha 255. epx's X11 color names, `red`, are not taken: a name is a table of its own, and `rgb(255, 0, 0)` says the same.

A coordinate and a size are `Int`. epx takes a float too, which the first cut leaves out: a program that places at a fraction wants the drawing functions, which are the later cut. An alpha and a fade are `Int`, 0 to 255, as epx's `fix8()` has them; its float form, 0.0 to 1.0, is left out for the same reason, one way to say a thing.

Flags, `epx_flags()`, `blend`, `sum`, `aalias` and the rest, are left out of the first cut's signatures: each operation is its plain form, `pixmap_fill/2` and not `/3`. A program that wants a blended fill has `blendArea`; the flags come in with the drawing functions, whose context carries them.

## 4. What faults

epx's NIF raises `badarg` for a pixmap that is not one, a coordinate outside the pixmap on `getPixel`, a format it does not know and a byte string of the wrong size on `putPixels`; a write outside the pixmap, `putPixel` and the area operations, is clipped and does nothing. Each fault crosses as §7.4 has it, `foreign function epx:pixmap_get_pixel/3 raised error:badarg`, and each function's `Errors` section says which argument did it, as Ernest's `Ets` says it. What the first experiment finds epx does on each edge goes into the doc blocks, from the experiment and not from this paragraph.

A `Color` channel outside 0 to 255 is Ernest's to refuse before the call, since epx masks it silently: a fault with the cause `a channel of a Color is outside 0 to 255`, as the runtime's own preconditions fault (§7.4).

## 5. The documentation

The module is documented as Ernest's standard library modules are, Appendix E.0's shape rule 6: the module's doc block opens with one sentence, then a paragraph each for what a caller must know before the first call, a pixmap's life, that it is changed in place and shared, the coordinate system, then `Examples` and `since v0.1.0`; every exported declaration has a doc block, with `Errors` where it faults and an example that calls it. `make doc` renders the page.

## 6. The example

`examples/mandelbrot.ern`: the Mandelbrot set over a rectangle of the plane, each pixel colored by the count of iterations before its point escapes, written with `putPixel` into a pixmap and then to a file. It needs a file format: the pixmap's bytes from `getPixels` in `Rgb` format with a PPM header before them, `P6`, the width, the height and `255`, three tokens that any viewer opens. A data format is a library's work and not an example's (CLAUDE.md, *Defects and gaps*), so the writer is the library's, `toPpm(pixmap) : Bytes`, five lines of Ernest, and stays until `epx_image` is shimmed with the adapter it needs.

`examples/README.md` lists the programs by topic, as Ernest's does, and the tests build and run each.

## 7. What is tried first

Before the doc blocks are written, a scratch program tries each edge of section 4 against the NIF: a read outside the pixmap, a write outside it, a wrong-sized `putPixels`, an unknown format, a `sub` outside its source. What epx does decides each `Errors` section. The scratch program of 2026-10-20 already made, filled and read a pixmap through the NIF from Ernest.

## 8. The decisions

For the user to accept or amend in one answer. Each with its recommendation.

1. **The operations** are section 2's twenty, the drawing functions and `epx_image` left for a later cut. Recommended: yes; a Mandelbrot needs `create`, `putPixel` and `getPixels` alone, and a cut that stops where the next foreign type begins is one the doc blocks can hold whole.
2. **`Color` is one record with alpha**, `rgb` making an opaque one, and epx's color names are not taken. Recommended: yes, one way to say a color.
3. **Coordinates, sizes, alphas and fades are `Int`**, epx's float forms left out. Recommended: yes, until the drawing functions.
4. **Flags are left out** of the first cut's signatures. Recommended: yes; each operation is its plain host function, and a blend is `blendArea`.
5. **A channel outside 0 to 255 faults** before the call. Recommended: yes; epx masks it silently, which principle 1 forbids.
6. **The PPM writer is the library's**, `toPpm`, until `epx_image` is shimmed. Recommended: yes; the alternative, an Erlang adapter for `epx_image` now, brings Erlang into the repository for the example's sake.
7. **One module**, `Epx`, not `Epx.Pixmap`. Recommended: yes; a second module comes with the graphics context, `Epx.Gc`, where the names would otherwise collide.
8. **The build** is an agent's, from this proposal once decided, with the doc blocks read back here against shape rule 6 before the item closes. Recommended: Opus 5.5 at xhigh for the shim and the example, the read-back on Fable.
