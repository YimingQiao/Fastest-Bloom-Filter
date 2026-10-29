# Optional native Rust K12: actual packaging proof

The optional native `FourSectorRange12BloomFilter` passes the bounded actual-package checks: **40 normal library tests, six K12 tests with AVX-512 disabled, six K12 ASan tests, and36 exact public native/reference fixtures**. All three fixture profiles produce checksum `18007857521353364698`. There were no throughput workloads or new false-positive calibration samples. This proves packaging correctness and records actual code generation; it does not establish native port-cost or Rust multithreaded speed.

The clean isolated integration worktree is `/home/yiming/projects/fastest-bf-rust-k12-integration`, base `4d2d2258302ace258c19b7ab33c1d0a2e7d796ef`, optional-source commit `771262e3ba9aa8e51610e0981d86884361d19624`, final test-only correction `3af9c6555bbd42b778c93075d1740e243ac9f11e`. The lab production crate is not changed by this evidence archive. Root may apply those two native commits after review.

## Exact native delta

[native-delta.patch](native-delta.patch) contains three new Rust source/test files and three `lib.rs` module/export lines. Public names, scalar/SIMD kernels, original ordinary inline hints, allocation and routing come from the frozen SingleLine source. Packaging changes only the local helper alias and test filename. The sole later source deletion removes an always-true test assertion `(indices[sector]&15)<16`, rejected by Clippy; independent physical-line, sector and popcount assertions remain. No algorithm or hint was changed during repair.

The private `k12_parallel` module retains the proved generic physical-line insertion and owner bodies. For physical line i, T workers and L lines, owner is floor(i*T/L), with shard bounds ceil(p*L/T). It uses the actual top24 address, not a high32 surrogate. Complete disjoint mutable line slices and `begin*16` rebasing remain unchanged. `backend`, `backends`, `build_workers`, `scratch_bytes`, `lookup` and the underlying `workers` function are byte-identical to the tested isolated helpers; production utilities are re-exported rather than copied or changed. [PROOF.json](PROOF.json) records exact function and native-file hashes.

## Bounded execution and provenance

Each profile compares the native public API to the immutable SingleLine package on12 fixed cases:192/1088/2097216 actual bytes, requestedT3/T7, and uniform/hotspot inputs. The192-byte bitmap has only three lines and correctly capsT7 toT3;17- and32769-line cases actually useT7. The caller checks full bitmap words, scalar/bulk/parallel dense outputs, no false negatives, append preservation, guards, input immutability, actual size/alignment, worker/scratch values, and invalid-length failure before writes. All runtime children record allowed physical CPUs3,5,7,9,11,13,15; the parent holds the socket1 exclusive lock onCPU3. No single-core affinity was misreported as parallel execution.

Structured Cargo package/manifest/target/artifact identities bind every actual compiler input before runtime. The normal closure has23 inputs/11 dep-info rules; disabled and ASan each have18 inputs/five rules. Six executable hashes and native/source identities are verified again at completion. Clippy passed inV2 and is reused with the exact source, flags and binaries. Normal compilation is not repeated.

The original attempts are preserved and remain `complete=false`:

- V1 (`84ba908172c22dcae8f81a7f1d2756056d8f0137`) built normal binaries, then stopped on the tautological test assertion; zero tests/BF ran.
- V2 (`f4fcd112c6ac205442ee1927d2bcbf47a6da2e03`) passed normal builds and Clippy, then stopped on Cargo's hyphen-to-underscore dep-info identity; zero tests/BF ran.
- V3 (`18b51be438b02ad46353b3cdae43f0a8a91a1496`) reused normal binaries, passed normal40/disabled6 tests and24 fixtures, and built ASan binaries; the nightly normalized internal name stopped the collector before ASan runtime.
- V4 (`b0d2d06491ffd9c5c24e945e03ed21a108044535`) reused all six binaries, passed ASan6 and12 fixtures, then stopped only because a folded standard-library trampoline had different displayed aliases in `nm` and `objdump`.

The two collector changes accept only literal/normalized names derived from validated structured Cargo identities. Ambiguous matches are rejected. Nightly's package/hash/out path and actual/final executable SHA equality are mandatory. There is no first-existing-path fallback. Eight offline guards pass. V4 did not rebuild or rerun prior successful runtime. The final capture is archive-only, with no compiler/BF execution. A final offline source-delta audit initially expected a whitespace-formatted deleted test line; matching the exact committed line corrected that audit, with no source/runtime change.

## Actual public machine code

The normal caller SHA is `6320a6e46303240e17ffcb62a5a2f6638ab7921433eb8f1bfe801469455ea6df`. Final [ELF capture](../proof-v4/assembly-v2/results/CAPTURE.json) selects only actual class methods and the three explicit caller wrappers. Every span is bound to a defined ELF FUNC address and size, raw `nm -S` identity and all same-address aliases. Instructions begin at the exact address and remain inside its extent. The old trampoline capture is retained; objdump's preferred label is not treated as identity.

| Actual symbol | Address | ELF bytes | Observed behavior |
|---|---:|---:|---|
| `native_visible_pure` | `0x2d060` |407| Full SingleLine body inline; one global line bounds comparison per key at`0x2d0c9`, four local word tests and dense0/1 output; no hot helper call. Six saved registers and72-byte frame. |
| `native_visible_fused` | `0x2ce80` |476| Project's public common hash, including both multiplications, remains inside the loop; one line comparison at`0x2cf26`, four word tests, no hot helper call. Six saved registers and104-byte frame. |
| `native_public_batch` | `0x2ce70` |6| Tail jump through GOT`0x6e378`; exact ELF relocation resolves it to public`lookup_hashes` at`0x232f0`. |
| Public `lookup_hashes` | `0x232f0` |7074| Length assertion precedes writes; size/backend dispatch, YMM/ZMM gathers, bounded tails and scalar paths remain. Six saved registers and72-byte frame. Remaining calls resolve to cold assertion/bounds panic paths. |
| Public `lookup_hashes_parallel` | `0x21a50` |2862| Length assertion precedes worker selection; T1 fallback resolves through the same public batch GOT target. Thread/scope work remains in the public operation. |

The pure wrapper returns at`0x2d1bf`; its calls at`0x2d1e1`/`0x2d1f1` are invalid-length/bounds panic paths. Fused returns at`0x2d022`; calls at`0x2d044`/`0x2d056` are likewise cold. The [relocation record](../proof-v4/assembly-v2/results/RELOCATION.json) binds GOT`0x6e378` to`0x232f0`; its raw table also binds panic slots to named panic functions. This supports the intended public-call integration, not whole-function byte identity or any speed guarantee. Existing frames, dispatch and thread costs remain.

Root and external_cpp independently reviewed actual spans, the relocation, native delta and physical ownership. Both found no correctness/codegen blocker. Native performance, external ranking and Rust MT performance remain separate future measurements. The original Rust108 and SingleLine72 reports keep all singleton, bulk, construction and Range-comparison losses; optional API packaging does not overwrite them.
