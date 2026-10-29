# Nearby odd MAGIC geometry: completed correctness proof

All 93 geometry cases passed on the first attempt: 31 each with native GCC,
AVX2-only GCC, and native AddressSanitizer/UndefinedBehaviorSanitizer. The nine
malformed CLI cases were rejected before any geometry output. The complete
112-command ledger and both output streams are retained in `validation-v1`.
The exact preparation was committed as
`9ece4af4db5089417aac119fe5166266b2716821` before compilation.

All 28 new family/U/size/cap combinations were supported by the unchanged
upstream public constructor. Actual metadata, complete bitmap digest and dense
query digest agree across all three backends. Three original MAGIC controls per
backend reproduce the committed Stage2 proof exactly. The fixtures also compare
the complete PImpl/dynamic/static bitmap and query arrays, all inserted keys,
exact-n compact scratch guards, output guards, offsets and tails. These are
65,536-insertion correctness fixtures, including the large-capacity cases; they
are not full-occupancy false-positive samples.

The tested public geometries include the following large (`n=2^25`) capacities.
Padding to complete 64-byte backing units is charged:

| Public family | Cap, bits/key | Blocks | Logical bytes | Backing bytes |
| --- | ---: | ---: | ---: | ---: |
| Sector32 | 12 | 1,572,859 | 50,331,488 | 50,331,520 |
| Sector32 | 24 | 3,145,727 | 100,663,264 | 100,663,296 |
| Sector64 | 12 | 786,431 | 50,331,584 | 50,331,584 |
| Sector64 | 24 | 1,572,859 | 100,662,976 | 100,662,976 |
| Register64 | 12 | 6,291,455 | 50,331,640 | 50,331,648 |
| Register64 | 24 | 12,582,909 | 100,663,272 | 100,663,296 |

Only the checker translation unit was compiled. The three previously verified
original upstream archives were reused unchanged, with GCC 12.2 and the complete
Boost 1.83 include tree. Actual compiler dependency files, command lines, linker
commands, backend macros and CMake caches are retained. The three tested binary
hashes and consumed-input hashes are in `PREFLIGHT_FREEZE.json`; binary payloads
remain in their recorded build directories and are not committed. The existing
user tuner file is unchanged. Upstream pure-scalar public support remains outside
this proof, as recorded in the original baseline archive.

The entire preflight ran under the inherited exclusive socket0 flock, pinned to
CPU2. That lease was released after completion. No throughput timer or independent
negative calibration ran. The later fixed 36-row accuracy-only pilot still needs
its own worker/protocol freeze and execution authorization; no divisor will be
changed or dropped in response to that future result.

`seal_validation.py` reconstructs every raw row, checks the old controls and
cross-backend equality, verifies current consumed inputs and binaries, copies
the actual build provenance, and writes the proof inventory without executing
any Bloom filter. The frozen source-preparation README remains unchanged.
