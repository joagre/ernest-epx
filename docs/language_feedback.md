# Language feedback

What writing Ernest felt against the principles, a line each, as `CLAUDE.md` says: a queue, each line carried to Ernest, and the file goes when it is empty.

- **`Float.atan2` at the origin is not stated.** Appendix E.9 gives `Float.atan2 : (Float, Float) -> Float // the angle of the point #(x, y), the y first` and says nothing of `#(0.0, 0.0)`, where it states the edges of `sqrt`, `pow`, `log`, `asin` and `acos`. `examples/boids.ern`'s `limited` takes a velocity's direction from it and meets the zero vector where the three rules cancel exactly; on `ern 0.9.0`, `Float.atan2(0.0, 0.0)` is `0.0`. Principle 1: a reader cannot predict the answer from the page. Ask: E.9 states the answer at the origin.
