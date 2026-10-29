# Balanced-order caller proof

The pre-data order-only correction passed on the first compiler/runtime attempt: native and ASan callers produced16 tiny rows with exact old output/geometry/FP parity in both orders, plus4 invalid-CLI rejections. All19 commands succeeded as expected;2 executables and402 actual compiler inputs are bound in COMPILED_PROOF.json. No formal workload or repeated kernel matrix ran.

The source commit is7546719bf38b77b4d12ca8d9cc829a09a96e459b. The new normal executable SHA is46c593a4740f161fac09e78e2b745f9b2aba7f2ea34ac6f4d7e06ec0061461cf. The exact prior V1 link failure and V2 successful native/minimal-F/ASan mapping proof remain preserved at a029583a66936b1bf061df4ee8699cb3514117ca.

The actual normal assembly review confirms all8 insertion bodies match the old proof after address normalization, with unchanged instruction counts. The4 clock windows call the actual public insert helper inside their corresponding intervals. See assembly-review/REVIEW.md and its raw excerpts; an exit0 objdump status alone is not used as evidence.

The public helper, algorithm, timer, inputs, flags and build trial columns are unchanged. Only the strict final order flag is new; it runs after the original job shuffle and consumes no RNG. Seed5011 keeps original order, seed6011 reverses it. This balances the two relative filter positions over the fixed two seeds for each geometry/chunk. Pure-before-hash build phase order remains fixed, and these are descriptive training measurements rather than an order-effect or universal performance guarantee.

CPU3/socket1 was used under the inherited whole-operation exclusive lock. It has been released. No formal8 data exists at this proof stage.
