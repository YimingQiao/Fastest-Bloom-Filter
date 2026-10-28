# Decision: reject this shortcut for native promotion

The four-line `Independent32SingletonV1` shortcut does not reliably improve
the generic singleton path and harms batch2/31 in this training screen.
The unchanged Independent32 prototype remains available. No production
source was changed and no global-fastest claim follows.

All16 workloads/192 rows completed on CPU2/socket0 under one exclusive
inherited flock lease. Full outputs, absence of false negatives, before/after
calibration agreement, all four trial vectors, phase balance, exact
source-derived row order, committed source hashes and final source/dependency/
binary hashes passed. Fourteen separate offline analysis tests pass.

Ratios below are unchanged Independent32 / shortcut. The geometric mean
summarizes four size/allocation conditions, not independent replications.

| Batch | Generic prehashed: GM ratio; wins/losses | Generic staged hash: GM ratio; wins/losses |
| ---: | --- | --- |
| 1 | 0.9975; 1/3 | 1.0435; 2/2 |
| 2 | 0.9234; 0/4 | 0.9620; 0/4 |
| 31 | 0.9681; 0/4 | 0.9788; 0/4 |
| 4096 | 1.0285; 2/2 | 1.0175; 4/0 |

Batch2 prehashed is6.4–9.9% slower in all four conditions. The largest generic
batch31 loss is the128MiB bitmap:4.193→4.661ns/query,11.2% slower. All64
shortcut/before comparisons across the four contracts are retained:28
faster,36 slower, no exact ties. Those counts reuse workloads and are not
a significance test. The positive large-batch results do not rescue the
targeted singleton/short-batch behavior.

This is consistent with the preflight concern about the larger common
prologue and altered code generation; it does not prove those instructions
caused each measured difference. The candidate saves six callee-saved
registers rather than one and its portable scalar remainder calls a helper.
No extra annotation or alternative was introduced after observing results.

The public visible singleton API still has promising strict-tier behavior,
but it was unchanged by this shortcut. At actual32bpk and batch1, the
unchanged version's prehashed/fused times are1.299/1.754ns for n=65536 and
4.500/5.998ns for n=33554432; the fastest eligible of the three Rust external
families, Bloomsday, measures1.503/2.174ns and5.005/6.375ns respectively.
These are same-process values from this screen, never ratios against older
CPU3 results. They motivate fresh-seed confirmation of the existing public
API, not promotion of the failed shortcut.

The shortcut's generic strict singleton path still loses prehashed at both
sizes (3.912 versus3.254ns;9.436 versus8.855ns). Staged common-hash results are
mixed:6.524 versus6.246ns on the small table,14.733 versus17.466ns on the large
table. All other feasible allocations and original native rivals remain in
the detailed report.

Before/after mappings and calibration counts match exactly. Actual32bpk
Independent32 Wilson95 upper endpoints are0.003520% and0.004642%, below the
0.01% target. Actual16bpk endpoints are0.131878% and0.134815%, above the0.1%
target. Each bound uses its own2^20 negatives. Clone and repeated batch/mode
queries add no independent calibration evidence; no prior screen is pooled.

This seed42 screen is not pair-order balanced: the shortcut is first relative
to unchanged Independent32 at both sizes (zero-based positions1/9 and0/9).
All mode phases are balanced, but that does not balance filter execution
order. Fresh-seed confirmation must preserve both order strata before small
differences are attributed to a source change. Large-table trial ranges are
also retained rather than represented as speed confidence intervals.

A separate future one-change experiment could test a forced inline scalar
helper to remove the common ABI cost, with unchanged/before/shortcut controls
and the same public contracts. That is a hypothesis only; no such candidate
has been built or timed here.
