# Fixed Rust singleton internal analysis rules

This is a source-only calculation package for the immutable [96-process proposal](../2026-10-29-rust-k12-singleton-internal-plan/README.md), commit `9e7fb401ccd6bd55a151eb8cc32395a06375862a`. It uses the actual dynamic caller schema at `23e9b075a295deb11c3073cc3b4182b5810a9057`, including the literal `MAIN.patch`. No earlier latency, partially completed result, or unrelated calibration enters these rules. `source_inputs.json` binds the exact source bytes and commits; imports are standard-library only.

`summarize.calculate(records, cases)` accepts the complete ordered 96-case ledger and two rows per case. It reconstructs the fixed ledger independently, requires the exact actual JSON schema, eight positive finite samples per query contract, the repeated four-mode/two-mode phase schedule, explicit measured stage, zero calibration, exact 24 bits/key payload and caller scratch, and the expected AVX-512 backend in both profiles. Both arms must share every semantic field. Input/output fingerprints must also match across the reused batch/round/profile conditions; insertion/bitmap fingerprints match across hit ratios. These digest checks support the producer's full output validation; they do not replace it with a mathematical collision-free proof.

The frozen finite outputs are:

| Artifact | Rows | Rule |
|---|---:|---|
| `pairs` | 288 | Candidate/control median latency, including all wins, losses and exact ties |
| `vectors` | 576 | Every original eight-value API/contract vector, median/minimum/maximum |
| `samples` | 4,608 | Every vector element, with profile/case/round/seed/API/contract identity |
| `round_sensitivity` | 144 | Same-input opposite API order; ratio of ratios and each API's round2/round1 |
| `seed_round_ranges` | 72 | All four seed × round points; descriptive minimum/maximum, no pooling |

Native and portable profiles remain separate in every key and table. Each profile has 144 pairs and 36 condition ranges. The six fixed hit/batch cells are retained: hit50 with batches1/3/31/4096, plus hit0 and hit100 at batch1. The 224 tiny-path and 64 bulk-control contrasts are both mandatory. Batch1 has generic prehashed, generic common-hash+query, visible public prehashed and visible public fused-hash contracts. Other batches have the two generic contracts. Public hashing and output materialization remain in their measured contracts. Batch31's q22 remainder is4, so this case does not test a newly changed1–3-key remainder.

Ratios are **candidate latency / control latency**; below1 is faster. Each median is computed from that API's eight trials. API clocks are not simultaneous; no per-trial pairing or significance inference is invented. Four-point ranges are not confidence intervals. Round2 reverses both the full process ledger and API order, but environmental history changes too. The candidate couples SIMD routing with the compiler's inlining, target boundaries, frames and unrolling; this experiment does not isolate one instruction's causal effect. Retained bulk source is not assumed to produce identical machine code. Actual rebuilt caller proof and ASM, not old tiny-proof symbol addresses, govern final interpretation.

No pooled winner, cross-profile performance ranking, external comparison, new FPR/quality, build, multithread or global-fastest claim is produced. All individual slower/tied cases are rendered explicitly; complete CSVs retain every observation. The old insertion and accuracy evidence is outside this query-only calculation.

There is deliberately **no measured-data loader** in this package: `load()` always fails. A later additive loader must bind the final frozen producer and completed committed raw archive, verify the full import/source/binary/placement closure, replay all96 exact commands and192 ordered raw rows through the producer audit, and then call this unchanged calculation. No raw anchor is populated before completion. Tests use synthetic records only; no Rust compiler or Bloom filter is executed.
