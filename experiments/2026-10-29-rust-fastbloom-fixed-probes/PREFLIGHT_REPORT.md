# Fixed public probe-count correctness completed

The focused preflight passed without changing the committed Rust sources.
No112-row formal calibration or performance matrix has run. The initial public
K1..12 proposal is `bbc3474cdd15b2e3301384dff4afdc12505cbfe9`; the accuracy
executable source is `cb4b160e6f4a6a079efd1a4ccb9591f4f5bf91a6`.

Normal, disabled-AVX512 and ASan builds passed all16 executed test cases across
their six test invocations. These check every fixed-K wrapper's complete public
bitmap, dense/public-singleton equality, tails, offsets, guards, duplicates,
false negatives, unchanged query bitmap and counted allocation/deallocation.
The default16-bpk/K11 alias matches exactly. Driver tests prove one constructor
and destructor per row and reject deliberately changed final answers in the
inserted, mixed-query and calibration streams. The broad unchanged native
implementation tests were not rerun.

The normal test additionally observed all72 formal EMPTY fixed-K constructors:
K1..12 at16/24/32 actual bpk and n2^16/2^25. Public `num_bits` and `num_hashes`
matched the intended geometry. Every constructor retained exactly one counted
allocation, no temporary allocation, and freed exactly the observed bytes.
The count is requested backing bytes, not allocator usable-size or RSS. This
audit generated no formal inserted or negative stream.

All180 tiny correctness rows (20 APIs ×3 capacities ×3 backend modes) agreed
on complete counts/checksums and geometry. Each mode reproduced all24 retained
public reference semantics from the immutable Rust Range executable, giving
72 semantic comparisons. The tiny fixtures use n1024, q4096 and4096 calibration
negatives and must not be treated as the formal FPR screen. Every emitted dense
answer was checked against the public singleton before counting. All30 malformed
CLI cases rejected before CSV output.

The first attempt completed the tests and normal/disabled CLI checks, then its
artifact-discovery guard stopped: nightly Cargo stores test executables under
`release/build/<package>/<hash>/out`, while the script expected `release/deps`.
V1's42 commands, original output, failure record and exact executable remain
archived. The additive V2 resume, committed as
`325838708d9cef7fb9c5d1d7d476efe659a3aafe`, reused those successful checks only
after verifying their source/flags/dependency/output/binary pins. It discovered
the exact executed test from Cargo stderr, built only the missing ASan standalone
program using structured Cargo compiler-artifact output, and completed14 pending
commands. No passed test suite was repeated.

Both attempts held the inherited exclusive socket1 flock and CPU3 affinity;
no explicit NUMA memory policy was set. The normal executable uses rustc1.92.0,
LLVM21.1.3, release thin LTO, one codegen unit and
`-C target-cpu=native -C symbol-mangling-version=v0`. Disabled dispatch used the
generic stable target; ASan used nightly1.100.0/LLVM23.1.1 with
`-Zsanitizer=address`. All298 preserved source/evidence inputs,11 dependency sets
and seven executable hashes passed the final checks. The separate freeze records
the actual compiler-consumed repository paths and original dependency files.

The selected untimed native calibration executable is
`/tmp/fastest-bf-fastbloom-fixed-k-preflight/accuracy-validation-v1/normal/release/accuracy`,
SHA256 `c12193083676046d31fc871cfa54e1f2b36e48fb19cc566f91f9dd546edf6271`.
The later112-row accuracy runner still needs a reviewed committed protocol and
explicit lease. The initial minimum-qualified-K neighborhood remains only a
diagnostic shortlist; a subsequent timing protocol may include all12 public K
values. These correctness results establish no latency or FPR leadership.
