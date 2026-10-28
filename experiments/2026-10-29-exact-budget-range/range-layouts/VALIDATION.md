# Correctness preflight

Clang23 compiled and ran both isolated range types in six modes: native,
AVX2 and scalar fallback, each with and without AddressSanitizer/UBSan. Every
mode produced checksum `12991785245891427605`.

Independent scalar oracles compared every bitmap byte at2/3/5/7/31/257/1027/4097
cache lines. Inputs include duplicate inserts and values immediately around every
range boundary for each allocation. Checks cover all inserted keys, physical line
ownership, all output tails0..131 at three input offsets, long tails4096/4097/4127,
sentinel guards, and removing each required probe bit for24 keys per geometry.
Sizing checks include the128-byte minimum, arithmetic overflow, the256MiB upper
geometry limit without allocating it, and fitting14bpk at65,536 real keys.

The first compilation rejected a leftover template prefix on the test inspector's
friend declaration. That declaration was corrected before any executable ran.
The failed compiler log and command record remain under `validation/initial-*`.
All six final configurations passed. No bitmap algorithm failure, timing or FPR
calibration was observed in this preflight.

The whole build/check operation held `/tmp/fastest-bf-socket1.lock` and CPU3
affinity. Binary hashes and compile commands are retained in `FREEZE.json` and
`validation/`; sanitizer executions are correctness evidence only. Parallel
construction and Rust parity remain future work for these experimental types.
