# Poppy public byte and iterator semantics

This bounded untimed stage uses all86 exact public constructors from the
[completed geometry proof](../2026-10-29-poppy-public-geometry/GEOMETRY_REPORT.md).
The dependency remains unmodified `hashlookup/poppy@992a13e27e8b09b2a832333a4ba3d160545fa866`.
Real constructor capacity, all four policies, every selected K, power-of-two
and modulo bucket selection, and the separate index cache remain intact.

For each constructor, two independently built filters insert1031 fixed fixture
keys through `insert_bytes(h.to_le_bytes())` and the public
`build_index_iter(&bytes.as_slice())` / `insert_iter` path. Every insertion
return value and every serialized byte must agree, including the cache and
all buckets. All8193 mixed query outputs compare the byte, byte-slice generic,
and reusable prepared-iterator APIs. Every inserted key is checked. Duplicate
insertion and rejected uninitialized iterators must leave every serialized
byte unchanged. Clearing checks empty membership and bucket bits; it does
not claim the index cache is reset to a fresh constructor's bytes.

All17 Space rows also build the same-parameter None filter and compare the
entire serialization, except the documented policy-tag byte. This establishes
the finite None/Space mapping aliases with actual outputs. No quality samples
are taken or pooled. Four policies also test invalid FPP values, zero capacity,
and a full one-key filter rejecting a new key without changing its bytes.

The byte-slice specialization preserves the supplied64-bit value as its first
hash. Generic `u64` insertion hashes it again and is not the prehashed API.
Public bucket xorshift, optional cache lookup and lazy secondary WyHash remain
mandatory. A later performance adapter must include their work and any byte
or iterator preparation in its measured call; this proof grants no private
kernel bypass or precomputed-iterator timing exemption.

The checker retains one full serialization in memory and compares subsequent
public streaming serialization byte for byte; only digests, lengths and
equality records are archived. At most three filter-sized allocations coexist
with the reference payload. Digests label artifacts, not the equality proof.
No upstream serializer/read-back roundtrip is needed by the planned benchmark.

Normal and nightly ASan builds each execute exactly86 rows plus one error
summary. Whole-operation CPU2/3 socket locking, exact committed source checks,
the previous86-row geometry identities, explicit Cargo artifacts, executable
hashes and actual dep-info text are retained. Dependency text is not described
as a resolved full compiler closure. The same pinned lockfile is reused with
only this local package name changed. There are no timers, fresh performance
seeds, calibration runs or new constructor searches in this stage.

Run only after committing the source manifest, under an available socket:

```sh
flock /tmp/fastest-bf-socket0.lock taskset -c 2 python3 \
  experiments/2026-10-29-poppy-public-semantics/validate.py \
  --cpu 2 --source-commit FULL_COMMITTED_REVISION
```
