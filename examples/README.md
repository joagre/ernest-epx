# Examples

Complete programs that use the library, each larger than a doc block's example can hold. They are listed by topic: a picture computed pixel by pixel, a figure drawn by recursion, a scene traced by several processes into one pixmap, a picture drawn with a graphics context and redrawn live every second, a richer scene traced slowly enough to watch, and a flock animated thirty times a second.

## Seeing them

On a machine with a screen, once `make examples` has built them and with `ern` on your `PATH`, each one from the repository's root; the window closes on Enter:

```
ern run --load-path build --libs-dir lib examples/build/mandelbrot.erc build/mandelbrot.ppm show
ern run --load-path build --libs-dir lib examples/build/sierpinski.erc build/sierpinski.ppm show
ern run --load-path build --libs-dir lib examples/build/raytracer.erc build/raytracer.ppm 8 show
ern run --load-path build --libs-dir lib examples/build/clock_face.erc build/clock_face.ppm show
ern run --load-path build --libs-dir lib examples/build/clock_face.erc build/clock_face.ppm live
ern run --load-path build --libs-dir lib examples/build/whitted.erc build/whitted.ppm 8 4 show
ern run --load-path build --libs-dir lib examples/build/boids.erc build/boids.ppm show
```

The ray tracers take a count of workers, 8 above, and Whitted's spheres a count of samples after it: 4 fills the window in well under a minute on eight workers, and 16, the picture at the top of the README, takes about five minutes, each row appearing as a worker finishes it.

The word `show` opens a window of the picture's size before the program draws, shows the picture in it as the program's comment says, writes the file all the same, and leaves the window until Enter is pressed (`Epx.Window`); without the word nothing of the window happens, which is how `make examples` runs them. The clock's word `live` opens the window the same way and draws the face again at every whole second until Enter is pressed, writing the last face to the file. The boids' `show` animates in the same way, thirty frames a second, and writes the last frame once Enter is pressed.

Each file begins with a comment that says what the program does, what to look at in it, and how to run it; what is named beside each is on the page of `Epx`, of `Epx.Gc` or of `Epx.Window`, a heading of its first part or a function.

`make examples` builds every program here and runs each, writing its picture under `build/examples/`, and fails where one ends with a status other than 0; `make test` runs it after its own checks.

| Program | What it is | What it shows | On the page |
|---|---|---|---|
| [`mandelbrot.ern`](mandelbrot.ern) | the Mandelbrot set, written to the file named as a PPM image | a pixmap written in place one pixel at a time, pure arithmetic beside the parts that act, the bytes of a file from `toPpm` | *In place and shared*, `toPpm`, `Epx.Window.show` |
| [`sierpinski.ern`](sierpinski.ern) | the Sierpinski gasket by recursive subdivision, written to the file named as a PPM image | a figure's definition as a function that calls itself three times, one pixmap written by every call | *In place and shared*, *Bounds*, `toPpm`, `Epx.Window`'s *Shown later* and `showArea` |
| [`raytracer.ern`](raytracer.ern) | the Boing ball above a mirror floor, ray traced by the count of workers named after the file, 1 where none is, and written to the file named as a PPM image | one pixmap captured by every worker and written a row at a time, a monitor and a `Down` for each worker, vector and color arithmetic beside the parts that act | *In place and shared*, *Rectangles*, `putPixels`, `toPpm`, `Epx.Window.showArea` |
| [`clock_face.ern`](clock_face.ern) | a clock's dial at the time the program runs, in UTC, written to the file named as a PPM image, or with `live` drawn again in a window at every whole second until Enter | one context set before each part it draws and read by the drawing functions, a hand drawn as a triangle so that it tapers to its tip, a thin line smoothed by `Antialiased`, two pixmaps shown in turn as the window page asks, and a wait until the next whole second in a `receive` with `after`, derived from the clock | `Epx.Gc`'s *The keys* and *In place and shared*, `drawEllipse`, `drawLine`, `drawTriangle`, `toPpm`, `Epx.Window.show` |
| [`whitted.ern`](whitted.ern) | a glass sphere and a mirror sphere over a checkered floor, ray traced by the count of workers named after the file with the count of samples named after that, each 1 where none is, and written to the file named as a PPM image | Cook's distributed ray tracing over a seed from `Random`, each ray of a pixel drawing its own point of the light and its own scattered reflection; each row traced from its own seed, so that the picture is the same whatever the count of workers; refraction and Fresnel beside reflection; the acting half of `raytracer.ern` unchanged | *In place and shared*, *Rectangles*, `putPixels`, `toPpm`, `Epx.Window.showArea` |
| [`boids.ern`](boids.ern) | a flock of 150 boids steering by separation, alignment and cohesion, flown 200 steps and written to the file named as a PPM image, or with `show` animated in a window at 30 frames a second until Enter | the flock a list threaded through a recursive loop in one process, a pure `step` from one list to the next, a starting flock from a fixed seed of `Random`, a boid drawn as a triangle along its heading, two pixmaps shown in turn and how far that protects a frame, and each frame's due time on the clock, a late frame waiting 0 in a `receive` with `after` and moving no frame after it | `Epx.Gc`'s *The keys*, `drawTriangle`, `toPpm`, `Epx.Window.show`, `Epx.Window`'s *Shown later* and *A call's cost* |

Each is built with the library on the load path, `--load-path build`, and run with epx and tree_db beside it, `--libs-dir lib`, as its first comment shows.

## The pictures

What each program but `boids.ern` draws, from `assets/`, where [`assets/README.md`](../assets/README.md) says how a picture is made.

`mandelbrot.ern`:

![The Mandelbrot set](../assets/mandelbrot.png)

`sierpinski.ern`:

![The Sierpinski gasket](../assets/sierpinski.png)

`raytracer.ern`:

![The Boing ball above a mirror floor](../assets/raytracer.png)

`clock_face.ern`:

![A clock face](../assets/clock_face.png)

`whitted.ern`, with one sample, as `make examples` runs it, and with sixteen:

![A glass sphere and a mirror sphere over a checkered floor, with one sample](../assets/whitted.png)

![The same with sixteen samples](../assets/whitted16.png)
