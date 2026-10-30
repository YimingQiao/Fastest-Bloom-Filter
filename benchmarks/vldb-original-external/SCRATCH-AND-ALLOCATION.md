# Compact scratch and allocation proof contract

The native and AVX2 correctness/accounting stages and native ASan/UBSan stage
pass. The whole-library non-AVX compile fails in unchanged upstream emulated
storeu code. No throughput or memory ranking follows from these proofs; runtime
allocation values come from the separate accounting executable.

For the supported positive-K blocked-Bloom public paths, exactly `n` u32 slots
(`4*n` checked bytes) hold every physical compact-output store. This capacity is
about input count, not returned hit count:

- `blocked_bloomfilter_batch_dispatch.hpp` writes one scalar position before
  conditionally advancing its writer. There are fewer than n consumed inputs
  before each such store.
- `simd/intrin_avx2.hpp` mask4/mask8 write all four/eight positions, including
  nonmatches. Before each nested-vector store, the writer cannot have advanced
  farther than the previously consumed inputs. The full native-vector width is
  still within the current processed-input extent.
- `simd/vec.hpp` compounded masks advance the writer by each nested popcount;
  the same invariant holds for U2/U4. AVX512 compressstore writes only matches.
- For AVX512 u64 masks, the supported positive probe count intersects the initial
  mask with equality masks that clear unused upper bits. This proof does not
  apply to arbitrary standalone complemented or all-one mask16 objects.

The proof was independently reviewed against pinned DTL
`c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf`. `PositionScratchBytes` rejects overflow.
The adapters return immediately for zero-count input, permitting null buffers.

`GuardedBuffer` places the exact payload end against a protected page and checks
left padding. Inputs become read-only. The correctness program checks all-miss,
all-hit and mixed queries, dense/compact/singleton equivalence, returned indices,
duplicates and count bounds, tails0..131 and long tails4096/4097/4127, across
query unroll0/1/2/4. Varying n also varies the guard-ended input alignment; source
query offsets vary the values, not necessarily that guarded address. Returned
positions are validated only in `[0,count)`; physical stores after count but
before n are allowed. Guard-page virtual space is test overhead, not query
scratch charged to a future baseline.

The original PImpl surface remains `dtl::bbf_32`/`dtl::bbf_64`. A public
`Configure -> construct -> CheckConfiguration -> use -> destroy` sequence is
mandatory. An adapter guard refuses Configure while any same-word artifact
instance is alive and rejects a different U after destruction. The upstream
transient calibration map uses insert without replacement, so each U uses a
fresh process. Upstream name() reads the shared tuner, whereas its query closure
captured the unroll setting at construction. DirectDynamic and
StaticLogic are separately named public alternatives, never replacements hidden
under the artifact label. Upstream files and algorithms remain unchanged.

The separate `vldb_accounting_check` executable replaces C++ new/delete and wraps
explicit mmap/munmap references from the linked translation units. A phase tag
attributes setup, owned control objects, explicit bitmap allocation, metadata,
and API work. It uses thread-safe counters, including upstream setup workers;
phase changes occur only in the serial caller after prior workers finish.
Allocation ownership is stored per allocation, so frees are attributed correctly
even after the active phase changes. The test verifies alignment, exact byte
accounting, direct mapping accounting, owned destruction, and no hidden C++ heap
scratch in the inspected insert/contains/batch API implementations.

The CSV distinguishes:

- Logical bitmap bytes and actual requested aligned backing bytes, including
  explicit padding. Adapter object sizeof and separately allocated control heap
  are distinct; the stack object is not silently added to the bitmap cap.
- Current owned control heap, total constructor allocation traffic and peak
  extra requested bytes. StaticLogic may own no control heap; public PImpl and
  std::function wrappers retain their observed heap state.
- Shared setup heap and mapped tuner-file bytes/pages as cumulative process
  state, with per-setup traffic/peak. These fields are not multiplied by alias
  count or charged as independent copies of the same registry.
- Metadata allocations and API scratch requests. Input/output fixtures and
  validation vectors run in the Harness phase, outside API accounting.
- Prefix-tracker overhead, explicitly excluded from original requested bytes.
  The instrumentation changes allocation layout and is never a timed target.

The ordinary-allocator `vldb_public_check` is also the ASan/UBSan target; it does not
link the prefix tracker, so instrumentation padding cannot hide payload
redzones. The tracker counts C++ heap requests and explicit linked mmap calls,
not allocator size classes, process RSS, libc-internal thread bookkeeping, or
resident pages. The inspected owned logic/tuner structures use C++ new and STL
containers; the model may additionally map its existing calibration file. A
future memory policy must distinguish bitmap caps, private control state and
shared setup; no memory winner is claimed here.

The validation driver records the existing `~/.dtl-filter.dat` identity/hash
before and after execution without changing HOME, deleting the file, invoking
calibration, or calling persistence. It verifies exact dependency commits,
clean trees, every pinned DTL source hash, original source inputs, compiler
commands, outputs and binary hashes. Completed and failed stages are retained in the versioned validation directories.
Native and AVX2 allocation records agree exactly; sanitizer output digests also
agree, with no diagnostics. No broader geometry or FPR claim is inferred.
