# The ray tracer

A proposal for `examples/raytracer.ern`, the plan's milestone 4: the Boing ball, a sphere in red and white checks, above a mirror floor, traced by a count of processes the command line gives, each writing its rows into one pixmap, and written as a PPM. Begun 2026-10-20.

## 1. What it is for

The first two examples draw with one process. This one shows what they cannot: a pixmap captured by spawned functions and written by all of them at once, since a pixmap is changed in place and shared by every process that holds it (the page, *In place and shared*); a monitor on each and a `Down` for each, received by `main` before it writes the file; and floats and processes in one program, which is the first such program written in Ernest and so the first to say what that feels against the principles. It also shows the speedup on the machine: the same picture with one worker and with eight, timed by the shell.

## 2. The scene

A sphere of radius 1 centered at height 1.2 above a floor at height 0, the camera at height 1.5 some 5 units back looking slightly down, a point light above and to the left, and a sky of one color behind. The sphere is checked in red and white: a point's color is decided by the parity of its latitude band and its longitude band, 8 bands of latitude and 16 of longitude, which is the Boing ball's look. The floor is a mirror: a ray that hits it is reflected and traced again, to a depth of two, and the floor's own color, a dark gray, is mixed in so that the reflection reads as a floor. Shading is Lambert from the light with a white highlight, and a point the light does not reach, the sphere's shadow on the floor among them, has the ambient part alone.

The picture is 400 by 300 pixels, `Rgb`. No anti-aliasing: one ray per pixel keeps the tracer at its definition.

## 3. The program's shape

The pure half, about two thirds of the program: a `Vector` record with its own `+`, `-` and `*` by a scalar, `dot`, `normalized` and `reflected`; a `Ray` of an origin and a direction; `hitSphere` and `hitFloor`, each answering `Optional(Float)`, the distance along the ray, which `Float.sqrt`'s `Optional` gives naturally; `nearest`, the closer hit of the two; `shade`, the color at a hit from its normal, the light and the eye; and `trace(ray, depth)`, which calls itself once for a mirror hit. `pixelRay(x, y)` makes the ray through a pixel from the camera. A color is three floats from 0 to 1 while it is computed, and becomes an `Epx.Color` once, at the pixel.

The acting half: `renderRow(pixmap, y)` traces the row's pixels into a `Bytes` of `width` times 3 and writes it with one `Epx.putPixels`; a worker is `fn() = List.forEach(rows, fn(y) = renderRow(pixmap, y))` over its rows; `main` reads the file's name and the worker count from the command line, makes the pixmap, spawns each worker with `spawnMonitored`, receives a `Down` for each, and writes `Epx.toPpm(pixmap)` with `Fs.write`. Run with no file it says how it is called and ends with status 2, as the other examples do; the worker count is the second argument, and is 1 where it is not given, so that `raytracer out.ppm` works as the others do and `raytracer out.ppm 8` shows the speedup.

## 4. The processes

The rows are shared out in turn: worker `k` of `n` takes the rows `y` with `y % n == k`, so that the sphere's rows, the slow ones, are spread over the workers, where blocks of rows would give one worker the sphere and another the sky. Each worker holds the pixmap by capture and writes with `putPixels`, one call a row, so that the NIF is called 300 times in all and not 120,000; two workers never write one row, so nothing interleaves within a row, and the reader is `main` alone, after the last `Down`.

`main` spawns each worker with `spawnMonitored(worker, fn(down) = down)` and receives `n` times; a `Down` whose reason is not `Returned` ends the program with that reason on standard error and status 1, so that a faulting worker is not a half-black picture. Nothing is sent back: the pixmap is the result, which is the point.

## 5. What to look at

The header says, as the other examples' do: the pure half beside the acting half; a pixmap shared by capture and written by every worker (the page, *In place and shared*), with `putPixels` a row at a time (*Rectangles*); `spawnMonitored` and the `Down` per worker (report §6.9); `Float.sqrt`'s `Optional` as the no-hit case; and the shell's `time` over `raytracer out.ppm 1` and `raytracer out.ppm 8`.

## 6. How it is built and tested

A third row of `examples/README.md`. `make test` builds it with the others and runs it as it runs them, with one argument, the output path; the worker count is then 1, and the picture takes a few seconds. The program is written by an agent from this proposal once decided, and read back here; a line of `language_feedback.md` for whatever floats and processes together felt against the principles.

## 7. The decisions

For the user to accept or amend in one answer, each with its recommendation.

1. **Rows in turn**, `y % n == k`, not blocks of rows. Recommended: yes, for the balance.
2. **The worker count is the second argument, 1 where not given.** Recommended: yes; Ernest has no function for the host's scheduler count, and the count on the command line is what shows the speedup.
3. **Each worker writes into the shared pixmap with `putPixels` a row at a time**, and nothing is sent back. Recommended: yes; it is what the example exists to show. The alternative, each worker answering its rows as messages for `main` to write, is the shape a program takes when the picture is a value, and could be a sentence in the header, not a second program.
4. **A faulting worker ends the program** with the reason and status 1. Recommended: yes.
5. **Reflection to a depth of two, no anti-aliasing, 400 by 300**, fixed in the program and not flags. Recommended: yes; an example carries no options.
6. **The scene as section 2 has it.** Recommended: yes; the one thing worth a second look is the checker mapping, 8 by 16 bands, which the agent adjusts to the eye.
