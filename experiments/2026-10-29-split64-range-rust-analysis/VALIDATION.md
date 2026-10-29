# Separate Rust120 analysis

This directory owns only postprocessing. The producer, its source/dependency
freeze and measured executable remain unchanged. The analysis refuses incomplete
metadata and checks the exact committed source before reading performance rows.
No compiler, BF workload or calibration process is invoked by the analysis.

The initial11 synthetic tests passed before reading fresh timings. Independent
read-only review by `/root/optimize_probe` found no blocker in the20-allocation
choice set,216/4320/648 nested counts, three ownership classes,40 unpooled family
quality records,96 same-allocation controls or240 within-row API comparisons.
The reviewer also compared all14 historical quality tuples to their cited
immutable sources. Its suggested hardening was applied: the analyzer itself now
reconstructs those tuples from committed blobs and checks full equality before
recomputing Wilson intervals. The final12 offline tests pass, including a valid
Wilson interval attached to a deliberately wrong seed, which must be rejected.

The four query contracts remain separate. The whole-array visible public
singleton loops do not change their API contract with the batch tag. All smaller
allocations compete under a larger actual-byte ceiling. Build metrics have
separate nested views; the source CSV records their medians but no trial vectors,
so the analysis does not fabricate construction variability. Equal-allocation
Range/Split controls do not assert identical hash-to-block mappings.

Historical FourSector quality failures, their larger disjoint-suffix resolutions
and the fresh six-seed144 observations are contextual quality records only.
They are never used to exclude a current seed42 training row, import old
latencies or pool different constructions or intervals into one FPR sample.
The current ranking uses only its current geometry's two-sided95% Wilson upper
endpoint. This screen remains training, not fresh-seed confirmation.

After metadata marked all18 cases complete, both full analysis invocations
passed every source/raw/phase/geometry/quality check. The authoritative narrative
is `report-final/REPORT.md`; all numeric CSV/JSON outputs are byte-identical to
the initial `report/`. The final narrative adds concrete cap24 and same-allocation
results and a read-only public Fastbloom API scope clarification. The pinned
builder supports `.hashes(k)`; these variants were not measured. No ranking or
eligibility changed after that observation. `public-api-note.json` records the
exact consumed upstream source SHA and confirms that no fixed-K workload ran.

The raw screen is sealed by its38-entry `archive-manifest.json`. The result CSV
SHA is `d7afeff4ef9aa8f9a153ff8f5c16e9c2e5320d8d8c1e5ab0501226e1ef6ba8cd`;
the raw manifest SHA is
`57900c5aa1d431ac0166b938092c2380be5788ec8e5b64ab16695db2c2f5605d`.
No measured process was restarted for any analysis or report change.
