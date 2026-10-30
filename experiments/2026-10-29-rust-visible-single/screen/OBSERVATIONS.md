# Initial findings

All four workloads and 28 rows passed. Every original family/size output checksum and calibration count also matches the prior SBBF14 screen; timing comparisons here use only this same-process CPU2 matrix. No native library changed.

Removing per-key wrapper boundaries and making the actual public API visible improves all 56 within-family query ratios in this initial screen. This is a change in caller/query contract, not a production optimization result. At 65,536 keys and actual 16 bpk, ByteSplit changes from 3.475 to 1.529 ns prehashed and 5.509 to 2.266 ns with hashing. Bloomsday also changes from 3.242 to 1.476 ns and 5.334 to 2.143 ns, so native ByteSplit still loses both strongest public-path comparisons. The original-path losses remain in the first two tables.

The large loose-FPR result is mixed: ByteSplit's visible prehashed 6.305 ns is near Bloomsday 6.405 ns, but its visible fused raw 7.421 ns loses to Bloomsday 6.948 ns. This small pure-query gap is training data and has no uncertainty or held-out claim.

The strict 32 bpk/0.01% gap remains larger: small native Split64 visible 2.379/3.098 ns (pure/raw) versus Bloomsday 1.519/2.147 ns; large native Split64 10.369/12.723 ns versus Bloomsday 8.416/10.436 ns. Split/Four visible public calls use scalar-source kernels, so their difference from original SIMD batch queries cannot be attributed only to wrapper overhead.

Pre-data assembly showed ByteSplit still calls the public singleton method per key and Split/Four still call scalar helpers. Stronger leaf-inlining annotations are now a testable follow-up, but no performance conclusion about those hypothetical annotations follows from this screen. SBBF's public dynamic dispatch remains intact. The exact-budget external grid and arbitrary-capacity native experiment address a different possible disadvantage and should remain separate.

The report preserves 48 cap/FPR/contract rankings, 384 individual native comparisons, 56 API ratios and 28 family/size quality records. Caps and FPR tiers reuse samples; quality records share input streams across families and all four query modes. There is no global fastest claim, no production promotion, and no held-out performance evidence.
