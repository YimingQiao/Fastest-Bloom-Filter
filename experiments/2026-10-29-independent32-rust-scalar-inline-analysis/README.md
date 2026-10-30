# Rust scalar-inline208 analysis

This sidecar verifies the complete screen frozen at
`c357f6943940e44a2c527674d5f5c244da65309f`. It checks265 source/evidence pins,
11 external dependency sets, two executable hashes, committed source blobs,
all16 exact commands and source-derived13-type orders, raw/aggregate equality,
complete trial vectors/phase balance, byte allocations and all clone outputs.
The sidecar order-oracle copy must equal the actual imported frozen module.

The reports retain192 nested allocation/FPR/mode views,3840 individual native
alternatives,320 controlled original/candidate pairs,64 direct V1/V2 pairs,
128 construction pairs,416 API ratios and32 unpooled quality records. The
three Independent32 versions remain separate. Smaller measured allocations
compete under larger caps. External scope is the three Rust families actually
in this executable; prior binaries and different query workloads are never
timing rivals.

Thirteen offline tests cover quality/allocation eligibility, alias reuse,
separate contracts, every loss, V1/V2 identity, construction comparisons and
early Python-O rejection. Preflight's11 runner guards additionally cover
actual row-order corruption and inherited socket lock descriptors.

Reproduce offline to a fresh directory:

```sh
python3 experiments/2026-10-29-independent32-rust-scalar-inline-analysis/summarize.py --output /tmp/scalar-inline208-report
python3 -m unittest discover -s experiments/2026-10-29-independent32-rust-scalar-inline-analysis -p 'test_*.py' -v
```

Neither command compiles or executes a filter. See `FINDINGS.md` for the
decision and `report/RESULTS.md` for all strict-threshold comparisons.
