# A window that shows

A proposal for `Epx.Window`, the plan's milestone 8: a window on the screen that shows a pixmap, drawn into as the pixmap changes, and that sends nothing back to the program. Begun 2026-10-20.

## 1. What it is

epx draws on the screen through a backend, a process of its own that the epx application starts, X11 here; a window is a resource the backend owns, made by `window_create` and shown by `window_attach`; a pixmap is handed to the backend by `pixmap_attach`, and `pixmap_draw` copies a rectangle of it into a window, which the backend puts on the screen. The backend draws off screen by default, `use_off_screen`, and shows a window's buffer whole, which is the double buffering that keeps a row drawn at a time from flickering.

A window made by `window_create/4`, without event flags, is told nothing by the backend: no key, no button, no close, no expose. That is the window this library has. Receiving from a window is epx's events crossing into an Ernest mailbox in a shape no Ernest type names, which is Ernest's question before it is epx's, and stays out.

## 2. The functions

`Epx.Window`, a module of its own, over four functions:

| Function | epx | What it does |
|---|---|---|
| `open(x, y, width, height)` | `epx:start/0`, `window_create/4`, `window_attach/1` | a window on the screen at that place and size, the backend started where it is not running |
| `show(window, pixmap)` | `pixmap_attach/1`, `pixmap_draw/8`, `window_sync/1` | the whole pixmap drawn into the window at its top left and shown |
| `showArea(window, pixmap, x, y, width, height)` | the same | the rectangle of the pixmap drawn at the same place in the window and shown |
| `close(window)` | `window_detach/1` | the window gone from the screen |

`Window` is a foreign type, a resource of epx's, freed by the host when nothing holds it, as a pixmap and a context are. A window also goes when the program ends, since the backend ends with the node. A pixmap is attached once, at its first `show`, and the module keeps nothing: whether `pixmap_attach` of a pixmap already attached is refused or harmless decides whether `show` attaches each time, section 5.

`open` starts epx's application through `epx:start`, which starts it once and answers at once when it runs; a program with no display, `DISPLAY` unset or the X server gone, has `open` fault with epx's cause, which section 5 finds the words of. The coordinates and sizes are bounded as every function of `Epx` bounds them.

## 3. The examples

Each example takes the word `show` after its other arguments, `mandelbrot out.ppm show`, `raytracer out.ppm 8 show`, `clock_face out.ppm show`, and then opens a window of the picture's size before it draws, shows the picture as it is drawn, writes the PPM as it does today, prints `press Enter to close`, waits on a line from standard input, and closes the window; without the word nothing of the window happens, which is how `make test` runs them with no display. A word on the command line is what an argument already is for these programs, and it keeps the PPM, which `make test` holds to.

What is shown and when: the Mandelbrot and the clock face show the whole pixmap once, drawn; the Sierpinski shows after each subdivision at the depth its header names, so that the figure is seen to grow; the ray tracer's each worker shows its own row after writing it, `showArea` of one row, so that eight workers are seen filling the picture in turn, which is the point of the window. The window's close button does nothing, since the window takes nothing back; the header says so, and Enter closes it.

## 4. The three questions

**A display under `make test`.** `make test` runs with or without a display, so no test of `Epx.Window` runs under it: the module has no `Test.Case`, and its page's examples and the examples' `show` word are tried by hand on a machine with a screen before a release, which `release.md` gains a line for, the readers among those who try. The module's doc block says so, as the standard library's terminal module says what cannot be tried without a terminal.

**How the window closes.** The program decides: it waits on a line from standard input and then calls `close`, a wait on what it means. A window left open when the program ends goes with the backend.

**Who draws.** Each worker, after its row, since the demonstration is the workers and `pixmap_draw` is a message to the backend from whatever process sends it; section 5 confirms that a draw from a process other than the window's maker is taken.

## 5. What is tried first

In Erlang against epx directly, before a line of Ernest, since each answer shapes a function: whether a window made without event flags receives any message at all, `window_sync`'s `synced` among them, which is the question that decides everything, since one message into an Ernest mailbox faults the process at its next wait (report §8.4); whether a draw is seen without `window_sync`, and whether a row drawn at a time flickers with the off-screen buffer on; whether `pixmap_attach` twice is refused; whether `pixmap_draw` from another process than the window's maker is taken; what `epx:start` does with no display; and what a second `open` after `close` does. A defect found goes to `epx_bugs.md` as the others did.

If the `synced` message reaches the maker whatever the flags, `show` does not sync, and the picture is shown by the backend's own flush where the experiment finds it is; if no flush shows it, the window cannot be made without a message crossing, and the proposal stops there with a line for Ernest's `language_feedback.md`, an Erlang message shape no Ernest type names, which the plan then waits on.

## 6. The decisions

For the user to accept or amend in one answer. Each with its recommendation.

1. **`Epx.Window` with four functions**, `open`, `show`, `showArea` and `close`, over epx's window and its backend. Recommended: yes.
2. **The word `show` on each example's command line**, the PPM written as before. Recommended: yes.
3. **Enter closes**, the program waiting on a line from standard input. Recommended: yes.
4. **Each worker shows its own row** in the ray tracer. Recommended: yes, if section 5 finds a draw from any process is taken.
5. **No test under `make test`**; the window tried by hand before a release, `release.md` saying so. Recommended: yes.
6. **The experiment first**, in Erlang, its answers shaping `show` and the sync. Recommended: yes.
7. **The build an Opus 5.5 agent's at xhigh**, the page read back here. Recommended: yes.
