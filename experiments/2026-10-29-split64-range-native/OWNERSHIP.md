# Exact ownership for arbitrary line counts

This implementation applies only to a filter whose global line index is
`line = floor(x * L / 2^32)`, where `x` is the hash's high 32 bits. `L` is
the allocated line count, and `1 <= T <= L` is the effective worker count.

The general owner is `floor(line * T / L)`. Worker `p` receives the complete
line interval `[ceil(p*L/T), ceil((p+1)*L/T))`. Consequently every hash in its
partition writes only its owned physical lines. Histogram and scatter use
the same owner function. The Rust insertion kernel subtracts the interval's
beginning from its global line index before touching its exclusive slice.

When `L` is divisible by `T`, put `D = L/T`. Then

```
floor(floor(x*L / 2^32) * T / L)
  = floor(floor(x*D*T / 2^32) / D)
  = floor(x*T / 2^32).
```

The final identity follows from `floor(floor(y)/D) = floor(y/D)` for integer
`D > 0`. This permits one multiply-high for those geometries, including
many practical intermediate byte budgets. It does not depend on `L` or `T`
being powers of two. Otherwise the implementation uses the exact general
formula, including integer division. Both languages select the same formula.

Unconditionally using the fast formula is incorrect. For example, with
`L=3`, `T=2`, and `x=2^31`, the global line is 1 and belongs to worker 0,
while `floor(x*T/2^32)` is 1. The latter would violate Rust's exclusive
slice boundary and C++'s physical-line ownership.

All products fit u64: `L <= 2^22`, effective `T <= 1024`, and `x < 2^32`.
The helper additionally validates `T <= L`; even that larger admitted range
has products below `2^54` (hash products) and `2^44` (line products).

Correctness tests exercise exact source-state boundaries at full 32-bit
width, a reduced-domain exhaustive grid, divisible and nondivisible worker
counts, full serial/parallel bitmaps, duplicate insertions and lookup outputs.
These tests are required before timing; this proof is not a speed measurement.
