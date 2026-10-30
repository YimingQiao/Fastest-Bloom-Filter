# CPP616 actual caller correctness and code generation

The bounded V2 correctness attempt completed in one run after the preserved V1 compile failure. No formal 616-row performance matrix has run. Source commit is `a90c826a2be88dba38987a055dae2407be277fd4`; session 58715 exited 0 under one inherited exclusive socket1 flock. The parent and compiler ran on CPU3; filter children used CPU3 and explicit NUMA node1 memory binding. The socket was released after completion. A subsequent short read-only capture closed the actual query callee spans, with no compiler or filter execution.

V1 is preserved unchanged: source `d0b9a90ab75efa63c866fd4f4ffdd8ef27885d06`, failure archive commit `2d23a3860f3dd9abc67657f2b8c0e6d6da90b3f0`. Its normal compile stopped on nine unqualified native names after four commands, before any filter invocation. V2 adds only the reviewed 15-line namespace-binding entry and provenance/path adjustments. CMake, flags, kernels, adapters, geometry, input construction, timing body and validation loops retain their reviewed bytes. All original warnings and errors remain in the logs.

## Functional evidence

The complete 205-command ledger and every stdout/stderr digest are in `validation-v2/commands.json`. Normal, minimal-F and ASan+UBSan each passed 122 small caller rows and 64 allocation-only rows. Across profiles that is 366 caller rows, 192 exact allocation observations, and six old committed semantic replays. Both orderings reproduce identical full semantics. Two injected full-output mismatches and nine invalid CLI cases produced exactly exit 1, empty stdout and the required diagnostic. No crash or arbitrary nonzero exit counts as a successful rejection.

The 19 actual instantiated types are seven native types, three Boost types, seven FastFilter types and two RocksDB types. Page headers belong to the inherited dependency closure; no Page type is measured by this panel. All 64 formal geometries receive empty allocation checks at their real n16/n25 sizes; full insertion tests stay within the fixed small proof. There is no new large kernel or concurrent-build matrix.

The final metadata binds 191 prepared source/evidence paths, 591 actual consumed input paths, six executable tool paths and these three executables:

| Profile | SHA256 |
|---|---|
| Normal | `976f56bf14a63483ab8c2de340c08e7c32fcc064cd87abf933e55140d5b70a47` |
| Minimal-F | `41935d2da7dfa812719a1182ef41923353186be4d985e8091832504621f132a5` |
| ASan+UBSan | `63ea36d5e729486c16f7306dbca0b0249cc162cdc9f169f7c1f5eee031835a72` |

The candidate intrinsic requirement is AVX512F. The minimal executable also retains AVX2 for the unchanged Fixed32/64 external public baseline. It disables AVX512VL/DQ/BW/VBMI/VBMI2/BITALG/VPOPCNT; this does not imply the entire executable is restricted to AVX512F alone. Binary, source, consumed-input and tool hashes were checked before filter execution and again at the end. Unknown repository inputs fail the prepared closure check.

## Actual address evidence

`assembly-review/SYMBOL_MAP.{json,md}` lists all 152 initial bounded ELF captures: per profile, 19 opaque generic helpers, 38 public visible loops and 19 typed Run bodies. `assembly-review/callees-v1/CAPTURE.json` adds 16 query callees per profile by following the actual direct call/tail-branch graph from generic and visible roots. It includes actual public Lookup, the old K12 source-scalar oracle, remaining vector targets and Boost query cores. All 184 captures are nonempty, begin at the raw ELF symbol address, remain within its size and bind the exact executable and tool hashes. There are no unbound direct transfers in this query-root closure. This inventory does not claim arbitrary indirect-call or whole-program closure.

`assembly-review/CLOCK_WINDOWS.json` records all 38 Run clock pairs and their four in-window typed query callsites. Generic common hashing, public query calls and dense output writes remain inside the clocks; poisoning, full-output checking and input validation remain outside. For the normal candidate, the interval is `0x4c9d2` to `0x4ce10`, calls are `0x4ca4c`, `0x4ca7f`, `0x4caa2`, `0x4cc4e`, and the full output check is later at `0x4cf6f`. This verifies actual caller placement, not just source-line placement.

The normal candidate visible pure loop is `0x61340`/546 bytes, with two-key unrolling and one saved GPR. Its fused loop is `0x61570`/263 bytes, also with one saved GPR and no hot call. The minimal-F pure candidate is `0x57350`/209 bytes, without a frame or hot call, and uses KMOVW. Full-line bitmap reads are folded into memory VPERMD operands; dictionary selection and variable rotations remain present.

The old K12 normal fused visible loop is `0x5f6a0`/154 bytes, retains six saved GPRs plus 24 bytes of explicit stack space, and calls `LookupScalar` at `0x5f4f0` per key. That callee is a source-level scalar oracle, but its 297-byte machine body uses compiler-vectorized 128-bit work and four individual word loads/inserts. Calling its machine path purely scalar would be inaccurate. Range fused `0x63490`/443 bytes is fully inlined with two-key unrolling. These differences are retained as actual public-call costs.

The candidate opaque normal helper at `0x61208` tail-jumps to public `Lookup` at `0x62100`/1368 bytes. Its n=0 guard returns, n=1/2/3 execute the inline singleton-vector operations, and larger inputs take the original source routes. The minimal-F public counterpart is `0x57fa0`. Larger query source bodies are unchanged; equality of machine-code layout or throughput is not assumed.

The SIMD helper change is coupled to the compiler's inline, frame and unrolling decisions. Symbol sizes differ from the earlier two-type proof because this is a larger caller binary. No future observed gain may be attributed solely to one line load, and the earlier large-batch losses remain part of the fixed formal design. This correctness/ASM evidence makes no speed, FPR leadership, build, Rust or multithread claim.

The independent external public-path review is complete in `assembly-peer-baseline/REVIEW.md` and `inventory.json`. All 48 external visible wrappers across both profiles have no call instruction in their actual bodies; common hashing and dense writes remain present. Boost32 generic wrappers tail-jump to public Lookup, while Boost64 retains a call to its public-bulk implementation core. FastFilter singleton aliases and Rocks direct versus prepared-bulk contracts remain separately registered. This is actual public-path evidence, not a private-kernel substitution or throughput claim.

The original functional metadata intentionally retains `manual_review_pending=true`. The separate final `COMPILED_PROOF.json` closes the manual gate using the exact caller/callee captures, native/timer review and independent external public-path review, without rewriting that historical record.
