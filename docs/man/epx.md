# Ernest module Epx

*Since 0.1.0.*

Pixmaps, rectangles of pixels held outside any process, made, read,
written, drawn into, copied, scaled, scrolled and blended over epx, the
pixel library for Erlang.

Use it where a program makes a picture pixel by pixel or a rectangle at
a time: a pixmap is changed in place, where a `Bytes` would be made
again at each change. A picture kept as a value is the bytes `getPixels`
answers, or the bytes of a PPM file that `toPpm` answers, which a
program writes with `Fs.write`.

A program puts the library's build on its load path when it is compiled
and when it is run, and epx's `ebin` directory when it is run, with
tree_db's beside it where it opens a window (`Epx.Window`); epx finds its
NIF in the `priv` directory beside its `ebin`. Run without epx's `ebin`,
a call faults with a cause such as `foreign function
epx:pixmap_create/3 raised error:undef`.

**A pixmap's life.** A pixmap lives while a process holds it, and the
host frees it once none does: there is no `close`. Its width, its height
and its format are fixed when it is made, and every pixel of a new
pixmap is 0 in every channel. It stays on the node that made it.

**In place and shared.** A pixmap is not a value. `fill`, `putPixel` and
every other function that writes change it in place, and every process
that holds it sees the change: a pixmap sent in a message, or captured
by a spawned function, is the same pixmap there. Nothing orders the
writes of two processes but the order in which they run, and epx takes
no lock: two calls on one pixmap from two processes may interleave pixel
by pixel, and a read may see a write half done. `copy` makes a pixmap
that shares nothing with the first.

**Coordinates.** A pixel is at `x`, `y`, where `0`, `0` is the top left
pixel, `x` grows to the right and `y` downward. A rectangle is its top
left pixel, its width and its height. A width or a height below 0 is 0,
and a rectangle of width 0 or of height 0 has no pixels: a function
reads and writes nothing of it.

**Bounds.** A coordinate is from -16777216 to 16777216, and a width or a
height at most 16777216. A function given a coordinate outside that
range faults, with the cause `a coordinate is beyond 16777216`, and one
given a larger width or height with `a width or height is beyond
16777216`; a scroll's amount and a rounded rectangle's radius have the
same bounds, each with a cause of its own, `a scroll's amount is beyond
16777216` and `a radius is beyond 16777216`.

A pixmap's bytes are its row's bytes times its height, a row's bytes
being its width times its format's bytes a pixel, rounded up to a
multiple of 16; `create` faults on a pixmap whose bytes reach 2 GiB,
with the cause `the pixmap's bytes reach 2 GiB`.

**The clip.** Each pixmap has a clip, a rectangle within it, which is
the whole pixmap until `setClip` sets another.
`putPixel`, `putPixels`, `fillArea`, `scale`, `copyArea` and the blends,
`blendArea`, `fadeArea`, `shadowArea` and `operationArea`, write only
within the target's clip; `copyArea` and the blends read only within
the source's; and `getPixel` answers opaque black outside it. `fill`,
`flip`, `copyTo`, `scroll` and `getPixels` do not read it. `scale` reads
the source's clip, and what it writes from a source whose clip is not
the whole pixmap is not stated: set the source's clip to the whole
pixmap first.

**Rectangles.** A rectangle that reaches outside what a function reads
or writes is cut to the part within it, and each pixel that remains
lands at its place.

**Colors.** A `Color` is four channels from 0 to 255, alpha 255 being
opaque. A function given a channel outside that range faults, with the
cause `a channel of a Color is outside 0 to 255`.

**Drawing.** `drawPoint`, `drawLine`, `drawRectangle`, `drawEllipse`,
`drawRoundedRectangle`, `drawTriangle` and `drawPolygon` draw into a
pixmap with a `Context`, which holds the colors, the styles and the
widths they draw with, and which `Epx.Gc` makes, sets and reads. Each
writes only within the clip, and its doc block names the keys of the
context it reads.

**A call's cost.** A call runs on the host's scheduler until it ends,
and nothing else runs on that scheduler meanwhile. Most calls end at
once; one that touches each pixel of a large pixmap or rectangle does
not: `create`, `copy`, `fill`, `copyTo`, `flip`, `scroll`, `scale` and
`toPpm` of a large pixmap, and `fillArea`, `getPixels`, `putPixels`,
`copyArea` and the blends of a large rectangle. `scale` of an 8192 by
8192 pixmap holds its scheduler for seconds. A drawing function traces
its shape whole, the part outside the pixmap among it: a triangle with
its corners at the coordinates' bounds holds its scheduler for a fifth
of a second. A filled polygon scans each row of its height, within the
clip or not, and one from the coordinates' top bound to their bottom
holds its scheduler for about three seconds.

## Examples

A pixmap filled, a pixel set, and the pixel read back:

```ernest
{
    let pixmap = Epx.create(4, 3, Epx.Argb);
    Epx.fill(pixmap, Epx.rgb(0, 0, 255));
    Epx.putPixel(pixmap, 1, 2, Epx.rgb(255, 0, 0));
    Epx.getPixel(pixmap, 1, 2)
}
// => Color(alpha = 255, red = 255, green = 0, blue = 0)
```

A rectangle drawn on white with a border two pixels wide, and a pixel
of its border beside one of its fill read back, the context's colors
epx's defaults:

```ernest
{
    let pixmap = Epx.create(8, 8, Epx.Rgb);
    Epx.fill(pixmap, Epx.rgb(255, 255, 255));
    let context = Epx.Gc.create();
    Epx.Gc.setBorderWidth(context, 2);
    Epx.drawRectangle(pixmap, context, 1, 1, 6, 6);
    Epx.getPixels(pixmap, 2, 3, 2, 1)
}
// => <<0, 0, 0, 255, 0, 0>>
```

A picture written to a file as PPM, which an image viewer opens:

```ernest
{
    let pixmap = Epx.create(64, 64, Epx.Rgb);
    Epx.fill(pixmap, Epx.rgb(255, 255, 255));
    Fs.write(Path("white.ppm"), Epx.toPpm(pixmap), 5000)
}
```

## See also

`Epx.Gc` for the context the drawing functions draw with, `Epx.Window`
for a window that shows a pixmap on the screen, and `Bytes` for the
pixels held as a value.

## Epx.Pixmap

```ernest
foreign type Pixmap
```

A rectangle of pixels held by epx outside any process, changed in place
and shared by every process that holds it.

### Examples

```ernest
Epx.create(640, 480, Epx.Argb)
```

## Epx.Format

```ernest
type Format = Argb | Rgba | Abgr | Bgra | Rgb | Bgr
```

The order of a pixel's bytes, one byte a channel, in which `getPixels`
answers them and `putPixels` reads them. `Rgb` and `Bgr` hold no alpha:
a pixel of either is read with alpha 255, and the alpha it is written
with is dropped. `Rgb` is this format, and `rgb` the function that makes
an opaque `Color`.

### Examples

```ernest
Epx.format(Epx.create(1, 1, Epx.Rgb))
// => Rgb
```

- `Argb`: Alpha, red, green and blue, four bytes a pixel.
- `Rgba`: Red, green, blue and alpha, four bytes a pixel.
- `Abgr`: Alpha, blue, green and red, four bytes a pixel.
- `Bgra`: Blue, green, red and alpha, four bytes a pixel.
- `Rgb`: Red, green and blue, three bytes a pixel.
- `Bgr`: Blue, green and red, three bytes a pixel.

## Epx.Color

```ernest
type Color = Color(alpha : Int, red : Int, green : Int, blue : Int)
```

A color as four channels, each from 0 to 255. A channel is stored as it
is given, not multiplied by the alpha.

### Examples

```ernest
Epx.Color(alpha = 128, red = 255, green = 0, blue = 0)
// => Color(alpha = 128, red = 255, green = 0, blue = 0)
```

- `Color`
  - `alpha : Int`: How opaque the color is: 255 is opaque and 0 transparent.
  - `red : Int`: The red channel.
  - `green : Int`: The green channel.
  - `blue : Int`: The blue channel.

## Epx.Operation

```ernest
type Operation =
    Clear
  | Src
  | Dst
  | SrcOver
  | DstOver
  | SrcIn
  | DstIn
  | SrcOut
  | DstOut
  | SrcAtop
  | DstAtop
  | Xor
  | Copy
  | Add
  | Sub
  | SrcBlend
  | DstBlend
```

How `operationArea` combines a pixel of the source with the pixel of
the target it falls on, giving the target's new pixel. Below, a channel
scaled by an alpha `a` is the channel times `a / 256`, and one pixel
blended into another by `a` has each channel of the other moved `a /
256` of the way to the first's, each rounded down.

An opaque source is scaled and blended by 255 / 256, not by 1, so that
it may come out one short of itself, a channel of 200 as 199 under
`Src`; `Copy` writes it exactly.

### Examples

```ernest
Epx.SrcOver
// => SrcOver
```

- `Clear`: Transparent black, whatever the two pixels.
- `Src`: The source, its color channels scaled by its alpha.
- `Dst`: The target, its color channels scaled by its alpha.
- `SrcOver`: The source over the target: the source's color blended by its alpha
into the target's, whose color channels are first scaled by its alpha,
and the target's alpha moved toward 255 by the source's.
- `DstOver`: The target over the source, as `SrcOver` with the two swapped.
- `SrcIn`: The source where the target is: its alpha the source's scaled by the
target's, and the source's color channels scaled by that alpha.
- `DstIn`: The target where the source is, as `SrcIn` with the two swapped.
- `SrcOut`: The source where the target is not: its alpha the source's scaled by
255 less the target's, and the source's color channels scaled by that
alpha.
- `DstOut`: The target where the source is not, as `SrcOut` with the two swapped.
- `SrcAtop`: The source atop the target: the target's alpha, and the source's color
blended by its alpha into the target's, both first scaled by the
target's alpha.
- `DstAtop`: The target atop the source, as `SrcAtop` with the two swapped.
- `Xor`: The source where the target is not, and the target where the source
is not: its alpha the two alphas summed less twice their product
divided by 256, rounded down; and its color the source's color
channels scaled by 255 less the target's alpha, blended by the
source's alpha into the target's color channels scaled by the
target's alpha.
- `Copy`: The source as it is, its alpha among its channels.
- `Add`: Each channel, alpha among them, the source's and the target's summed,
255 at most.
- `Sub`: Each channel, alpha among them, the source's less the target's, 0 at
least.
- `SrcBlend`: The source blended into the target by the source's alpha, alpha among
the channels blended.
- `DstBlend`: The target blended into the source by the target's alpha, as
`SrcBlend` with the two swapped.

## Epx.Backfill

```ernest
type Backfill = Wrapped | Filled(Color)
```

*Since 0.2.0.*

What `scroll` leaves in the part of the target its shift uncovers.

### Examples

```ernest
Epx.Filled(Epx.rgb(0, 0, 0))
// => Filled(Color(alpha = 255, red = 0, green = 0, blue = 0))
```

- `Wrapped`: The pixels shifted out of the other side, the shift taken modulo the
common area's width and height.
- `Filled`: The color, in the part uncovered, which is the whole area where the
shift reaches its width or its height.

## Epx.Context

```ernest
foreign type Context
```

*Since 0.2.0.*

A graphics context: the colors, the styles and the widths the drawing
functions draw with, held by epx outside any process, changed in place
and shared by every process that holds it. `Epx.Gc` makes one, and sets
and reads its keys.

### Examples

```ernest
Epx.Gc.create()
```

## Epx.Window

```ernest
foreign type Window
```

*Since 0.2.0.*

A window on the screen, in which a pixmap is shown, held by epx outside
any process. The module `Epx.Window` opens one, shows a pixmap in it and
closes it.

### Examples

```ernest
Epx.Window.open(0, 0, 640, 480)
```

## Epx.create

```ernest
Epx.create(width : Int, height : Int, format : Format) : Pixmap
```

A new pixmap of that width, height and format, every pixel 0 in every
channel: transparent black, which a format without alpha reads as
opaque black. Its clip is the whole pixmap. A width or a height below 0
is 0. Making it writes every pixel once.

### Errors

Faults on a width or a height above 16777216, with the cause `a width
or height is beyond 16777216`, and on a pixmap whose bytes, its row's
bytes times its height, reach 2 GiB, with the cause `the pixmap's bytes
reach 2 GiB`. Faults where the host cannot allocate the pixels, with
epx's cause: `foreign function epx:pixmap_create/3 raised error:badarg`.

### Examples

```ernest
{
    let pixmap = Epx.create(3, 2, Epx.Argb);
    #(Epx.width(pixmap), Epx.height(pixmap), Epx.getPixel(pixmap, 0, 0))
}
// => #(3, 2, Color(alpha = 0, red = 0, green = 0, blue = 0))
```

## Epx.copy

```ernest
Epx.copy(pixmap : Pixmap) : Pixmap
```

A new pixmap of the same width, height, format and pixels, which shares
nothing with the first. Its clip is the whole pixmap, whatever the
first's.

### Errors

Faults where the host cannot allocate the new pixmap's pixels, with
epx's cause: `foreign function epx:pixmap_copy/1 raised error:badarg`.

### Examples

```ernest
{
    let pixmap = Epx.create(1, 1, Epx.Argb);
    let copied = Epx.copy(pixmap);
    Epx.fill(pixmap, Epx.rgb(255, 255, 255));
    Epx.getPixel(copied, 0, 0)
}
// => Color(alpha = 0, red = 0, green = 0, blue = 0)
```

## Epx.width

```ernest
Epx.width(pixmap : Pixmap) : Int
```

The pixmap's width, in pixels.

## Epx.height

```ernest
Epx.height(pixmap : Pixmap) : Int
```

The pixmap's height, in pixels.

## Epx.format

```ernest
Epx.format(pixmap : Pixmap) : Format
```

The pixmap's format.

### Errors

Faults on a pixmap that foreign code made in a format `Format` does not
name, with the cause `the pixmap's format is none of Format's`.

## Epx.fill

```ernest
Epx.fill(pixmap : Pixmap, color : Color) : Unit
```

Sets every pixel of the pixmap to the color. The clip is not read.

### Errors

Faults on a color with a channel outside 0 to 255, with the cause `a
channel of a Color is outside 0 to 255`.

## Epx.fillArea

```ernest
Epx.fillArea(pixmap : Pixmap, x : Int, y : Int, width : Int, height : Int, color : Color) : Unit
```

Sets every pixel of the rectangle at `x`, `y` to the color, within the
clip; the rest of the rectangle is left as it was.

### Errors

Faults on a color with a channel outside 0 to 255, with the cause `a
channel of a Color is outside 0 to 255`. Faults on a coordinate outside
-16777216 to 16777216, with the cause `a coordinate is beyond
16777216`, and on a width or a height above 16777216, with the cause `a
width or height is beyond 16777216`.

### Examples

```ernest
{
    let pixmap = Epx.create(3, 1, Epx.Rgb);
    Epx.fillArea(pixmap, 1, 0, 9, 9, Epx.rgb(255, 255, 255));
    Epx.getPixels(pixmap, 0, 0, 3, 1)
}
// => <<0, 0, 0, 255, 255, 255, 255, 255, 255>>
```

## Epx.getPixel

```ernest
Epx.getPixel(pixmap : Pixmap, x : Int, y : Int) : Color
```

The color of the pixel at `x`, `y`, or opaque black, `Color(alpha =
255, red = 0, green = 0, blue = 0)`, where the point is outside the clip
or outside the pixmap. A pixel of a format without alpha is read with
alpha 255.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`.

### Examples

```ernest
Epx.getPixel(Epx.create(2, 2, Epx.Rgb), 5, 5)
// => Color(alpha = 255, red = 0, green = 0, blue = 0)
```

## Epx.putPixel

```ernest
Epx.putPixel(pixmap : Pixmap, x : Int, y : Int, color : Color) : Unit
```

Sets the pixel at `x`, `y` to the color. A point outside the clip is
left as it was.

### Errors

Faults on a color with a channel outside 0 to 255, with the cause `a
channel of a Color is outside 0 to 255`. Faults on a coordinate outside
-16777216 to 16777216, with the cause `a coordinate is beyond
16777216`.

## Epx.getPixels

```ernest
Epx.getPixels(pixmap : Pixmap, x : Int, y : Int, width : Int, height : Int) : Bytes
```

The pixels of the rectangle at `x`, `y`, row by row from the top, as
bytes in the pixmap's format. A rectangle that reaches outside the
pixmap answers the bytes of the part within it, and one wholly outside,
or with no pixels, answers none. The clip is not read. The bytes are a
value: a later write to the pixmap does not change them.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`. Faults
where the host cannot allocate the bytes, with epx's cause: `foreign
function epx:pixmap_get_pixels/5 raised error:badarg`.

### Examples

```ernest
{
    let pixmap = Epx.create(2, 2, Epx.Argb);
    Epx.fill(pixmap, Epx.rgb(1, 2, 3));
    #(Epx.getPixels(pixmap, 1, 1, 5, 5), Epx.getPixels(pixmap, 0, 0, 0, 0))
}
// => #(<<255, 1, 2, 3>>, <<>>)
```

## Epx.putPixels

```ernest
Epx.putPixels(pixmap : Pixmap, x : Int, y : Int, width : Int, height : Int, format : Format, bytes : Bytes) : Unit
```

Sets the pixels of the rectangle at `x`, `y` from the bytes, row by row
from the top, the bytes read in the format given and written in the
pixmap's. The part of the rectangle within the clip is written, and the
rest of the bytes is not read.

### Errors

Faults where the bytes are not `width` times `height` pixels in the
format, a width or a height below 0 being 0, with the cause `the bytes
are not width times height pixels in the format`. Faults on a
coordinate outside -16777216 to 16777216, with the cause `a coordinate
is beyond 16777216`, and on a width or a height above 16777216, with the
cause `a width or height is beyond 16777216`.

### Examples

```ernest
{
    let pixmap = Epx.create(2, 1, Epx.Argb);
    Epx.putPixels(pixmap, 0, 0, 2, 1, Epx.Rgb, <<1, 2, 3, 4, 5, 6>>);
    Epx.getPixel(pixmap, 1, 0)
}
// => Color(alpha = 255, red = 4, green = 5, blue = 6)
```

## Epx.copyTo

```ernest
Epx.copyTo(source : Pixmap, target : Pixmap) : Unit
```

Copies the source's pixels into the target, in the target's format: the
rectangle at the top left of both, as wide as the smaller width and as
high as the smaller height. Neither clip is read.

### Examples

```ernest
{
    let source = Epx.create(1, 1, Epx.Argb);
    let target = Epx.create(2, 1, Epx.Rgb);
    Epx.fill(source, Epx.rgb(7, 8, 9));
    Epx.copyTo(source, target);
    Epx.getPixels(target, 0, 0, 2, 1)
}
// => <<7, 8, 9, 0, 0, 0>>
```

## Epx.copyArea

```ernest
Epx.copyArea(source : Pixmap, target : Pixmap, sourceX : Int, sourceY : Int, targetX : Int, targetY : Int, width : Int, height : Int) : Unit
```

Copies the source's rectangle at `sourceX`, `sourceY` into the target at
`targetX`, `targetY`, in the target's format, its alpha copied and not
blended. A pixel outside the target's clip is left out, and one outside
the source's clip is not read, the rest landing at their places all the
same. The source and the target may be one pixmap, the two rectangles
overlapping.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`.

### Examples

```ernest
{
    let source = Epx.create(2, 1, Epx.Rgb);
    let target = Epx.create(3, 1, Epx.Rgb);
    Epx.putPixels(source, 0, 0, 2, 1, Epx.Rgb, <<1, 1, 1, 2, 2, 2>>);
    Epx.copyArea(source, target, 0, 0, 1, 0, 2, 1);
    Epx.getPixels(target, 0, 0, 3, 1)
}
// => <<0, 0, 0, 1, 1, 1, 2, 2, 2>>
```

A row that begins left of the source's clip, cut to it, the source's
pixel 0 landing at its place, the target's 2:

```ernest
{
    let source = Epx.create(2, 1, Epx.Rgb);
    let target = Epx.create(4, 1, Epx.Rgb);
    Epx.putPixels(source, 0, 0, 2, 1, Epx.Rgb, <<1, 1, 1, 2, 2, 2>>);
    Epx.copyArea(source, target, -1, 0, 1, 0, 3, 1);
    Epx.getPixels(target, 0, 0, 4, 1)
}
// => <<0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2, 2>>
```

## Epx.scale

```ernest
Epx.scale(source : Pixmap, target : Pixmap, width : Int, height : Int) : Unit
```

Scales the whole source to `width` by `height` pixels and writes it into
the target at its top left, within the target's clip. Scaled up, a
pixel is mixed from the source's pixels around its place; scaled down,
from those it covers. A width or a height of 0 or below writes nothing.
What it writes from a source whose clip is not the whole pixmap is not
stated: set the source's clip to the whole pixmap first.

### Errors

Faults on a width or a height above 16777216, with the cause `a width or
height is beyond 16777216`.

### Examples

```ernest
{
    let source = Epx.create(1, 1, Epx.Rgb);
    let target = Epx.create(2, 2, Epx.Rgb);
    Epx.fill(source, Epx.rgb(9, 9, 9));
    Epx.scale(source, target, 2, 2);
    Epx.getPixel(target, 1, 1)
}
// => Color(alpha = 255, red = 9, green = 9, blue = 9)
```

## Epx.flip

```ernest
Epx.flip(pixmap : Pixmap) : Unit
```

Reverses the order of the pixmap's rows in place, the top row becoming
the bottom one. The clip is not read.

### Examples

```ernest
{
    let pixmap = Epx.create(1, 2, Epx.Rgb);
    Epx.putPixel(pixmap, 0, 0, Epx.rgb(255, 255, 255));
    Epx.flip(pixmap);
    Epx.getPixels(pixmap, 0, 0, 1, 2)
}
// => <<0, 0, 0, 255, 255, 255>>
```

## Epx.scroll

```ernest
Epx.scroll(source : Pixmap, target : Pixmap, right : Int, down : Int, backfill : Backfill) : Unit
```

*Since 0.2.0.*

Writes the source's pixels into the target shifted `right` columns to
the right, or to the left where it is below 0, and `down` rows down, or
up where it is below 0, within the common area of the two: the smaller
width by the smaller height, from the top left of each. The target
outside it is left as it was, and a pixel is written in the target's
format. Neither clip is read.

The part of the common area the shift uncovers is as `backfill` says.
`Wrapped` writes there the pixels shifted out of the other side, the
shift taken modulo the common area's width and height, so that a shift
by a whole width or height copies the source as it is. A wrapped scroll
keeps the wrapped columns or rows in memory of their size meanwhile, and
where the host cannot allocate that memory it writes nothing.
`Filled(color)` fills the uncovered part with the color, the whole area
where the shift reaches its width or height.

The source and the target may be one pixmap. A scroll by 0 and 0 writes
nothing, into another pixmap too, and what a scroll between two pixmaps
by both amounts writes is not stated.

### Errors

Faults on an amount outside -16777216 to 16777216, with the cause `a
scroll's amount is beyond 16777216`, and on a color of `Filled` with a
channel outside 0 to 255, with the cause `a channel of a Color is
outside 0 to 255`.

### Examples

A row scrolled one pixel to the right, wrapped:

```ernest
{
    let pixmap = Epx.create(3, 1, Epx.Rgb);
    Epx.putPixels(pixmap, 0, 0, 3, 1, Epx.Rgb, <<1, 1, 1, 2, 2, 2, 3, 3, 3>>);
    Epx.scroll(pixmap, pixmap, 1, 0, Epx.Wrapped);
    Epx.getPixels(pixmap, 0, 0, 3, 1)
}
// => <<3, 3, 3, 1, 1, 1, 2, 2, 2>>
```

A column scrolled one pixel down into another pixmap, the top filled
white:

```ernest
{
    let source = Epx.create(1, 3, Epx.Rgb);
    let target = Epx.create(1, 3, Epx.Rgb);
    Epx.putPixels(source, 0, 0, 1, 3, Epx.Rgb, <<1, 1, 1, 2, 2, 2, 3, 3, 3>>);
    Epx.scroll(source, target, 0, 1, Epx.Filled(Epx.rgb(255, 255, 255)));
    Epx.getPixels(target, 0, 0, 1, 3)
}
// => <<255, 255, 255, 1, 1, 1, 2, 2, 2>>
```

## Epx.blendArea

```ernest
Epx.blendArea(source : Pixmap, target : Pixmap, alpha : Int, sourceX : Int, sourceY : Int, targetX : Int, targetY : Int, width : Int, height : Int) : Unit
```

Blends the source's rectangle into the target's by `alpha`: each color
channel of the target moves `alpha / 256` of the way to the source's,
rounded down. The source's alpha is not read, and the target keeps its
own. An alpha of 0 leaves the target as it was, and at 255 a channel
comes out one short of the source's where the target's was below it,
200 as 199; `copyArea` copies the source exactly.

The rectangles are placed and cut as `copyArea` places and cuts them,
and must not overlap in one pixmap: where they do, what is written is
not stated.

Where both pixmaps hold four bytes a pixel in one format and the
rectangle is 8 pixels wide or more, epx may blend with the machine's
vector instructions, whose result may differ by one from the one rounded
down.

### Errors

Faults on an alpha outside 0 to 255, with the cause `the alpha is
outside 0 to 255`. Faults on a coordinate outside -16777216 to 16777216,
with the cause `a coordinate is beyond 16777216`, and on a width or a
height above 16777216, with the cause `a width or height is beyond
16777216`.

### Examples

```ernest
{
    let source = Epx.create(1, 1, Epx.Argb);
    let target = Epx.create(1, 1, Epx.Argb);
    Epx.fill(source, Epx.rgb(200, 200, 200));
    Epx.fill(target, Epx.rgb(0, 0, 0));
    Epx.blendArea(source, target, 128, 0, 0, 0, 0, 1, 1);
    Epx.getPixel(target, 0, 0)
}
// => Color(alpha = 255, red = 100, green = 100, blue = 100)
```

## Epx.fadeArea

```ernest
Epx.fadeArea(source : Pixmap, target : Pixmap, fade : Int, sourceX : Int, sourceY : Int, targetX : Int, targetY : Int, width : Int, height : Int) : Unit
```

Blends the source's rectangle into the target's by the source's own
alpha scaled by `fade`: each channel of the target, alpha among them,
moves `a / 256` of the way to the source's, rounded down, where `a` is
the source's alpha times `fade / 256`, rounded down, and at a fade of
255 the source's alpha itself. A fade of 0 leaves the target as it was,
and one of 255 blends as `SrcBlend` does.

The rectangles are placed and cut as `copyArea` places and cuts them,
and must not overlap in one pixmap: where they do, what is written is
not stated.

Where both pixmaps hold four bytes a pixel in one format and the
rectangle is 8 pixels wide or more, epx may blend with the machine's
vector instructions, whose result may differ by one from the one rounded
down.

### Errors

Faults on a fade outside 0 to 255, with the cause `the fade is outside 0
to 255`. Faults on a coordinate outside -16777216 to 16777216, with the
cause `a coordinate is beyond 16777216`, and on a width or a height
above 16777216, with the cause `a width or height is beyond 16777216`.

### Examples

```ernest
{
    let source = Epx.create(1, 1, Epx.Argb);
    let target = Epx.create(1, 1, Epx.Argb);
    Epx.fill(source, Epx.Color(alpha = 128, red = 200, green = 200, blue = 200));
    Epx.fill(target, Epx.rgb(0, 0, 0));
    Epx.fadeArea(source, target, 255, 0, 0, 0, 0, 1, 1);
    Epx.getPixel(target, 0, 0)
}
// => Color(alpha = 191, red = 100, green = 100, blue = 100)
```

## Epx.shadowArea

```ernest
Epx.shadowArea(source : Pixmap, target : Pixmap, sourceX : Int, sourceY : Int, targetX : Int, targetY : Int, width : Int, height : Int) : Unit
```

Darkens the target by the source's rectangle: each channel of the
target, alpha among them, is multiplied by `(256 - l) / 256` and rounded
down, where `l` is the luminance of the source's pixel, `(299 * red +
587 * green + 114 * blue) / 1000`. A black source leaves the target as it
was, and a white one makes it transparent black. The source's alpha is
not read.

The rectangles are placed and cut as `copyArea` places and cuts them,
and must not overlap in one pixmap: where they do, what is written is
not stated.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`.

### Examples

```ernest
{
    let source = Epx.create(1, 1, Epx.Argb);
    let target = Epx.create(1, 1, Epx.Argb);
    Epx.fill(source, Epx.rgb(128, 128, 128));
    Epx.fill(target, Epx.rgb(100, 100, 100));
    Epx.shadowArea(source, target, 0, 0, 0, 0, 1, 1);
    Epx.getPixel(target, 0, 0)
}
// => Color(alpha = 127, red = 50, green = 50, blue = 50)
```

## Epx.operationArea

```ernest
Epx.operationArea(source : Pixmap, target : Pixmap, operation : Operation, sourceX : Int, sourceY : Int, targetX : Int, targetY : Int, width : Int, height : Int) : Unit
```

Combines the source's rectangle with the target's by the operation,
pixel by pixel, and writes the result into the target; `Operation` says
what each gives.

The rectangles are placed and cut as `copyArea` places and cuts them,
and must not overlap in one pixmap: where they do, what is written is
not stated.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`.

### Examples

```ernest
{
    let source = Epx.create(1, 1, Epx.Argb);
    let target = Epx.create(1, 1, Epx.Argb);
    Epx.fill(source, Epx.rgb(200, 0, 100));
    Epx.fill(target, Epx.rgb(100, 10, 200));
    Epx.operationArea(source, target, Epx.Add, 0, 0, 0, 0, 1, 1);
    Epx.getPixel(target, 0, 0)
}
// => Color(alpha = 255, red = 255, green = 10, blue = 255)
```

## Epx.setClip

```ernest
Epx.setClip(pixmap : Pixmap, x : Int, y : Int, width : Int, height : Int) : Unit
```

Sets the pixmap's clip to the part of the rectangle at `x`, `y` within
the pixmap, which may be empty. The clip of the whole pixmap is set
again with `setClip(pixmap, 0, 0, width(pixmap), height(pixmap))`.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`.

### Examples

```ernest
{
    let pixmap = Epx.create(2, 1, Epx.Rgb);
    Epx.setClip(pixmap, 0, 0, 1, 1);
    Epx.fillArea(pixmap, 0, 0, 2, 1, Epx.rgb(255, 255, 255));
    Epx.getPixels(pixmap, 0, 0, 2, 1)
}
// => <<255, 255, 255, 0, 0, 0>>
```

## Epx.drawPoint

```ernest
Epx.drawPoint(pixmap : Pixmap, context : Context, x : Int, y : Int) : Unit
```

*Since 0.2.0.*

Sets the pixel at `x`, `y` to the context's foreground, written by its
line's style. A point outside the clip is left as it was. It reads the
context's foreground and line style, and not its line's width.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`.

### Examples

```ernest
{
    let pixmap = Epx.create(2, 1, Epx.Rgb);
    Epx.drawPoint(pixmap, Epx.Gc.create(), 1, 0);
    Epx.getPixels(pixmap, 0, 0, 2, 1)
}
// => <<0, 0, 0, 0, 0, 255>>
```

## Epx.drawLine

```ernest
Epx.drawLine(pixmap : Pixmap, context : Context, x1 : Int, y1 : Int, x2 : Int, y2 : Int) : Unit
```

*Since 0.2.0.*

Draws the line from `x1`, `y1` to `x2`, `y2` in the context's
foreground, by its line's style, as wide as its line's width, within the
clip. It reads the context's foreground, line style and line width.

A line of width 0 draws nothing, and one of width 1 every pixel from one
end to the other, both ends among them where it is horizontal or
vertical; one that is neither leaves out its first pixel, `x1`, `y1`. A
horizontal or vertical line wider than 1 is the rectangle that runs from
one end of the line to the other and is the line's width across,
`width / 2` of its rows or columns above or left of the line, rounded
down. Any other line wider than 1 is a band centered on the line, and
which pixels it covers is not stated. `Antialiased` smooths a line of
width 1 that is neither horizontal nor vertical, and no other.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`.

### Examples

```ernest
{
    let pixmap = Epx.create(4, 3, Epx.Rgb);
    let context = Epx.Gc.create();
    Epx.Gc.setLineWidth(context, 3);
    Epx.drawLine(pixmap, context, 1, 0, 1, 2);
    Epx.getPixels(pixmap, 0, 1, 4, 1)
}
// => <<0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0>>
```

## Epx.drawRectangle

```ernest
Epx.drawRectangle(pixmap : Pixmap, context : Context, x : Int, y : Int, width : Int, height : Int) : Unit
```

*Since 0.2.0.*

Draws the rectangle at `x`, `y` within the clip: its border, the
outermost pixels of the rectangle, as many on each side as the
context's border's width, in its border's color by its border's style;
and its fill, the rest, in its fill's color by its fill's style. It
reads the context's fill style and color and its border style, color
and width.

With a fill, a border of width 0 is none. With no fill, the border alone
is drawn, one pixel wide where its width is 0. A border wider than the
rectangle's width or height writes nothing outside the rectangle. A
width or a height below 0 is 0, and a rectangle with no pixels draws
nothing.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`.

### Examples

A rectangle with no fill and a white border of width 0, drawn one
pixel wide:

```ernest
{
    let pixmap = Epx.create(3, 3, Epx.Rgb);
    let context = Epx.Gc.create();
    Epx.Gc.setFillStyle(context, None);
    Epx.Gc.setBorderColor(context, Epx.rgb(255, 255, 255));
    Epx.drawRectangle(pixmap, context, 0, 0, 3, 3);
    Epx.getPixels(pixmap, 0, 1, 3, 1)
}
// => <<255, 255, 255, 0, 0, 0, 255, 255, 255>>
```

## Epx.drawEllipse

```ernest
Epx.drawEllipse(pixmap : Pixmap, context : Context, x : Int, y : Int, width : Int, height : Int) : Unit
```

*Since 0.2.0.*

Draws the ellipse in the rectangle at `x`, `y` within the clip:
centered at `x + width / 2`, `y + height / 2`, its radii `width / 2`
and `height / 2`, each rounded down, so that it covers
`2 * (width / 2) + 1` columns and `2 * (height / 2) + 1` rows, one more
than an even width or height. An ellipse whose width or height is below 2 draws
nothing. It reads the context's fill style and color and its border
style, color and width.

Its border is the ring from its edge inward, the context's border's
width and one pixel across, both its edges drawn, in the border's color
by the border's style; its fill is within the ring, in the fill's color
by the fill's style. With a fill, a border of width 0 is none. With no
fill, the ring alone is drawn, one pixel across where the border's width
is 0. `Antialiased` smooths the edge of the fill.

A ring is malformed near the top and the bottom where the border's width
is 1 or 2, a pixel of it outside the ellipse and the fill showing
through below it, and at any border's width past a radius of 65535.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`.

### Examples

The ellipse 4 by 4 covers 5 columns:

```ernest
{
    let pixmap = Epx.create(6, 5, Epx.Rgb);
    Epx.drawEllipse(pixmap, Epx.Gc.create(), 0, 0, 4, 4);
    Epx.getPixels(pixmap, 0, 2, 6, 1)
}
// => <<255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0>>
```

## Epx.drawRoundedRectangle

```ernest
Epx.drawRoundedRectangle(pixmap : Pixmap, context : Context, x : Int, y : Int, width : Int, height : Int, radiusX : Int, radiusY : Int) : Unit
```

*Since 0.2.0.*

Draws the rectangle at `x`, `y` with rounded corners, within the clip:
each corner a quarter of an ellipse of radii `radiusX` and `radiusY`,
`radiusX` above `(width - 1) / 2`, rounded down, being that, and
`radiusY` above `(height - 1) / 2` likewise; with both radii 0 the
corners are square. It reads the context's fill style and color and its
border style, color and width.

Its border and its fill are a rectangle's, as `drawRectangle` draws
them, the border within the shape, except that the border is a row
thicker at the top and at the bottom than at the sides. A width, a
height or a radius below 0 is 0. A rounded rectangle of width or height
0 draws nothing, and one of width or height 1 is a line of pixels in the
border's color, or in the fill's where there is a fill and no border.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, on a width or a height above 16777216,
with the cause `a width or height is beyond 16777216`, and on a radius
above 16777216, with the cause `a radius is beyond 16777216`.

### Examples

The top row of a rounded rectangle of radii 2, its corners left out:

```ernest
{
    let pixmap = Epx.create(7, 7, Epx.Rgb);
    Epx.drawRoundedRectangle(pixmap, Epx.Gc.create(), 0, 0, 7, 7, 2, 2);
    Epx.getPixels(pixmap, 0, 0, 7, 1)
}
// => <<0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0>>
```

## Epx.drawTriangle

```ernest
Epx.drawTriangle(pixmap : Pixmap, context : Context, x1 : Int, y1 : Int, x2 : Int, y2 : Int, x3 : Int, y3 : Int) : Unit
```

*Since 0.2.0.*

Draws the triangle of corners `x1`, `y1`, `x2`, `y2` and `x3`, `y3`,
within the clip. With a fill, it is every pixel within the corners, its
edges among them, in the context's fill's color by its fill's style.
With no fill, it is its three edges, each a line from corner to corner
in the context's foreground by its line's style, one pixel wide where
the line's width is 0 or 1; where the width is above 1, which pixels the
edges cover is not stated. It reads the context's fill style and color,
and with no fill its foreground, line style and line width.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`.

### Examples

```ernest
{
    let pixmap = Epx.create(3, 3, Epx.Rgb);
    Epx.drawTriangle(pixmap, Epx.Gc.create(), 0, 0, 2, 0, 0, 2);
    Epx.getPixels(pixmap, 0, 1, 3, 1)
}
// => <<255, 0, 0, 255, 0, 0, 0, 0, 0>>
```

## Epx.drawPolygon

```ernest
Epx.drawPolygon(pixmap : Pixmap, context : Context, points : List(#(Int, Int))) : Unit
```

*Since 0.2.0.*

Draws the closed figure of the points, each joined to the next and the
last to the first, within the clip. With a fill, it is every pixel
within the figure by the even-odd rule, its edges among them, in the
context's fill's color by its fill's style. It reads the context's fill
style and color, and with no fill its foreground, line style and line
width.

With no fill, it is its edges, each a line from point to point in the
context's foreground by its line's style and width, one pixel wide where
the width is 0 or 1, as a triangle's edges are. An edge that is neither
horizontal nor vertical leaves out its upper end, the point of the
smaller `y`, whichever end the list names first.

A polygon of no points draws nothing. With a fill, one point is that
pixel and two points the line between them, both ends among them, in
the fill's color and one pixel wide whatever the line's width. With no
fill, one point is a line of no length, that pixel where the line's
width is at most 1, and two points the line between them, drawn as an
edge is. A filled polygon costs its height in rows, within the clip or
not.

### Errors

Faults on a coordinate of a point outside -16777216 to 16777216, with
the cause `a coordinate is beyond 16777216`.

### Examples

```ernest
{
    let pixmap = Epx.create(4, 4, Epx.Rgb);
    Epx.drawPolygon(pixmap, Epx.Gc.create(), [#(1, 1), #(2, 1), #(2, 2), #(1, 2)]);
    Epx.getPixels(pixmap, 0, 1, 4, 1)
}
// => <<0, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0>>
```

## Epx.rgb

```ernest
Epx.rgb(red : Int, green : Int, blue : Int) : Color
```

The opaque color of those channels, its alpha 255. Its channels are
checked where it is used, not here.

### Examples

```ernest
Epx.rgb(255, 128, 0)
// => Color(alpha = 255, red = 255, green = 128, blue = 0)
```

## Epx.toPpm

```ernest
Epx.toPpm(pixmap : Pixmap) : Bytes
```

The pixmap as a PPM file in its binary form, `P6`: the text `P6`, a line
feed, the width and the height in decimal with a space between them, a
line feed, `255` and a line feed, and then the pixels, row by row from
the top, each as its red, green and blue bytes. A pixel's alpha is
dropped, and its color channels are written as they are. It holds a
copy of the pixels, three bytes each, while it runs.

### Errors

Faults where the host cannot allocate the copy or the file's bytes,
with epx's cause: `foreign function epx:pixmap_create/3 raised
error:badarg` or `foreign function epx:pixmap_get_pixels/5 raised
error:badarg`.

### Examples

```ernest
Epx.toPpm(Epx.create(1, 1, Epx.Rgb)) == String.toUtf8("P6\n1 1\n255\n") <> <<0, 0, 0>>
// => true
```

---

Generated by ern 0.5.0 from src/epx.ern.
