# Independent32Range correctness proof

The one authorized operation completed on its first attempt: session82549,
exit0, source `944c1bae12d725dffeee900632baf1b95b67c259` and preparation
`6aa8074b649ba7114075e50fbef3085e45c4487842f9175f54afd309bf3741fa`.
The inherited socket1 flock covered all configure/build/check commands, pinned
to CPU3 with explicit NUMA1 binding. The lease was released after actual process
completion. No accuracy matrix or performance measurement ran.

| Profile | Observed compiled backend | Result |
| --- | --- | --- |
| native | AVX512VBMI + VL | pass |
| AVX2 | AVX2 fallback | pass |
| scalar | scalar source | pass |
| native ASan + UBSan | AVX512VBMI + VL | pass |

Each backend passed four small candidate serial bitmap fixtures and two original
control fixtures,324 guarded query length/offset calls,1024 missing-required-bit
cases and five invalid-size checks. The fixture-count phrase in checker stdout
refers to the six serial bitmap fixtures; the essential-bit and255-byte floor
checks construct their own additional small objects. Every inserted key is
present, complete bitmap bytes match the independent mapping-specific oracle,
and duplicate insertion, zero-length/null calls and query input/bitmap
immutability pass. The old and new mappings are **not** required to have equal
bitmaps at the pilot capacities.

All four small candidate geometries include exact range-transition boundary
hashes. Required-bit tests clear each of the8×32 selected probe positions and
require both singleton and dense APIs to reject. The255-byte request reports
192 actual bytes. Large n25 geometry and the inclusive256MiB maximum were only
checked arithmetically; no large bitmap was allocated in this proof. Actual
large allocations remain a requirement of the separately reviewed accuracy
worker.

`validation-v1/metadata.json` retains all14 command records and28 stdout/stderr
streams, including the compiler version and actual NUMA policy. Each profile
also retains its raw dependency file, CMake cache and compile commands. The
actual source union contains359 files (358 native/AVX2,242 scalar,359 ASan),
hashed before first execution and checked again at completion. `COMPILED_PROOF.json`
binds those inputs and the four retained executables; executables are not added
to Git. The final seal rechecked every command stream, actual input and binary.

This establishes finite correctness across the four compiled paths. It supplies
no new FPR evidence, speed estimate, Rust result or parallel-construction proof.
In particular, a future timed public caller must receive its own actual assembly
review; this checker does not establish that caller's clock boundaries.
