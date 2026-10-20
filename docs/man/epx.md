# Ernest module Epx

*Since 0.1.0.*

Pixmaps, rectangles of pixels held outside any process, made, read,
written, copied, scaled and blended over epx, the pixel library for
Erlang.

Use it where a program makes a picture pixel by pixel or a rectangle at
a time: a pixmap is changed in place, where a `Bytes` would be made
again at each change. A picture kept as a value is the bytes `getPixels`
answers, or the file `toPpm` writes.

A program puts the library's build on its load path when it is compiled
and when it is run, and epx's `ebin` directory when it is run; epx finds
its NIF in the `priv` directory beside its `ebin`. Run without epx's
`ebin`, a call faults with a cause such as `foreign function
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
16777216`. A pixmap's bytes are its row's bytes times its height, a
row's bytes being its width times its format's bytes a pixel, rounded up
to a multiple of 16; `create` faults on a pixmap whose bytes reach 2
GiB, with the cause `the pixmap's bytes reach 2 GiB`.

**The clip.** Each pixmap has a clip, a rectangle within it, which is
the whole pixmap until `setClip` sets another. `putPixel`, `putPixels`,
`fillArea`, `scale`, `copyArea` and the blends, `blendArea`,
`fadeArea`, `shadowArea` and `operationArea`, write only within the
target's clip; `copyArea` and the blends read only within the source's;
and `getPixel` answers opaque black outside it. `fill`, `flip`, `copyTo`
and `getPixels` do not read it. `scale` reads the source's clip, and
what it writes from a source whose clip is not the whole pixmap is not
stated: set the source's clip to the whole pixmap first.

**Rectangles.** A rectangle that reaches outside what a function reads
or writes is cut to the part within it. The exception is a source
rectangle that begins left of or above the source's clip: it is cut to
the clip and lands at the target's corner all the same, as `copyArea`
shows.

**Colors.** A `Color` is four channels from 0 to 255, alpha 255 being
opaque. A function given a channel outside that range faults, with the
cause `a channel of a Color is outside 0 to 255`.

**A call's cost.** A call runs on the host's scheduler until it ends,
and nothing else runs on that scheduler meanwhile. Most calls end at
once; `create`, `scale` and `toPpm` of a large pixmap do not, and
`scale` of an 8192 by 8192 pixmap holds its scheduler for seconds.

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

A picture written to a file as PPM, which an image viewer opens:

```ernest
{
    let pixmap = Epx.create(64, 64, Epx.Rgb);
    Epx.fill(pixmap, Epx.rgb(255, 255, 255));
    Fs.write(Path("white.ppm"), Epx.toPpm(pixmap), 5000)
}
```

## See also

`Bytes` for the pixels held as a value.

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
rectangle at the top left of both, as wide as the narrower and as high
as the lower. Neither clip is read.

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
blended. A pixel outside the target's clip is left out. The source and
the target may be one pixmap, the two rectangles overlapping.

A rectangle that begins left of or above the source's clip is cut to the
clip, and what remains lands at `targetX`, `targetY` all the same, short
of its place by what was cut: a row copied from `sourceX` -1 to
`targetX` 1 puts the source's pixel 0 at the target's 1, where its place
is 2. Begin the source's rectangle within its clip.

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

A row that begins left of the source's clip, its pixel 0 landing at the
target's 1 and not at its 2:

```ernest
{
    let source = Epx.create(2, 1, Epx.Rgb);
    let target = Epx.create(4, 1, Epx.Rgb);
    Epx.putPixels(source, 0, 0, 2, 1, Epx.Rgb, <<1, 1, 1, 2, 2, 2>>);
    Epx.copyArea(source, target, -1, 0, 1, 0, 3, 1);
    Epx.getPixels(target, 0, 0, 4, 1)
}
// => <<0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0>>
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

Generated by ern 0.4.0 from epx.ern.
