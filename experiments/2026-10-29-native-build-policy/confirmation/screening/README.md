# Fixed96 paired build-policy confirmation runner

This runner reuses the exact two normal executables from focused proof commit
`cc2b2e2a3a39f395ece3b8cf308cdca6bda406e2`; it does not rebuild either library or
timing harness. The compiled-source commit is
`b09b326127792882202f5c3cda8e3d927454aa1e` and the independently frozen plan is
`3c521886e93707468cb2b827115929831a87ef93`.

The six scenarios, two families, requested4/8, two languages and seeds74381 /
164321 give96 commands. Each command contains both disabled and bounded public
wrappers and its own serial reference. The C/P pair is measured in one process
with four-trial ABBA ordering. Serial is first/last only. Complete case/language
order reverses for the second seed; scenario results are never reordered from
observed performance. The seeds are fresh relative to threshold selection at
seed42. Small cases at the first seed have already been used to validate this
frozen harness, without choosing another threshold or inspecting speed ranks.

Only insertion and empty allocation+build are ranked. Populated cases have no
allocation samples. The192 variant CSV rows refer to96 separate shared serial
CSV records, avoiding duplicated reference samples. Every raw paired object
and all trial vectors survive. Absolute nanoseconds, per-new-hash medians and
separate prefill setup diagnostics are explicit. No FPR qualification, query
speed comparison, external ranking or cross-language speed claim is introduced.

The complete matrix holds the socket1 write flock. Parent coordination remains
onCPU3; each child first expands to the original T core budget before libnuma
binds it to node1. Physical cores are3,5,7,9 and additionally11,13,15,17 forT8.
The public call may migrate or colocate threads within that set; individual
worker pinning is not claimed. Candidate W1 retains the same allowed T set.
All setup/validation/affinity/destruction exclusions, first-touch rules and
worker/scratch accounting are those of the frozen harness.

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  env BF_SOCKET_LEASE=socket1-cpu3 python3 \
  experiments/2026-10-29-native-build-policy/confirmation/screening/run.py \
  --source-commit FULL_REVIEWED_COMMIT --execute-frozen
```

No run is authorized by this file alone. Source review/commit and the parent's
explicit socket lease remain required. Existing result paths and failed
outcomes are never replaced. The original proof's116 artifacts,132 source
inputs,437 compiler inputs and four binaries are checked before/after the run,
including the binary-specific proof that all four C++ policy selections occur
between the actual clock calls.

The offline audit reconstructs every raw record and command in the fixed order,
checks original-T placement, input fingerprints, full-semantics invariants,
all phase schedules/worker/scratch formulas, and both CSV tables. Repeated T and
language runs agree in24 semantic geometry groups but do not constitute
independent FPR samples. A nested `counts` object cannot overwrite the96-entry
`cases` ledger. Partial results are retained without ranking or plan changes.
Keep later archive manifests/review notes outside `results-v1`, whose exact raw
inventory is part of the audit.
