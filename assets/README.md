# The pictures

What the examples draw, as PNG, for the READMEs: `mandelbrot.png`, `sierpinski.png`, `raytracer.png`, `clock_face.png`, `whitted.png` and `boids.png` are each program's own output, `build/examples/<name>.ppm` after `make examples`, converted with ImageMagick's `convert <name>.ppm <name>.png`; `whitted16.png` is `whitted.ern`'s picture with sixteen samples, written by `ern run --load-path build --libs-dir lib examples/build/whitted.erc whitted16.ppm 8 16` and converted the same way; `collage.png` is all of them laid out together by hand, Whitted's spheres at sixteen samples among them, 1280 by 640 pixels, for the top of [`README.md`](../README.md) and for the repository's social preview on GitHub, which takes it from the repository's settings, where it is uploaded by hand when it changes. A picture is made again when its program changes what it draws.

`icon.png`, 128 by 128, is the repository's icon, a crop of Whitted's glass sphere.
