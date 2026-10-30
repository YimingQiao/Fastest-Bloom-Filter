# Public query code generation

The archive contains22 typed `visible_lookup` symbols and22 distinct bodies,
two public modes for each of eleven filter configurations. It was generated
from the exact release executable pinned in `inventory.json`; no query timing
was collected for this audit. The inventory's call list includes cold panic
paths, so call presence alone does not establish a hot per-key call.

Independent32's prehashed and fused modes begin at0x1fe50 and0x202b0. Their
immutable runtime backend flags are tested before the key loops. Both VBMI
paths contain `vpmultishiftqb`, `vpmovzxbd`, `vprolvd`, a32-byte bucket load and
`vptest` directly in the loop. The AVX2 fallback also has its mask and test
inline. Only the portable scalar fallback calls `contains_scalar` per key.
The public `contains_hash` hint was fixed in the separately validated native
crate before this executable or any performance data existed.

The original Byte public call and original FourSector/Split64 scalar calls
remain per key. The three leaf controls remove their intended hot calls, while
Byte's scalar fallback remains out of line. Leaf Split64 still uses
`vpmullq`/qword shifts, as in the earlier leaf experiment. FastPattern,
Fastbloom and Bloomsday have their public membership bodies inline; their
remaining listed indirect calls are cold bounds/panic paths. SBBF's retained
upstream virtual interface calls the selected backend once per key in both
modes. No local private-kernel shortcut changes any of these contracts.

These observations describe the emitted program and do not predict a speedup.
