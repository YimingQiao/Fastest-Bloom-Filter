# Split64 bit selection with explicit mask-register reduction

Correctness and assembly preflight passed. The completed initial timing screen
rejected this replacement; see [RESULTS.md](RESULTS.md) and the full retained data.
The V1 archive in `../2026-10-29-split64-bitshuffle/` is unchanged.

This isolated hybrid preserves the original narrow-position path for singleton
and bulk queries and wide positions for lengths 2..15. It changes only the BITALG
result reduction: unmasked `_mm512_bitshuffle_epi64_mask(bits, positions)` returns
the selected bits, then `_ktestc_mask64_u8(result, selected)` requires every
selected output bit to be set. The [official intrinsic contract](https://doc.rust-lang.org/core/arch/x86_64/fn._ktestc_mask64_u8.html)
implements `(~result & selected) == 0`; explicit tests cover the full 64-bit mask,
including selected bit 56, all-ones/zero results and each missing selected bit.
`candidate.patch` retains the exact source change. No mask positions, insertion,
allocation, prefetch or public batch policy changed.

The six compiled configurations are FastPattern, original Split64, V1 hybrid,
V1 always-narrow, V1 always-wide, and the new HybridKtest. Original V1 sources and
binaries are checked against their freeze before copying; unchanged `before.h`
and `after.h` copies remain separate controls in this binary.

All eight oracle modes pass checksum `3906731148184842256`: native, portable
source path, AVX2, and BITALG without VL/DQ, each normal and ASan+UBSan. Full bitmap,
all inserted keys, dense output, offsets/tails/guards, duplicates/collisions and
all 8×64 controlled selected-bit positions remain covered. `validation.json`,
logs and `freeze.json` retain every command and all ten binary hashes.

Assembly for all six query kernels is in `assembly/`. HybridKtest now emits
`vpshufbitqmb` followed by `ktestq`/`setb`, with no result-mask extraction into a
GPR. `kmovq` remains for selected-mask constants, which are hoisted in loop paths;
the singleton path still sets up its constant per call. The wrapper saves two
registers, matching original versus V1 hybrid's four. This is the intended
code-generation change, not performance evidence. The compiler feature closure
requires AVX512BW along with BITALG; the tested boundary excludes VL and DQ.

## Prespecified internal timing and retained result

`timing-protocol.json` fixes the complete 24-case/144-row training matrix:
n=2^16/2^25, requested8/16 (actual16/32 bits/key), batches1/3/4/8/31/4096,
seed42, 50% hits, q=2^22, five repeats, full-input construction and cal0.
The exact query-only transformation has unchanged probability distribution;
every Split64 row must match original bytes, complete-output checksum and FP
counts. FastPattern is a separate context control, not an accuracy-equivalent
Split64 row. Both pure and common-hash query times and all losses are retained.

The default is the full 24 matrix. A separately approved small 12 triage stage may
reject further work, but cannot support a full-size or promotion claim. Before
promotion, complete both sizes on an unchanged binary and prespecify fresh
held-out timing. No comparison to a different executable, compiler or socket is
used. Construction timings are unchanged-source checks, not optimization claims.

The full matrix ran after source commit
`0f7303b9e473e49ec89714c729fec7e5b4f8ff30` and an explicit socket1 lease.
Recorded command (the driver refuses to overwrite the completed output):

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-split64-bitshuffle-ktest/run_timing.py --stage full --source-commit 0f7303b9e473e49ec89714c729fec7e5b4f8ff30
```

`timing-preparation.json` freezes protocol, runner, shared runner and correctness
manifest before data. `run_timing.py` verifies them and all compiled inputs before
and after measurement, refuses output overwrite, requires all six rows in every
case, and records the explicit source commit. No production code is modified.
