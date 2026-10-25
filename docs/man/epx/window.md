# Ernest module Epx.Window

*Since 0.2.0.*

Windows on the screen, each showing a pixmap as it is drawn, over epx's
windows and the backend that draws them.

Use it to watch a picture while a program draws it: a window shows a
pixmap, or a rectangle of one, each time `show` or `showArea` is called.
A picture to keep is made the bytes of a PPM file with `Epx.toPpm`, and
written with `Fs.write`: a window keeps nothing once it is closed.

A program puts epx's `ebin` directory on its load path when it is run,
as for `Epx`, and beside it the `ebin` of tree_db, an application epx's
own lists among those it needs. `open` starts epx's application, which
opens the display `DISPLAY` names; where none can be opened, `open`
faults.

**A window's life.** A window lives while a process holds it, and the
host frees it and takes it off the screen once none does; a window
still open when the program ends goes with the program. `close` takes it
off the screen at once. It stays on the node that made it.

**Shown later.** `show` and `showArea` hand the rectangle to epx's
backend and answer before it is on the screen. The backend draws the
rectangles in the order it is given them, and reads the pixmap's pixels
as it draws: a write made after `show` answered may be shown with it,
and a write another process makes meanwhile may be seen half done. Any
process that holds a window and a pixmap may show the one in the other.

**No flicker.** The backend draws into a copy of the window kept off the
screen and puts the copy on the screen whole, so that a picture shown a
row at a time does not flicker, and a window covered and uncovered keeps
its picture.

**The close button.** A window reads no key and no button, and its close
button does not close it: epx sends the process that opened the window a
message no Ernest type names, whatever the window's flags. A `receive`
whose patterns each name a constructor leaves that message in the
mailbox, where it stays; one whose pattern is a variable takes it as a
message of the mailbox's type, and the program then holds a value that is
none of that type's. So the process that opens a window must not
`receive` with a variable pattern: a program opens a window in a process
that receives nothing, or whose patterns each name a constructor, and
closes it with `close`.

**Bounds.** A window's coordinates are from -32767 to 32767, and its
width and height from 1 to 32767, one below 1 being 1. The place is
asked of the window manager, which may put the window elsewhere.

**A call's cost.** A call answers at once. The backend copies the whole
window to the screen for each rectangle shown, and rectangles shown
faster than it draws them wait in its queue. A window's copy off the
screen takes four bytes a pixel of the display's memory, and a window
whose copy the display cannot allocate shows nothing.

**Trying it.** A window is shown only where there is a screen. No test
of the library opens one, and the examples below are tried by hand on a
machine with a screen.

## Examples

A pixmap filled and shown in a window of its size until Enter is
pressed:

```ernest
{
    let pixmap = Epx.create(320, 200, Epx.Rgb);
    Epx.fill(pixmap, Epx.rgb(0, 96, 160));
    let window = Epx.Window.open(100, 100, 320, 200);
    Epx.Window.show(window, pixmap);
    Io.println("press Enter to close");
    let _ = Io.readLine();
    Epx.Window.close(window)
}
```

A picture drawn and shown a row at a time:

```ernest
{
    let pixmap = Epx.create(256, 256, Epx.Rgb);
    let window = Epx.Window.open(100, 100, 256, 256);
    Epx.Window.show(window, pixmap);
    List.forEach(List.range(0, 255), fn(y) = {
        Epx.fillArea(pixmap, 0, y, 256, 1, Epx.rgb(y, 0, 255 - y));
        Epx.Window.showArea(window, pixmap, 0, y, 256, 1)
    });
    let _ = Io.readLine();
    Epx.Window.close(window)
}
```

## See also

`Epx` for the type `Window` and the pixmaps a window shows, and
`Epx.toPpm` for a picture kept as the bytes of a PPM file.

## Epx.Window.open

```ernest
Epx.Window.open(x : Int, y : Int, width : Int, height : Int) : Epx.Window
```

A new window on the screen at `x`, `y`, `width` pixels wide and `height`
high, starting epx's application where it is not running. A width or a
height below 1 is 1. The place is asked of the window manager, which may
put the window elsewhere. What the window shows before a pixmap is shown
in it is not stated.

### Errors

Faults on a coordinate outside -32767 to 32767, with the cause `a
window's coordinate is beyond 32767`, and on a width or a height above
32767, with the cause `a window's width or height is beyond 32767`.
Faults where no display can be opened, `DISPLAY` unset or naming no X
server, with epx's cause: `foreign function epx:window_attach/1 raised
error:{no_backend,default}`. Faults where tree_db, which epx's
application depends on, is not on the load path, with epx's cause from
`epx:start/0`, a `badmatch` naming `tree_db.app`.

### Examples

```ernest
Epx.Window.open(100, 100, 400, 300)
```

## Epx.Window.close

```ernest
Epx.Window.close(window : Epx.Window) : Unit
```

Takes the window off the screen. Nothing brings it back: a pixmap shown
in it afterwards is not seen, and a second `close` does nothing.

### Examples

```ernest
Epx.Window.close(Epx.Window.open(100, 100, 400, 300))
```

## Epx.Window.show

```ernest
Epx.Window.show(window : Epx.Window, pixmap : Epx.Pixmap) : Unit
```

Shows the pixmap in the window, each of its pixels at the window's pixel
of the same column and row. Only the part within the pixmap's clip is
shown, and a pixel outside the window is not. It answers before the
pixmap is on the screen.

### Errors

Faults where two processes show one pixmap for its first time at once,
in the one that comes second, with epx's cause: `foreign function
epx:pixmap_attach/1 raised error:badarg`.

### Examples

```ernest
{
    let pixmap = Epx.create(400, 300, Epx.Rgb);
    Epx.fill(pixmap, Epx.rgb(255, 255, 255));
    let window = Epx.Window.open(100, 100, 400, 300);
    Epx.Window.show(window, pixmap);
    let _ = Io.readLine();
    Epx.Window.close(window)
}
```

## Epx.Window.showArea

```ernest
Epx.Window.showArea(window : Epx.Window, pixmap : Epx.Pixmap, x : Int, y : Int, width : Int, height : Int) : Unit
```

Shows the rectangle of the pixmap at `x`, `y` in the window, at the same
place: the pixmap's pixel at `x + i`, `y + j` at the window's pixel at
`x + i`, `y + j`. Only the part of the rectangle within the pixmap's
clip is shown, and a pixel outside the window is not. A width or a
height below 0 is 0. It answers before the rectangle is on the screen.

### Errors

Faults on a coordinate outside -16777216 to 16777216, with the cause `a
coordinate is beyond 16777216`, and on a width or a height above
16777216, with the cause `a width or height is beyond 16777216`. Faults
where two processes show one pixmap for its first time at once, in the
one that comes second, with epx's cause: `foreign function
epx:pixmap_attach/1 raised error:badarg`.

### Examples

```ernest
{
    let pixmap = Epx.create(400, 300, Epx.Rgb);
    let window = Epx.Window.open(100, 100, 400, 300);
    Epx.fillArea(pixmap, 0, 10, 400, 1, Epx.rgb(255, 255, 255));
    Epx.Window.showArea(window, pixmap, 0, 10, 400, 1);
    let _ = Io.readLine();
    Epx.Window.close(window)
}
```

---

Generated by ern 0.5.0-dev from src/epx/window.ern.
