# Whitted's spheres

A proposal for `examples/whitted.ern`, the plan's milestone 5: the scene of Whitted's 1980 picture, a glass sphere and a mirror sphere over a checkered floor, traced as `raytracer.ern` traces, with the rays a pixel multiplied by counts the command line gives, so that the window of milestone 8 shows the workers filling a picture that takes minutes. Begun 2026-10-21.

## 1. What it is for

The Boing ball traces three rays a pixel and is done in under a second, which `make test` wants and the window does not: eight workers fill its rows faster than the eye follows. This program is the slow tracer. It spends its rays where the picture gets better, anti-aliasing, soft shadows and a glossy floor, each a count in the program, the rays a pixel their product, so that the same program runs in a second under `make test` with the counts at one and for minutes on one worker, under a minute on eight, with the counts at sixteen. It is also the richer scene: refraction through glass, reflection in a mirror sphere and in the floor, a shadow that bends through the glass, which Whitted's picture is known for.

## 2. The scene

Two spheres over a floor at height 0, a glass one of radius 1 at the left front, refracting with an index of 1.5, and a mirror one of radius 1 at the right back, reflecting; the floor checked in two colors, mirror-like with a glossy reflection; one area light, a disc above and to the left; a sky of one color. The camera as the Boing ball's, looking slightly down. A ray that hits the glass sphere is both reflected and refracted, the two mixed by Fresnel's law in Schlick's form, and traced on, to a depth of five, since a ray enters the glass and leaves it; one that hits the mirror sphere is reflected; one that hits the floor is shaded by the checks and mixed with a reflection scattered by the gloss.

The picture is 400 by 300, `Rgb`, as the Boing ball's. The colors, the light's place and size, the gloss and the depth are the program's constants, tuned by eye.

## 3. The sampling

Three counts, each a loop over samples and an average:

- **Anti-aliasing.** `n` by `n` rays through each pixel, at points jittered within the pixel, averaged; `n` of 1 is the Boing ball's one ray through the center.
- **Soft shadows.** At each hit, `m` shadow rays to `m` points on the light's disc, the shadow the fraction that reach it; `m` of 1 is a hard shadow from the disc's center.
- **Glossy reflection.** On the floor, `k` reflected rays scattered within a small cone around the mirror direction, averaged; `k` of 1 is a mirror.

One count on the command line, `samples`, sets all three, `n`, `m` and `k` each `samples`, so that `whitted out.ppm 8 16 show` means sixteen by sixteen rays a pixel, sixteen shadow rays a hit and sixteen reflected rays a floor hit: with the depth, several thousand rays a pixel against the Boing ball's three. Three counts on the command line would be three knobs for one effect, slowness, and an example carries no options beyond its arguments.

The jitter and the points come from `Random`: a worker seeds with `Random.seed(index)` and threads the seed through its rows, so that the picture a seed draws is the same whatever the worker count, since worker `k` always takes the rows `y % n == k`... which it does not, when `n` changes. So the seed is per row, `Random.seed(y)`, and a row's samples are the same whatever worker draws it: one seed, one picture, under any worker count, which is what makes the eight-worker picture byte for byte the one-worker picture, as the Boing ball's is.

## 4. The program's shape

The Boing ball's, with the pure half grown: `Vector`, `Ray` and `Color` as there, the hit as `Optional(Float)` for each of the three surfaces, `nearest` over three, `shade` with the area light and the shadow fraction, `refracted` beside `reflected`, `fresnel`, and `trace(ray, depth, seed)` carrying the seed through its samples and answering the color and the seed after it; `pixel(x, y, seed)` averaging `n` by `n` traces. The acting half is the Boing ball's unchanged: `renderRow` with one `putPixels` a row, the workers over `y % count == index`, `spawnMonitored` and a `Down` each, `showArea` after a row under `show`, the PPM, `press Enter to close`.

The command line is `whitted file.ppm [workers [samples]] [show]`: the file, the workers as the Boing ball has them, 1 where not given, the samples, 1 where not given, and the word `show`. A count that is not a whole number above 0 gives the usage and status 2.

The pure half is written again rather than shared with `raytracer.ern`, since the examples are programs each of a file and a reader of one does not open another; the header says it grows out of the Boing ball's.

## 5. What to look at

The header says: the three samplings and their counts as loops over `Random`'s seed, each pure; `trace` carrying the seed through recursion; refraction and Fresnel; and the window with eight workers against one, `time` on both, the picture the same.

## 6. The decisions

For the user to accept or amend in one answer. Each with its recommendation.

1. **The scene as section 2 has it**, a glass and a mirror sphere, a glossy checkered floor, an area light. Recommended: yes.
2. **One `samples` count sets `n`, `m` and `k`.** Recommended: yes; one knob for one effect.
3. **The seed is the row's**, `Random.seed(y)`, so that the picture is one whatever the worker count. Recommended: yes; the plan's line said the worker's index, which would change the picture with the count.
4. **The command line is `whitted file.ppm [workers [samples]] [show]`**, each count 1 where not given. Recommended: yes.
5. **Depth five**, fixed. Recommended: yes.
6. **The pure half written again**, not shared. Recommended: yes.
7. **The build an Opus 5.5 agent's at xhigh**, the picture looked at and the timings taken, the program read back here. Recommended: yes; the agent runs the long trace once on eight workers and reports its time, and `make test` runs it with the counts at one.
