# Fixed Rust K12 confirmation analysis sidecar

Source-only preparation while the frozen108 producer runs; this sidecar has
not read partial timing/quality rows. `load()` first requires the exact complete
committed raw archive and replays the frozen producer/source/metadata/order/
trial/quality guards. A movable Git ref, incomplete/changed raw ledger or altered
aggregate is rejected before numerical ranking. The original runner and all
measured inputs remain untouched.

The analysis implements the pre-data rules:288 primary/secondary cap views,
all1728 allocation alternatives,720 named ratios and240 three-seed conditions,
48 primary-position strata and216 same-row query API ratios. Every metric is
ranked separately. Cap32 admits24 allocations; owner classes remain separate,
and secondary extra geometries are marked as different processes. Main all-three
seed qualification, current-seed qualification and unconditional timing views
are retained together, so ineligible cases and all losses/ties remain inspectable.

Quality keeps36 separate API/geometry/size/seed records and12 worst-endpoint
all-three-seed gates without pooling. Query trial vectors/ranges remain attached
to pairs; build outputs have medians only and no invented trial vectors.
No post-data selection, global fastest, all-K-fresh or C++→Rust speed claim.

Run only after complete raw evidence is sealed and committed:

```sh
python3 experiments/2026-10-29-four-sector-range12-rust-analysis/summarize.py \
  --raw-commit FULL_COMMITTED_RAW_REVISION
```
