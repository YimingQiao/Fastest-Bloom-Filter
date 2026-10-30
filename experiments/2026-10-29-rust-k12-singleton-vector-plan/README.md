# One native Rust K12 singleton SIMD candidate

This is source preparation only. No Rust compiler, filter construction, test or
measurement is authorized here. The exact control is the optional native
SingleLine module at `ba5530a4fc38930a9da4593f2a8af7d1de3c853a`. `derive.py`
creates one candidate and proves that removing its three precise additions
recovers every original byte. No production file is edited.

The public `contains_hash` checks the existing cached `avx512` flag before a
private AVX512F helper. Public `lookup_hashes` preserves its mismatch assertion,
then routes only lengths1..3 to a feature-enabled tiny loop. That loop gives
one public-to-target-feature boundary per batch, rather than requiring that
transition per key. The compiler may still leave calls between the two
same-feature helpers; actual inlining is not guaranteed. Empty input and every >=4 source body retain the
old route. The unchanged runtime flag requires AVX2+AVX512F, is false on
non-x86_64, and respects `disable-avx512`. The new operations themselves need
only AVX512F; no VL/DQ/BW intrinsic is added.

One checked line borrow establishes the initialized,64-byte-aligned allocation.
The helper loads that complete line and selects four words using VPERMD. Its
offsets are quarters XOR ((hi XOR (hi >> [32,2,4,6])) &3); SIMD shift32 produces
zero for the first sector. RORV32 of low32 at0/8/16/24 includes the scalar wrap
bits, VPERMD uses the low4 dictionary index bits, and ROLV32 uses the low5 bits
of code>>4. Only the low4 equality-mask lanes determine the answer. The masks,
top24 address, dictionary, bitmap, allocation, insertion and physical-line
parallel ownership are unchanged. Source bodies at larger batches remain
unchanged, but extra dispatch and compiler layout may still alter their cost.

The current Rust scalar control already has the proved SingleLine inlined body.
This differs from the old C++ control's helper-call boundary. Rust's Reference
states that `target_feature` functions cannot inline into callers lacking those
features and cannot use `inline(always)` (locally installed Rust1.97.1 Reference,
attributes/codegen.html, target_feature.inline). Both new helpers use ordinary
`#[inline]`; no existing hint is changed. A portable binary may keep a runtime
feature branch and outlined public-singleton call. A native-feature build may
inline or hoist dispatch, but this is an assembly question, not a promise.
No C++ speed result is transferred to Rust.

`PLAN.json` fixes the next bounded correctness and actual-call inspection
scope. A later actual caller must snapshot the complete native crate from the
same commit for each arm, use the same compiler/optimization/profile per arm,
and bind every consumed input before execution. The retained original tests
and independent bit oracle are provenance; the existing broad native/MT kernel
matrix is not scheduled again. Focused additions must cover this helper and
its public route, output-length rejection, complete outputs and the unchanged
source guards. No test/build driver is supplied or authorized by this plan.

If performance is later authorized, the primary comparison must keep generic
batch1/3 pure and common-hash contracts, visible public pure/fused singleton
loops, and31/4096 unchanged-source controls, all against current native
SingleLine in the same executable. Portable dispatch and native-feature
contexts must be labeled separately; do not combine their latencies or use
the C++ measurements as a baseline. Both same-input API orders, all losses and
actual call/branch/frame costs must be retained. The concrete seeds, matrix,
placement, actual binary, and timing authorization remain unfixed; there is no
performance entry point and no parameter search in this stage.
