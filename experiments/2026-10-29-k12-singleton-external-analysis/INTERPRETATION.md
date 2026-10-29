# C++ singleton comparison: interpretation

The SIMD singleton candidate improves the tested K12 tiny-query paths, but this
screen does not establish it as the best native choice. It wins every one of the
336 same-byte comparisons with old K12 at batch 1 or 3, while losing all 224
qualifying primary comparisons with Range. Its external wins are confined to
some strict-quality modes. The current full public Lookup candidate also retains
58 slower outcomes among 96 batch-31/4096 comparisons with old K12. Keep this
candidate experimental; do not promote the whole change as a default on this
evidence.

The completed matrix has 48 processes and 616 rows: n=2^16/2^25, q=2^22,
eight timing repetitions, seeds 982451653 and 961748941, and two complete launch
rounds with reversed case and API orders. Primary external comparisons use
batch 1 and 50% hits. Separate native-only diagnostics cover batch-1 hit 0/100
and hit 50 batches 3/31/4096. Generic prehashed, generic staged common-hash,
visible public prehashed, and visible public fused common-hash contracts remain
separate. This is a single-machine, fixed-ISA C++ result, not a Rust, build,
multithread, external-bulk or global-fastest result.

All ratios below are **candidate or named native latency / named rival latency**;
below one is faster. Ranges retain the two seeds and two rounds individually;
they are not confidence intervals. The eight-repetition median supplies each
row's latency. Ranking uses actual backing bytes under nested 16/24/32-bpk caps,
including smaller allocations and Boost padding. Eligibility requires both
seed-specific cal26 Wilson upper bounds to pass the stated FPR ceiling. No
alias, seed or negative-probe denominator is pooled.

## External and native comparisons

The fixed leaders minimize the geometric mean over the four seed/round medians
and stay fixed for those four comparisons. This is descriptive selection on
these data. The separate per-cell envelope instead uses the fastest eligible
rival in that individual seed/round. Both require the same two-seed quality gate.

| Primary contrast | Faster | Slower | Not comparable |
|---|---:|---:|---:|
| Candidate / retained external leader | 20 | 204 | 64 |
| Candidate / production-native leader | 4 | 188 | 96 |
| Candidate / Range | 0 | 224 | 64 |
| Production-native leader / external leader | 156 | 68 | 64 |
| All-native composite / external leader | 193 | 63 | 32 |

These are counts of overlapping nested views, not independent win rates. The
all-native composite may select production, Range, old K12 or the candidate;
its wins cannot be credited to the candidate. Not-comparable rows are not wins.

The external envelope changes rival identity in 46 of its 288 rows; the
production envelope changes identity in six of 288. Nevertheless their candidate
outcome counts remain exactly 20/204/64 and 4/188/96 respectively. All 576
envelope rows are retained. Thus the limited external wins survive the stronger
per-cell comparison, but they do not support a broad leadership claim.

For example, under cap 16/FPR 1%, small-table candidate visible-pure latency is
2.18550–2.23613 times FastFilterFixed16SingleV1 at actual 14 bpk. At the large size,
the same mode is 1.28530–1.34011 times Boost192Multi32K8 at 50,331,647 backing
bytes (just under 12 bpk). Smaller qualifying rivals remain eligible.

## The strict 24-bpk distinction

K12 and Range at actual 24 bpk pass the fresh 0.01% ceiling at both sizes. Candidate
upper bounds span 0.00865816–0.00955000%; Range spans 0.00896456–0.00948362%.
Candidate at 16 bpk fails the 0.1% ceiling at both sizes/seeds (upper 0.124701–0.129939%),
so its missing cap 16 medium/strict comparisons must not become speed wins.

The following table compares the fixed actual 24 bpk candidate and Range against
the same mode-specific strongest eligible external leader under cap 24/FPR 0.01%.

| Size | Mode | External leader (backing bytes) | Candidate / external | Range / external |
|---|---|---|---:|---:|
| 2^16 | Generic pure | FastFilterFixed64 (196,608) | 1.218213–1.219545 | 0.809919–0.837695 |
| 2^16 | Generic staged hash | FastFilterFixed64 (196,608) | 1.022904–1.029048 | 0.835197–0.842310 |
| 2^16 | Visible pure | FastFilterFixed64 (196,608) | 1.148050–1.149727 | 0.736225–0.739159 |
| 2^16 | Visible fused hash | FastFilterFixed64 (196,608) | 0.961462–0.962515 | 0.661657–0.663176 |
| 2^25 | Generic pure | Boost192Multi64K8 (100,663,295) | 0.962558–1.017884 | 0.839532–0.848703 |
| 2^25 | Generic staged hash | Boost192Multi64K8 (100,663,295) | 0.913166–0.938841 | 0.870369–0.884880 |
| 2^25 | Visible pure | Boost192Multi64K8 (100,663,295) | 1.031027–1.112200 | 0.885494–0.903361 |
| 2^25 | Visible fused hash | RocksDBFastLocalBloom64K8Batch32 (100,663,296) | 0.922772–0.928799 | 0.820856–0.842929 |

Large generic-pure candidate results include three wins and one loss. In large
visible-fused mode, one individual envelope cell chooses Boost192Multi64K8
instead of Rocks; the candidate/envelope range becomes 0.922772–0.935433 and
still has four wins. Those external wins do not make K12 the native leader:
candidate/Range is 1.45130–1.45447 for small visible-fused,
1.04132–1.06594 for large staged-hash, and 1.10113–1.12778 for large
visible-fused. Range is faster in every strict 24-bpk primary cell.

The four production layouts have no qualifying point under cap 24/FPR 0.01% in
this retained 16/32 geometry panel. That is a not-comparable production result,
not a candidate victory. At cap32, production Split64 is a meaningful rival:
for small strict visible-pure, even the selected all-native leader Split64@32
loses to FastFilterSimdBlockSingleV1@32 by 1.21086–1.22003 times latency.
For large strict visible-pure, the composite instead selects Range@24 and beats
Boost192Multi32K8 at 117,440,511 bytes (just under 28 bpk), ratio 0.966127–0.992180.
Native strengths and external losses therefore both remain visible.

## K12 improvement and bulk tradeoffs

At hit 50/batch 1, all 24 equal-byte observations per mode improve over old K12:

| Mode | Candidate / old K12 | Equivalent throughput factor |
|---|---:|---:|
| Generic pure | 0.680043–0.768812 | 1.30071–1.47050x |
| Generic staged hash | 0.682599–0.859122 | 1.16398–1.46499x |
| Visible pure | 0.513228–0.648552 | 1.54190–1.94845x |
| Visible fused hash | 0.447521–0.606161 | 1.64973–2.23453x |

All singleton hit 0/hit 100 observations and all hit 50/batch 3 observations also
improve. These are K12-before/after results, not external or native leadership.

| Bulk contract versus old K12 | Faster | Slower | Full latency-ratio range |
|---|---:|---:|---:|
| Batch31 generic pure | 7 | 17 | 0.938410–1.024439 |
| Batch31 generic staged hash | 6 | 18 | 0.950846–1.074194 |
| Batch4096 generic pure | 15 | 9 | 0.958498–1.040503 |
| Batch4096 generic staged hash | 10 | 14 | 0.954375–1.049319 |

The earlier screen's all-loss large batch31 staged pattern must not be copied
into this result: the current large subset has six wins and six losses,
ratio 0.950846–1.015390; the small subset has twelve losses. Bulk source bodies
were retained, but their enclosing public Lookup and code layout changed.
Actual ASM also shows the candidate's singleton inlining/frame/unrolling differ
from old K12's per-key public scalar-helper call. Gains cannot be attributed
solely to one full-line load, and old source-named LookupScalar itself contains
compiler-generated vector instructions.

All 864 equal-byte comparisons remain unconditional with explicit quality flags.
Against Range they contain 89 faster and 343 slower outcomes; native-only bulk
wins do not imply superiority to external bulk APIs, which were not measured
here. The full primary and unconditional loss records are retained in report-v2.

## Provenance and the repaired analysis guard

The one formal benchmark completed at source 4beef700, session 19870, exit 0. Its
99 raw artifacts, 49-line complete launcher log and actual terminal evidence are
committed at 8fa1dee7. The first offline loader (82115) failed before report
creation because its bitmap-presence predicate incorrectly excluded the two
Rocks public Data() APIs. Exact failure evidence is retained at b0cbdf23.

Repair 9ba1ad7 changes only the availability guard and corresponding fixture/tests;
the calculate-through-render body is byte-identical to predata analysis 0acf6e43.
Loader binding 95b48b84 changed no executable loader code. Its single offline
retry 93885 passed into report-v2 with empty stderr. No benchmark, calibration,
constructor, candidate, threshold, timing, selection or ranking rule was changed
or rerun. The root independent audit verified all 128 quality records, 2304
alternatives, 72 views, 2016 primary pairs, 576 envelopes, 864 equal-byte pairs,
2032 vectors, 16256 samples and 1440 round-sensitivity records.

The reversed rounds expose order/history sensitivity but are not independent
order-causal experiments. This report recommends retaining the current candidate
as an experiment, preserving its useful K12 tiny-query result and its measured
bulk/native/external limitations, with no automatic production promotion.
