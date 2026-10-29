# Fixed singleton192 offline analysis

This stage prepares analysis before the formal measurements exist. It does not
run a filter, compiler, planner search, or performance command, and does not read
partial Poppy or singleton results. The immutable proposal is
`42f5d62ce9a0a2ee7b6e7ce4586c96623c68bfb5`; the actual caller source is
`2c85beb3d5c945a1e62465687eb547ccfa5098fb`.

The fixed ledger contains 96 processes, two rows per process, two launch rounds,
two input seeds, n=2^16/2^25, 24 actual bits/key, hit ratios 0/50/100%, and query
batches 1/3/31/4096. Every process uses q=2^22 and eight query trials. Round 2
reverses the complete first-round ledger and both API positions without changing
the inputs. Each process builds one canonical bitmap per API, without build
timing. The two API objects are sequential, not simultaneously resident.

`calculate()` retains exactly 240 candidate/control metric contrasts, 480
eight-trial vectors, all 3,840 values, 120 same-input round comparisons, and 60
four-point (two seeds × two rounds) ranges. Batch 1 has generic pure,
generic staged common-hash, visible public pure, and visible public fused
common-hash contracts. Other batches have the first two contracts. Each metric,
hit ratio, size, batch, seed and round remains identified; none is pooled into
an independent win rate. All slower, faster, and exactly equal outcomes remain.
Ratios are candidate latency / control latency; a value below one is faster.
The ratio of those ratios in round 2 versus round 1 is descriptive sensitivity,
not a causal estimate of API order.

Every row's complete output, bitmap, inserted-key, query-key and hashed-input
digests must match its paired API. Both rounds and all batch shapes must retain
their corresponding semantic identities. These digests are observed checksums,
not archived complete arrays or a proof of cross-process byte equality. The
caller separately performs full element equality and guard checks after every
timed phase, validates every inserted key, and checks input immutability.

The larger batches (31/4096) exercise source paths unchanged by the candidate.
Their machine code, code layout, caller context, or timing is not assumed to be
unchanged. Actual assembly shows a coupled change: old visible singleton loops
call `LookupScalar(1)` per key and retain a larger frame; the candidate's public
singleton is inlined, and the normal pure loop also unrolls two keys. Results
cannot isolate a single-line load, SIMD instruction, inlining, or unrolling as
the sole cause. The minimum-ISA proof is AVX512F without VL/DQ/BW. No new
false-positive qualification, external ranking, build/parallel claim, old
latency comparison, or automatic production promotion is made here.

The final loader will require an additive `completed-raw-anchor.json` binding
the full immutable producer and raw commits, complete raw manifest, exact
producer analysis-loader sources, proof, and actual executable. It will call
the producer's `audit.load_complete` only after checking that those import
sources are committed, then accept only the complete 96-case ledger. The
incomplete template `raw-anchor.json` is not an executable authorization and
must remain unchanged. The producer is still preparing its formal runner, so
its eventual loader interface and exact source closure must be frozen before
this analyzer can consume any data. Do not infer provenance from a commit's
existence alone.

The calculation tests use synthetic rows only; their execution status is
recorded separately. Final numerical analysis must wait for a complete,
committed raw archive and a coordinated offline-compute lease.
