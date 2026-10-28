# Modern external confirmation — 2026-10-28

The frozen large-batch stage confirms a query lead for our candidates in every
scenario with eligible configurations in the measured suites. This is a bounded
result, not a claim of an unrestricted fastest Bloom filter. Single-key, short
batches, hit-rate extremes and new-layout parallel scaling are separate work.

The C++ matrix has **234 rows: 13 candidates × 18 cases**. The Rust matrix has
**90 rows: five candidates × the same 18 cases**. Candidate selection preceded
these measurements; insertion seeds 307, 509 and 1021 were held out. All inserted
keys are validated, and cross-language candidate bitmap/checksum parity is checked
separately. See the [frozen protocol](confirmation-protocol-2026-10-28.md).

Host: Xeon Platinum 8474C, one thread pinned to CPU 2; Clang 23 and Rust 1.92,
native instructions. The suites ran serially. Each seed has 2^22 timed queries,
50% hits, batch 4096, whole-input build calls and five timing repetitions. Rows
report the median of seed medians, not the best repetition. Allocation spans
128 KiB–128 MiB; the latter exceeds one socket's 97.5 MiB LLC, but repeated query
access is not guaranteed cold. Hardware/compiler/API details limit generalization.

Eligibility uses an explicit resident-allocation ceiling, zero byte slack, and
a pointwise one-sided 95% Wilson upper FPR bound. Each configuration pools three
disjoint 2^24-negative calibration streams (50,331,648 samples), after timing.
These are separate insertion seeds, not repeated counts of the timed queries.
Different configurations can use different bytes within a ceiling; exact bytes
and confidence bounds remain in the rankings. At the 16 bits/key ceiling no tested
configuration qualifies for 0.01% FPR, so that target is shown at 32 bits/key.
Pointwise bounds are not simultaneous confidence guarantees for every selected rank.

![C++ query speedup against the fastest eligible external baseline](figures/modern-confirmation.svg)

## C++ large-batch queries

Each row chooses the lowest median hash+query time among eligible configurations.
The external reference is the fastest eligible external configuration in this suite.

| Keys | Memory ceiling, bits/key | FPR ceiling | Our candidate | ns/key | External reference | ns/key | Speedup |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 | 1.00% | FastPatternBF | 1.119 | FastFilterFixed16 | 1.572 | 1.40× |
| 16,777,216 | 16 | 1.00% | FastPatternBF | 3.709 | FastFilterSimdBlock | 4.096 | 1.10× |
| 33,554,432 | 16 | 1.00% | FastPatternBF | 4.071 | FastFilterFixed32Bulk | 4.816 | 1.18× |
| 65,536 | 16 | 0.10% | FourSector16K8 | 1.510 | FastFilterFixed64 | 2.614 | 1.73× |
| 16,777,216 | 16 | 0.10% | Split64P32 | 3.789 | Boost192Multi64K8 | 4.433 | 1.17× |
| 33,554,432 | 16 | 0.10% | FourSector16K8 | 4.143 | Boost192Multi64K8 | 5.351 | 1.29× |
| 65,536 | 32 | 0.01% | FastPattern64Experiment | 1.168 | FastFilterSimdBlock | 1.710 | 1.46× |
| 16,777,216 | 32 | 0.01% | FastPatternBF | 4.110 | FastFilterFixed32 | 4.855 | 1.18× |
| 33,554,432 | 32 | 0.01% | FastPatternBF | 5.657 | Boost192Multi32K8 | 6.269 | 1.11× |

Rust has two external families; C++ has the broader baseline set. A large Rust-only
ratio can result from fastbloom being the only eligible external family at 16 bits/key
and 0.1% FPR. It does not mean that Rust beats the fastest C++ baseline by that ratio.

## Rust large-batch queries

Each row chooses the lowest median hash+query time among eligible configurations.
The external reference is the fastest eligible external configuration in this suite.

| Keys | Memory ceiling, bits/key | FPR ceiling | Our candidate | ns/key | External reference | ns/key | Speedup |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 65,536 | 16 | 1.00% | FastPatternBF | 1.099 | BloomsdayPinned | 1.922 | 1.75× |
| 16,777,216 | 16 | 1.00% | FastPatternBF | 3.698 | BloomsdayPinned | 4.077 | 1.10× |
| 33,554,432 | 16 | 1.00% | FastPatternBF | 4.123 | BloomsdayPinned | 4.929 | 1.20× |
| 65,536 | 16 | 0.10% | FourSector16K8Experimental | 1.527 | Fastbloom017 | 14.732 | 9.65× |
| 16,777,216 | 16 | 0.10% | FourSector16K8Experimental | 3.759 | Fastbloom017 | 35.312 | 9.40× |
| 33,554,432 | 16 | 0.10% | FourSector16K8Experimental | 4.153 | Fastbloom017 | 36.865 | 8.88× |
| 65,536 | 32 | 0.01% | FastPatternBF | 1.160 | BloomsdayPinned | 1.961 | 1.69× |
| 16,777,216 | 32 | 0.01% | FastPatternBF | 4.032 | BloomsdayPinned | 4.680 | 1.16× |
| 33,554,432 | 32 | 0.01% | FastPatternBF | 5.672 | BloomsdayPinned | 7.180 | 1.27× |

## Construction remains a separate tradeoff

The following are median **hash+insert ns/key**, using the same actual 16 bits/key
allocation ceiling and the four configurations eligible for 0.1% FPR. They include
hashing and insertion, and exclude bitmap allocation/zeroing; the CSV also retains
allocate+hash+insert. FourSector's query advantage does not make it the fastest
builder. Split64 and the external filters remain useful construction comparators.

| Keys | Candidate | Hash+insert ns/key |
| --- | --- | --- |
| 65,536 | FourSector16K8 | 3.689 |
| 65,536 | Split64P32 | 2.035 |
| 65,536 | Boost192Multi64K8 | 2.368 |
| 65,536 | FastFilterFixed64 | 2.349 |
| 16,777,216 | FourSector16K8 | 5.782 |
| 16,777,216 | Split64P32 | 5.165 |
| 16,777,216 | Boost192Multi64K8 | 5.413 |
| 16,777,216 | FastFilterFixed64 | 7.060 |
| 33,554,432 | FourSector16K8 | 6.113 |
| 33,554,432 | Split64P32 | 5.379 |
| 33,554,432 | Boost192Multi64K8 | 5.699 |
| 33,554,432 | FastFilterFixed64 | 7.626 |

The complete screen included 42 external C++ configurations. This confirmation
uses its shortlist, not every implementation ever published. The wider dictionary
is still experimental; production FourSector/Split64 integration and subsequent
optimizations require their own correctness and timing checks. The optional
PageBloom AES screen is retained separately and is not mixed into these medians.

[C++ raw data and provenance](../results/2026-10-28-modern-confirmation-cpp/),
[Rust raw data and provenance](../results/2026-10-28-modern-confirmation-rust/),
[C++ 16-bit ranking](../results/2026-10-28-modern-confirmation-cpp/ranking-16.csv),
[C++ 32-bit ranking](../results/2026-10-28-modern-confirmation-cpp/ranking-32.csv),
[baseline source/API contracts](../benchmarks/all-external/README.md).
