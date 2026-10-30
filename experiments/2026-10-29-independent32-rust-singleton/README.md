# Independent32 singleton dispatch diagnosis

This is a source-only candidate. Nothing here has been compiled or timed.
Production and previously frozen source files are unchanged. The evidence is
read-only disassembly of the existing Rust132 executable, SHA256
`5e7d08133b4404fcfe8090a482c55256eb7dc91fba7533a7a02f9ffed0f4305c`.
`provenance.json` records exact source hashes and extraction commands.

The measured distinction is real: at strict 32 bpk, generic batch1 prehashed
Independent32 took 3.888 ns/key at 65,536 keys versus Bloomsday 3.252; at
33,554,432 keys it took 15.971 versus 14.426. The public visible mode took
1.313 versus 1.524 and 7.352 versus 8.439, respectively. These values come from
the unchanged training archive; no new measurements were made for this diagnosis.

## What the emitted program does

The shared harness retains `#[inline(never)] lookup<F>` at main.rs:215. For
Independent32 it is a six-byte indirect tail jump at `0x23860`; relocation
`0xb0f78` resolves to the public `lookup_hashes` at `0x709e0`. The original and
leaf Byte/FourSector/Split64 controls have the same kind of tail-jump entry.
This is not a trait-object dispatch: the Rust filter trait is monomorphized.
SBBF separately retains its actual upstream virtual interface.

Independent32's public batch function already contains its VBMI and AVX2 mask
kernels inline. There is no hot call to a target-feature helper to remove.
For a one-key VBMI request it nevertheless takes the general batch route:

- `0x709e0..0x709f1`: stack frame and full input/output length check.
- `0x709f7`: runtime VBMI selection, followed by the empty check at `0x709fd`.
- `0x70a0d..0x70a21`: remainder modulo4, four-key eligibility and tail index setup.
- `0x70c56..0x70c72`: another tail check, pointer rebasing and mask-constant loads.
- `0x70c80..0x70cc2`: one mask/bucket test plus tail increment/loop comparison.
- `0x70eab..0x70eb3`: epilogue and `vzeroupper`.

The visible public loop at `0x1fe50` instead checks backend fields once at
`0x1fe8d`/`0x1fea6`, loads VBMI constants at `0x1fecf`/`0x1fed8`, then processes
four keys per loop at `0x1fef0`. Its fused counterpart starts at `0x202b0`.
Cross-key scheduling and setup amortization are therefore part of that public
whole-array contract. It would be incorrect to subtract the two measurements
and call the entire difference a single function-call cost.

Bloomsday's generic wrapper at `0x22790` contains its public membership body
directly, whereas Independent32 retains the extra tail jump to its public
batch method. The proposed fix below intentionally leaves the common harness
boundary and this library boundary intact. Constant setup and backend dispatch
also remain per batch. Any remaining generic/visible gap will still be reported.

Existing native controls already specialize one-element batches. Original
Byte's source checks `hashes.len() == 1` at byte_split.rs:142 and invokes its
public `contains_hash`; leaf Byte's machine code has that check at `0x6c2cd`
and directly reaches its inline AVX2 mask at `0x6c2e2`. Split64 has its explicit
one-element route at split64.rs:124. The leaf-inline changes concern their
visible public leaf bodies, not a newly introduced batch1 adapter shortcut.
Prefix extracts in `assembly/` are labeled as partial; the complete Independent32
batch and visible functions are archived.

## One candidate, four added lines

`candidate.rs` differs from `before.rs` only immediately after the existing
length assertion:

```rust
if hashes.len() == 1 {
    out[0] = self.contains_hash(hashes[0]) as u32;
    return;
}
```

This uses the same public native operation that normal library callers use.
No adapter bypass, private kernel call, changed trait, inlining attribute,
allocation, probe bit, insertion, feature check or timer is added. Empty input
and every length other than1 retain the original source body. Mismatched
lengths must still panic before a write. Parallel immutable queries inherit
the same public operation; complete64-byte construction ownership is unchanged.

The hypothesis is narrower than closing the entire generic/visible gap: avoid
the generic remainder-loop setup for exactly one key. Four added lines can
still change code placement or register allocation, so source equality of the
larger-batch body does not prove unchanged performance. The actual release
caller and before/after bulk results must be audited after a later authorized
build. No expected speedup is asserted now.

## Validation and independent confirmation plan

`plan.json` is a proposal, not an execution authorization. It separates two
questions: whether this shortcut helps generic batch1 without unacceptable
bulk regressions, and whether the already frozen visible API wins reproduce
on fresh inputs. The latter can use the unchanged eleven-filter executable;
the new shortcut must not silently replace the filter being confirmed.

Correctness starts with all existing native bitmap/oracle/parallel tests,
normal/disable-avx512/ASan modes, direct scalar/AVX2/VBMI coverage, the complete
nine-row C++ fixture, length-mismatch-before-write checks, and singleton/tail
guards. The same harness must keep its four contracts, all outputs, phase
schedule and public APIs. The before/after pair must have identical full
bitmaps, bytes, checksums, mixed FPR and calibration counts.

An initial before/after screen would retain all eleven frozen configurations
and register the additional candidate through the same public macro. Proposed
small-query screen: seed42, n2^16/2^25, actual16/32bpk, batches1/2/31/4096,
q2^20, four balanced repetitions and calibration2^20. It is a regression and
code-generation screen, not held-out leadership evidence. Every mode and
larger-batch loss remains visible.

The separate visible confirmation proposes the unchanged Rust132 binary,
all eleven configurations, batch1, n2^16/2^25, actual16/32bpk, q2^22,
eight balanced repetitions and calibration2^24, using input seeds
104743/130367/155921. Those seeds are chosen before any new filter execution;
the documented source-only selection rejects raw-range overlap with seed42,
not unfavorable FPR or timing. No construction hash/salt is retuned. The
primary candidate is fixed at Independent32 actual32bpk and the primary
training rival at Bloomsday actual32bpk for the strict0.01% tier. A quality
failure in any seed remains a failure and does not trigger a replacement.
All other fixed external configurations remain in the archive; secondary
per-cap views must also include smaller allocations and retain any stronger
eligible external. No speed claim survives a faster eligible challenger.

Each seed gets its own quality endpoint and paired ratio; report the worst
quality endpoint and the minimum ratio rather than pooling calibration across
seeds or modes. Nested resource views and trial ranges are descriptive, not
independent statistical superiority tests. A generic shortcut would need its
own later fresh-seed confirmation after source/binary freeze, especially for
unchanged visible and bulk paths. No timing is authorized by this document.

The source module and accompanying licenses/NOTICE are copied from the native
Independent32 experiment. `verify_source.py` proves the exact four-line delta
without compiling or executing a filter.
