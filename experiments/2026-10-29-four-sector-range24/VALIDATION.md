# Six-backend correctness result

The candidate passes native AVX-512, AVX2 and scalar builds, each with and
without ASan/UBSan. All six complete oracle digests are identical and all
runtime stderr files are empty. This is correctness evidence only: no FPR
calibration or throughput result has been produced.

The independent128-bit address/bit-enumeration oracle checks full bitmaps,
all inserted keys, tails0..131 at eight offsets, long4096/4097/4127 calls,
empty input, output guards, essential-bit deletion and invalid capacities.
Ten line counts include arbitrary3/5/12/127/1001/3072 and the32768/32769
boundary on either side of the2MiB prefetch cutoff. Query calls leave the
complete bitmap unchanged. Native, AVX2 and scalar address paths agree.

The pre-execution peer review checked disjoint24/8/32-bit fields, vector
product/packing bounds, sector isolation and oracle independence. Its
threshold/immutability coverage suggestions were included before compilation.

[Metadata](validation-v1/metadata.json) records source commit
`28d8af7758d1371a2093624de23e04f482ed84af`, all14 commands, six binary hashes,
actual compiler header dependencies and the inherited CPU3/socket1 write lock.
Normal builds use Clang23-O3; sanitizer builds use-O1 with recovery disabled.
The raw archive excludes executables, which remain locally retained and hashed.

The next fixed accuracy stage must retain all six proposed size/capacity
outcomes. Finite24-bit address resolution and the unchanged correlated mask
codes still require empirical quality measurement; passing correctness does
not establish that24 bpk reaches the0.01% target.
