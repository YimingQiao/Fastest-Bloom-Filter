# Fixed-capacity fresh-seed confirmation

This is a source-only confirmation plan. No confirmation benchmark, compiler, or
new filter implementation has run here. The executable is the unchanged
`build/exact-budget-range-native/benchmark` from source commit
`d70077b28fb3cd5821ae471f185e98393423ec64`. The original 74-configuration archive
and its 988-row training run remain unchanged.

The selection is deterministic from the completed training archive at
`758499c63c5397cd64c9d67cdecab7e0388e774a`:

- All non-null external, production-native, and range-experiment leaders in all
  24 main rankings and all 126 supplementary capacity-frontier records.
- All four production-native layouts at each originally measured actual
  8/16/32-bit allocation and each original input size, including nonqualifiers.
- Deduplicate repeated nominal budgets for the same alias/effective geometry.
  Preserve each original input size and canonical constructor request; do not
  expand a selected geometry to an unselected input size.

The main rankings select 27 unique configurations. Including the supplementary
frontiers gives 37; retaining native controls adds 17. The final selection has
**54 configurations, 15 aliases, 39 command invocations, and 162 rows** across
three seeds. It includes 24 production-native, 17 external, and 13 range points;
33 points use 65,536 keys and 21 use 33,554,432 keys. There are 48 distinct
calibration identities per seed, hence 144 mapping/seed samples. API aliases do
not multiply the number of negative probes.

[selected-geometries.csv](selected-geometries.csv) contains the exact charged
and logical byte counts, unit sizes/counts, probe policies, constructor arguments,
and calibration identities. [selection.json](selection.json) additionally records
every training record that caused selection. The original 42 null frontier
records are retained. Main and supplementary settings overlap; they are not
independent replications.

The three seeds were drawn once with `secrets.randbits(63)`, before any
confirmation workload, and are fixed in [seeds.json](seeds.json):

```
7562001474399208876
3054562362472030614
6571923779321589834
```

Each configuration builds once with every inserted key, validates all inserted
keys, then measures six repetitions of each query mode using batches of 4,096,
2^22 queries, 50% intended hits, and 2^24 independent negative calibration
queries. Construction metrics stay NaN and `build_repeats` stays zero. The parent
binary alternates seeded prehashed/common-hash phase order; six repetitions give
each mode three first and three second positions. Every timed output and guard
is validated outside the timer. There is no construction timing claim.

The measurement lease is **CPU3/socket1**, unlike the original CPU2 training run.
Only same-confirmation candidate/external latency ratios are interpreted. The
runner requires an inherited whole-matrix flock descriptor and exact CPU3-only
process affinity. Root must review and commit the complete plan before launch:

```sh
flock /tmp/fastest-bf-socket1.lock taskset -c 3 \
  python3 experiments/2026-10-29-exact-budget-confirmation/run_confirmation.py \
  --source-commit FULL_CONFIRMATION_ARCHIVE_COMMIT \
  --lease socket1 --cpu 3 \
  --output-dir experiments/2026-10-29-exact-budget-confirmation/screen
```

The source commit must contain the exact new manifest and every inventoried
artifact. The runner also verifies the original d70077 archive's exact git blobs,
all 195 frozen source/dependency hashes, and all 15 frozen binaries, plus the
exact prior training-input git blobs. It checks the parent freeze before every
case and all source/training anchors again at completion. Existing result
directories cannot be overwritten. Commands, stdout/stderr hashes, lease proof,
complete trial vectors, and case membership are retained.

`summarize.py screen/ --verify-live` validates the archive and reports the fixed
comparisons. Each configuration must meet the target in **every seed**, using
the worst upper endpoint of its three two-sided 95% Wilson intervals. These are
pointwise bounds, not simultaneous or family-wide confidence guarantees. Neither
API duplicates nor different seeds are pooled into one calibration count.

All three latency ratios are retained, along with their median, worst ratio,
and per-seed losses. Ratios are **candidate latency / external latency**; values
below one favor the candidate. If either fixed leader fails quality, its timing
is still reported descriptively and the comparison is labeled a quality failure.
There is no held-out replacement, reselection, or retry with a different seed.
A null training leader remains null. Production natives, external baselines,
and project experiments remain separate; range candidates are not promoted by
this plan.

`test_contract.py` uses copied training rows relabeled as synthetic fixtures. It
never executes the benchmark, and its fixtures are not confirmation evidence.
It covers deterministic selection, complete seed/geometry coverage, missing or
duplicate cases, geometry/hit/phase corruption, alias calibration conflicts,
worst-seed failures without replacement, retained losses/nulls, exact recorded
commands, portable archive paths, lease proof, and committed-blob verification.
