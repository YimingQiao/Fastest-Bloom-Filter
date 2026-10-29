# Original MAGIC addressing: a source-level correlation mechanism

This is a read-only audit of the pinned DTL source, **a mechanism, not a measured
causal decomposition**. No source, hash, geometry, raw result or ranking was
changed. Nearby-capacity controls remain queued and have not been implemented.

The public artifact uses DTL commit
`c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf`, pinned by reproduction commit
`0d2fe8e72496909cdac73c914e8f1a3dd956ac7f` and the local
[source lock](../benchmarks/vldb-original-external/source-lock.json).
Its [hasher alias](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/hash_family.hpp#L444)
selects multiplication modulo2^32. The first three
[multipliers](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/hash_family.hpp#L22)
are596572387,370248451,2654435769, all odd. Public blocked Bloom
[reserves hash0 for addressing and starts probes at hash1](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/blocked_bloomfilter.hpp#L45).

[MAGIC addressing](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/block_addressing_logic.hpp#L103)
uses `hash0 % block_count` through exact cheap division. If
`block_count = odd_part * 2^t`, fixing a block fixes the low t bits of hash0.
An odd multiplier is invertible modulo2^t, so this also fixes the key's low t
bits and therefore the low t bits of **every** multiplicative probe hash. This
holds for arbitrary raw keys, not only the observed input permutation.

For the measured large sector32 geometry,96MiB/32-byte blocks is3*2^20 blocks.
The [probe extraction recursion](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/blocked_bloomfilter_block_logic_sgew.hpp#L75)
consumes five-bit positions from hash1 at shifts27,22,17,12,7,2, then hash2 at
shifts27,22. Consequently the shifts12/7/2 positions are constant among all keys
in a block; the shift17 position can take at most four values. The eight probes
do not have independent within-block position entropy.

The other measured96MiB MAGIC geometries have the same type of restriction:

| Family | Block count | Fixed low bits | Consequence for six-bit probe positions |
|---|---:|---:|---|
| sector64,64-byte block | 3*2^19 | 19 | hash1 shifts8/2 fixed; hash1 and hash2 shift14 each at most2 values |
| register64,8-byte block | 3*2^22 | 22 | hash1 shifts14/8/2 and hash2 shift14 fixed; shifts20 at most16 values |

[Power-of-two addressing](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/filter/blocked_bloomfilter/block_addressing_logic.hpp#L208)
instead selects the high address bits of hash0, so it does not impose this same
fixed-low-bit restriction. That is not a proof that its remaining hash/probe
correlations vanish.

The completed seed42 raw-u32 screen observed large24bpk MAGIC false-positive
counts173410/229475/170798 out of16777216 negatives for sector32/sector64/register64.
Each sector count reproduces across all18 U/surface/round rows; register
reproduces across6. These remain in the committed
[728-row results](2026-10-29-vldb-raw32-analysis/RESULTS.md), including all quality
failures. The source mechanism does not quantify how much of each observed rate
it explains, establish performance for another geometry, or invalidate the
other unchanged API measurements.

A future explicitly separate control could request a nearby fitting public
constructor size whose accepted cheap divisor contains fewer factors of two.
The upstream [next_cheap_magic](https://github.com/peterboncz/bloomfilter-bsd/blob/c3d854c8c6b2fa7788af19c33fa804f80ac4f6cf/src/dtl/div.hpp#L30)
may round a request upward, so actual backing bytes and the returned divisor
would need explicit validation under the same cap. Selection rules and quality
gates must be fixed before new observations. No private kernel or hash-family
substitution is proposed for the original public PImpl baseline.
