# Language feedback

What writing Ernest has felt against the principles, a line each, in the shape of Ernest's file of that name: a queue, each line carried there by copy, after which the log here cites Ernest's number and the line goes (CLAUDE.md, *Who owns each fact*). An entry keeps its number while it stands; the next is 2.

1. **A list mapped with a value threaded through it is a fold over a pair and a reverse** (2026-10-21, `examples/whitted.ern`, `renderRow`). Each pixel of a row is traced from the seed the pixel before it left, so `renderRow` folds `#(traced, seed)` over the columns and reverses the pixels after, where a reader who knows Erlang predicts `lists:mapfoldl/3`. E.2 left `mapFold` out as a `foldLeft` whose accumulator hides a choice about the ends (Ernest's log, *Nothing Waits for a Program*, 2026-09-20); this use makes none, and is evidence to weigh or to drop. Principle 1.
