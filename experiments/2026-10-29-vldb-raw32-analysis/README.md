# Raw32 paired-context analysis preparation

This is source-only while the fixed728 matrix is active. No partial timing
values or quality results have been read or ranked. Synthetic tests are written
but have not been executed during the exclusive performance leases.

The loader requires the **completed** original metadata, all728 exact raw CSV
rows and stderr files, exact recorded commands/launch order, the recorded CPU2
inherited write lease, unchanged tuner state, all query trial vectors/schedules,
all166 unpooled quality identities, and a separately committed raw archive. It
checks each raw/evidence file against both its digest and its exact git blob.
The measured producer's three preparation inventories, worker freeze, and
successful correctness artifacts are also checked against the measured source
commit. Portable archived analysis needs these repository artifacts; it does
not silently substitute live compiler files or newly built binaries.

Fixed outputs, before seeing complete results:

| Output | Count | Contract |
|---|---:|---|
| Same-context rankings | 288 | 2 executables ×2 launch rounds ×2 n ×4 actual byte caps ×3 FPR gates ×3 query modes |
| All alternatives/losses | 26208 | Every measured API/geometry, including budget/quality failures, in every relevant same-context view |
| Cross-context observations | 144 | Original public leader, modern external leader, and both native leader sets shown as raw observations |
| Paired native controls | 144 | The same native/filter/actual geometry in both executable contexts for each round/mode |
| Quality identities | 166 | One pointwise Wilson95 interval per observed construction/negative stream; API and round aliases checked and never pooled |

Qualification uses actual allocated bitmap bytes under caps12/16/24/32 and the
two-sided Wilson95 **upper** endpoint under1%/.1%/.01%. Smaller allocations may
compete under every fitting larger cap. All original PImpl/dynamic/static and
modern public aliases stay in the ranking; the fastest eligible shape is used,
with every tie/name/geometry retained. Original public surfaces also have
separate leader columns. The out-of-line RocksDB Batch32 singleton must not stand
in for its faster direct same-layout alias.

Public-single, dense-batch1 and dense-batch4096 remain separate contracts. The
two launch rounds are not averaged or used as independent quality samples. A
cross-context ratio is explicitly an observation from two different
executables: both native-control sets and individual times remain visible, and
no native ratio is subtracted, divided out or used for a context correction.
All alternative rows retain qualification, trial vectors/range/phase order and
raw ratios; an ineligible candidate receives no eligible-win label.

This is seed42 training, not held-out confirmation and not a universal fastest
claim. Prior u64 gates, other seeds, other allocation sizes, and previous
quality-resolution streams are not imported into this raw-u32 analysis.

After all728 rows finish, seal `benchmarks/vldb-raw32-stage3/SCREEN_ARCHIVE.json`
with `producer_commit` and a `files` mapping relative to the Stage3 root. It must
include `screen/metadata.json`, every `screen/rowNNN.stdout/.stderr`, and
`screen-run.log`. Commit that evidence before invoking:

```sh
python3 experiments/2026-10-29-vldb-raw32-analysis/summarize.py \
  --raw-commit FULL_RAW_ARCHIVE_COMMIT \
  --archive benchmarks/vldb-raw32-stage3/SCREEN_ARCHIVE.json \
  --output experiments/2026-10-29-vldb-raw32-analysis/report
```

The final prose report will be written only from the completed guarded outputs,
including all losses and quality failures. No timing rerun is part of analysis.
