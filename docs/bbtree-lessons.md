# What we borrow from bbtree

Xiangpeng Hao's [bbtree explanation](https://blog.xiangpeng.systems/posts/bbtree/)
orders the main costs as dependent cache-line accesses, instructions, then cache
coherence traffic. Compact inline keys reduce pointer chasing; SIMD searches
compact nodes without a chain of unpredictable branches. Batched operations
interleave independent searches to hide memory latency. Optimistic reads avoid
writing shared reader counters. These are mechanisms to measure, rather than a
promise that applying one technique makes another data structure faster.

Our Bloom filters have different work: a query tests bit positions rather than
following an ordered search path. All four layouts keep a key's probes in one
64-byte line. The remaining decisions depend on whether that line is already
cached, how many independent keys are available, and whether writers share it.

| Cost | Implementation here | Evidence and limits |
| --- | --- | --- |
| Cache-line accesses | FastPattern, FourSector and Split64 cluster probes; ByteSplit packs four 16-byte buckets into each aligned line. | Fewer lines is useful only with acceptable FPR at the measured space budget. [Layouts and constrained rankings](modern-confirmation-2026-10-28.md). |
| Independent memory work | Large batches use prefetching and SIMD gathers; FourSector prepares short groups to expose independent accesses. | [Native C++ short-query confirmation](../experiments/2026-10-28-four-sector-probe/integration.md) and [Rust control](../experiments/2026-10-28-rust-four-sector-short/README.md). Small and large batches have separate kernels and results. |
| Hot-path instructions | Tiny queries bypass unused batch setup. ByteSplit directly addresses a power-of-two bucket array. | [Short-query controls](../experiments/2026-10-28-small-batch-kernels/README.md). The ByteSplit port needed a flat byte offset: the compiler did not collapse its line/slot expression automatically. [Assembly and port check](../experiments/2026-10-29-native-byte-split/integration-report.md). |
| Cache coherence | Exclusive parallel builders assign complete lines to workers and align histogram rows. Immutable queries do not update shared counters. | [Native layout scaling](layout-parallel-2026-10-28.md). Partitioning scratch and thread launch remain real costs; atomic overlapping writers/readers have separate semantics. |

We also use the cost model to reject appealing changes. A design that accelerates
the insertion loop can still lose if distributing hashes costs more. A masked
query can accelerate prehashed reads but stall on freshly written hash scratch.
Therefore the benchmark retains full construction cost, pure-query and hash+query
columns, actual payload bytes, FPR evidence and failed experiments.

Correctness gates are independent of speed: scalar bitmap oracles, all inserted
keys, dense output checksums, boundary/offset tests, sanitizers, thread checks and
cross-language parity. These are practical checks, not a claim that this Bloom
filter project has bbtree's formal-verification coverage. The shared benchmark
also checks that the requested implementations actually ran and that first-timed
outputs match the verified warm-up outside the timers.

## What the later experiments showed

The instruction-count lesson is useful only alongside the space/quality gate.
A cyclic probe mask needed fewer vector instructions but increased false
positives; compensating with a larger bitmap lost15 of16 eligible external
comparison views. It was [rejected](../experiments/2026-10-29-cyclic-split64-analysis/FINDINGS.md).
A fixed multiply-code mask keeps a short dependency chain while passing the
first16/24-bpk quality gates. Its [70-row screen](../experiments/2026-10-29-multiply-code-split64-performance-analysis/report/RESULTS.md)
improves small equal-space Split64Range throughput by about8–10%, yet loses on
large tables. Quality estimates need sufficient precision too: a
[new disjoint sample](../experiments/2026-10-29-four-sector-quality-resolution/RESULTS.md)
qualifies both FourSector16 constructions whose earlier confidence upper
endpoints narrowly failed0.1%. The stronger rival remains visible in the
[fresh-seed comparison](../experiments/2026-10-29-multiply-code-small-confirmation/README.md).
The mask remains experimental; fewer instructions alone do not establish a win.

The next [uniform precision audit](../experiments/2026-10-29-eight-api-quality-resolution/RESULTS.md)
applies the same117-million fresh negatives to all eight APIs and all six
constructions. FourSector passes every new gate. Under that separate new gate,
Multiply loses all36 comparisons against the fastest rival in the original
timings. Keeping a fast rival in view can change the engineering decision;
an inconclusive accuracy interval should not become a permanent exclusion.

The [native Rust range screen](../experiments/2026-10-29-split64-range-rust-analysis/report-final/REPORT.md)
shows why address arithmetic needs the same scrutiny. Arbitrary cache-line
budgets make24 bpk usable, but range addressing loses47/48 equal-allocation
query comparisons to the power-of-two Split64 layout. The useful result is
finer capacity control, with an explicitly measured cost in that workload.

The [eight-core comparison](../experiments/2026-10-29-split64-range-parallel-analysis/report-final/REPORT.md)
retains that capacity benefit: Range24 leads the eligible external controls
at the strict24-bpk ceiling, while losing most wider comparisons against
production layouts. A separate [FourSector range pilot](../experiments/2026-10-29-four-sector-range24/accuracy/RESULTS.md)
keeps the fast gather kernels but fails the same24-bpk quality gate. Fitting
the desired memory budget and preserving a fast kernel are both insufficient
without testing the resulting probe distribution.

The [native API scaling screen](../experiments/2026-10-29-split64-range-native-scaling-analysis/report-final/REPORT.md)
also exposes a practical limit of exclusive ownership. At 32M keys, full
allocation+parallel construction gains 2.18–2.61×, but every tested 65K-key
eight-core build loses. Partitioning and thread startup are included, so the
worker-selection experiment must consider an incremental insertion's
batch length and the existing bitmap's size must both be considered: a short
batch can still touch a large table. The query worker policy is a separate decision.

Baseline configuration needs the same care. The [complete Fastbloom probe
calibration](../experiments/2026-10-29-rust-fastbloom-fixed-probes-analysis/report/REPORT.md)
finds that K7 at 24 bpk passes the 0.01% gate at both tested sizes, while its
automatic default uses K17 for greater accuracy. Counting a win over that
default alone can overstate our advantage. The next timing comparison keeps
every tested K; the fewest qualifying probes need not give the lowest latency.

Compiler boundaries also matter. Exposing Rust ByteSplit's public singleton
body removed a hot per-key call and improved fused throughput16–38% in the
isolated comparison, with2–3% losses in some short batches. The
[minimal hint](../experiments/2026-10-29-rust-byte-inline-integration/EVIDENCE.md)
is integrated with that tradeoff documented. Conversely, a four-line
Independent32 shortcut made the compiler save six registers instead of one
and was rejected after batch regressions. Its next isolated revision restores
the smaller prologue. The [208-row comparison](../experiments/2026-10-29-independent32-rust-scalar-inline-analysis/FINDINGS.md)
improves batch-one throughput10–20% but still loses16.6% on small batch-two
queries, despite matching the original's bulk-loop instructions. It remains
isolated. Source brevity and instruction counts alone are insufficient evidence.

The [original/modern raw-u32 screen](../experiments/2026-10-29-vldb-raw32-analysis/RESULTS.md)
shows why the same cost model must include allocation flexibility and the public
call boundary. Native filters beat the eligible original-artifact configurations,
but modern Boost at roughly 24 bpk still beats the fastest qualifying native at
32 bpk in both large strict bulk rounds. The remaining gap cannot be explained
by cache-line count alone. Page's scalar byte API also exposed a by-value stack
copy in the caller. The completed
[240-row pointer-direct control](../experiments/2026-10-29-page-pointer-single-analysis/RESULTS.md)
finds no stable benefit from removing that copy: small-table single calls all
regress, while large-table changes have both signs. Unchanged dense callees also
vary. A plausible instruction-saving change still needs a measured result.

The [full Rust public-probe screen](../experiments/2026-10-29-rust-fastbloom-fixed-probes-performance-analysis/report/INTERPRETATION.md)
now quantifies that baseline-configuration effect: tuning strengthens 48 of 216
query views, up to 1.97×. Range retains its 24-bpk niche but loses most equal-byte
controls. A different [range K12 pilot](../experiments/2026-10-29-four-sector-range-probe-pilot/RESULTS.md)
changes the existing dictionary while preserving four word accesses. It meets
the strict 24-bpk quality gate at both sizes. Its
[296-row bulk screen](../experiments/2026-10-29-four-sector-range12-analysis/INTERPRETATION.md)
then wins the eight strict24-bpk views against both external and retained native
leaders, while losing most wider views. The smallest hash+query gains are only
about3%, so independent seeds still matter. The reduced word count helps in a
specific measured capacity range; it is not a general argument for more mask bits.

The [fixed build-policy confirmation](../experiments/2026-10-29-native-build-policy-analysis/DECISION.md)
puts numbers on thread-startup costs. Serial fallback for small batches in small
bitmaps improves every active-gate comparison, but several unchanged-policy
controls regress repeatedly. Even a policy that leaves the selected worker
count unchanged can alter caller/code generation. The native port therefore
keeps the failing controls and must compare the actual public entrypoints before
changing defaults. Neither a shorter path nor unchanged algorithmic work proves
that the generated program is faster.

The [safe Rust K12 single-line rewrite](../experiments/2026-10-29-rust-k12-single-line-analysis/INTERPRETATION.md)
makes cache-line locality explicit in safe code: borrow the physical line once,
then index its four words. Ordinary inline hints remain unchanged. Actual
visible callers reduce four global line-bound checks to one and eliminate the
successful-path per-key helper call. Visible-single throughput improves
1.19–1.46× against original K12, but small batch31 regresses and4096 is mixed;
Range still wins every singleton/build comparison. Body simplification and the
compiler's changed inline decision occur together, so their separate causal
contributions are not identified. The earlier forced-inline variant's losses
remain relevant: removing a call alone was insufficient.

The [conditional C++ insertion confirmation](../experiments/2026-10-29-k12-prefetch-line-or-analysis/DECISION.md)
illustrates the cost of replacing scattered word updates with full-line SIMD
updates. Extra mask preparation accompanies fewer scalar memory ORs. Every
96MiB construction observation improves, while3MiB whole-input insertion
regresses in all three seeds and12MiB is mixed. Different cache residency and
instruction cost are plausible explanations, not measured hardware-counter
causality. The existing2MiB dispatch therefore does not justify enabling this
kernel throughout that interval. Evaluate the complete operation and actual
working set before turning a local improvement into a default policy.

The [C++ singleton SIMD experiment](../experiments/2026-10-29-k12-singleton-vector-analysis/INTERPRETATION.md)
loads one aligned line and selects its four words with register permutations.
Its dictionary lookup and rotations also use SIMD. This preserves the original
one-cache-line footprint: it does not reduce cache lines fetched. The actual
visible caller also inlines the public method, shrinks its frame and sometimes
unrolls the loop. Visible fused throughput improves 1.91–2.27× over old K12,
while large batch31 hash+query loses 1.8–3.0% despite unchanged bulk source paths.
The useful lesson is to inspect the generated public caller and measure both
tiny and bulk operations; the evidence cannot isolate SIMD as the sole cause.
In the [expanded external caller](../experiments/2026-10-29-k12-singleton-external-plan/caller-v2/PROOF_REPORT.md),
even old K12's source-level scalar oracle contains compiler-generated 128-bit
vector operations. API names alone do not describe the instructions being timed.

The [completed external comparison](../experiments/2026-10-29-k12-singleton-external-analysis/INTERPRETATION.md)
also tests whether that internal speedup closes the useful gap. It does not:
the SIMD candidate wins 20 eligible external single-key comparisons and loses
204, while 64 are unavailable under the fixed memory/quality gates. The native
composite still loses 63 external comparisons. Reducing one kernel's instruction
cost is useful, but the next design must target the strongest qualifying rival
and preserve the bulk regressions, not just beat its own predecessor.

The [Rust SIMD caller proof](../experiments/2026-10-29-rust-k12-singleton-vector-plan/caller/assembly-review/REVIEW.md)
shows why this must be checked separately for each language and build profile.
Its native build hoists the feature check and inlines the vector path. The
portable build retains a public call and a target-feature jump for each key,
while the old safe scalar control already inlines. Both pass correctness checks,
and the [subsequent 192-row measurement](../experiments/2026-10-29-rust-k12-singleton-internal-analysis/INTERPRETATION.md)
reports the profiles separately. Visible hash+query throughput improves
2.14–2.24× in native builds and 1.68–1.80× in portable builds against each
profile's own control. All 224 batch1/3 pairs improve, while native large
batch31 hash+query retains four losses and batch4096 is mixed. These results
support measuring the actual caller; they do not isolate the cost of a call
or prove that unchanged bulk source preserves bulk performance.

The [raw-byte baseline caller](../experiments/2026-10-29-fastbloom-rs-raw8-caller/proof-final/REPORT.md)
also makes temporary memory part of the complete-operation cost. A prehash API
needs workspace to process raw keys in batches; that workspace's allocation
and initialization belong inside complete construction, while a direct raw-byte
API receives no unused buffer. The verified caller releases build scratch
before queries and keeps every implementation's required hashing inside its
raw operation. This prevents a faster inner loop from hiding prepaid work.

The [fixed64 prefetch caller](../experiments/2026-10-30-independent32-range-prefetch64/caller/assembly-review/REVIEW.md)
makes the memory-overlap hypothesis explicit: a 256-byte queue holds bucket
indices for 64 future queries, while each probe mask is computed when its
bucket is consumed. The actual native and AVX2 code moves the queue's stack
setup before the batch-size branch, so even short generic calls pay that cost.
Boost's measured public adapter returns from its singleton path before its
larger bulk frame. This is a concrete reason to retain small-batch controls
when adding a bulk pipeline. Correct output and visible prefetch instructions
alone establish neither a speedup nor how many misses the processor overlaps.
The [completed comparison](../experiments/2026-10-30-independent32-range-prefetch64-analysis/INTERPRETATION.md)
reduces large batch4096 latency 8.7–12.6% against its exact non-prefetch control,
yet prehashed queries still lose to both eligible rival groups. Hash+query wins
are only 0.2–1.8%, and small-table bulk calls regress against the control.
The preset target fails. Queue traffic, address arithmetic, stack work and
changed generated code remain costs to investigate together; the measurement
does not isolate a prefetch-only effect.

The [complete Poppy comparison](../experiments/2026-10-29-poppy-public-speed-analysis/INTERPRETATION.md)
also keeps the strongest existing rivals visible. Adding 47 public mappings
produces no Poppy win over retained external leaders in this prepared-input
contract, while the native composite still loses 73 query and 42 build views
to Bloomsday. Poppy's actual per-key call, cache and secondary hashing are
measured costs, but the timing does not isolate any one as the cause. A new
baseline failing to lead does not close an existing gap or predict a different
raw-input API's performance. Optimize the remaining measured losses and keep
the complete-operation boundary explicit.
