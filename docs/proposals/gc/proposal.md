# The second cut: the graphics context and the drawing functions

A proposal for `Epx.Gc`, epx's graphics context, and for the drawing functions of `Epx` that take one: a point, a line, a rectangle, an ellipse, a rounded rectangle, a triangle and a polygon drawn into a pixmap with a context's colors, styles and widths. It is the plan's milestone 2, item 4. Begun 2026-10-20.

## 1. What it is

epx draws through a graphics context, `epx_gc`, a resource of its own with twenty-one settable keys: the fill's style and color, the line's style and width, the border's style, color and width, the foreground and background colors, the join and cap styles, three textures, a fader, a font and four glyph settings. Each drawing function reads the keys it needs: a point and a line take the foreground color and the line's style and width; a rectangle, an ellipse and a rounded rectangle take the fill's style and color and the border's style, color and width, drawing the fill and then the border where its width is above 0; a triangle and a polygon take the fill's.

The context is a resource as a pixmap is: made by `gc_create`, changed in place by `gc_set`, shared by every process that holds it, freed by the host when nothing holds it. The library keeps it so, a second foreign type beside `Pixmap`, in a module of its own, `Epx.Gc`, as the first proposal said it would: one concept, one module.

## 2. What the cut takes

**`Epx.Gc`.** `create()`, a context with epx's own defaults; `copy(gc)`; and a typed setter and getter for each of the ten keys a 2-D library draws with, each a shim over `gc_set` or `gc_get` with Ernest making the atom and the value:

| Setter | Getter | epx's key | Type |
|---|---|---|---|
| `setFillStyle(gc, style)` | `fillStyle(gc)` | `fill_style` | `Style` |
| `setFillColor(gc, color)` | `fillColor(gc)` | `fill_color` | `Epx.Color` |
| `setLineStyle(gc, style)` | `lineStyle(gc)` | `line_style` | `Style` |
| `setLineWidth(gc, width)` | `lineWidth(gc)` | `line_width` | `Int` |
| `setBorderStyle(gc, style)` | `borderStyle(gc)` | `border_style` | `Style` |
| `setBorderColor(gc, color)` | `borderColor(gc)` | `border_color` | `Epx.Color` |
| `setBorderWidth(gc, width)` | `borderWidth(gc)` | `border_width` | `Int` |
| `setForeground(gc, color)` | `foreground(gc)` | `foreground_color` | `Epx.Color` |
| `setBackground(gc, color)` | `background(gc)` | `background_color` | `Epx.Color` |

`Style` is one type for the three style keys: `Solid`, `Blend`, `Sum`, `Antialiased` and `NoStyle`, crossing as epx's atoms `solid`, `blend`, `sum`, `aalias` and `none`; a fill of `NoStyle` is no fill, and a border of `NoStyle` no border.

**`Epx`'s drawing functions**, each a shim over one epx function, the context second after the pixmap, the coordinates bounded as the first cut bounds them:

| Function | epx |
|---|---|
| `drawPoint(pixmap, gc, x, y)` | `pixmap_draw_point/4` |
| `drawLine(pixmap, gc, x1, y1, x2, y2)` | `pixmap_draw_line/6` |
| `drawRectangle(pixmap, gc, x, y, width, height)` | `pixmap_draw_rectangle/6` |
| `drawEllipse(pixmap, gc, x, y, width, height)` | `pixmap_draw_ellipse/6` |
| `drawRoundedRectangle(pixmap, gc, x, y, width, height, radiusX, radiusY)` | `pixmap_draw_roundrect/8` |
| `drawTriangle(pixmap, gc, x0, y0, x1, y1, x2, y2)` | `pixmap_draw_triangle/8` |
| `drawPolygon(pixmap, gc, points)` | `pixmap_draw_poly/3` |

`points` is a `List(#(Int, Int))`, which crosses as epx's list of pairs.

**Left for a later cut**, each with its reason: the textures, `fill_texture`, `line_texture` and `border_texture`, which take a pixmap and a style of `textured`, until a program asks; the join and cap styles, the dashed line and the line's `nfirst` and `nlast`, and the border's four sides, which are flags on a style and would make `Style` a list, until a program asks; the fader; the font and the glyph settings with `draw_char`, `draw_string` and `draw_utf8`, which are a cut of their own with `epx_font`; `pixmap_draw_fan`, `pixmap_draw_strip` and `pixmap_draw_triangles`, the batched forms, until a program draws enough triangles to want them.

## 3. The defaults

A new context has epx's defaults: a solid red fill, no border, width 0, a solid line of width 1, a blue foreground and a green background. They are the host's and the page states them; a program sets what it draws with. The alternative, a context of the library's own defaults, a black foreground and no fill, would make `create` more than the shim and give a reader two sets of defaults to know.

## 4. What faults

A context given to a drawing function that is not one, and a width below 0, fault with epx's cause, which the experiment of section 6 confirms. A coordinate or a size past the first cut's bounds faults with the library's cause before the call, as every function of `Epx` does. A `Color` with a channel outside 0 to 255 faults as `fill` has it.

## 5. The documentation and the example

`Epx.Gc`'s page as the standard library's, Appendix E.0's shape rule 6: what a context is, that it is changed in place and shared, the keys and which function reads which, the defaults; every setter and getter with its example; `since 0.2.0`. The drawing functions join `Epx`'s page under a section of their own, each saying which keys it reads.

The example is `examples/clock_face.ern`: a clock face at the moment the program runs, from `Clock.now`, an ellipse for the dial with a border, sixty ticks as lines, twelve thicker, three hands of three widths, written as a PPM; the fourth row of `examples/README.md`, run by `make test`.

## 6. What is tried first

A scratch program before the doc blocks: a context's defaults read back through `gc_get`; a rectangle with a border of width 0, 1 and 5, to see what the border covers and where it lies, inside, centered or outside the rectangle, since `epx_draw_rectangle` has three placements and the context has no key for them; a line of width 1 and of width 5; an ellipse with and without a border; a polygon with a style of `none`; a context that is not one and a negative width, for the faults; and `gc_set` with a value of the wrong kind, to see whether epx refuses it or takes it silently, which decides whether a setter checks in Ernest.

## 7. The decisions

For the user to accept or amend in one answer. Each with its recommendation.

1. **The context is a resource mirrored from epx**, `Epx.Gc` a foreign type changed in place, not an Ernest record converted at each call. Recommended: yes; it is what epx has, a pixmap is already so, and a record would cost ten `gc_set` calls at every draw or a cache the program cannot see.
2. **Ten keys with typed setters and getters**, the textures, the join and cap styles, the fader, the font and the glyphs left out. Recommended: yes.
3. **One `Style` type for the three style keys**, `Solid`, `Blend`, `Sum`, `Antialiased`, `NoStyle`, the flags that would make it a list left out. Recommended: yes.
4. **Seven drawing functions in `Epx`**, the context after the pixmap; the fan, the strip and the triangle list left out. Recommended: yes.
5. **epx's defaults kept** and stated. Recommended: yes.
6. **`examples/clock_face.ern`** as the example. Recommended: yes.
7. **The build an Opus 5.5 agent's at xhigh** from the decided proposal, the pages read back here. Recommended: yes.
