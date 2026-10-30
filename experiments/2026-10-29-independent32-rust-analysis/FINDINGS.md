# Initial findings

Independent32 is promising for the visible public singleton API at the strict
32-bpk quality tier. This is one seed42 training screen on CPU3, with three
frozen Rust external families. It is not held-out confirmation or a claim over
the wider C++/Rust baseline collection.

At a 0.01% FPR ceiling and 32-bpk cap, the batch1-tag public singleton results
are:

| Keys | Contract | Independent32 ns/key | Best external ns/key | External / Independent32 |
| ---: | --- | ---: | ---: | ---: |
| 65,536 | Prehashed visible | 1.313 | Bloomsday 1.524 | 1.160 |
| 65,536 | Fused common hash visible | 1.756 | Bloomsday 2.149 | 1.224 |
| 33,554,432 | Prehashed visible | 7.352 | Bloomsday 8.439 | 1.148 |
| 33,554,432 | Fused common hash visible | 9.825 | Bloomsday 10.463 | 1.065 |

All of those selected allocations are exactly 32 bpk. The Independent32
calibration Wilson upper bounds are 0.003986% and 0.003899%, below the 0.01%
ceiling. At 16 bpk the bounds are 0.1299% and 0.1327%; those configurations fail
the 0.1% tier. No extra negatives are obtained by reusing calibration under
another batch or API mode. ByteLeaf does not qualify for this strict tier.

The generic batch1 path loses to the strongest external in all eight eligible
resource/quality views, in both contracts: external/Independent32 is
0.834–0.903 prehashed and 0.959–0.990 with staged hashing. These losses are
separate from the visible API wins. At strict 32 bpk, the generic prehashed
small/large results are 3.888/15.971 ns versus Bloomsday 3.252/14.426 ns.

Generic batches31/4096 beat the strongest external in every eligible view in
this screen, but several existing native bulk paths remain better. For example,
at strict 32 bpk and batch4096, small-table prehashed FourSector is 1.156 ns
versus Independent32 1.312 ns; large-table prehashed FastPattern is 6.129 ns
versus 7.330 ns. With staged hashing those native winners are 1.707 versus
1.925 ns and 6.090 versus 6.817 ns. This does not support replacing existing
bulk implementations with Independent32.

ByteLeaf wins most of the shared-quality loose views. The report therefore
keeps Independent32, ByteLeaf, the best original native, the best experimental
native and the best external selections separately. The 144 nested ranking
views are descriptive, not independent experiments. All 2,304 native
allocation comparisons, 144 retained leaf pairs, 264 generic/visible ratios
and 32 family/size/seed calibration records are retained in `report/`.

The matrix completed all 12 workloads / 132 rows in about 1,019 seconds,
including the prescribed repeated builds, validation and calibration outside
query timing. Every full output, no-false-negative, phase/trial, exact
retained-control, source/dependency and executable check passed. Production
sources remain unchanged. The next evidence needed before a claim is a
prespecified fresh-seed confirmation of the relevant public API contract;
generic batch1 and native bulk losses must remain visible.
