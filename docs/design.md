# Design

How the program is arranged, stated as rules: its processes and what each owns, its types, what each module owns, and the glossary of its names. This is the program's normative document; where the code and this differ, this is corrected first, then the log, then the code (CLAUDE.md, *Before code*). Each section has a test whose comment names it.

## 1. What the library does

The library is three modules over epx, the pixel library for Erlang. `Epx`, over epx's pixmaps, makes a pixmap, fills, reads and writes it pixel by pixel and in rectangles, copies, scales and blends one into another, draws points, lines, rectangles, ellipses and triangles into it with a graphics context, and writes one as a PPM file. `Epx.Gc`, over epx's graphics context, makes a context and sets and reads its keys (§7). `Epx.Window`, over epx's windows, opens a window on the screen and shows a pixmap in it (§11).

The library reads no event. It starts no process of its own, `open` starting epx's application (§11), and holds no Erlang of its own.

`Epx` declares the types of §3, the context's type `Context` and the window's type `Window` among them, and the drawing functions (§9). `Epx.Gc` declares `Style` (§8) and the functions of §7's table, which name `Epx`'s `Context` and `Color`. `Epx.Window` declares the functions of §11's table, which name `Epx`'s `Window` and `Pixmap`. `Epx`'s code names nothing of `Epx.Gc`'s or `Epx.Window`'s; its doc examples may.

Each function but `toPpm`, `drawLine` and the window's calls the epx functions its table names, each at most once: the table below for the pixmap's functions, §7's for the context's, §9's for the drawing functions. The window's call those §11's table names, as §11 says. Where one epx function does a function's work exactly, the function is a `foreign fn` over it, and where it differs, Ernest closes the difference around the call.

The differences closed are these, each stated where its rule is (§2 to §10): a `Color` crosses as the tuple epx takes, and a `Format`, an `Operation` or a `Style` as its atoms; epx's `ok` is `Unit`; a width or a height below 0 is 0; a precondition of §5, §10 or §12 is checked before the call. Each module checks with functions of its own, since Ernest has no function private to a library (report §4.2).

Also closed: a new pixmap is filled; a new context's border lies within its shape; a horizontal or vertical line wider than 1 is drawn as a rectangle; and `getPixels` answers a rectangle of width and height 0 without epx, which answers its whole memory for one at `0`, `0`.

| Function | epx | What it does |
|---|---|---|
| `create(width, height, format)` | `pixmap_create/3`, `pixmap_fill/2` | a new pixmap, every pixel 0 in every channel |
| `copy(pixmap)` | `pixmap_copy/1` | a new pixmap with the same size, format and pixels |
| `width(pixmap)`, `height(pixmap)`, `format(pixmap)` | `pixmap_info_/2` | what the pixmap is |
| `fill(pixmap, color)` | `pixmap_fill/2` | every pixel the color |
| `fillArea(pixmap, x, y, width, height, color)` | `pixmap_fill_area/6` | the rectangle the color |
| `getPixel(pixmap, x, y)` | `pixmap_get_pixel/3` | the color at a point |
| `putPixel(pixmap, x, y, color)` | `pixmap_put_pixel/4` | the point the color |
| `getPixels(pixmap, x, y, width, height)` | `pixmap_get_pixels/5` | the rectangle's pixels as bytes in the pixmap's format |
| `putPixels(pixmap, x, y, width, height, format, bytes)` | `pixmap_put_pixels/7` | the rectangle's pixels from bytes in the format |
| `copyTo(source, target)` | `pixmap_copy_to/2` | the source's pixels into the target |
| `copyArea(source, target, sourceX, sourceY, targetX, targetY, width, height)` | `pixmap_copy_area/8` | a rectangle of the source into the target |
| `scale(source, target, width, height)` | `pixmap_scale/4` | the source scaled into the target |
| `flip(pixmap)` | `pixmap_flip/1` | the rows in reverse order |
| `blendArea(source, target, alpha, sourceX, sourceY, targetX, targetY, width, height)` | `pixmap_alpha_area/9` | a rectangle of the source blended into the target by `alpha` |
| `fadeArea(source, target, fade, sourceX, sourceY, targetX, targetY, width, height)` | `pixmap_fade_area/9` | a rectangle of the source blended into the target by its own alpha, scaled by `fade` |
| `shadowArea(source, target, sourceX, sourceY, targetX, targetY, width, height)` | `pixmap_shadow_area/8` | the target darkened by the luminance of a rectangle of the source |
| `operationArea(source, target, operation, sourceX, sourceY, targetX, targetY, width, height)` | `pixmap_operation_area/9` | a rectangle of the source combined with the target by the operation |
| `setClip(pixmap, x, y, width, height)` | `pixmap_set_clip/2` | the pixmap's clip (§4) |
| `rgb(red, green, blue)` | none | an opaque color |
| `toPpm(pixmap)` | Ernest over `width`, `height`, `create` without its fill, `copyTo` and `getPixels` | the pixmap as a PPM file (§6) |

## 2. Pixmaps

A pixmap is a rectangle of pixels held by epx outside any process. Its width, its height and its format are fixed when it is made. Every pixel of a new pixmap is 0 in every channel its format holds.

A pixmap is not a value. A function that writes it changes it in place, and every process that holds it sees the change, a process it was sent to or that captured it among them. Nothing orders the writes of two processes but the order in which they run. epx takes no lock: two calls on one pixmap from two processes may interleave pixel by pixel, and a read may see a write half done. `copy` makes a new pixmap, which shares nothing with the first.

A pixmap lives while a process holds it, and the host frees it once none does; there is no `close`. A pixmap is bound to the node that made it (report §3.8, §3.11).

The library starts no process of its own, and no function receives or names a mailbox (report Appendix E.0 shape rule 5).

## 3. The types

```
export foreign type Pixmap

export type Format = Argb | Rgba | Abgr | Bgra | Rgb | Bgr

export type Color = Color(alpha : Int, red : Int, green : Int, blue : Int)

export type Operation = Clear | Src | Dst | SrcOver | DstOver | SrcIn | DstIn | SrcOut | DstOut
                      | SrcAtop | DstAtop | Xor | Copy | Add | Sub | SrcBlend | DstBlend

export foreign type Context

export foreign type Window
```

`Pixmap` is epx's pixmap, which the host compares exactly (report §3.10). `Context` is epx's graphics context (§7), and `Window` epx's window (§11), each compared so too.

A `Format` names the order of a pixel's bytes, one byte a channel: `Argb` is alpha, red, green and blue, and each other format the channels its name lists in that order. `Rgb` and `Bgr` hold no alpha and take three bytes a pixel, and the other four take four. A pixel of a format without alpha is read with alpha 255, and the alpha it is written with is dropped. A `Format` crosses to epx as the atom of its name in lower case, `argb`.

A `Color` is four channels, each from 0 to 255, alpha 255 being opaque and 0 transparent. It crosses to epx as `{Alpha, Red, Green, Blue}`, and a pixel epx answers crosses back the same way. A channel is stored as it is given, not multiplied by its alpha. `rgb(red, green, blue)` is the color of those channels and alpha 255.

An `Operation` is one of epx's seventeen ways of combining a pixel of the source with a pixel of the target, crossing as the atom of its name in lower case with `_` between its words, `src_over`. What each does is its constructor's doc block.

## 4. Coordinates and the clip

A pixel is at `x`, `y`, where `0`, `0` is the top left pixel, `x` grows to the right and `y` downward. A rectangle is its top left pixel, its width and its height.

A coordinate is from −16,777,216 to 16,777,216, and a width or a height at most 16,777,216 (§5). A width or a height below 0 is 0 (report §7.4), and a rectangle of width 0 or of height 0 has no pixels: a function reads and writes nothing of it.

A pixmap's bytes are its row's bytes times its height, and a row's bytes are its width times its format's bytes a pixel, rounded up to a multiple of 16. A pixmap's bytes are below 2,147,483,648, 2 GiB (§5).

Each pixmap has a clip, a rectangle within it, which is the whole pixmap when the pixmap is made or copied. `setClip` sets the clip to the part of its rectangle within the pixmap, which may be empty.

The clip bounds what a function writes and what it reads:

- `putPixel`, `putPixels`, `fillArea`, `scale` and the five area functions, `copyArea`, `blendArea`, `fadeArea`, `shadowArea` and `operationArea`, write only within the target's clip, and the area functions read only within the source's.
- `scale` reads the source's clip. What it writes from a source whose clip is not the whole pixmap is not stated: a program sets the source's clip to the whole pixmap first.
- `getPixel` answers opaque black, `Color(alpha = 255, red = 0, green = 0, blue = 0)`, for a point outside the clip, and for one outside the pixmap.
- `fill`, `flip`, `copyTo` and `getPixels` do not read the clip.

A rectangle that reaches outside what a function reads or writes is cut to the part within it, and one wholly outside is empty.

In an area function the source's pixel at `sourceX + i`, `sourceY + j` goes to the target's at `targetX + i`, `targetY + j`, and a pixel outside the target's clip is left out. The exception is a source rectangle that begins left of or above the source's clip: it is cut to the clip and lands at `targetX`, `targetY` all the same, as epx has it (`epx_bugs.md` 6), so a program begins the source's rectangle within the clip.

The two rectangles of `copyArea` may overlap in one pixmap. Those of `blendArea`, `fadeArea`, `shadowArea` and `operationArea` must not, and what they write where they do is not stated.

`getPixels` answers the bytes of the part of its rectangle within the pixmap, row by row from the top, and no bytes for a rectangle that has no pixels.

## 5. What faults

An argument the library refuses faults the calling process before epx is called (report §7.4):

- a coordinate outside −16,777,216 to 16,777,216: `Fault("a coordinate is beyond 16777216")`;
- a width or a height above 16,777,216: `Fault("a width or height is beyond 16777216")`;
- a width, a height and a format given to `create` whose pixmap's bytes reach 2 GiB (§4): `Fault("the pixmap's bytes reach 2 GiB")`;
- a `Color` with a channel outside 0 to 255, given to `fill`, `fillArea` or `putPixel`: `Fault("a channel of a Color is outside 0 to 255")`;
- an `alpha` outside 0 to 255, given to `blendArea`: `Fault("the alpha is outside 0 to 255")`;
- a `fade` outside 0 to 255, given to `fadeArea`: `Fault("the fade is outside 0 to 255")`;
- bytes given to `putPixels` that are not `width` times `height` pixels in the format, a width or a height below 0 being 0: `Fault("the bytes are not width times height pixels in the format")`.

Memory the host cannot allocate faults as a foreign function that raises does, with epx's function in the cause (report §7.4): a new pixmap's pixels, in `create`, `copy` and `toPpm`, with `Fault("foreign function epx:pixmap_create/3 raised error:badarg")` or `epx:pixmap_copy/1`'s, and the bytes `getPixels` answers, in `getPixels` and `toPpm`, with `epx:pixmap_get_pixels/5`'s. `format` faults with `Fault("the pixmap's format is none of Format's")` on a pixmap that foreign code made in another format.

Nothing else faults but what §10 lists. A read outside the pixmap or its clip answers as §4 says, and a write outside the clip writes nothing.

## 6. The PPM writer

`toPpm(pixmap)` answers the pixmap as a PPM file in its binary form, `P6`: the text `P6`, a line feed, the width and the height in decimal with a space between them, a line feed, `255` and a line feed, and then the pixels, row by row from the top, each as its red, green and blue bytes. A pixel's alpha is dropped and its color channels are written as they are.

## 7. The context

A context is epx's graphics context, of type `Context`: the colors, the styles and the widths the drawing functions draw with (§9). It is held by epx outside any process, as a pixmap is (§2). A setter changes it in place, and every process that holds it sees the change. `copy` makes a new context with the same keys, which shares nothing with the first. A context lives while a process holds it, and is bound to the node that made it (report §3.8, §3.11).

A context has eight keys, each with a setter and a getter in `Epx.Gc`. A getter answers what its setter last set, or the key's default:

| Key | Setter | Getter | Type | epx's key | Default |
|---|---|---|---|---|---|
| the fill's style | `setFillStyle(context, style)` | `fillStyle(context)` | `Optional(Style)` | `fill_style` | `Some(Solid)` |
| the fill's color | `setFillColor(context, color)` | `fillColor(context)` | `Epx.Color` | `fill_color` | opaque red, `rgb(255, 0, 0)` |
| the line's style | `setLineStyle(context, style)` | `lineStyle(context)` | `Style` | `line_style` | `Solid` |
| the line's width | `setLineWidth(context, width)` | `lineWidth(context)` | `Int` | `line_width` | 1 |
| the border's style | `setBorderStyle(context, style)` | `borderStyle(context)` | `Style` | `border_style` | `Solid` |
| the border's color | `setBorderColor(context, color)` | `borderColor(context)` | `Epx.Color` | `border_color` | opaque black, `rgb(0, 0, 0)` |
| the border's width | `setBorderWidth(context, width)` | `borderWidth(context)` | `Int` | `border_width` | 0 |
| the foreground | `setForeground(context, color)` | `foreground(context)` | `Epx.Color` | `foreground_color` | opaque blue, `rgb(0, 0, 255)` |

The defaults are epx's. A width below 0 is 0, and one above 16,777,216 faults (§10). A color crosses as §3 says, and one with a channel outside 0 to 255 faults (§10).

| Function | epx | What it does |
|---|---|---|
| `create()` | `gc_create/0`, `gc_set/3` | a new context of the defaults, its border placed within its shape (§8) |
| `copy(context)` | `gc_copy/1` | a new context with the same keys |
| each setter | `gc_set/3` | the key set |
| each getter | `gc_get/2` | the key read |

## 8. Styles

```
export type Style = Solid | Blend | Antialiased
```

A style says how a drawing function writes a pixel in a color. `Solid` writes the color as it is, its alpha among its channels. `Blend` combines the color with the pixel as the operation `SrcBlend` combines a source pixel with a target pixel (§3), so that an opaque color is written as it is. `Antialiased` is `Blend`, except in a line one pixel wide that is neither horizontal nor vertical and along the edge of an ellipse's fill, where a pixel the edge passes through is blended by how near the edge passes to it.

The fill's style is an `Optional(Style)`, and `None` is no fill. The line's style and the border's are a `Style`.

A style crosses to epx as a list of atoms: `Solid` as `[solid]`, `Blend` as `[blend]` and `Antialiased` as `[blend, aalias]`. A border's style adds `inside`, which places the border within its shape (§9), and `create` sets the border's style so. A fill of `None` crosses as `[]`. A style read back is the one whose atoms epx answers, the border's `inside` and the `center` epx answers beside it left out; a list that is none of these faults (§10).

## 9. The drawing functions

A drawing function draws into a pixmap with a context, the pixmap first and the context second, and writes only within the pixmap's clip (§4). It reads the context's keys the table names, and no other:

| Function | epx | Keys read |
|---|---|---|
| `drawPoint(pixmap, context, x, y)` | `pixmap_draw_point/4` | the foreground, the line's style |
| `drawLine(pixmap, context, x1, y1, x2, y2)` | `pixmap_draw_line/6`, or `gc_get/2` and `pixmap_fill_area/7` | the foreground, the line's style and width |
| `drawRectangle(pixmap, context, x, y, width, height)` | `pixmap_draw_rectangle/6` | the fill's style and color, the border's style, color and width |
| `drawEllipse(pixmap, context, x, y, width, height)` | `pixmap_draw_ellipse/6` | the fill's style and color, the border's style, color and width |
| `drawTriangle(pixmap, context, x1, y1, x2, y2, x3, y3)` | `pixmap_draw_triangle/8` | the fill's style and color; with no fill, the foreground and the line's style and width |

A point is the pixel at `x`, `y`, in the foreground by the line's style.

A line of width 0 draws nothing, and one of width 1 every pixel from `x1`, `y1` to `x2`, `y2`, both ends among them. A line whose two ends are one pixel is a horizontal line of one pixel's length.

A horizontal or vertical line wider than 1 is the rectangle that runs from one end of the line to the other and is the line's width across, `width / 2` of its rows or columns above or left of the line, rounded down. Any other line wider than 1 is a band beside the line, and which pixels it covers is not stated (`epx_bugs.md` 10).

`drawLine` reads the line's width for a horizontal or vertical line, and where it is above 1 reads the foreground and the line's style and fills that rectangle with `pixmap_fill_area/7`, where epx's own line writes past the clip and past the pixmap (`epx_bugs.md` 9).

A rectangle is its border and its fill. The border is the outermost pixels of the rectangle, the border's width of them on each side, in the border's color by the border's style; the fill is the rest, in the fill's color by the fill's style. With a fill, a border of width 0 is none. With no fill, the border alone is drawn, one pixel wide where its width is 0. Where the border is wider than the rectangle's width or height, which pixels it writes outside the rectangle is not stated (`epx_bugs.md` 11).

An ellipse is centered at `x + width / 2`, `y + height / 2`, its radii `width / 2` and `height / 2`, each rounded down, so that it covers `2 * (width / 2) + 1` columns from `x` and `2 * (height / 2) + 1` rows from `y`: one more than an even width or height. An ellipse whose width or height is below 2 draws nothing.

An ellipse's border is the ring from its edge to the edge of the ellipse the border's width inside it, both edges drawn, so that the ring is the border's width and one pixel across; its fill is within the ring. With a fill, a border of width 0 is none. With no fill, the ring alone is drawn, one pixel across where the border's width is 0.

A ring may leave a pixel undrawn near the ellipse's top and bottom where the border's width is 1, and a ring drawn by `Blend` or `Antialiased` blends a few of its pixels twice (`epx_bugs.md` 12).

A triangle with a fill is every pixel within its three corners, its edges among them, in the fill's color by the fill's style. With no fill it is its three edges, each a line from corner to corner in the foreground by the line's style, one pixel wide where the line's width is 0 or 1; where the width is above 1, which pixels the edges cover is not stated.

A drawing function reads each key it needs as it runs. A key another process sets meanwhile is read before the change or after it, and `drawLine`, which reads three keys one after another, may read some before the change and some after (§2).

## 10. What the context and the drawing functions fault

An argument the library refuses faults the calling process before epx is called (report §7.4), as §5's do:

- a coordinate given to a drawing function outside −16,777,216 to 16,777,216: `Fault("a coordinate is beyond 16777216")`;
- a width or a height given to `drawRectangle`, or a width given to `setLineWidth` or `setBorderWidth`, above 16,777,216: `Fault("a width or height is beyond 16777216")`;
- a width or a height given to `drawEllipse` above 131,071: `Fault("an ellipse's width or height is beyond 131071")`;
- a `Color` with a channel outside 0 to 255, given to `setFillColor`, `setBorderColor` or `setForeground`: `Fault("a channel of a Color is outside 0 to 255")`.

A getter of a style faults with `Fault("the context's style is none of Style's")` on a style that foreign code set and that is none of `Style`'s (§8). Memory the host cannot allocate for a new context faults as a foreign function that raises does, with epx's function in the cause: `Fault("foreign function epx:gc_create/0 raised error:badarg")`, or `epx:gc_copy/1`'s. Nothing else faults.

## 11. Windows

`Epx.Window` shows pixmaps on the screen, each in a window, through epx's backend, a thread of epx's that draws on the display `DISPLAY` names. A window is epx's window, of type `Window` (§3). It is held by epx outside any process, as a pixmap is (§2). It lives while a process holds it, and the host frees it and takes it off the screen once none does; a window still open when the program ends goes with the program. It is bound to the node that made it (report §3.8, §3.11).

| Function | epx | What it does |
|---|---|---|
| `open(x, y, width, height)` | `epx:start/0`, `window_create/4`, `window_attach/1` | a window at that place and of that width and height on the screen, epx's application started where it is not running |
| `show(window, pixmap)` | those of `showArea`, and `pixmap_info_/2` for the pixmap's width and height | the pixmap within its clip drawn at the same place in the window |
| `showArea(window, pixmap, x, y, width, height)` | `pixmap_info_/2`, `pixmap_attach/1`, `pixmap_draw/8` | the rectangle of the pixmap at `x`, `y`, within its clip, drawn at the same place in the window |
| `close(window)` | `window_adjust/2` | the window taken off the screen |

`open` starts epx's application with `epx:start/0`, which starts it where it is not running and answers at once where it is. It makes the window with no event flag and attaches it to epx's backend, which puts it on the screen. Its place is asked of the window manager, which may place it elsewhere. A coordinate given to `open` is from −32,767 to 32,767, and a width or a height from 1 to 32,767, one below 1 being 1 (§12). What a new window shows before a pixmap is shown in it is not stated.

`showArea` reads the pixmap's format and whether it is attached to the backend with `pixmap_info_/2`, attaches it with `pixmap_attach/1` where it is not, and draws the rectangle with `pixmap_draw/8`. A pixmap is attached by the first `show` or `showArea` that shows it and stays attached while it lives.

The rectangle `showArea` shows is cut to the pixmap's clip, the cut moving its place in the window with it, and to the first 32,767 columns and rows, beyond which no window reaches. The pixmap's pixel at `x + i`, `y + j` is drawn at the window's pixel at `x + i`, `y + j`, and a pixel outside the window is not drawn. `show` is `showArea` of the rectangle at `0`, `0` of the pixmap's width and height.

`show` and `showArea` answer once the backend has the request, before the pixels are on the screen, and the backend draws the requests in the order it takes them, each on the screen without a sync. The backend reads the pixmap's pixels when it draws them, so that a write made after `show` answered may be shown, and, since epx takes no lock, a write half done may be seen (§2). A pixmap may be shown in a window by any process that holds both.

The backend draws each request into a copy of the window kept off the screen, `use_off_screen` as epx starts it, and copies the copy to the screen whole. A row shown at a time is so seen without flicker, and a window covered and uncovered keeps its picture.

`close` takes the window off the screen, and nothing brings it back. A window closed is epx's until no process holds it: a `show` into it draws into it off the screen, where nothing is seen, and a second `close` does nothing. An `open` after a `close` makes a new window.

No function sends the backend a sync, which epx answers with a message to the process that made the window. The window's close button is sent to that process all the same, as `{epx_event, Window, close}`, whatever the window's flags (`epx_bugs.md` 16), and the window stays on the screen.

The message is of no Ernest type: a `receive` whose patterns each name a constructor leaves it in the mailbox, and one whose pattern is a variable takes it as a message of the mailbox's type. A program opens a window in a process that receives nothing, or whose patterns each name a constructor.

Where no display can be opened, `DISPLAY` unset or naming no X server, epx's application starts with no backend, and `open` faults (§12). Where `DISPLAY` is unset, epx tries the framebuffer, `/dev/fb0`, first, and what a window on the framebuffer shows is not stated.

The copy off the screen takes four bytes a pixel of the X server's memory, and a window whose copy the server cannot allocate shows nothing. Each request costs the backend a copy of the whole window to the screen and a round trip to the X server: requests made faster than the backend draws them wait in epx's queue, and are drawn after the program has gone on.

`make test` runs with or without a display, and no test opens a window. §12's refusals come before epx is called and are tested, those of `show` and `showArea` on a window `window_create/4` makes with no display; the rest of this section and of §12 is tried by hand before a release (`release.md`).

## 12. What the window functions fault

An argument the library refuses faults the calling process before epx is called (report §7.4), as §5's do:

- a coordinate given to `open` outside −32,767 to 32,767: `Fault("a window's coordinate is beyond 32767")`;
- a width or a height given to `open` above 32,767: `Fault("a window's width or height is beyond 32767")`;
- a coordinate given to `showArea` outside −16,777,216 to 16,777,216: `Fault("a coordinate is beyond 16777216")`, and a width or a height above 16,777,216: `Fault("a width or height is beyond 16777216")`;
- a pixmap in `Rgba` or `Abgr`, given to `show` or `showArea`: `Fault("a window shows no pixmap in Rgba or Abgr")` (`epx_bugs.md` 18).

`open` where no display can be opened faults with epx's cause, `Fault("foreign function epx:window_attach/1 raised error:badarg")` (`epx_bugs.md` 21), and where tree_db, which epx's application depends on, is not on the load path, with epx's cause from `epx:start/0`, a `badmatch` naming `tree_db.app`.

Two processes that make the first `show` of one pixmap at once may each find it not attached, and the second to attach it faults with `Fault("foreign function epx:pixmap_attach/1 raised error:badarg")`; a program shows a pixmap from one process before others show it. `show` and `showArea` fault as `Epx.format` does on a pixmap that foreign code made in a format `Format` does not name (§5). Nothing else faults.

## Glossary

The names that recur across modules, one for each concept, in every module. A name the report states takes the report's; the names of the glossary of Ernest's `guide/style.md` hold here too.

- **pixmap**: a rectangle of pixels held by epx, of type `Pixmap` (§2); many are `pixmaps`. Not `image`, `bitmap`, `canvas`, `pm`.
- **color**: a `Color`, four channels (§3). Not `pixel` for the value, nor `c`, `col`.
- **channel**: one of a color's four values, `alpha`, `red`, `green` or `blue`, from 0 to 255 (§3). Not `component`.
- **format**: a `Format`, the order of a pixel's bytes (§3). Not `pixelFormat`, `fmt`.
- **source, target**: the pixmap a function of two reads and the one it writes; their rectangles' corners are `sourceX`, `sourceY`, `targetX` and `targetY`. Not `src`, `dst`, `destination`.
- **clip**: a pixmap's clip (§4). Not `clipRect`.
- **function, operation**: one of the library's functions, `fill` or `copyArea` (§1), and an `Operation`, one of epx's ways of combining two pixels (§3). Not `operation` for a function.
- **context**: epx's graphics context, a `Context` (§7), which `Epx.Gc` makes, sets and reads; many are `contexts`. Not `gc`, `graphicsContext`: `Gc` is the module's name alone.
- **style**: a `Style`, how a drawing function writes a pixel in a color (§8). Not `flags`, `mode`.
- **fill**: what a rectangle, an ellipse or a triangle holds within its border or its edges, and the two keys it is drawn by, the fill's style and color (§9). Not `interior`, `body`.
- **border**: the edge of a rectangle or an ellipse, within it, and the three keys it is drawn by, the border's style, color and width (§9). Not `outline`, `stroke`, `frame`.
- **line**: what `drawLine` draws, and the two keys a line, a point and a triangle's edges are drawn by beside the foreground, the line's style and width (§9). Not `stroke`, `pen`.
- **window**: a window on the screen, of type `Window` in `Epx`, in which a pixmap is shown, and `Epx.Window`, the module of its functions, one name for the two (§11); many are `windows`. Not `win`, `view`, `frame`, `display`, `screen`.
