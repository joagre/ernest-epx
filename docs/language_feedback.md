# Language feedback

What writing Ernest has felt against the principles, a line each, in the shape of Ernest's `docs/language_feedback.md`: a queue, each line carried there by copy, the log here citing Ernest's number, and the line then going; the file goes when it is empty (CLAUDE.md, *Who owns each fact*). The next is 2.

1. **Two modules of one library cannot share a private function** (2026-10-20, `src/epx/gc.ern`, `extent` and `channels`). `Epx.Gc` checks a width and a color by the rules and causes `Epx` checks them by, and since a declaration is either private to its module or exported to every program (report §4.2), the four private functions are written again in `Epx.Gc` rather than exported from `Epx` as functions no caller should see. The same split puts the tests of `Epx`'s drawing functions in `Epx.Gc`, the one module that can make a context, since `Epx` cannot name a module that names it (§4.1). Principle 2.
