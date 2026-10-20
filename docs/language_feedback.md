# Language feedback

What writing Ernest has felt against the principles, in the shape of Ernest's file of that name, so that a line is carried there by copy (CLAUDE.md, *Who owns each fact*). An entry stays until it is carried to Ernest; an entry keeps its number; the next is 3.

1. **A vector cannot be multiplied by a number with `*`** (2026-10-20, `examples/raytracer.ern`, `Vector`). A member named by an operator takes two values of its type (report §4.8), so `fn Vector.*(vector : Vector, factor : Float)` is refused, and scaling is the function `scaled`. Vector arithmetic then mixes operators and a call, `ray.origin + scaled(ray.direction, distance)` and `direction - scaled(normal, 2.0 * dot(direction, normal))`. The program's proposal wrote `*` by a scalar, which is what a reader predicted. Principle 1.

2. **`Float.sqrt` and `Float.pow` answer `Optional` where the argument cannot fail them** (2026-10-20, `examples/raytracer.ern`, `length` and `glint`). The square root of a sum of squares, a vector's length, and a base not below zero to the power 40, a highlight's level, each write a `None` arm that cannot run, here a `fault` that names why. The compiler cannot see that the arm cannot run, and the reader meets a case the program cannot reach in `length`, which every vector program writes first. Principle 3.
