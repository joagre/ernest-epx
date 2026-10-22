# Ernest module Epx.Gc

*Since 0.2.0.*

Graphics contexts, the colors, the styles and the widths `Epx`'s
drawing functions draw with, held outside any process over epx's
graphics context.

Use it to make the `Epx.Context` that `Epx.drawPoint`, `Epx.drawLine`,
`Epx.drawRectangle`, `Epx.drawEllipse` and `Epx.drawTriangle` take, and
to set what they draw with. It is in the library `Epx` is in, and a
program that has `Epx` on its load path has it.

**The keys.** A context has eight keys, each set by its setter and read
by its getter:

- the fill's style and color, which `drawRectangle`, `drawEllipse` and
  `drawTriangle` fill with; a fill style of `None` is no fill;
- the line's style and width, which `drawLine` draws with, `drawPoint`
  the style alone, and `drawTriangle` its edges where it has no fill;
- the border's style, color and width, which `drawRectangle` and
  `drawEllipse` draw their border with, within the shape;
- the foreground, the color of a point, a line and a triangle's edges.

**The defaults.** `create` makes a context of epx's defaults: a fill of
`Solid` in opaque red, a line of `Solid` one pixel wide, a border of
`Solid` in opaque black and of width 0, and an opaque blue foreground.

**In place and shared.** A context is not a value. A setter changes it
in place, and every process that holds it sees the change: a context
sent in a message, or captured by a spawned function, is the same
context there. A drawing function reads the keys it needs as it runs, so
that a key another process sets meanwhile is read before the change or
after it. `copy` makes a context that shares nothing with the first. A
context lives while a process holds it, and the host frees it once none
does: there is no `close`. It stays on the node that made it.

**Widths and colors.** A width below 0 is 0, and a setter given a width
above 16777216 faults, with the cause `a width or height is beyond
16777216`. A setter given a `Color` with a channel outside 0 to 255
faults, with the cause `a channel of a Color is outside 0 to 255`.

## Examples

A context set to draw a thick white line, the line drawn, and a column
read back across it:

```ernest
{
    let pixmap = Epx.create(5, 5, Epx.Rgb);
    let context = Epx.Gc.create();
    Epx.Gc.setForeground(context, Epx.rgb(255, 255, 255));
    Epx.Gc.setLineWidth(context, 3);
    Epx.drawLine(pixmap, context, 0, 2, 4, 2);
    Epx.getPixels(pixmap, 2, 0, 1, 5)
}
// => <<0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 0>>
```

A circle with a border and no fill, written to a file as PPM:

```ernest
{
    let pixmap = Epx.create(64, 64, Epx.Rgb);
    let context = Epx.Gc.create();
    Epx.Gc.setFillStyle(context, None);
    Epx.Gc.setBorderColor(context, Epx.rgb(255, 255, 255));
    Epx.Gc.setBorderWidth(context, 3);
    Epx.drawEllipse(pixmap, context, 2, 2, 60, 60);
    Fs.write(Path("circle.ppm"), Epx.toPpm(pixmap), 5000)
}
```

## See also

`Epx` for the pixmaps and the drawing functions.

## Epx.Gc.Style

```ernest
type Style = Solid | Blend | Antialiased
```

How a drawing function writes a pixel in a color. A context's line and
border each have one, and its fill an `Optional(Style)`, of which `None`
is no fill.

### Examples

```ernest
Epx.Gc.lineStyle(Epx.Gc.create())
// => Solid
```

- `Solid`: The color written as it is, its alpha among its channels.
- `Blend`: The color combined with the pixel as the operation `Epx.SrcBlend`
combines a source pixel with a target pixel: each channel of the
pixel, alpha among them, moves toward the color's by the color's
alpha, and an opaque color is written as it is.
- `Antialiased`: As `Blend`, and in a line one pixel wide that is neither horizontal nor
vertical, and along the edge of an ellipse's fill, a pixel the edge
passes through is blended by how near the edge passes to it.

## Epx.Gc.create

```ernest
Epx.Gc.create() : Epx.Context
```

A new context of epx's defaults: a fill of `Solid` in opaque red, a
line of `Solid` one pixel wide, a border of `Solid` in opaque black and
of width 0, and an opaque blue foreground.

### Errors

Faults where the host cannot allocate the context, with epx's cause:
`foreign function epx:gc_create/0 raised error:badarg`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    #(Epx.Gc.fillStyle(context), Epx.Gc.lineWidth(context), Epx.Gc.borderWidth(context))
}
// => #(Some(Solid), 1, 0)
```

## Epx.Gc.copy

```ernest
Epx.Gc.copy(context : Epx.Context) : Epx.Context
```

A new context with the same keys, which shares nothing with the first.

### Errors

Faults where the host cannot allocate the context, with epx's cause:
`foreign function epx:gc_copy/1 raised error:badarg`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    let copied = Epx.Gc.copy(context);
    Epx.Gc.setLineWidth(context, 5);
    #(Epx.Gc.lineWidth(context), Epx.Gc.lineWidth(copied))
}
// => #(5, 1)
```

## Epx.Gc.setFillStyle

```ernest
Epx.Gc.setFillStyle(context : Epx.Context, style : Optional(Style)) : Unit
```

Sets the style the context's fill is drawn by, `None` for no fill.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setFillStyle(context, Some(Epx.Gc.Blend));
    Epx.Gc.fillStyle(context)
}
// => Some(Blend)
```

## Epx.Gc.fillStyle

```ernest
Epx.Gc.fillStyle(context : Epx.Context) : Optional(Style)
```

The style the context's fill is drawn by, `None` where it has no fill.

### Errors

Faults on a style that foreign code set and that is none of `Style`'s,
with the cause `the context's style is none of Style's`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setFillStyle(context, None);
    Epx.Gc.fillStyle(context)
}
// => None
```

## Epx.Gc.setFillColor

```ernest
Epx.Gc.setFillColor(context : Epx.Context, color : Epx.Color) : Unit
```

Sets the color the context's fill is drawn in.

### Errors

Faults on a color with a channel outside 0 to 255, with the cause `a
channel of a Color is outside 0 to 255`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setFillColor(context, Epx.rgb(0, 128, 255));
    Epx.Gc.fillColor(context)
}
// => Color(alpha = 255, red = 0, green = 128, blue = 255)
```

## Epx.Gc.fillColor

```ernest
Epx.Gc.fillColor(context : Epx.Context) : Epx.Color
```

The color the context's fill is drawn in.

### Examples

```ernest
Epx.Gc.fillColor(Epx.Gc.create())
// => Color(alpha = 255, red = 255, green = 0, blue = 0)
```

## Epx.Gc.setLineStyle

```ernest
Epx.Gc.setLineStyle(context : Epx.Context, style : Style) : Unit
```

Sets the style a point, a line and a triangle's edges are drawn by.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setLineStyle(context, Epx.Gc.Antialiased);
    Epx.Gc.lineStyle(context)
}
// => Antialiased
```

## Epx.Gc.lineStyle

```ernest
Epx.Gc.lineStyle(context : Epx.Context) : Style
```

The style a point, a line and a triangle's edges are drawn by.

### Errors

Faults on a style that foreign code set and that is none of `Style`'s,
with the cause `the context's style is none of Style's`.

### Examples

```ernest
Epx.Gc.lineStyle(Epx.Gc.create())
// => Solid
```

## Epx.Gc.setLineWidth

```ernest
Epx.Gc.setLineWidth(context : Epx.Context, width : Int) : Unit
```

Sets the width a line and a triangle's edges are drawn in, in pixels. A
width below 0 is 0.

### Errors

Faults on a width above 16777216, with the cause `a width or height is
beyond 16777216`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setLineWidth(context, -3);
    Epx.Gc.lineWidth(context)
}
// => 0
```

## Epx.Gc.lineWidth

```ernest
Epx.Gc.lineWidth(context : Epx.Context) : Int
```

The width a line and a triangle's edges are drawn in, in pixels.

### Examples

```ernest
Epx.Gc.lineWidth(Epx.Gc.create())
// => 1
```

## Epx.Gc.setBorderStyle

```ernest
Epx.Gc.setBorderStyle(context : Epx.Context, style : Style) : Unit
```

Sets the style the border of a rectangle and of an ellipse is drawn by.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setBorderStyle(context, Epx.Gc.Blend);
    Epx.Gc.borderStyle(context)
}
// => Blend
```

## Epx.Gc.borderStyle

```ernest
Epx.Gc.borderStyle(context : Epx.Context) : Style
```

The style the border of a rectangle and of an ellipse is drawn by.

### Errors

Faults on a style that foreign code set and that is none of `Style`'s,
with the cause `the context's style is none of Style's`.

### Examples

```ernest
Epx.Gc.borderStyle(Epx.Gc.create())
// => Solid
```

## Epx.Gc.setBorderColor

```ernest
Epx.Gc.setBorderColor(context : Epx.Context, color : Epx.Color) : Unit
```

Sets the color the border of a rectangle and of an ellipse is drawn in.

### Errors

Faults on a color with a channel outside 0 to 255, with the cause `a
channel of a Color is outside 0 to 255`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setBorderColor(context, Epx.rgb(255, 255, 255));
    Epx.Gc.borderColor(context)
}
// => Color(alpha = 255, red = 255, green = 255, blue = 255)
```

## Epx.Gc.borderColor

```ernest
Epx.Gc.borderColor(context : Epx.Context) : Epx.Color
```

The color the border of a rectangle and of an ellipse is drawn in.

### Examples

```ernest
Epx.Gc.borderColor(Epx.Gc.create())
// => Color(alpha = 255, red = 0, green = 0, blue = 0)
```

## Epx.Gc.setBorderWidth

```ernest
Epx.Gc.setBorderWidth(context : Epx.Context, width : Int) : Unit
```

Sets the width of the border of a rectangle and of an ellipse, in
pixels. A width below 0 is 0, and a border of width 0 is none where the
shape has a fill.

### Errors

Faults on a width above 16777216, with the cause `a width or height is
beyond 16777216`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setBorderWidth(context, 4);
    Epx.Gc.borderWidth(context)
}
// => 4
```

## Epx.Gc.borderWidth

```ernest
Epx.Gc.borderWidth(context : Epx.Context) : Int
```

The width of the border of a rectangle and of an ellipse, in pixels.

### Examples

```ernest
Epx.Gc.borderWidth(Epx.Gc.create())
// => 0
```

## Epx.Gc.setForeground

```ernest
Epx.Gc.setForeground(context : Epx.Context, color : Epx.Color) : Unit
```

Sets the color a point, a line and a triangle's edges are drawn in.

### Errors

Faults on a color with a channel outside 0 to 255, with the cause `a
channel of a Color is outside 0 to 255`.

### Examples

```ernest
{
    let context = Epx.Gc.create();
    Epx.Gc.setForeground(context, Epx.Color(alpha = 128, red = 0, green = 0, blue = 0));
    Epx.Gc.foreground(context)
}
// => Color(alpha = 128, red = 0, green = 0, blue = 0)
```

## Epx.Gc.foreground

```ernest
Epx.Gc.foreground(context : Epx.Context) : Epx.Color
```

The color a point, a line and a triangle's edges are drawn in.

### Examples

```ernest
Epx.Gc.foreground(Epx.Gc.create())
// => Color(alpha = 255, red = 0, green = 0, blue = 255)
```

---

Generated by ern 0.4.0 from gc.ern.
