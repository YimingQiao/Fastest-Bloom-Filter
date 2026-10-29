# Fixed142 native Range shared-query analysis

This is an offline sidecar to the immutable142-row T8 producer committed at `35c97d584b600fdd71e6c086459433a53d4e567a`. All30 raw/audit artifacts are committed at `3cbe13263153135a1fe2e86cacf688016cd782ca`, with manifest SHA `99addd9db1ebaa332e8307b4c014d08d243320f857186162a8b81778424bf2c4`. The loader checks every raw committed blob and hash, then invokes the frozen source/binary/command/order/placement/trial-vector/raw-versus-aggregate audit before computing any comparison. No benchmark or compiler is run here.

The authoritative narrative is `report-final/REPORT.md`. It reports a cap24/0.01% Range niche and preserves the substantial losses elsewhere, the current FourSector16 precision gate, source phase-order limitations and all serial build tradeoffs. Seventy-two query views are2 sizes ×3 actual-byte caps ×3 FPR limits ×4 separate pure/raw gated/end-to-end metrics. All5112 allocation alternatives remain, including over-cap, unavailable and quality-failing records;216 belong to Range. External, production-native and experimental owners are distinct. Smaller selected allocations compete under larger caps; prior fixed12/14/20/28-bpk extras are retained. No older latency is imported.

There are92 alias-deduplicated calibration records, never pooled,568 same-row serial scaling records,72 separate serial-build views/5112 build alternatives, and880 Range/other equal-byte pairs across four query and four build metrics. All eligible native losses are included as individual alternative records. Nested caps reuse measurements; win counts are descriptive and not independent significance tests. The single-seed, fixed-phase training screen supports no global-fastest or promotion claim.

Twelve offline regression tests cover smaller-cap eligibility, quality failure, four-mode independence, unavailable raw-only pure metrics, exact ties, owner separation, aliases without pooled denominators, conflicting alias answers, null winners, same-row scaling, equal actual bytes and Wilson endpoints. The first test run had two analysis-only failures: its intended all-gates-failing synthetic FPR was too low, and floating arithmetic gave a tiny positive Wilson lower endpoint for zero events. The fixture was corrected and endpoints clamped exactly. Failed logs remain as `*-v1.*`; all measured numeric CSV outputs before/after are byte-identical. The final summary adds only the committed raw revision and the narrative is expanded.

Reproduction (offline only):

```sh
python3 -m unittest discover -s experiments/2026-10-29-split64-range-parallel-analysis -p test_summary.py
python3 experiments/2026-10-29-split64-range-parallel-analysis/summarize.py --output /tmp/range-mt142-report
```

The output path must be fresh. The source producer and every native algorithm remain unchanged.
