# Design

How the program is arranged, stated as rules: its processes and what each owns, its types, what each module owns, and the glossary of its names. This is the program's normative document; where the code and this differ, this is corrected first, then the log, then the code (CLAUDE.md, *Before code*). Each section has a test whose comment names it.

## 1. What the library does

The library is one module, `Epx`, over the pixmaps of epx, the pixel library for Erlang. It makes a pixmap, fills, reads and writes it pixel by pixel and in rectangles, copies, scales and blends one into another, and writes one as a PPM file. It draws no line or shape, opens no window and reads no event. It starts no process and holds no Erlang of its own.

Each operation calls the epx functions the table below names, each at most once. Where one function does the operation's work exactly, the operation is a `foreign fn` over it, and where it differs, Ernest closes the difference around the call.

The differences closed are these, each stated where its rule is (§2 to §5): a `Color` crosses as the tuple epx takes, and a `Format` or an `Operation` as its atom; epx's `ok` is `Unit`; a precondition of §5 is checked before the call; a new pixmap is filled; and an empty rectangle is read without epx.

| Operation | epx | What it does |
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
| `toPpm(pixmap)` | none | the pixmap as a PPM file (§6) |

## 2. Pixmaps

A pixmap is a rectangle of pixels held by epx outside any process. Its width, its height and its format are fixed when it is made. Every pixel of a new pixmap is 0 in every channel its format holds.

A pixmap is not a value. An operation that writes it changes it in place, and every process that holds it sees the change, a process it was sent to or that captured it among them. Nothing orders the writes of two processes but the order in which they run. `copy` makes a new pixmap, which shares nothing with the first.

A pixmap lives while a process holds it, and the host frees it once none does; there is no `close`. A pixmap is bound to the node that made it (report §3.8, §3.11).

The library starts no process, and no operation receives or names a mailbox (report Appendix E.0 shape rule 5).

## 3. The types

```
export foreign type Pixmap

export type Format = Argb | Rgba | Abgr | Bgra | Rgb | Bgr

export type Color = Color(alpha : Int, red : Int, green : Int, blue : Int)

export type Operation = Clear | Src | Dst | SrcOver | DstOver | SrcIn | DstIn | SrcOut | DstOut
                      | SrcAtop | DstAtop | Xor | Copy | Add | Sub | SrcBlend | DstBlend
```

`Pixmap` is epx's pixmap, which the host compares exactly (report §3.10).

A `Format` names the order of a pixel's bytes, one byte a channel: `Argb` is alpha, red, green and blue, and each other format the channels its name lists in that order. `Rgb` and `Bgr` hold no alpha and take three bytes a pixel, and the other four take four. A pixel of a format without alpha is read with alpha 255, and the alpha it is written with is dropped. A `Format` crosses to epx as the atom of its name in lower case, `argb`.

A `Color` is four channels, each from 0 to 255, alpha 255 being opaque and 0 transparent. It crosses to epx as `{Alpha, Red, Green, Blue}`, and a pixel epx answers crosses back the same way. A channel is stored as it is given, not multiplied by its alpha. `rgb(red, green, blue)` is the color of those channels and alpha 255.

An `Operation` is one of epx's seventeen ways of combining a pixel of the source with a pixel of the target, crossing as the atom of its name in lower case with `_` between its words, `src_over`. What each does is its constructor's doc block.

## 4. Coordinates and the clip

A pixel is at `x`, `y`, where `0`, `0` is the top left pixel, `x` grows to the right and `y` downward. A rectangle is its top left pixel, its width and its height. A coordinate is an `Int` the host holds in 32 bits with a sign, and a width or a height one it holds in 32 bits without.

Each pixmap has a clip, a rectangle within it, which is the whole pixmap when the pixmap is made or copied. `setClip` sets the clip to the part of its rectangle within the pixmap, which may be empty.

The clip bounds what an operation writes, and what `getPixel` reads:

- `putPixel`, `putPixels`, `fillArea`, `scale` and the five area operations, `copyArea`, `blendArea`, `fadeArea`, `shadowArea` and `operationArea`, write only within the target's clip, and the area operations read only within the source's.
- `getPixel` answers opaque black, `Color(alpha = 255, red = 0, green = 0, blue = 0)`, for a point outside the clip, and for one outside the pixmap.
- `fill`, `flip`, `copyTo` and `getPixels` do not read the clip.

A rectangle that reaches outside what an operation reads or writes is cut to the part within it, and one wholly outside is empty. In an area operation the source's pixel at `sourceX + i`, `sourceY + j` goes to the target's at `targetX + i`, `targetY + j`, and a pixel outside the target's clip is left out. A source rectangle that begins left of or above the source's clip is cut to the clip and lands at `targetX`, `targetY` all the same, as epx has it (`epx_bugs.md` 6): a program begins the source's rectangle within the clip. `getPixels` answers the bytes of the part of its rectangle within the pixmap, row by row from the top. A rectangle of width 0 and height 0 has no pixels, and `getPixels` answers no bytes for it.

## 5. What faults

An argument the library refuses faults the calling process before epx is called (report §7.4):

- a `Color` with a channel outside 0 to 255, given to `fill`, `fillArea` or `putPixel`: `Fault("a channel of a Color is outside 0 to 255")`;
- an `alpha` outside 0 to 255, given to `blendArea`: `Fault("the alpha is outside 0 to 255")`;
- a `fade` outside 0 to 255, given to `fadeArea`: `Fault("the fade is outside 0 to 255")`;
- bytes given to `putPixels` that are not `width` times `height` pixels in the format, where the width and the height are 0 or more: `Fault("the bytes are not width times height pixels in the format")`.

An argument epx refuses faults as a foreign function that raises does, with epx's function in the cause: `Fault("foreign function epx:pixmap_create/3 raised error:badarg")` (report §7.4). epx refuses a negative width or height, and a coordinate, a width or a height the host does not hold as §4 says. `format` faults with `Fault("the pixmap's format is none of Format's")` on a pixmap that foreign code made in another format.

Nothing else faults. A read outside the pixmap or its clip answers as §4 says, and a write outside the clip writes nothing.

## 6. The PPM writer

`toPpm(pixmap)` answers the pixmap as a PPM file in its binary form, `P6`: the text `P6`, a line feed, the width and the height in decimal with a space between them, a line feed, `255` and a line feed, and then the pixels, row by row from the top, each as its red, green and blue bytes. A pixel's alpha is dropped and its color channels are written as they are.

## Glossary

The names that recur across modules, one for each concept, in every module. A name the report states takes the report's; the Ernest names of [`style.md`](style.md)'s glossary hold here too.

- **pixmap**: a rectangle of pixels held by epx, of type `Pixmap` (§2); many are `pixmaps`. Not `image`, `bitmap`, `canvas`, `pm`.
- **color**: a `Color`, four channels (§3). Not `pixel` for the value, nor `c`, `col`.
- **channel**: one of a color's four values, `alpha`, `red`, `green` or `blue`, from 0 to 255 (§3). Not `component`.
- **format**: a `Format`, the order of a pixel's bytes (§3). Not `pixelFormat`, `fmt`.
- **source, target**: the pixmap an operation of two reads and the one it writes; their rectangles' corners are `sourceX`, `sourceY`, `targetX` and `targetY`. Not `src`, `dst`, `destination`.
- **clip**: a pixmap's clip (§4). Not `clipRect`.
