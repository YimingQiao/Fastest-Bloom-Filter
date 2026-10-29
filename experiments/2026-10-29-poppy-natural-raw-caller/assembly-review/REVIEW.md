# Actual natural-Poppy public paths and clock boundaries

The reviewed normal binary is `/tmp/fastest-bf-poppy-natural-raw-v2-cpu3/normal/release/poppy_raw_benchmark`, SHA256 `42174b031164dd958a92a25acfd2c437292b6f4dc27ce0ffa39e87b00c5b3c5a`. The bounded driver retained exact ELF symbols, sizes, folded aliases, complete disassembly and relocations. This review uses those texts only; it did not rebuild, disassemble again or execute a filter.

All 28 Poppy report specializations are present. Shared raw helper symbols retain ID20 for each natural form; their callsites establish shared use, not 28 independent machine bodies. Both forms of a given constructor call the same compiled constructor body. `EXTRACT.json` adds the 14 exact constructor spans from the retained ELF text and binds the input text hashes. `clock-map.csv` identifies all 28 report windows and targets.

| Actual path | Byte8 | Typed u64 |
|---|---:|---:|
| Raw visible helper | `0x211e60`, 304 bytes | `0x211f90`, 356 bytes |
| Raw batched helper | `0x210ec0`, 304 bytes | `0x210ff0`, 372 bytes |
| Raw insertion helper | `0x20e090`, 177 bytes | `0x20e150`, 1,178 bytes |
| Representative report | `0x160240`, 25,003 bytes | `0x1663f0`, 25,131 bytes |

Byte visible/batched load the original u64 directly into iterator state for public `contains_iter` at `0x218be0` (398 bytes). The public byte8 first-hash behavior is retained; no common prehash is introduced. Typed visible/batched perform the natural WyHash first hash (`rorx` and two `mulx` operations) before calling the same public iterator query. Per-key Result checks and complete dense u32 stores remain in each helper. The shared iterator query contains the cache test, xorshift bucket mapping, mask/division, bit probes and lazy secondary WyHash on probe1. An early rejection can avoid later work; this proof does not claim every query executes every hash or probe.

Byte insertion calls public `insert_bytes::<[u8;8]>` at `0x20b880` (972 bytes) per original key and checks its Result. Typed insertion has the public typed hash/insertion body inlined in `0x20e150`, including cache/bit stores and the error path. The success bodies contain no hot allocation call and no prepared-hash vector or artificial identity-copy. These public-path findings received an independent text-only peer review.

The complete build clock includes public constructor and insertion. For representative byte8, start is `0x16049b`, constructor call `0x1604ba` targets `0x220cf0`, ready is `0x160531`, insertion call `0x160576` targets `0x20e090`, and done is `0x160580`. Typed uses start `0x166658`, the same constructor at `0x166677`, ready `0x1666f1`, insertion `0x166736` and done `0x166740`. Constructor `0x220cf0` (653 bytes) calls public Poppy `BloomFilter::make` at `0x503c0`; its allocation and parameter work is therefore inside the complete build interval. Insertion-only begins after readiness. No hash-scratch allocation occurs in either direct form's build window. Required output/validation buffers are outside those clocks, consistently with the frozen reporter contract. Full constructor backing and zero-operation allocations are also checked by the focused runtime tests; assembly alone is not an allocation census.

Query poison is outside the query clock. Byte8's scalar poison store at `0x161520` (with its preceding vector fill) precedes start `0x161537`; selected batched/visible calls at `0x1615d1`/`0x16160b` precede elapsed `0x161618`. Typed poison `0x167740` precedes start `0x16775a`, calls `0x167800`/`0x16782e`, and elapsed `0x16783b`. Retained relocations resolve GOT `0x2638e0` to `Instant::now` at `0x23c8e0`, and GOT `0x2638f0` to `Instant::elapsed` at `0x23c8f0`. The extraction checks the same four now calls, one elapsed call, constructor, insertion and two query callsites in every one of the 28 report specializations.

These are correctness, public-call and accounting observations. No old/current whole-function byte equivalence, natural-input quality, latency improvement or strongest-baseline claim is inferred. Both forms still require their own full-load calibration and future same-contract comparison; historical shared-prehash Poppy timing/FPR cannot be imported into these mappings.
