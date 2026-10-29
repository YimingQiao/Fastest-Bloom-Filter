# Cache-unit assertion repair

The original selector source and failed session73941 are preserved at `228cf5fb2d0dfc39d748c33617cd53e6b748f869` and `3efa4a9385272f0bf1f6df38ba67f23401a34255`. The source catalog stores `[n, buckets, cache_bytes, probes]`; V1 used `cache_bits` in its consistency assertion. Its zero-cache synthetic fixtures missed the unit distinction. Complete immutable source/raw replay passed, then construction projection rejected the first cached point before any view selection or output.

`selector.py` is an exact copy with only that one field corrected; `SELECTOR.patch` and `derived()` enforce the delta. No eligibility, tie, quality, constructor, metric, union or reporting rule changes. The wrapper verifies the original source, failed terminal/log archive and this additive source before imports; it reuses the original complete-data loader and writer. It writes only a fresh output directory with both source commits and the failed attempt in provenance.

Three focused tests cover a nonzero-cache tuple, rejection of the incorrect bit unit, every one of the 47 committed source constructors (30 cached), and rejection of extra selector changes. This geometry check reads no historical latency/FP values and runs no filter/compiler. The earlier 12 pure guards remain preserved; unchanged selection bodies do not require a repeated broad suite.

After source review/commit and a separate coordinated offline lease:

```sh
python3 repair-v2/run.py --source-commit FULL_REPAIR_COMMIT --output selection-v2
```

No BF/calibration/performance execution is part of this repair. Historical selection is still used only to prepare a finite future panel; both natural public input forms remain unmeasured.
