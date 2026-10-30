# Focused four-arm caller preflight

This is a correctness and assembly stage. No compiler or Bloom filter has
run in this directory. The source-only guards pass seven synthetic tests.
The two formal fresh seeds are never used by a successful preflight command.

Normal and ASan builds each run six cases per language: both native families,
scenarios 0/1/2, old seed 74381, C++ T4 or Rust T8. Each invokes
`--caller-check` and one full four-row Williams cycle through the same Trial
function used by `--measure`. This yields 24 checked records, 96 arm records
and 640 successful timed fresh-bitmap lifetimes. Four injected-output faults
and 14 malformed/stage-mismatched CLIs must reject. The four-trial durations
are incidental validation output and will not support performance rankings.

Every arm must reproduce the full guarded output of its untimed serial
oracle, and every old/new inserted key must remain present. The 12 old
semantic references are extracted from the exact committed native96 raw
aggregate; only semantic fields are copied. Language-specific scratch and
spawn counts are checked separately. Both languages and both build profiles
must agree on all semantic fields. Large-table and above-byte cases retain
the existing native correctness proof; this preflight does not repeat a
large Cartesian product or consume formal seeds.

`lease.py` and `dependencies.py` are unchanged copies of previously reviewed
guards. Their commit/path/SHA origins are pinned. The latter resolves all
Cargo dep-info using the actual package/manifest/target identity, including
nightly's output directory via the dep-info left-hand side and matching
reported/sibling executable hashes. There is no first-existing-source guess.
The complete compiler input closure and four executable hashes are captured.

After source review, commit, and an explicit whole-socket lease, the entry is:

```sh
flock /tmp/fastest-bf-socket0.lock \
  taskset -c 2 env BF_SOCKET_LEASE=socket0-cpu2 \
  python3 experiments/2026-10-29-native-build-policy-controls/caller/preflight/validate.py \
  --cpu 2 --source-commit FULL_COMMITTED_REVISION --execute-correctness
```

The runner also supports an explicitly assigned CPU3/socket1 lease. It
compiles on the single parent CPU and widens child affinity before invoking
`numactl` with the matching memory node. No invocation is authorized merely
by this documentation.

After validation, capture normal binaries' raw symbols, relocation/package
identity and disassembly without running a filter. The assembly gate must
prove the shared A0/A1 Trial address and original-T native calls between
clocks, locate the Policy gate in both insert/allocation paths, and report
whether before/clone code was folded. Distinct source names do not establish
independent code layout. This manual gate and the frozen binary/source proof
must be reviewed before a separate formal performance entry is prepared.
Previous sources and failures remain immutable; repairs use additive stages.
