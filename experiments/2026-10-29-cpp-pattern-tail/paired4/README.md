# Exact four-input paired gather

The original C++ scalar remainder is auto-vectorized into a four-key loop on the native Clang build. This experiment retains that original as its control and adds an explicit four-key paired-sector path after the existing16- and8-key groups. The public<=3 path, insertion, allocation, hash fields, and mask dictionary remain unchanged.

The candidate loads exactly four hashes with an unmasked256-bit load, zero-extends them to512 bits, prepares eight adjacent sector probes, gathers only the low eight lanes, combines pairs into four answers, and stores exactly128 bits. The remaining0–3 queries follow the original scalar source loop. It needs AVX-512F plus AVX2, with no AVX-512VL/DQ/BW requirement; a minimal-feature compile checks that boundary. Scalar and AVX2 fallbacks remain the original implementation. The source makes no padding/overread assumption.

This is motivated by two observations from the retained earlier experiments: variable masked input loads regress hash-plus-query timing, and replacing the original auto-vectorized remainder with a <=7 scalar entry loses performance even after caching fields. Neither observation proves that this fixed-load kernel will be faster.

Correctness compares every bitmap word and answer against an independent scalar oracle and the original, including all inserted keys, duplicates, collisions, exact allocation ends, output guards, offsets0–7, and lengths0–131/4096–4127. Native, scalar, minimal-feature and ASan+UBSan runs are recorded in `validation/`. Native public/inner-kernel assembly is retained in `assembly/`.

The first training screen is a subset: batches4/7/15/31/4096, keys2^16/2^24, requested8/16 (actual16/32) bits/key, seed42,50% hits,2^22 queries,five repetitions. It is20 workloads with both implementations in one process. If justified, the extended grid adds1/3/5/8/12/20/23/28/63. A promotion requires held-out confirmation. Ratios mean **new/old latency**, below1 is faster. ByteSplit reserved seeds2309/6311/10007 are excluded.

```sh
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/paired4/validate.py
flock /tmp/fastest-bf-socket1.lock taskset -c 3 python3 experiments/2026-10-29-cpp-pattern-tail/paired4/assembly.py
flock /tmp/fastest-bf-socket1.lock python3 experiments/2026-10-29-cpp-pattern-tail/paired4/run.py \
  --mode speed --output experiments/2026-10-29-cpp-pattern-tail/paired4/screen --cpu 3 \
  --key-powers 16,24 --requested-bpk 8,16 --seeds 42 --hits 50 \
  --batches 4,7,15,31,4096 --query-power 22 --calibration-power 0 --repeats 5
```

## Frozen result

Correctness passes native/scalar/minimal AVX-512F+AVX2(noVL/DQ/BW)/ASan+UBSan with full-output checksum `14935109807921651589`. The native assembly contains the intended unmasked256-bit input, one masked8-sector gather, and128-bit output.

[Training](training/README.md) includes60 workloads/120rows in two source-identical stages. [Held-out confirmation](heldout/README.md) includes120 workloads/240rows with fresh seeds3253/9283 and seven repeats. The candidate improves several short batches but has repeatable regressions in the8/4096 controls and other cases. **Unconditional promotion is rejected.** Every per-seed latency increase is retained in [regressions.csv](heldout/regressions.csv), and [audit.json](heldout/audit.json) verifies exact semantic/source/binary parity. No production code was changed.
