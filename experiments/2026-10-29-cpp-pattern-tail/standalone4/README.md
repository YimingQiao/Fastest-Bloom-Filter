# Standalone four-to-seven-query paired4 dispatch

The preceding paired4 candidate improved several short batches but also regressed bulk/control paths. This separate snapshot narrows the change to standalone calls containing4–7 queries. Public calls of0–3 keep the original early path. Calls of8 or more execute the original `LookupImpl` template; `bulk-source-identity.txt` records a byte-for-byte source check. Source identity is not proof of identical generated code or timing, so every guard batch remains part of the measurement.

The private4–7 helper consumes four exact inputs using an unmasked256-bit load, computes one paired eight-sector gather, stores four answers with128 bits, then processes0–3 remaining inputs. It uses AVX-512F+AVX2 without requiring VL/DQ/BW. AVX2/scalar builds skip the new dispatch. It inherits the old inner kernel's disjoint input/output-buffer contract; no public `restrict` qualifier is added.

The original compiler-auto4 remainder is the same-process control. All source-level bitmap/hash/insertion behavior remains identical. The independent scalar/full-bitmap test covers every answer, all inserted keys, duplicates, collisions, null empty calls, input offsets0–7, exact allocation ends, output guards, lengths0–131 and4096–4127. Native, scalar, minimal-feature, ASan+UBSan and actual assembly are required before timing.

Training is specified before measurement: seed42,50% hits, keys2^16/2^24, requested8/16 (actual16/32) bits/key,2^22 queries,five repetitions; batches1/3/4/5/6/7/8/15/28/31/63/4096. Ratios are **new/old latency**, below1 is faster. All1/3/8-and-above guards count in the decision. No production change or fresh-seed promotion claim is made at this stage. ByteSplit reserved seeds2309/6311/10007 are excluded.

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/standalone4/validate.py
flock /tmp/fastest-bf-socket1.lock taskset -c 3 python3 experiments/2026-10-29-cpp-pattern-tail/standalone4/assembly.py
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/standalone4/run.py \
  --mode speed --output experiments/2026-10-29-cpp-pattern-tail/standalone4/screen --cpu 3 \
  --key-powers 16,24 --requested-bpk 8,16 --seeds 42 --hits 50 \
  --batches 1,3,4,5,6,7,8,15,28,31,63,4096 --query-power 22 --calibration-power 0 --repeats 5
```

## Training result: do not promote as-is

All48 workloads/96rows match output checksum, bytes, and false positives, with unchanged source/binary throughout timing. Native/scalar/minimal AVX-512F+AVX2 without VL/DQ/BW and ASan+UBSan pass checksum `14935109807921651589`. The helper is inlined in the native public method. Both large-filter prefetch kernels occupy1187bytes, while public methods differ in size (original1727bytes; standalone2223bytes). Source-level bulk identity does not imply identical whole-program timing.

The targeted4–7 raw path improves, but controls still regress: small4096 raw latency becomes1.017/1.022 times original, and large28 becomes1.024/1.050. Small actual16bpk batch7 pure lookup also regresses1.213 with tight five-trial ranges: candidate2.32989–2.33685ns versus original1.92122–1.9234ns. That loss is retained, not dismissed as a noisy sample. Actual32bpk batch7 improves in the same screen. No production promotion or fresh-seed confirmation is claimed for this version.

Every positive per-seed metric change is retained in `screen/regressions.csv`; insertion is unchanged and its measured variation is not an algorithmic claim. Table values are **new/old latency**, below1 is faster.

| Keys | Actual bits/key | Batch | Pure latency ratio | Hash+query latency ratio |
|---:|---:|---:|---:|---:|
| 65536 | 16 | 1 | 1.000 | 1.000 |
| 65536 | 16 | 3 | 0.998 | 0.999 |
| 65536 | 16 | 4 | 0.957 | 0.893 |
| 65536 | 16 | 5 | 0.903 | 0.828 |
| 65536 | 16 | 6 | 0.842 | 0.979 |
| 65536 | 16 | 7 | 1.213 | 0.851 |
| 65536 | 16 | 8 | 0.981 | 1.010 |
| 65536 | 16 | 15 | 0.998 | 1.004 |
| 65536 | 16 | 28 | 1.017 | 0.998 |
| 65536 | 16 | 31 | 0.999 | 0.996 |
| 65536 | 16 | 63 | 1.004 | 1.001 |
| 65536 | 16 | 4096 | 0.992 | 1.017 |
| 65536 | 32 | 1 | 1.000 | 1.001 |
| 65536 | 32 | 3 | 0.998 | 1.000 |
| 65536 | 32 | 4 | 0.962 | 0.894 |
| 65536 | 32 | 5 | 0.921 | 0.831 |
| 65536 | 32 | 6 | 0.847 | 0.952 |
| 65536 | 32 | 7 | 0.906 | 0.870 |
| 65536 | 32 | 8 | 0.995 | 1.013 |
| 65536 | 32 | 15 | 0.997 | 0.975 |
| 65536 | 32 | 28 | 1.007 | 0.993 |
| 65536 | 32 | 31 | 0.999 | 0.996 |
| 65536 | 32 | 63 | 0.991 | 1.002 |
| 65536 | 32 | 4096 | 0.987 | 1.022 |
| 16777216 | 16 | 1 | 1.012 | 1.001 |
| 16777216 | 16 | 3 | 0.998 | 1.002 |
| 16777216 | 16 | 4 | 0.957 | 0.832 |
| 16777216 | 16 | 5 | 0.889 | 0.850 |
| 16777216 | 16 | 6 | 0.921 | 0.909 |
| 16777216 | 16 | 7 | 0.968 | 0.850 |
| 16777216 | 16 | 8 | 1.013 | 0.998 |
| 16777216 | 16 | 15 | 0.984 | 0.997 |
| 16777216 | 16 | 28 | 1.000 | 1.024 |
| 16777216 | 16 | 31 | 0.995 | 1.006 |
| 16777216 | 16 | 63 | 0.990 | 0.996 |
| 16777216 | 16 | 4096 | 1.005 | 1.001 |
| 16777216 | 32 | 1 | 1.004 | 1.004 |
| 16777216 | 32 | 3 | 1.016 | 1.005 |
| 16777216 | 32 | 4 | 0.941 | 0.813 |
| 16777216 | 32 | 5 | 0.887 | 0.874 |
| 16777216 | 32 | 6 | 0.916 | 0.916 |
| 16777216 | 32 | 7 | 0.964 | 0.878 |
| 16777216 | 32 | 8 | 1.009 | 0.989 |
| 16777216 | 32 | 15 | 1.001 | 1.002 |
| 16777216 | 32 | 28 | 1.008 | 1.050 |
| 16777216 | 32 | 31 | 1.018 | 1.005 |
| 16777216 | 32 | 63 | 0.974 | 0.973 |
| 16777216 | 32 | 4096 | 1.001 | 0.997 |

`screen/metadata.json` and `validation/validation.json` freeze the final standalone sources and executables. `snapshot.json` is preserved original-source provenance inherited from the masked-tail ancestor; its historical purpose text does not describe this standalone helper. The final protocol and `after_standalone.h` specify the unmasked four-input load.
