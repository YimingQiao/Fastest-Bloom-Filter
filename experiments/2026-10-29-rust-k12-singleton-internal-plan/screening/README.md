# Fixed Rust internal singleton run: prepared entrypoint

This source prepares the exact proposal `9e7fb401ccd6bd55a151eb8cc32395a06375862a`: **96 fresh processes / 192 rows**, two sizes, six hit/batch cells, two seeds, two opposite launch/API rounds and both native-host and portable-runtime binaries. `ledger.json` and `protocol.json` are byte-identical copies of that committed proposal. This package grants no measurement permission by itself.

Both executables come from successful actual-caller proof `a2d508a5a93441e06e0b7776998916cdc53fd5b1`, compiled from `23e9b075a295deb11c3073cc3b4182b5810a9057`. Their two binary hashes, 24 actual source inputs, prepared source closure, toolchain/assembly/placement tool hashes, 20-row semantic proof, 8 CLI failures, 4 output faults and actual ELF/manual review are checked before any formal command. There is no build or source mutation in this producer. The native and portable actual call boundaries differ; the complete proof describes the once-per-phase outlined work wrapper and portable per-key public facade. No old address or timing is imported.

All rows use q22, actual24bpk and eight balanced query repetitions. Batch1 retains four contracts; batch3/31/4096 retain two. Native/portable profiles are never combined into a speed ranking. The complete output retains **288 contrasts, 576 vectors / 4608 values**, with 224 tiny-path and 64 bulk-control contrasts. The separate pre-data pure analysis retains 144 opposite-round sensitivities and 72 four-point ranges. There is no calibration, quality gate, build timing, external comparison or adaptive selection.

After exact source commit, review and an explicit performance lease, the sole launcher is:

```sh
set -o pipefail
flock /tmp/fastest-bf-socket1.lock env BF_SOCKET_LEASE=socket1-cpu3 taskset -c 3 python3 -u experiments/2026-10-29-rust-k12-singleton-internal-plan/screening/run.py --source-commit FULL_COMMITTED_SOURCE --execute-frozen 2>&1 | tee experiments/2026-10-29-rust-k12-singleton-internal-plan/screening/screen-run.log
```

The parent requires an actual inherited exclusive flock, CPU3 affinity and socket1/node1 topology. Before every command it rechecks that lease and the selected profile's executable. Every child explicitly uses `taskset -c 3 numactl --physcpubind=3 --membind=1` and inherits the verified lock descriptors. The whole matrix is exclusive on socket1. The full source/proof/tool/input/binary closure is checked again at completion. Both profiles use identical placement; no measurements may overlap.

Each process must return exactly two actual JSON rows in its frozen arm order and empty stderr. Fixed workload/geometry/backend/phase/sample fields and full semantic fingerprints are checked before appending the result. Complete replay checks all commands, raw stream hashes, profile-to-binary binding, exact case order, same-mapping arm identity, shared query identity across batches/rounds/profiles and bitmap identity across hits. Every failed command/partial artifact remains; the runner stops without replacement or automatic retry. Partial timings are not interpreted.

Output is the fresh fixed `results-v1/` directory. On success its `RAW_ARCHIVE.json` covers exactly 194 artifacts: 192 stdout/stderr files plus final metadata and ordered records. The full outer `screen-run.log` must additionally be sealed and committed after launcher exit. The analysis completed-raw anchor must bind both this raw inventory and that full launcher log; no anchor is populated before completion.

`audit.load_complete(raw_commit, raw_manifest_sha256)` returns `(metadata, records)` only after exact full-40-hex committed raw blob checks and the frozen producer/proof/placement/row audit. `records` is the exact96 ordered `{case, rows}` sequence. The analysis loader must first bind this producer/import inventory and the complete launcher anchor, then call the unchanged pure calculation. Runtime metadata or raw files cannot override the fixed proposal. All 192 rows, sample vectors, wins/losses/ties and no-effect controls remain; no seed/round pooling or instruction-level causal claim is intended.
