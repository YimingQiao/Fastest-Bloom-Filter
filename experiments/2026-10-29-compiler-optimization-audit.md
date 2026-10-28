# Fair compiler/profile/layout experiment: design audit

2026-10-29. Read-only source/toolchain inspection; **no compilation, training,
profile collection, linker change, host setting change or timing was performed**.
The only compiler invocation beyond help/version/path queries was `clang++ -###`,
which printed a proposed command without executing it.

## Feasibility on this machine

| Item | Observed installation | Consequence |
|---|---|---|
| Clang | `/usr/bin/clang++`, Debian Clang23.0.0, revision `cc613052fd6a` | Use this exact binary for every native/external candidate and every variant. |
| Instrumentation merge | `/usr/bin/llvm-profdata-23`, LLVM23.0.0 | Available; the unversioned `llvm-profdata` command is absent. |
| Profile runtime | `/usr/lib/llvm-23/lib/clang/23/lib/linux/libclang_rt.profile-x86_64.a` | Present. PGO is feasible without installing a package, subject to a later correctness-only build preflight. |
| ThinLTO plugin | `/usr/lib/llvm-23/lib/LLVMgold.so` plus GNU gold2.40/1.16 | Available matching-LLVM path. Driver-only inspection selects this plugin for `-flto=thin -fuse-ld=gold`. No actual link has yet been tested. |
| LLD | `/usr/bin/ld.lld-20`, LLVM20.0.0; no LLVM23 LLD found | Do not assume LLVM20 accepts LLVM23 bitcode. Use the matching LLVM23 gold plugin for the first ThinLTO experiment. |
| BOLT | No `llvm-bolt`, `perf2bolt` or `merge-fdata` found in PATH, `/usr/bin`, `/usr/local/bin`, installed LLVM20/23 `bin` directories, or `~/.local/bin` | BOLT is not ready; no install/build is proposed in this stage. |
| perf | `/usr/bin/perf`; `perf_event_paranoid=-1` | Presence/setting observed only. PMU/LBR access and event support have **not** been tested; no counter collection or setting changes. |

Clang documents IR instrumentation with `-fprofile-generate`, conversion by
`llvm-profdata merge`, then an ordinary optimized rebuild with `-fprofile-use`.
Instrumented training carries overhead and must never supply the comparison
timings. Keep generation/use source and flags matched and reject missing/stale
profile diagnostics. [Clang PGO documentation](https://clang.llvm.org/docs/UsersManual.html#profiling-with-instrumentation)

ThinLTO requires a compatible linker/plugin and performs cross-module importing
and optimization. Limit backend jobs to1 (`-Wl,-plugin-opt,jobs=1` with gold) so a
build respects the leased core. [ThinLTO documentation](https://clang.llvm.org/docs/ThinLTO.html)

The inspected existing scalar and bulk targets each compile **one C++ source
file**, with native/FastFilter/PageBloom/Boost/RocksDB implementations supplied
through headers/interface dependencies. Therefore much of the useful inlining
is already visible to `-O3`; large ThinLTO gains should not be presumed. PGO may
change branch decisions, nested inlining, register pressure or placement; a
measured change is not automatically evidence of an algorithm improvement.

## Preserve the two source contracts

The frozen scalar target
`experiments/2026-10-29-inline-single-query/benchmark.cpp` currently enforces
batch1. It has a noinline whole-array scalar kernel with optimizer-visible
public one-key calls, plus retained generic batch1 controls. Its raw scalar path
fuses the common hash per key; its original raw column stages hashes. Those
columns remain separate.

The shared bulk target `src/compare_benchmark.cpp` keeps noinline query/build
boundaries and runtime batches. The inspected release flags are
`-O3 -DNDEBUG -march=native -fno-strict-aliasing -std=gnu++17`, with no LTO/PGO.
Pinned versions, runtime ISA, raw-API traits, public-versus-private paths, output
writes, scratch, construction lifetimes and all allocation/FPR checks must stay
unchanged. Work from isolated copies with complete source/dependency hashes;
never rebuild a previously measured executable path.

`noinline` forbids inlining at the annotated function boundary. Keep it and
all explicit public-API controls unchanged in every build. PGO can still change
the code inside a kernel, including whether nested methods inline; verify the
required call boundaries and public indirect-call paths in assembly.
[Clang noinline reference](https://clang.llvm.org/docs/AttributeReference.html#noinline)

## Small first protocol, requiring a later execution decision

Freeze two separate registries: the full selected native/external list for the
scalar target, and the full selected list for the bulk target. Train and measure
**every selected candidate** in both reference and optimized binaries. Do not
profile only our implementations or compare an optimized native filter solely
against an unoptimized external build. An untrained compiled-but-unselected
candidate cannot enter the final ranking.

Use a four-variant factorial within each unchanged target:

| Variant | Compile/link differences relative to shared flags |
|---|---|
| G0 | `-fuse-ld=gold`; no PGO, no LTO. |
| G1 | Same gold linker; final `-fprofile-use=nonlto.profdata`. |
| G2 | Same gold linker; `-flto=thin`, one backend job, no PGO. |
| G3 | Same gold linker; `-flto=thin`, one backend job, final `-fprofile-use=thin.profdata`. |

Build separate instrumented G1/G3 training binaries using the corresponding
non-LTO/ThinLTO settings and `-fprofile-generate`. Both receive exactly the same
training scenarios and operation counts. Merge separately with the installed
LLVM23 tool; never force a stale non-LTO profile onto changed IR. Preserve the
current default-linker frozen executable as a sanity reference, but use G0 for
causal comparisons so linker differences are not attributed to PGO or ThinLTO.
These are fixed AOT executables; do not add fully-static libc linking as another
uncontrolled change.

Suggested bounded training data, to freeze before execution:

* Scalar: n2^16/2^20, requested8/16, batch1, hit50%, input42, q2^20, four
  repetitions. Four workloads, retaining all original/scalar phases.
* Bulk: the same dimensions with batches31/4096. Eight workloads.
* Whole-input insertion; independent calibration disabled **during profile
  collection**. Otherwise a large all-negative calibration loop would dominate
  the training branch distribution. Construction, inserted-key validation and
  warmups still contribute to the unchanged harness profile; disclose this.
* Equal complete workload sets per candidate; never stop training by wall time.
  Save one uniquely named `%m-%p` profile per invocation and its exact command,
  then merge with prespecified equal workload weights. No held-out inputs enter
  profile collection and no training timing is evidence of speed.

Before measurement, run native/full-output/CLI/fault checks for every final
variant, require identical bytes/checksums/FP/calibration counts, inspect profile
coverage for all selected implementations, and archive assembly/code size,
compiler/linker/profile/source hashes. Sanitizer builds are separate correctness
artifacts and never training or performance inputs.

Suggested held-out protocol: fresh input seeds not used in training, n2^16/2^25,
requested8/16, hit50%, q2^22, eight repetitions, independent calibration2^24.
Scalar keeps batch1; bulk keeps31/4096 and may add a prespecified short-tail
transfer case. Fix exact new seeds/registry/limits before running; this note
does not consume or choose held-out seeds. Run all variants on one leased
physical CPU with the same NUMA placement and rotate variant execution order
per scenario. Retain every trial and pair the same filter/workload/seed across
variants; do not compare unrelated medians from different runs.

Report each filter's G1/G0, G2/G0 and G3/G0 ratios and losses separately. For an
optimized native-versus-external claim, compare equal optimization variants and
also apply a conservative rival check against each external candidate's best
predeclared variant across the same held-out seeds, including G0 if PGO regresses.
Memory caps and independently measured FPR eligibility remain mandatory.

## Layout-only follow-up, not part of the first factorial

LLD20's local help exposes symbol ordering, call-graph sorting and seeded section
shuffling. It can be considered later for **native ELF objects without LLVM23
bitcode**, subject to a link preflight. Use the same linker and function-section
settings for both layout controls; keep a small predetermined set of layout
seeds for every candidate and report all of them, rather than selecting a lucky
layout. Do not mix linker, section, alignment, PGO and LTO changes into a single
unattributable experiment. Section shuffling is a sensitivity check, not an
assumed optimization.

BOLT is a later optional stage after a pinned tool is available. Its official
requirements include an unstripped symbol table; emitted relocations improve
its ability to optimize. A separate whole-suite profile and an otherwise
identical pre-BOLT control would be required. [Official BOLT README](https://github.com/llvm/llvm-project/blob/main/bolt/README.md)

No speedup, regression fix, or register-pressure improvement is established by
this audit. The feasible first step is a correctness-only G0/G1 toolchain
preflight and then the prespecified equal-treatment experiment; it remains
separate from the currently running BlowChoc held-out accuracy work.
