# Rust K12 safe SingleLine: complete internal screen

All24 fixed commands completed, retaining72 rows and all eight metric boundaries. This compares one safe scalar-body change with original K12 and unchanged Split64Range, at equal actual24 bits/key. The three seeds were already observed in Rust108; this is an internal regression screen, not fresh validation against external libraries.

Source `1251089437125d9c6c08188ee4cf23c764b94098`, committed complete raw `49298ee5386d4fc639cf8cbc773bcdc8e4bec2d1`, executable SHA `64ecc64b307f32dc5ff215720c608d9423abdc55d54536034ecbebe0334f91a3`. Raw52 files plus manifest were committed before numerical interpretation. Each three-filter workload executes in one process on CPU3 under the whole socket1 flock; no NUMA memory-placement policy was set.

## Complete ratios

Ratio is rival latency divided by the named denominator's latency; greater than1 favors the denominator. Each table cell retains the minimum–maximum ratio across all three seeds and win/loss counts. All576 named pairs,192 three-seed groups,384 pair-order strata and144 staged/visible API ratios are archived. Query pairs retain all eight samples per trial vector and measured minima/maxima. Build measurements retain medians only; no build-trial vectors or confidence intervals are invented.

| Rival / denominator | Query win/loss/tie (96) | Build win/loss/tie (96) |
|---|---:|---:|
| Original K12 / SingleLine K12 | 85/11/0 | 49/47/0 |
| Split64Range / SingleLine K12 | 21/75/0 | 0/96/0 |
| Split64Range / original K12 | 19/77/0 | 0/96/0 |

### Original K12 / SingleLine: query contracts

| Keys / batch | Staged prehashed | Staged common-hash+query | Visible prehashed | Visible fused common hash |
|---|---|---|---|---|
| 64K / 1 | 1.32232–1.32595 (3/0) | 1.18120–1.18360 (3/0) | 1.43878–1.45231 (3/0) | 1.31825–1.32639 (3/0) |
| 64K / 3 | 1.44687–1.44713 (3/0) | 1.30775–1.31006 (3/0) | 1.43648–1.45614 (3/0) | 1.31516–1.31816 (3/0) |
| 64K / 31 | 0.99387–0.99736 (0/3) | 0.99184–0.99446 (0/3) | 1.42355–1.45778 (3/0) | 1.31105–1.32644 (3/0) |
| 64K / 4096 | 0.99727–1.00834 (1/2) | 0.99240–1.01042 (2/1) | 1.43659–1.43960 (3/0) | 1.31559–1.33123 (3/0) |
| 32M / 1 | 1.09393–1.09968 (3/0) | 1.07707–1.10849 (3/0) | 1.27435–1.27632 (3/0) | 1.18996–1.19809 (3/0) |
| 32M / 3 | 1.22591–1.22872 (3/0) | 1.16187–1.16656 (3/0) | 1.27348–1.27528 (3/0) | 1.18682–1.19575 (3/0) |
| 32M / 31 | 1.00126–1.00416 (3/0) | 1.00572–1.01220 (3/0) | 1.27244–1.27744 (3/0) | 1.19140–1.19352 (3/0) |
| 32M / 4096 | 0.99845–1.00556 (2/1) | 0.99708–1.00245 (2/1) | 1.27795–1.28336 (3/0) | 1.19197–1.20674 (3/0) |

### Split64Range / SingleLine: query contracts

| Keys / batch | Staged prehashed | Staged common-hash+query | Visible prehashed | Visible fused common hash |
|---|---|---|---|---|
| 64K / 1 | 0.56429–0.56590 (0/3) | 0.60575–0.60659 (0/3) | 0.57129–0.57672 (0/3) | 0.46570–0.46597 (0/3) |
| 64K / 3 | 0.46438–0.46617 (0/3) | 0.55024–0.55178 (0/3) | 0.57089–0.57908 (0/3) | 0.46564–0.46677 (0/3) |
| 64K / 31 | 1.13902–1.15008 (3/0) | 1.03038–1.03376 (3/0) | 0.56577–0.57929 (0/3) | 0.46567–0.46627 (0/3) |
| 64K / 4096 | 1.39594–1.40334 (3/0) | 1.27653–1.29960 (3/0) | 0.56892–0.57256 (0/3) | 0.46527–0.46536 (0/3) |
| 32M / 1 | 0.57355–0.57998 (0/3) | 0.68551–0.70740 (0/3) | 0.45349–0.45618 (0/3) | 0.51023–0.51407 (0/3) |
| 32M / 3 | 0.43123–0.43461 (0/3) | 0.51977–0.52073 (0/3) | 0.45331–0.45726 (0/3) | 0.50952–0.51415 (0/3) |
| 32M / 31 | 1.03260–1.04934 (3/0) | 1.02608–1.04274 (3/0) | 0.45890–0.46053 (0/3) | 0.51236–0.51817 (0/3) |
| 32M / 4096 | 0.98519–0.99339 (0/3) | 1.00139–1.01946 (3/0) | 0.45310–0.46182 (0/3) | 0.51592–0.52047 (0/3) |

The visible whole-array query loops do not change contract with the batch tag. Repeated batch tags are retained observations, not extra independent quality samples.

### Original K12 / SingleLine: construction

| Keys / batch | Insert | Allocate+insert | Hash+insert | Allocate+hash+insert |
|---|---|---|---|---|
| 64K / 1 | 0.99516–1.00951 (2/1) | 0.87976–1.10178 (1/2) | 0.99074–1.00885 (1/2) | 0.77374–1.02081 (1/2) |
| 64K / 3 | 0.99983–1.00202 (2/1) | 0.87209–1.12988 (1/2) | 0.98467–1.01305 (2/1) | 0.79584–1.01517 (2/1) |
| 64K / 31 | 0.98550–1.00376 (1/2) | 0.86393–1.12145 (1/2) | 0.97818–1.01630 (1/2) | 0.79812–1.03108 (1/2) |
| 64K / 4096 | 0.98927–1.00534 (1/2) | 0.88864–1.15840 (1/2) | 0.98409–1.00489 (1/2) | 0.78633–1.00839 (1/2) |
| 32M / 1 | 0.99727–1.00331 (1/2) | 0.99757–1.00322 (2/1) | 0.99979–1.00216 (2/1) | 1.00042–1.00208 (3/0) |
| 32M / 3 | 0.99811–1.00029 (1/2) | 0.99784–1.00028 (1/2) | 0.99669–0.99847 (0/3) | 0.99708–0.99842 (0/3) |
| 32M / 31 | 0.99993–1.00145 (2/1) | 0.99997–1.00095 (2/1) | 1.00012–1.00184 (3/0) | 0.99987–1.00333 (2/1) |
| 32M / 4096 | 1.00033–1.00215 (3/0) | 1.00072–1.00142 (3/0) | 0.99952–1.00179 (2/1) | 0.99866–1.00168 (2/1) |

### Split64Range / SingleLine: construction

| Keys / batch | Insert | Allocate+insert | Hash+insert | Allocate+hash+insert |
|---|---|---|---|---|
| 64K / 1 | 0.50049–0.51054 (0/3) | 0.40940–0.79125 (0/3) | 0.54556–0.56845 (0/3) | 0.43107–0.85387 (0/3) |
| 64K / 3 | 0.50620–0.51262 (0/3) | 0.40292–0.79302 (0/3) | 0.53157–0.57905 (0/3) | 0.43093–0.85107 (0/3) |
| 64K / 31 | 0.50160–0.51174 (0/3) | 0.40065–0.79662 (0/3) | 0.53183–0.57599 (0/3) | 0.43374–0.85430 (0/3) |
| 64K / 4096 | 0.50377–0.51032 (0/3) | 0.41272–0.78639 (0/3) | 0.54652–0.57002 (0/3) | 0.44135–0.84744 (0/3) |
| 32M / 1 | 0.84057–0.84667 (0/3) | 0.84853–0.85512 (0/3) | 0.86300–0.86734 (0/3) | 0.86890–0.87400 (0/3) |
| 32M / 3 | 0.83776–0.84092 (0/3) | 0.84611–0.84864 (0/3) | 0.86076–0.86339 (0/3) | 0.86681–0.87074 (0/3) |
| 32M / 31 | 0.84382–0.84500 (0/3) | 0.85176–0.85286 (0/3) | 0.86659–0.86695 (0/3) | 0.87288–0.87299 (0/3) |
| 32M / 4096 | 0.84029–0.84620 (0/3) | 0.84886–0.85451 (0/3) | 0.86149–0.86845 (0/3) | 0.86686–0.87416 (0/3) |

Insertion bodies and allocation policies are unchanged. Measured construction differences can reflect code layout, row order and allocator placement; this comparison does not isolate a new insertion algorithm. The original fixed ordering of build boundaries is preserved.

## Exact source and code-generation evidence

The only production-body delta in the isolated native crate borrows `self.lines[indices[0] >> 4]` once and accesses its four words through `index & 15`. Every probe differs only in the low four word-index bits; an independent u128 boundary test checks the physical-line invariant, including non-power-of-two and maximum capacities without huge allocations. Original public/private ordinary `#[inline]` hints remain unchanged. There is no new unsafe block, mask/address/dispatch change, or insertion/parallel change. The rejected two-hint implementation is not linked.

Actual candidate visible callers have one global line bound check and no successful-path scalar-helper calls. Original visible callers retain one helper call per key. Candidate callers still save six registers, with72/104-byte pure/fused frames versus72/72 for the original. Captured symbol spans are448/496 versus192/224 bytes; public batch lookup expands from6336 to7088 bytes. These spans include padding, and call removal does not establish a speed gain by itself. See [the exact passed proof](../2026-10-29-rust-k12-single-line/proof/REPORT.md).

## Quality and scope

Normal and ASan full-bitmap/output fixtures passed. Each formal row reproduces the original construction's complete mixed-query count/checksum. Calibration is0 throughout this screen. Twelve historical independent size/seed/family records remain unpooled context; SingleLine aliases original K12 and supplies no new FPR estimate. Their old Wilson upper endpoints remain below0.01%.

The candidate is first/middle/last at each size, and every pair occurs in both directions, with2:1 pair counts rather than perfect balance. All per-seed and order-stratified losses remain. There is no external library in this screen, no fresh-seed leadership claim and no production promotion implied by these tables. The previous original Rust108 and rejected two-hint losses remain separately archived.
