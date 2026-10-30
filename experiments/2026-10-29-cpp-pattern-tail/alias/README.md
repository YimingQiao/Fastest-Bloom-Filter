# Public-entry alias controls

This separate snapshot compares the original FastPattern implementation, the retained failed `<=7` scalar-entry / `i>=16` masked-tail policy, and two controls motivated by that policy's assembly:

- `FastPatternLocalTailBF` snapshots the word mask, dictionary pointer, and bitmap pointer into local variables before the short loop. It adds no public `restrict` qualifier.
- `FastPatternRestrictTailBF` adds `BF_RESTRICT` to public `Lookup` input/output parameters while retaining the failed policy's source loop. The old inner `LookupImpl` already used this disjoint-buffer contract for calls above three keys. This experiment does not change the production public API.

Both controls preserve the failed policy's masked-tail condition and bitmap layout. The comparison directly investigates the observed repeated object-field loads; fewer instructions alone will not justify promotion. Native assembly is retained to show whether the fields actually stay cached. No unsupported causal claim is made about total runtime.

The independent scalar/full-bitmap tests cover all four variants, all inserted keys, collision-heavy hashes, duplicate insertion, exact query allocation ends, output guards, offsets0–7, lengths0–131 and4096–4127, sparse/dense dictionaries, and filters above the prefetch threshold. All tested caller input/output buffers are disjoint. The local-snapshot version does not add an alias contract, although overwriting private object metadata through an output pointer is not a supported practical use.

Initial timing uses seed42, the same36-case grid as the retained policy, and all four implementations in one process. Ratios always mean **new/old latency**, so below1 is faster. The ByteSplit preregistration seeds2309/6311/10007 are excluded. Both validation and the complete timing matrix hold the shared socket1 lock.

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/alias/validate.py
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/alias/run.py \
  --mode speed --output experiments/2026-10-29-cpp-pattern-tail/alias/screen --cpu 3 \
  --key-powers 16,24 --requested-bpk 8,16 --seeds 42 --hits 50 \
  --batches 4,5,6,7,8,15,31,63,4096 --query-power 22 --calibration-power 0 --repeats 5
```

## Result: both alias controls rejected

All36 workloads/144rows match bytes, complete output checksum, and false-positive counts. Native, scalar, minimal AVX-512F+AVX2 without VL/DQ/BW, and ASan+UBSan pass the same independent full-output checksum `14935109807921651589`. No source changed during timing.

The alias observation was correct: both controls load mask/table/bitmap pointer once and keep them cached. Their complete public `Lookup` instruction sequences are identical after normalizing symbol names and addresses (243instructions; `assembly/comparison.json`). That optimization is insufficient. Both still lose materially in standalone4–7 batches, and large-filter batch31 can also regress.

A more significant code-generation difference is visible in the original: Clang auto-vectorizes the source-level scalar remainder into a four-key loop. In `assembly/FastPatternBeforeTailBF-public.txt`, the size comparison against4 leads to an unmasked256-bit input load and four `vpgatherqd` dictionary/bitmap gathers. The <=7 entry policies instead execute unrolled scalar operations. Thus the hypothesis that this region was all scalar was false on the tested native compiler. The exact contribution of each instruction change to latency has not been isolated.

Ratios are **new/old latency**; below1 is faster. The failed-entry control is retained in the complete CSV/summary; the table below shows both new controls.

| Keys | Actual bits/key | Batch | Local pure | Local hash+query | Restrict pure | Restrict hash+query |
|---:|---:|---:|---:|---:|---:|---:|
| 65536 | 16 | 4 | 1.218 | 1.330 | 1.211 | 1.341 |
| 65536 | 16 | 5 | 1.172 | 1.286 | 1.171 | 1.291 |
| 65536 | 16 | 6 | 1.112 | 1.330 | 1.107 | 1.328 |
| 65536 | 16 | 7 | 1.091 | 1.126 | 1.090 | 1.127 |
| 65536 | 16 | 8 | 1.090 | 1.014 | 1.062 | 1.018 |
| 65536 | 16 | 15 | 1.043 | 1.020 | 1.038 | 1.020 |
| 65536 | 16 | 31 | 0.935 | 0.881 | 0.930 | 0.883 |
| 65536 | 16 | 63 | 0.965 | 0.973 | 0.966 | 0.974 |
| 65536 | 16 | 4096 | 1.019 | 0.980 | 1.002 | 0.990 |
| 65536 | 32 | 4 | 1.207 | 1.336 | 1.201 | 1.354 |
| 65536 | 32 | 5 | 1.183 | 1.294 | 1.185 | 1.302 |
| 65536 | 32 | 6 | 1.112 | 1.331 | 1.108 | 1.332 |
| 65536 | 32 | 7 | 1.090 | 1.114 | 1.091 | 1.116 |
| 65536 | 32 | 8 | 1.029 | 1.011 | 1.025 | 1.012 |
| 65536 | 32 | 15 | 1.044 | 1.020 | 1.043 | 1.021 |
| 65536 | 32 | 31 | 0.957 | 0.889 | 0.948 | 0.888 |
| 65536 | 32 | 63 | 0.980 | 0.973 | 0.969 | 0.972 |
| 65536 | 32 | 4096 | 1.009 | 0.981 | 1.006 | 0.991 |
| 16777216 | 16 | 4 | 1.350 | 1.311 | 1.369 | 1.334 |
| 16777216 | 16 | 5 | 1.274 | 1.281 | 1.264 | 1.277 |
| 16777216 | 16 | 6 | 1.267 | 1.250 | 1.268 | 1.247 |
| 16777216 | 16 | 7 | 1.217 | 1.335 | 1.226 | 1.351 |
| 16777216 | 16 | 8 | 1.012 | 0.999 | 1.006 | 0.998 |
| 16777216 | 16 | 15 | 1.016 | 1.020 | 1.009 | 1.025 |
| 16777216 | 16 | 31 | 0.998 | 1.023 | 1.031 | 1.030 |
| 16777216 | 16 | 63 | 0.989 | 1.002 | 0.988 | 1.003 |
| 16777216 | 16 | 4096 | 1.017 | 1.005 | 1.011 | 0.997 |
| 16777216 | 32 | 4 | 1.262 | 1.216 | 1.275 | 1.215 |
| 16777216 | 32 | 5 | 1.222 | 1.240 | 1.216 | 1.233 |
| 16777216 | 32 | 6 | 1.240 | 1.232 | 1.220 | 1.205 |
| 16777216 | 32 | 7 | 1.153 | 1.348 | 1.181 | 1.367 |
| 16777216 | 32 | 8 | 0.997 | 0.996 | 1.003 | 1.002 |
| 16777216 | 32 | 15 | 1.011 | 1.017 | 1.002 | 1.022 |
| 16777216 | 32 | 31 | 0.993 | 1.047 | 0.987 | 1.024 |
| 16777216 | 32 | 63 | 0.987 | 1.016 | 0.989 | 1.012 |
| 16777216 | 32 | 4096 | 1.006 | 0.994 | 1.017 | 0.995 |

Insertion is unchanged; its observed timings are retained in the complete CSV rather than interpreted as an algorithmic improvement. No promotion or fresh-seed promotion confirmation is justified for these scalar-entry controls.
