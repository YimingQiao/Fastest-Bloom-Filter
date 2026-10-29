# Fixed four-arm confirmation entry

This separate stage uses the already validated normal C++ and Rust binaries.
It does not rebuild or change native code, the caller, threshold, seeds,
Williams schedule, number of samples or selection rule. The complete caller
proof is committed at `094345ebf5050e4705540836441a6de09bc45931`.
No formal case has run yet.

The immutable plan is40 processes: two families, two languages, five fixed
scenarios and two fresh seeds. C++ uses requestedT4, RustT8. Each process
executes32 repetitions/eight complete Williams blocks for each available
contract. There are72 contracts,160 arm records,288 trial vectors and9,216
fresh timed bitmap lifetimes. The untimed serial oracle is built once per
process and released before the arms. Populated allocation+insert is
unavailable, and there are no timed serial or query observations.

CPU3/socket1 is the only formal placement. Parent CPU3 retains an inherited
exclusive WRITE flock for the whole matrix. Each child expands affinity
before numactl: C++ cores3,5,7,9; Rust cores3,5,7,9,11,13,15,17, all physical
cores on NUMA1 with explicit memory binding. These are allowed core budgets,
not individually pinned native workers. Native construction first-touch and
thread/coordinator differences remain as documented in the fixed plan;
there is no cross-language speed claim.

After review/commit and an explicit socket1 lease:

```sh
flock /tmp/fastest-bf-socket1.lock \
  taskset -c 3 env BF_SOCKET_LEASE=socket1-cpu3 \
  python3 experiments/2026-10-29-native-build-policy-controls/screening/run.py \
  --source-commit FULL_REVIEWED_COMMIT --execute-frozen
```

The runner checks the committed294-artifact caller proof, all four binary
hashes and475 actual compiler inputs before and after. It uses only the two
normal binaries. Every raw result revalidates complete chronology, all32
values, geometry/worker/scratch/input metadata and full-output digests.
Cross-language semantic equality is checked without treating those repeated
mappings as independent quality samples. Exact commands, stdout/stderr and
failure outcomes are retained; the cases ledger cannot be replaced by count
metadata. Complete raw reconstruction must match both the JSON aggregate and
160-row CSV. Progress prints counts only; no partial ranking or adaptive
extension is allowed. Any failure stops and preserves the attempt.

## Prespecified interpretation

All six named latency ratios are retained: A1/A0, Policy/A0, Policy/A1,
Clone/A0, Clone/A1 and Policy/Clone. Numerator latency divided by denominator
latency greater than1 means slower. This differs from prior speedup tables;
no older observed latency is imported. All samples and every adverse outcome
remain, separately by language/family/scenario/contract/seed. The two
predeclared target cells do not replace the remaining same-level controls.

The engineering band is[0.97,1.03]. For each contrast, average the four
per-repeat log ratios in each cycle, then average eight cycle means and
exponentiate. The10,000-draw complete-cycle bootstrap uses seed20261029,
identical index resamples across all contrasts within a fixed case/contract,
and percentile endpoints with rank(B-1)*p interpolation. Neither the eight
cycles nor shared A0/A1 references create independent observations. All
cycle/trial values are retained; an optional geometric A-reference summary
is secondary only.

A negative control is inside the band only if all full pointwise intervals
for A1/A0, Clone/A0 and Clone/A1 lie inside it at both seeds. Only then can
Policy be labeled consistently slower/faster when both Policy/A0 and
Policy/A1 full intervals lie beyond the same band edge at both seeds.
All policy intervals inside means practically within this band, not no
impact. Everything else stays unresolved. There is no familywise or causal
guarantee, no pooling across cells/seeds, and no extra samples to turn an
unresolved result into a win. Unexplained offsets do not justify default
policy promotion. The exact fixed definitions are copied in `protocol.json`
and checked against the previously committed plan before execution.
