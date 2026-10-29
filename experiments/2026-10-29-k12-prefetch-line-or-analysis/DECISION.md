# Keep the conditional line-OR implementation experimental

Do not integrate this exact `SizeInBytes() > 2 MiB` candidate into the native K12 default. The fixed confirmation establishes a useful96MiB construction improvement, but the unchanged dispatch also activates a measured3MiB regime where whole-input insertion loses in all three seeds. No new threshold or API is proposed from these results, and no production file is changed.

The complete72-row C++ screen measures n=65,536/1,048,576/4,194,304/33,554,432 at actual24bpk (192KiB/3MiB/12MiB/96MiB), chunks4/whole input, three fixed seeds, seven construction repetitions, and CPU2/NUMA0. Queries are correctness controls only. All raw outputs and all288 construction comparisons remain archived. Against original K12, the candidate has64 faster and32 slower observations; the allocation-inclusive subset has34 faster and14 slower. These are repeated metric/seed/cell views, not independent trials or a pooled superiority statistic.

| Bitmap | Allocation+pure build, chunks4 | Allocation+hash+build, chunks4 | Allocation+pure build, whole input | Allocation+hash+build, whole input |
|---|---|---|---|---|
|192KiB|19.2% lower to22.8% higher|7.5% lower to10.6% higher|16.7% lower to26.0% higher|17.6% lower to25.4% higher|
|3MiB|21.1% lower to0.7% higher|12.2–24.5% lower|2.3% lower to27.7% higher|6.7% lower to14.0% higher|
|12MiB|6.0–29.2% lower|14.3–27.9% lower|17.0% lower to19.2% higher|9.7% lower to13.5% higher|
|96MiB|18.1–20.2% lower|22.3–23.7% lower|15.8–16.5% lower|14.6–14.8% lower|

These are the full three-seed descriptive ranges for each fixed cell. They do not isolate allocation, filter position, input seed or code placement. The192KiB false kernel retains the original word-OR instructions, yet its actual caller measurements vary; that evidence prevents treating every small observed loss as a new algorithmic cost. It also prevents claiming that restoring the old source alone guaranteed unchanged whole-program performance.

The3MiB whole-input insertion subinterval supplies a clearer limitation: prehashed insertion is1.96–8.64% slower in all three seeds, and common-hash insertion is1.53–6.13% slower in all three. Whole construction is mixed and reaches27.67% slower for prehashed allocation+build. At12MiB, chunks4 improve across all twelve metric/seed observations, while whole-input results retain six losses out of twelve. At96MiB, all24 metric/seed observations improve, including every allocation-inclusive outcome. This large-table result is useful evidence for this particular workload, not support for the full existing2MiB dispatch interval.

Every per-construction pointwise95% Wilson upper endpoint passes the strict0.01% target: all12 API/size all-three-seed gates pass, with worst bound0.009794374%. The36 API records reduce to24 proven mapping records; repeated chunks and K12 aliases reuse their denominator. Quality does not account for the speed differences. Native Range is faster in all96 candidate/Range construction comparisons at equal actual bytes, including all48 allocation-inclusive comparisons. This is an internal construction comparison; it says nothing new about K12's separately established query niche or external leadership.

The previous unconditional192KiB whole-input regressions remain in their original archive. This stage did not import those latencies, tune the threshold, select seeds by quality, extend a workload, or measure query leadership. The Latin schedule balances absolute positions across the three seeds but not all six predecessor directions; pure-before-common build phase order remains fixed. Allocation-inclusive and insertion intervals are nested, and multiple contrasts share the same controls. Preserve the exact candidate and negative findings as an experiment; keep the existing native insertion implementation while other validated K12/native improvements are integrated independently.

Evidence: source`957b17ad279c23b2292b59808cad9ebe09e839a8`, raw`981c76903771d0eca1780b916d1aedbfcee0fc73`, analysis-source`abd1cc9f749868939d4e2123c6bacf3eead58137`. The complete machine-readable results are in`report/all-records.json`, all individual losses in`report/REPORT.md`, and original seven-value samples in`report/vectors.csv`.
