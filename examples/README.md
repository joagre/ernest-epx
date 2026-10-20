# Examples

Complete programs that use the library, each larger than a doc block's example can hold. They are listed by topic: a picture computed pixel by pixel, and a figure drawn by recursion. Each file begins with a comment that says what the program does, what to look at in it, and how to run it; the sections named beside each are [`docs/design.md`](../docs/design.md)'s.

The commands run from the repository's root once `make` has built the library, with `ern` on your `PATH`. `make test` builds every program here and runs each, writing its picture under `build/examples/`, and fails where one ends with a status other than 0.

| Program | What it is | What it shows | Design |
|---|---|---|---|
| [`mandelbrot.ern`](mandelbrot.ern) | the Mandelbrot set, written to the file named as a PPM image | a pixmap written in place one pixel at a time, pure arithmetic beside the one part that acts, the bytes of a file from `toPpm` | §2, §6 |
| [`sierpinski.ern`](sierpinski.ern) | the Sierpinski gasket by recursive subdivision, written to the file named as a PPM image | a figure's definition as a function that calls itself three times, one pixmap written by every call | §2, §6 |

Each is built and run with the library and epx on the load path, `--load-path build --load-path lib/epx/ebin --load-path lib/tree_db/ebin`, as its first comment shows.
