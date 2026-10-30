# What the fixed195 comparison establishes

The optional native K12 layout provides a useful eight-core query result at the strict 0.01% false-positive ceiling and a 24-bit/key allocation ceiling. It wins all 24 comparisons in that slice: two sizes, four query metrics and three already-seen construction seeds. This is a result for the frozen external shortlist, batch4096 and these caller contracts. It does not make K12 the preferred layout for every query or construction workload.

All ratios here are **candidate latency / rival latency**; below1 is faster. The complete 195-row raw archive is commit `7c526683db0ad367ac99bbeeeba252a11a27b64e`. The analysis follows the rules fixed before measurement at producer commit `a46a7afd49094fb1c6748191d1fc448a8cd1f2fb`. The full tables retain every loss and quality failure.

## Strict quality at 24 bits/key

For 65,536 keys, K12 uses196,608 bytes and beats the fastest eligible external, FastFilterFixed64 at the same allocation. The three hash-plus-query latency ratios are0.64291–0.65079 for the gated interval and0.68730–0.69617 end to end. Prehashed-query ratios are0.54896–0.56308 gated and0.61782–0.62405 end to end.

For33,554,432 keys, K12 uses100,663,296 bytes. The strongest eligible external is Boost192Multi64K8 at100,663,295 bytes; that actual one-byte difference remains charged. Hash-plus-query ratios are0.89909–0.93170 gated and0.90566–0.93382 end to end. Prehashed-query ratios are0.86731–0.88857 gated and0.87712–0.89373 end to end. Against the optional Split64Range layout at the same24-bit/key allocation, K12's large hash-plus-query ratios are0.95752–0.97299 gated and0.96177–0.97494 end to end. The latter gains are only about2.5–4.2% lower observed latency; there is no timing-confidence or significance claim.

Each quality estimate has67,108,864 held-out negative queries for its own construction. Held-out refers to a separate key range from inserted and timed mixed-query keys; APIs and mappings sharing a seed/input do not provide independent quality samples. The K12@24 counts are:

| Keys | Seed | False positives | Wilson95 upper, percent |
|---:|---:|---:|---:|
| 65,536 | 5357122369631638320 | 5849 | 0.00894192% |
| 65,536 | 10870879273875959492 | 5749 | 0.00879099% |
| 65,536 | 2465277812845611592 | 6080 | 0.00929051% |
| 33,554,432 | 5357122369631638320 | 6204 | 0.00947759% |
| 33,554,432 | 10870879273875959492 | 6019 | 0.00919846% |
| 33,554,432 | 2465277812845611592 | 6235 | 0.00952436% |

All six pass the pointwise0.01% gate, with limited margin. These are seen construction seeds, not a fresh quality confirmation. K12@16 fails the0.1% gate in all six constructions: upper endpoints0.12825076–0.13135603%. Its timings remain in the archive and in unconditional public-API comparisons, but cannot become qualified0.1% wins.

## The wider query comparison retains important losses

Across the216 nested-cap/metric/seed views, production-native leaders have162 wins and6 losses against eligible external leaders, with48 no-comparable views. All six losses occur for the large strict0.01% cap32 hash-plus-query views: FastPatternBF@32 loses to Boost192Multi64K8@24 with latency ratios1.00769–1.03904. Admitting a smaller external allocation under the32-bit/key cap is intentional. At cap24 strict quality, no production-native configuration in this panel qualifies; that absence is not an external win or a native win.

K12 has93 wins and75 losses against external leaders, with48 no-comparable views. Against production-native leaders it has15 wins and129 losses, with72 no-comparable views. Thus the strict24 niche is not a general query replacement. Split64Range has84 wins and108 losses against external leaders, with24 unavailable comparisons. The explicitly composite set of production plus optional layouts has192 wins, no losses and24 no-comparable views. That composite result must not be relabeled as production-only, one-layout leadership, or coverage of all external libraries.

The current-construction and all-three-constructions qualification policies happen to give the same counts here. The all-three policy admits an exact API/allocation only if every individual Wilson endpoint passes. It then allows each seed's fastest eligible configuration within an ownership group; it does not manufacture one fixed leader or pool the seeds. Nested caps and four metrics repeat observations and are not independent samples. All588 common-executor T8/same-row-serial query ratios are below1, but this is a separate scaling observation from external leadership.

## Actual public APIs: query benefit, construction cost

The48 public native rows call the real T1/T8 APIs on whole arrays. At equal allocated bytes, K12 beats Split64Range in all36 query comparisons (18 at each thread count), while losing all72 insertion or allocation-plus-insertion comparisons. Query latency ratios are0.7193–0.9498 at T1 and0.7190–0.9710 at T8. K12's insertion ratios against Range are1.2786–2.0630 at T1 and1.0334–1.7514 at T8; allocation-plus-insertion also loses at every point. These are unconditional comparisons with both quality endpoints beside each row.

Against power-of-two Split64, K12 wins11/12 T1 query comparisons and10/12 T8 query comparisons. It loses all24 T1 build comparisons and22/24 T8 build comparisons across insertion and allocation-plus-insertion. These residual query losses and construction losses remain visible rather than being discarded after finding the strict24 query result.

At the small65,536-key size, using T8 for construction is slower than T1 for all24 API/geometry/seed points, for both construction metrics. K12 insertion T8/T1 is2.5157–4.4405; Range is4.7343–5.2199; Split64 is5.2170–8.9917. At the large size, all24 points improve for both construction metrics. K12 insertion T8/T1 is0.2935–0.3266 and allocation-plus-insertion is0.3398–0.3535. Public query improves at all48 points; K12 T8/T1 is0.1422–0.1738 small and0.1326–0.1426 large. These observations support choosing thread count by workload; no new automatic worker policy is evaluated here.

The shared query executor creates fresh threads on every call, with gated and launch/join-inclusive timing reported separately. The public APIs have their own partitioning and scheduling. Their medians are not substituted for each other. Range and K12 retain an extra serial bitmap copy for full-byte validation during public timing; Split64 does not expose that copy. This auxiliary working-set difference is disclosed separately from the actual filter allocation cap. Within each family, T1 and T8 retain the same validation buffers. Complete outputs and all inserted keys are checked outside timers; public quality is reused only after the prescribed semantic agreement with the calibrated shared-query row. The public track contributes no additional quality denominator.

The useful outcome is an optional K12 query choice at strict24, alongside retained production and Range alternatives. The data does not justify a universal fastest claim, a default-layout change, or a new insertion kernel. Strong public external aliases, actual allocations, all per-seed losses and both caller contexts remain part of that conclusion.
