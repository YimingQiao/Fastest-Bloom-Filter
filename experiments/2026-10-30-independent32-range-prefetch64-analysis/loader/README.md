# Prefetch64 complete-only loader

This loader derives from repaired 515f6c0. Its complete source binding fixes pure calculation 8d672c5, actual caller ac71d43, proof 9563af24 with 272 archived members/three binaries/572 inputs, and producer 16d017c538376f9bb2c6b3ad336adb9cdf83350b with preparation SHA e738554d018f7cc0e4525f1008d6ed2fa1725ee25a53e9ed65a617cff325a688. There is no completed-raw anchor, and no real data has loaded. The loader invokes no timing, filter, compiler or calibration.

The executable delta is retained in `LOADER.patch` and independently reproduced by `derive.py`: new stage path,192 rows,32 API/26 known mapping records/160 reuse rows, three binaries,572 consumed inputs and the final committed proof's exact artifact count. The repaired proof-first rule stays intact: every proof artifact is verified against exact committed bytes/hashes before only its sole top-level `caller/seal.py` may supplement the earlier caller source inventory. The allowance is restricted to that caller directory and is excluded from returned import allowlists. Loader, producer and analysis Python inventories stay strict; unknown caller extras still reject.

The binding includes full lowercase40-hex identities, exact preparation/proof hashes and artifact count. The loader verifies its own source inventory, the producer and pure analysis import closures, all actual caller source inputs and manual ASM gate. Three binary identities and572 compiler inputs must agree with the producer's initial/final closure. Recorded placement/NUMA/inherited exclusive-lock evidence is validated by the frozen producer audit.

Only a separately committed complete raw archive can load. It must contain exactly51 sized members:24 stdout/stderr pairs, metadata, ordered records and quality links. The complete launcher log must have25 exact lines: process1/24 through24/24, then `Complete24 processes/192 rows; all final source/raw/semantic guards passed.` and a final newline. Its separate committed execution outcome must retain the actual positive session ID, integer exit0, empty redirected terminal output and no live session. Missing, extra or partial evidence rejects; a completion line alone is insufficient.

After complete raw evidence is committed, a separate `../completed-raw-anchor.json` commit binds producer/raw commits, raw-manifest/log/outcome hashes and the actual session ID. The loader verifies every artifact as a Git blob before importing and invoking the frozen `audit.load_complete(raw_commit, raw_manifest_sha256)`. Its returned metadata must retain24 ordered cases,192 rows, identical source/tool/binary and placement closures, and the exact compiled proof.

The pure analysis then verifies the committed core/caller selection and exact ledger, recalculates all products and reconciles32 API calibration records,26 known mapping groups and160 reuse links against the producer's identities. It retains512 timing vectors,4096 samples,64 unconditional direct-control pairs and the separate qualified primary24-comparison decision. No ranking function is replaced or added here. Publication requires a fresh output directory and adds provenance containing the exact source/raw/terminal identities.

Seven inherited loader guards have only count-text deltas from f692681; `TESTS.patch` records them. The three parent515 proof-sealer guards are adapted only to the new272-member, three-binary,572-input proof counts, with their exact delta in `REPAIR_TESTS.patch`. All ten guards and the repaired-parent derivation passed on their first execution (actual tool e4dbda, exit0) under a brief CPU3/socket1 whole flock. Exact stdout/stderr are retained and that lease is released. The14 pure calculation tests were not repeated. A real-data load still requires the complete raw/terminal evidence, a separately committed anchor and root's scheduling.

Future entry after all gates:

```sh
python3 experiments/2026-10-30-independent32-range-prefetch64-analysis/loader/run.py \
  --loader-commit FULL_FROZEN_LOADER_COMMIT \
  --anchor-commit FULL_COMPLETE_ANCHOR_COMMIT \
  --output FRESH_REPORT_DIRECTORY
```

