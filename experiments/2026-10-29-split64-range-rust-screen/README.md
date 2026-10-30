# Rust Split64Range exact-capacity source preparation

This is an uncompiled source-only stage. No candidate executable, Rust test
result or performance measurement exists for this harness yet. The static
source guard passes; that is not a substitute for the required preflight.
No production file or earlier frozen experiment is changed.

`native/` snapshots current production Rust, including the promoted minimal
ByteSplit public `contains_hash` hint. It adds only the unchanged validated
Split64Range/range-parallel modules, their tests, exports and parity example
from commit `f3a9f4c6c6a4ed5f14e1d8e3145cdd3bbedadb10`. The other native
implementation files remain byte-identical to their recorded production
snapshot. Native sources retain their MIT AND Apache-2.0 license, both license
texts and NOTICE. No external dependency is added to the native crate.

`benchmark/` copies the frozen seven-public-API visible-single harness and
pins the same Fastbloom0.17, Bloomsday commit, SBBF0.2.8 and safe-wrapper0.3.2
dependencies. SBBF retains its upstream public trait-object dispatch. The
eighth adapter delegates to the actual public Range methods, including their
existing runtime dispatch and inline annotations. The adapter's public-method
forwarding hint is the same as the retained native adapters.

The new `geometry.rs` changes construction, not any probe/hash/query kernel:

- Native power-of-two layouts receive the inverse public constructor argument
  with real n retained. Under caps16/24/32, they allocate16/16/32bpk.
- Range, Fastbloom, Bloomsday and SBBF use actual16/24/32bpk. All ceilings are
  strict; this initial grid uses powers-of-two n and integral budgets.
- Fastbloom keeps `.expected_items(real_n)` and checks its public bit/probe
  counts. Bloomsday uses its prior sizing-only FPR inverse. SBBF charges its
  padded backing bytes. Standalone allocator tests must verify retained bytes
  before these geometry values are accepted for timing.

Every existing timed helper, build/query timer boundary, scratch allocation,
whole-array visible loop, phase schedule, post-trial dense validation and
calibration body is byte-identical to the source evidence in `source-before/`.
Geometry metadata and its observed byte-count assertion are appended after
all timed phases and calibration. The legacy `requested_bpk` CSV column now
means the explicit ceiling; `size_contract=exact_byte_ceiling_v1`, constructor
argument and actual allocation make that change explicit. The CLI admits only
16/24/32 ceiling values and rejects unsupported geometry before printing CSV.

The proposed seed42 training screen has18 cases/120 rows: n2^16/2^25,
batches1/31/4096, q2^22,50% hits,8 balanced repetitions and cal24. Native
16/24 geometry aliases are measured once; the native16 row remains eligible
under24/32. All four modes are retained in each row, and visible loops remain
whole-array at every batch tag. No cross-batch sample independence or global
capacity optimum is claimed. `registry.json` distinguishes current production,
external APIs and the experimental Range candidate.

Tests are drafted for all eight public APIs and every output tail, the full
copied native library, native Range's independent bitmap/parallel oracles,
every constructor's observed retained allocation/deallocation, the new24-bpk
SBBF/Bloomsday mapping against an independent scalar oracle, invalid/overflow
geometry and preserved FastPattern density semantics. The unchanged C++/Rust
twelve-fixture comparison remains required. None has been executed here.

Next, under an explicit parent-granted socket lease, run normal,
disabled-AVX512, forced-scalar and ASan correctness, complete library/Clippy,
same-capacity retained-reference semantic checks, CLI/fault guards and actual
public-loop assembly inspection. Then freeze the actual executable,
dependencies, tested source and reviewed runner before any speed run. This
stage deliberately has no measurement launcher. Its protocol's placement is
unassigned and does not imply a NUMA policy or CPU lease.

`verify_source.py` is a lightweight, non-compiling source/selection check. It
verifies all immutable kernel snapshots, seven retained hot adapters, complete
timed body, dependency manifests, public registry order and120-row alias
selection. `copy-source.json` records original paths/hashes; `source.patch`
records the benchmark/native declaration delta. The sibling performance-plan
directory describes the later C++ shared-bitmap MT comparison and separate
allocation-inclusive native build work.
