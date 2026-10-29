# Public Fastbloom fixed-probe expansion

Source-only proposal. Nothing here has been compiled, calibrated or timed.
The frozen Rust120 screen used Fastbloom0.17's public
`.with_num_bits(...).expected_items(real_n)`, selecting11/17/22 probes at actual
16/24/32 bpk. That minimizes false positives; it does not necessarily minimize
latency subject to the looser1%/0.1%/0.01% ceilings.

This isolated package retains all eight old public configurations and adds
`Fastbloom017K1` through `Fastbloom017K12`, each calling the upstream public
`.with_num_bits(exact_bits).hashes(K)` constructor. The original insertion,
singleton lookup and dense lookup adapter bodies are unchanged. No private
kernel, fake expected item count, alternate hash, custom storage or production
library edit is introduced. The registry now has20 entries. Dependency versions,
upstream pins, release options and the complete measured/workload helper region
remain the same as committed Rust120 source
`2c7b1668880ab5a1e3ea0c73f2034b89da0d8650`.

The native path dependency points to that immutable snapshot, not the current
production working tree. Nine benchmark files were copied directly from Git;
only package/path names, registrations, an include and the new geometry arms
are derived. `verify_source.py` checks those exact deltas and the inherited
native bytes without compiling anything. The initially suggested K8/10/12/17
draft was replaced before any execution because it omitted likely faster
small-K qualifiers; `superseded-four-k.json` records that pre-data decision.

The accuracy-first proposal keeps all72 new fixed-K size/cap geometries plus
the40 retained family geometries,112 API/geometry rows in total. Native cap24
aliases actual16 and is omitted exactly as before. Every K1..12 row stays in
the accuracy archive, including failures. Real n remains2^16 or2^25; actual
capacities remain16/24/32 bpk, with q2^22 and2^24 calibration negatives on seed42
so old constructions/counts can be reproduced. This initial pass makes no
latency claim. A dedicated untimed one-build accuracy driver is still to be
prepared and reviewed; no performance execution is authorized by this proposal.

Before that pass, run the retained tests plus the added allocation, dense-output,
guard/tail, duplicate-key and public-bitmap tests. The only new intended quality
alias is default Fastbloom at16 bpk and explicitK11, proved through identical
public bit slices and full outputs. Count its two API timings separately, but
do not pool the duplicated calibration stream. The defaultK17/22 configurations
remain available at24/32 through the unchanged default API. Existing SBBF and
Bloomsday families are retained without introducing new cross-family alias
assumptions.

The proposed later timing selection uses **accuracy only**: for each size,
actual allocation and FPR ceiling, select the lowest fixedK whose two-sided95%
Wilson upper endpoint qualifies, plus the adjacent K-1/K+1 values within1..12.
Neighbors remain visible even if they fail that ceiling. Preserve the union
across ceilings, always retain the original default and all original native,
Range and other external controls, and compare all smaller allocations under
larger caps. If no fixedK qualifies, record that fact; do not invent a qualifying
point or omit its failed accuracy observations. No latency is used to choose K.
`selection_rule.py` implements that bounded shortlist and rejects performance
fields; its synthetic tests do not construct filters. This rule does not assume
that measured latency is monotonic in K, or prove the selected K is the fastest
of all public configurations. A later held-out performance check remains needed.

The accuracy protocol, deterministic selection rule, compiler inputs, executable
and correctness evidence must be reviewed and committed before execution.
Timing needs a separate frozen shortlist and explicit CPU/socket lease. All
four query modes and four build metrics remain separate, with every loss and
unqualified point retained. A faster fixed-K observation would narrow the old
Range/default-Fastbloom gap; it would not retroactively alter the frozen120 rows.
