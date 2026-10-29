# Full-load Poppy public accuracy: complete fixed86

Poppy has eligible configurations for a strict24-bits/key,0.01% comparison at
both tested sizes. Six public configurations pass at65,536 keys and four pass
at33,554,432 keys. These counts include public policy aliases; they are not
independent mappings or repeated evidence. This stage measures accuracy only.
It supplies stronger eligible baseline choices for a later shared speed test.

All86 fixed constructors completed once in fresh processes, with no failed
insertion or false negative among the complete inserted sets. Each used the
same seen seed42 dataset as the earlier Rust comparison,2^22 mixed queries,
and2^26 separate calibration negatives. No sample extension, geometry search,
quality pruning or timing loop occurred. Raw data was committed at
`ad45285e4ac4921f737b93ab688fd95dd794371a` before analysis. The executed runner
is `950e79dc1dfb9b8e69b8fa76d70c7fd78aaca63b`; the checked public worker is
`81e9eb412c9b816984dc4d91b1f135daa10943ea`.

## Complete eligibility counts

Each cell counts configurations whose actual bucket-plus-cache allocation is
within the stated ceiling and whose separate two-sided95% Wilson upper bound
is at or below the FPR ceiling. All86 rows remain in `report/quality.json`,
including failed and over-budget controls. There are46 small-table and40
large-table public configurations; source mapping labels reduce them to49
groups, without pooling any denominator.

| Actual bits/key ceiling | FPR ceiling | Eligible at65,536 keys | Eligible at33,554,432 keys |
|---:|---:|---:|---:|
| 12 | 1% | 8 | 4 |
| 12 | 0.1% | 0 | 0 |
| 12 | 0.01% | 0 | 0 |
| 16 | 1% | 16 | 10 |
| 16 | 0.1% | 8 | 4 |
| 16 | 0.01% | 0 | 0 |
| 24 | 1% | 34 | 28 |
| 24 | 0.1% | 24 | 20 |
| 24 | 0.01% | 6 | 4 |
| 32 | 1% | 39 | 31 |
| 32 | 0.1% | 29 | 23 |
| 32 | 0.01% | 11 | 7 |

## Useful strict-quality candidates and retained failures

The ordinary `Best` control requested with FPP0.0001 qualifies at both sizes:
20.5 actual bits/key small and20.173828125 large, including its cache. Their
Wilson upper bounds are0.00852079% and0.00970538%. The large cache occupies
4MiB of the total84,615,168-byte backing. This finite seen-seed result supports
including that public configuration; it does not guarantee the same error
rate on future data or establish a speed advantage.

At the near24-bit allocations, `None`/`Space` with17 probes qualify at both
sizes, as does `Best` with11 probes. Their allocations, public constructor
arguments and separate accuracy bounds are preserved individually. More
probes or a cache may change timing; accuracy alone cannot select the fastest.

The ordinary `None`/`Space` FPP0.0001 control qualifies at the small size
(19.5 bits/key, upper0.00914112%), but fails at the large size
(19.173828125 bits/key, upper0.01102172%). The large ordinary `None`/`Space`
FPP0.01 and0.001 controls also exceed their respective measured1% and0.1%
ceilings. Requested FPP remains a sizing parameter rather than an eligibility
substitute. The33-bit `Speed` control remains over every configured byte cap
even though it has a much lower false-positive rate. None of these rows was
dropped, resized or recalibrated.

## Public contract and evidence limits

The public byte-slice path consumes each common hash as eight little-endian
bytes, retaining Poppy's first-hash semantics and all mandatory bucket/cache
and secondary-hash work. No private insertion or lookup helper is substituted.
The exact normal worker first passed normal/ASan bounded checks against an
independent input oracle and public prepared-iterator results. The full run
held the socket0 lease on CPU2 from09:15:41 to09:22:24 UTC on2026-10-29; that
elapsed duration is operational metadata, not a throughput measurement.

All17 previously proved same-parameter None/Space pairs reproduce full-load
counts and checksums. All49 source-labelled mapping groups also have matching
observed counts and checksums where repeated. Those observations do not claim
complete full-load bitmap equality. No policy, batch or alias adds independent
negative samples, and the intervals are pointwise rather than simultaneous
guarantees across the grid.

The analysis retains86 quality records,24 nested cap/FPR views and1032
allocation alternatives. It verifies every raw log against its committed
archive, command, constructor and aggregate record. Three synthetic checks
cover Wilson boundaries, byte-budget eligibility and retaining every failed
configuration. The initial exact-zero boundary assertion encountered3.47e-18
floating rounding and was corrected to a1e-14 assertion tolerance; the Wilson
formula and all benchmark records were unchanged.

The next comparison must include these eligible public configurations in a
shared timed caller with the existing native and external controls. This
report establishes no latency, build-speed or multithread superiority.
