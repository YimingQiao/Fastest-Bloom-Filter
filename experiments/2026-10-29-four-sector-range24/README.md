# FourSector with an exact cache-line budget

This is an isolated source-only hypothesis. No compiler, accuracy or throughput
run has occurred. FourSector is a strong bulk-query control at16 bpk; the
question is whether its layout can use24 bpk effectively enough to compete in
the0.01% band. A range layout is useful only if measured accuracy and the added
address arithmetic leave a competitive result.

The candidate keeps the existing two-bit mask dictionary, scalar/AVX2/AVX-512
batch kernels, prefetch cutoffs and output contract. Addressing changes: the
top24 hash bits select a line by `floor(address24 * line_count / 2^24)`;
the next8 bits select one word in each of four distinct quarters; the low32
bits supply the unchanged four cyclic9-bit mask codes. Probe/address inputs
are disjoint. The first quarter is fixed and the other three word offsets are
XOR deltas from the first, a bijection of the eight offset bits.

This is a **new bitmap mapping**, including at power-of-two sizes. The masks
still share only32 input bits; they are not independent9-bit random values.
The24-bit address has finite resolution. Nondivisible line counts receive
floor/ceil(2^24/L) address codes, so large non-power-of-two geometries have
unequal line probabilities. Do not assume the old FourSector FPR carries over.
Bounds remain128 bytes through256 MiB, rounded down to complete64-byte lines.

`derive.py` reconstructs every edit from the pinned production header. The
new vector address helpers multiply even/odd32-bit lanes into64-bit products;
all remaining vector mask and gather logic comes from the parent. `check.cpp`
uses a separate128-bit arithmetic/bit-enumeration oracle, complete bitmaps,
all inserted keys, arbitrary line counts, batch tails, scalar/vector parity,
essential-bit deletion and invalid-size checks. Backend/sanitizer execution
will precede calibration. This prototype does not add a Rust port or claim a
parallel builder; those follow only if the candidate merits further work.

The fixed first accuracy grid will be n2^16/2^25, actual16/24/32 bpk, seed42
and2^24 disjoint negatives, with all six outcomes retained. The eight-bit
offset/mask mapping and range resolution will not be tuned after seeing them.
Only after that screen will a throughput protocol be fixed against retained
native and external public APIs. No throughput measurement is authorized by
this preparation stage.
