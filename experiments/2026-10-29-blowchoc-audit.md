# BlowChoc integration audit

Read-only audit of upstream commit
[`2c6da95532eda8b1dd0444c24516193a67edc508`](https://gitlab.com/rahmannlab/blowchoc-filters/-/tree/2c6da95532eda8b1dd0444c24516193a67edc508),
retrieved into `/tmp/fastest-bf-blowchoc`. No performance comparison has been run.
The [SEA 2025 paper](https://drops.dagstuhl.de/storage/00lipics/lipics-vol338-sea2025/html/LIPIcs.SEA.2025.25/LIPIcs.SEA.2025.25.html)
describes a blocked filter that selects an insertion block by cost and queries
multiple possible blocks, trading additional work for improved space efficiency.

## Adapter contract

Use the unmodified `blowchoc.filter_bb_choices.build_filter` factory and its public
`insert(array, key, positions)` / `lookup(array, key, positions)` methods. The
factory accepts a full u64 universe as `4**32`, one subfilter for serial comparison,
an explicit block count, choices, probe count and bit-selection strategy. Allocate
one reusable uint16 position array per worker; report its bytes separately.
The upstream code prefetches all candidate blocks and can return early during
bit tests. Those behaviors should be retained. The two-choice exponential cost
with the paper's golden-ratio beta and mu=1 is a relevant first configuration;
one-choice blocked and distinct/random bit variants should remain controls.

The factory compiles constants for each chosen layout. Compile and warm every
timed signature before measuring steady-state insertion/query, and record cold
compilation separately. Explicitly save the generated subfilter/block/bit hash
function strings; seeding key generation alone does not freeze these functions.
Use separate Python random state for construction parameters, unrelated to query
or calibration streams. Do not select hash functions using measured FPR.

## Actual allocation

`lowlevel/aligned_arrays.py` computes `slack = byte_alignment - itemsize`, then
allocates `np.empty(items + slack, dtype=dtype)`. For uint64/64-byte alignment this
adds **56 elements = 448 bytes**, not 56 bytes. The returned aligned array is a
view. `filter.mem_bytes` counts only that view and omits this backing-array space.
A comparison must follow the NumPy `.base` ownership chain and count the actual
backing allocation as filter payload, while reporting the logical bitmap too.
This is source inspection, not a measured memory result.

The factory rounds blocks per subfilter up to an odd number. At the intended
power-of-two byte budgets, passing `(budget - 448) // 64` blocks gives an odd
count and exactly meets the budget with this allocator. Verify actual bytes and
alignment at runtime; reject budgets too small for the backing allocation.
Do not silently repair the upstream allocator in the baseline.

## Measurement requirements before comparison

The published timing driver counts positive answers and uses its own datasets;
its numbers do not share the current native harness contract. An integration
needs identical u64 insert/query inputs, full dense output checks outside timers,
all inserted keys checked for false negatives, and independent negative
calibration. Native and JIT kernels should each execute the entire batch loop
in compiled code, with Python/FFI crossings once per measured trial rather than
once per key. Preserve query batch boundaries and distinguish prehashed work
from common raw-key hashing plus lookup. Match output writes and include common
hash scratch costs. Record compiler/JIT versions, flags, CPU/NUMA placement,
source hashes, repetitions and every raw trial.

First validate small deterministic inputs against a scalar oracle using the
actual frozen hash functions, then cross-check raw/prehashed outputs and measure
accuracy. Only after that should this baseline enter a throughput table. Its
native upstream hash/probe work remains inside timing, like the other adapters.
This audit does not establish a win or loss against BlowChoc.

## Chosen bridge for the next implementation stage

Use a Python driver that times one compiled whole-query loop per trial for each
implementation. C++ can export typed whole-loop operations through a shared
library; Numba compiles its loop around the unmodified upstream lookup. Both
write the same dense u32 output array. Python and FFI crossings occur once per
trial, outside per-key work. A C++ adapter calling a JIT function pointer for
each key would add a different opaque-call boundary, so it is not the selected
way to compare natural scalar API throughput.

This belongs with the separate optimizer-visible single-key track. Retain the
existing generic batch-API measurements independently. Warm the JIT functions
once per immutable parameter set; reuse compiled functions with newly allocated
bitmap arrays for construction trials. The compiled methods already accept the
bitmap explicitly. Verify that no warm-up bitmap remains retained by a Python
closure or descriptor while a measured bitmap is live. Preserve actual NumPy
backing allocation and record cold compilation separately.
