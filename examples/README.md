# Examples

Complete programs that use the library, each larger than a doc block's example can hold. They are listed by topic: a picture computed pixel by pixel, and a figure drawn by recursion. Each file begins with a comment that says what the program does, what to look at in it, and how to run it; what is named beside each is on the page of `Epx`, a heading of its first part or a function.

The commands run from the repository's root once `make` has built the library, with `ern` on your `PATH`. `make test` builds every program here and runs each, writing its picture under `build/examples/`, and fails where one ends with a status other than 0.

| Program | What it is | What it shows | On the page |
|---|---|---|---|
| [`mandelbrot.ern`](mandelbrot.ern) | the Mandelbrot set, written to the file named as a PPM image | a pixmap written in place one pixel at a time, pure arithmetic beside the parts that act, the bytes of a file from `toPpm` | *In place and shared*, `toPpm` |
| [`sierpinski.ern`](sierpinski.ern) | the Sierpinski gasket by recursive subdivision, written to the file named as a PPM image | a figure's definition as a function that calls itself three times, one pixmap written by every call | *In place and shared*, *Bounds*, `toPpm` |

Each is built and run with the library and epx on the load path, `--load-path build --load-path lib/epx/ebin`, as its first comment shows.
