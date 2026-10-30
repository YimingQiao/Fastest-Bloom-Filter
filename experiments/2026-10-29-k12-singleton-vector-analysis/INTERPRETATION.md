# Singleton192 interpretation

The fixed C++ candidate is a strong small-query improvement against its own
unchanged K12 control in this experiment. Every batch-1 and batch-3 comparison
is faster across both sizes, all three hit ratios, both seeds and both launch
rounds. It is not an unconditional bulk improvement: large batch-31 staged
common-hash lookup is slower in all 12 observations. This stage makes no
production promotion, external leadership, new accuracy, or Rust-performance
claim.

The complete 96-process/192-row archive was committed as
`cc63e8faf24c07d7d993216220a06c1258321fac` before analysis. Frozen calculation
`1b49388c97bb1fcfe537aa3e5bf9373ce9e9059b` and loader
`daf56866cb452e00a826aba62f4dd2eac1a3a3f2` checked the exact source, executable,
proof, command, raw-output and complete launcher-log identities. No adaptive
configuration, additional seed, timing rerun, or new filter was added.

The scope is one native C++ executable on CPU3/socket1/NUMA1; n=65,536 and
33,554,432; actual24bpk (192KiB and96MiB); hit0/50/100%; q=2^22;
seeds16057/32029; eight measured trials per query contract. Each API builds its
own canonical bitmap sequentially, without build timing. Round2 reverses the
entire48-case first-round ledger and the API order for every identical input.

## Small-query outcomes

The ratios in this table are **candidate/control latency**. Each interval is
the envelope of the 12 separately retained seed × round × hit observations,
not a pooled median or confidence interval. The full report keeps hit ratios
separate and shows every four-point seed × round condition.

| Contract | 65,536 keys | 33,554,432 keys |
|---|---:|---:|
| Batch1 generic pure | 0.697135–0.701201 | 0.696798–0.725139 |
| Batch1 generic staged common-hash | 0.673278–0.675097 | 0.784365–0.813616 |
| Visible public pure | 0.523186–0.524983 | 0.547283–0.556342 |
| Visible public fused common-hash | 0.440292–0.442952 | 0.510635–0.523579 |
| Batch3 generic pure | 0.667865–0.670530 | 0.639077–0.659321 |
| Batch3 generic staged common-hash | 0.729932–0.733302 | 0.731607–0.755605 |

For the same query counts, the visible fused latency ratios correspond to
approximately2.258–2.271× throughput at the smaller size and1.910–1.958× at the
larger size. These are observations against this C++ control, not comparisons
with the strongest external or Rust APIs. All96 batch1 and48 batch3 contrasts
are faster; none changes direction between the two launch rounds.

## All larger-batch regressions remain material

Batch31 has27 faster and21 slower observations. At the smaller size, staged
common-hash lookup is faster in all12 cells (ratio0.979450–0.985009), while
pure lookup has9 faster/3 slower cells (0.977909–1.005251). At the larger size,
pure lookup is split6/6 (0.995015–1.007988), and staged common-hash lookup loses
all12 cells: ratio1.018383–1.029918, or about1.8%–3.0% higher latency.

Batch4096 has22 faster and26 slower observations. Small pure and staged
contracts are each6/6; large pure is6/6 and large staged is4 faster/8 slower.
All48 ratios span0.975746–1.028989. These mixed observations do not establish
bulk parity, a uniform bulk regression, or an unconditional improvement.

Overall193 observations are faster,47 slower and none exactly equal. These
are bookkeeping counts, not independent repetitions or a statistical win
rate. [REPORT.md](report-v1/REPORT.md) lists every slower cell, and
[pairs.csv](report-v1/pairs.csv) retains every outcome. The original480 vectors
and3,840 values remain in the corresponding artifacts.

## Round sensitivity and interpretation limits

Among120 same-input two-round comparisons,23 change direction:7 of24 batch31
conditions and16 of24 batch4096 conditions; none of48 batch1 or24 batch3
conditions does. The complete sensitivity records retain both API orders,
both candidate/control ratios, each API's round2/round1 latency ratio, and the
ratio of those ratios. For batch31 that last ratio spans0.978710–1.019864;
for batch4096 it spans0.965803–1.036724. Reversing launch and API order does not
separate order from changing environmental history, and these are not causal
order-effect estimates or confidence intervals.

The change leaves allocation, mapping, insertion, the scalar oracle and
batch>=4 source bodies intact. That does not imply identical machine code,
layout or caller behavior for larger batches. Actual normal/minimum-AVX512F
assembly shows that the candidate tiny path loads the legal whole line through
VPERMD and performs dictionary selection and variable rotations without a
per-key helper call. The old visible control calls LookupScalar(1) per key
with a larger frame; the candidate inlines and its normal pure loop also
unrolls two keys. SIMD body, inlining, frame and unrolling changes occur
together, so the results cannot isolate a single load or instruction as the
cause. The already-inlined Rust SingleLine control has a different starting
point and a runtime target-feature boundary; no transfer of these ratios is
assumed.

Every formal row passed full element equality and output guards after every
timed phase, all-inserted checks and input-immutability checks. Across API,
batch and round processes, emitted bitmap/input/complete-output digests and
mixed-query counts match. Those archived digests are observed fingerprints,
not stored complete arrays or new independent false-positive measurements.
No new calibration or quality qualification was performed.

Root independently recomputed all240 medians/ratios,480 vectors,3,840 values,
120 sensitivities and60 four-point ranges directly from the complete records
and reported agreement. The retained small-query gains justify considering
this exact candidate further, while the consistent large batch31 loss and
all other regressions remain part of that decision. No implementation is
promoted by this report.
