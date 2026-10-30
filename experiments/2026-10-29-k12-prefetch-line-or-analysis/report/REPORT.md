# Conditional K12 construction: complete fixed72

The fixed C++ screen uses n16/20/22/25 (192 KiB/3 MiB/12 MiB/96 MiB at actual24 bpk), insertion chunks4/whole input, and seeds15485863/32452843/49979687. Each of24 processes runs old K12, conditional K12 and native Range with seven fresh construction repetitions. CPU2/NUMA0 and the exact checked binary remain fixed. Query q18/hit50/b4096 is semantic control only.

**Ratios are numerator latency / denominator latency; below1 is faster.** Allocation-plus-build is the primary contract and contains its insertion subinterval. Three-seed ranges are descriptive, not confidence intervals. All288 comparisons and288 seven-value vectors remain in the CSVs. No previous latency is imported.

## Conditional / original K12, every fixed cell

| Keys | Chunk | Metric | Minimum ratio | Maximum ratio | Three seed outcomes |
|---:|---:|---|---:|---:|---|
| 65536 | 4 | allocate_hash_insert_ns | 0.924543 | 1.106381 | faster / slower / slower |
| 65536 | 4 | allocate_insert_ns | 0.808457 | 1.227528 | faster / slower / slower |
| 65536 | 4 | hash_insert_ns | 1.006281 | 1.033153 | slower / slower / slower |
| 65536 | 4 | insert_ns | 1.010019 | 1.036718 | slower / slower / slower |
| 65536 | 65536 | allocate_hash_insert_ns | 0.824262 | 1.253855 | slower / slower / faster |
| 65536 | 65536 | allocate_insert_ns | 0.832792 | 1.260202 | faster / slower / faster |
| 65536 | 65536 | hash_insert_ns | 0.984777 | 1.034198 | faster / slower / faster |
| 65536 | 65536 | insert_ns | 0.994356 | 1.029008 | faster / slower / slower |
| 1048576 | 4 | allocate_hash_insert_ns | 0.754996 | 0.878379 | faster / faster / faster |
| 1048576 | 4 | allocate_insert_ns | 0.788895 | 1.007239 | faster / slower / faster |
| 1048576 | 4 | hash_insert_ns | 0.773590 | 0.829601 | faster / faster / faster |
| 1048576 | 4 | insert_ns | 0.838275 | 0.885802 | faster / faster / faster |
| 1048576 | 1048576 | allocate_hash_insert_ns | 0.932881 | 1.140146 | faster / slower / faster |
| 1048576 | 1048576 | allocate_insert_ns | 0.977321 | 1.276670 | faster / slower / slower |
| 1048576 | 1048576 | hash_insert_ns | 1.015286 | 1.061285 | slower / slower / slower |
| 1048576 | 1048576 | insert_ns | 1.019612 | 1.086439 | slower / slower / slower |
| 4194304 | 4 | allocate_hash_insert_ns | 0.720628 | 0.857075 | faster / faster / faster |
| 4194304 | 4 | allocate_insert_ns | 0.707930 | 0.940045 | faster / faster / faster |
| 4194304 | 4 | hash_insert_ns | 0.745594 | 0.815555 | faster / faster / faster |
| 4194304 | 4 | insert_ns | 0.742605 | 0.880071 | faster / faster / faster |
| 4194304 | 4194304 | allocate_hash_insert_ns | 0.902848 | 1.135359 | faster / slower / faster |
| 4194304 | 4194304 | allocate_insert_ns | 0.830355 | 1.192204 | faster / slower / slower |
| 4194304 | 4194304 | hash_insert_ns | 0.956258 | 1.050588 | faster / slower / faster |
| 4194304 | 4194304 | insert_ns | 0.886274 | 1.092931 | faster / slower / slower |
| 33554432 | 4 | allocate_hash_insert_ns | 0.763037 | 0.776520 | faster / faster / faster |
| 33554432 | 4 | allocate_insert_ns | 0.797854 | 0.818829 | faster / faster / faster |
| 33554432 | 4 | hash_insert_ns | 0.757928 | 0.770736 | faster / faster / faster |
| 33554432 | 4 | insert_ns | 0.791204 | 0.814299 | faster / faster / faster |
| 33554432 | 33554432 | allocate_hash_insert_ns | 0.851550 | 0.854245 | faster / faster / faster |
| 33554432 | 33554432 | allocate_insert_ns | 0.834560 | 0.842076 | faster / faster / faster |
| 33554432 | 33554432 | hash_insert_ns | 0.846084 | 0.848174 | faster / faster / faster |
| 33554432 | 33554432 | insert_ns | 0.825734 | 0.835917 | faster / faster / faster |

## Allocation-inclusive internal Range comparisons

| Keys | Chunk | Numerator / Range | Metric | Minimum ratio | Maximum ratio | Three outcomes | Both mappings pass all seeds |
|---:|---:|---|---|---:|---:|---|---|
| 65536 | 4 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.308867 | 1.792731 | slower / slower / slower | True |
| 65536 | 4 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.264734 | 2.300900 | slower / slower / slower | True |
| 65536 | 4 | K12ScalarOrControl | allocate_hash_insert_ns | 1.277185 | 1.939045 | slower / slower / slower | True |
| 65536 | 4 | K12ScalarOrControl | allocate_insert_ns | 1.232152 | 2.736429 | slower / slower / slower | True |
| 65536 | 65536 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.309959 | 2.355479 | slower / slower / slower | True |
| 65536 | 65536 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.406580 | 2.615067 | slower / slower / slower | True |
| 65536 | 65536 | K12ScalarOrControl | allocate_hash_insert_ns | 1.323882 | 2.316574 | slower / slower / slower | True |
| 65536 | 65536 | K12ScalarOrControl | allocate_insert_ns | 1.372801 | 2.638340 | slower / slower / slower | True |
| 1048576 | 4 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.129492 | 1.415558 | slower / slower / slower | True |
| 1048576 | 4 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.402386 | 2.014005 | slower / slower / slower | True |
| 1048576 | 4 | K12ScalarOrControl | allocate_hash_insert_ns | 1.478476 | 1.683763 | slower / slower / slower | True |
| 1048576 | 4 | K12ScalarOrControl | allocate_insert_ns | 1.672096 | 2.140738 | slower / slower / slower | True |
| 1048576 | 1048576 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.175493 | 1.847122 | slower / slower / slower | True |
| 1048576 | 1048576 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.496976 | 2.297974 | slower / slower / slower | True |
| 1048576 | 1048576 | K12ScalarOrControl | allocate_hash_insert_ns | 1.222701 | 1.980020 | slower / slower / slower | True |
| 1048576 | 1048576 | K12ScalarOrControl | allocate_insert_ns | 1.476564 | 1.947177 | slower / slower / slower | True |
| 4194304 | 4 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.142474 | 1.422519 | slower / slower / slower | True |
| 4194304 | 4 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.147507 | 1.695801 | slower / slower / slower | True |
| 4194304 | 4 | K12ScalarOrControl | allocate_hash_insert_ns | 1.466432 | 1.788976 | slower / slower / slower | True |
| 4194304 | 4 | K12ScalarOrControl | allocate_insert_ns | 1.418614 | 2.056118 | slower / slower / slower | True |
| 4194304 | 4194304 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.006817 | 1.317579 | slower / slower / slower | True |
| 4194304 | 4194304 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.031884 | 1.422902 | slower / slower / slower | True |
| 4194304 | 4194304 | K12ScalarOrControl | allocate_hash_insert_ns | 1.046735 | 1.377669 | slower / slower / slower | True |
| 4194304 | 4194304 | K12ScalarOrControl | allocate_insert_ns | 0.989652 | 1.477339 | slower / slower / faster | True |
| 33554432 | 4 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.213677 | 1.221061 | slower / slower / slower | True |
| 33554432 | 4 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.331117 | 1.340009 | slower / slower / slower | True |
| 33554432 | 4 | K12ScalarOrControl | allocate_hash_insert_ns | 1.572478 | 1.595016 | slower / slower / slower | True |
| 33554432 | 4 | K12ScalarOrControl | allocate_insert_ns | 1.630612 | 1.679517 | slower / slower / slower | True |
| 33554432 | 33554432 | K12PrefetchLineOrCandidate | allocate_hash_insert_ns | 1.075181 | 1.076229 | slower / slower / slower | True |
| 33554432 | 33554432 | K12PrefetchLineOrCandidate | allocate_insert_ns | 1.075161 | 1.100354 | slower / slower / slower | True |
| 33554432 | 33554432 | K12ScalarOrControl | allocate_hash_insert_ns | 1.259860 | 1.263012 | slower / slower / slower | True |
| 33554432 | 33554432 | K12ScalarOrControl | allocate_insert_ns | 1.288297 | 1.306715 | slower / slower / slower | True |

Range is an internal native control. Unqualified mappings remain unconditional timing observations, not qualified competitive wins. Same-mapping K12 comparisons remain informative with their quality attached. No external construction ranking is claimed.

## Every per-construction quality bound

| Keys | API | Seed | FP / negatives | Wilson upper % | Pass0.01% |
|---:|---|---:|---:|---:|---|
| 65536 | K12ScalarOrControl | 15485863 | 6011 / 67108864 | 0.009186391 | True |
| 65536 | K12PrefetchLineOrCandidate | 15485863 | 6011 / 67108864 | 0.009186391 | True |
| 65536 | Split64RangeBloomFilter | 15485863 | 6183 / 67108864 | 0.009445908 | True |
| 1048576 | K12ScalarOrControl | 15485863 | 5910 / 67108864 | 0.009033980 | True |
| 1048576 | K12PrefetchLineOrCandidate | 15485863 | 5910 / 67108864 | 0.009033980 | True |
| 1048576 | Split64RangeBloomFilter | 15485863 | 6104 / 67108864 | 0.009326717 | True |
| 4194304 | K12ScalarOrControl | 15485863 | 5914 / 67108864 | 0.009040016 | True |
| 4194304 | K12PrefetchLineOrCandidate | 15485863 | 5914 / 67108864 | 0.009040016 | True |
| 4194304 | Split64RangeBloomFilter | 15485863 | 6174 / 67108864 | 0.009432329 | True |
| 33554432 | K12ScalarOrControl | 15485863 | 6094 / 67108864 | 0.009311629 | True |
| 33554432 | K12PrefetchLineOrCandidate | 15485863 | 6094 / 67108864 | 0.009311629 | True |
| 33554432 | Split64RangeBloomFilter | 15485863 | 6083 / 67108864 | 0.009295032 | True |
| 33554432 | K12PrefetchLineOrCandidate | 32452843 | 6414 / 67108864 | 0.009794374 | True |
| 33554432 | Split64RangeBloomFilter | 32452843 | 6133 / 67108864 | 0.009370471 | True |
| 33554432 | K12ScalarOrControl | 32452843 | 6414 / 67108864 | 0.009794374 | True |
| 4194304 | K12PrefetchLineOrCandidate | 32452843 | 5826 / 67108864 | 0.008907209 | True |
| 4194304 | Split64RangeBloomFilter | 32452843 | 6097 / 67108864 | 0.009316155 | True |
| 4194304 | K12ScalarOrControl | 32452843 | 5826 / 67108864 | 0.008907209 | True |
| 1048576 | K12PrefetchLineOrCandidate | 32452843 | 5715 / 67108864 | 0.008739673 | True |
| 1048576 | Split64RangeBloomFilter | 32452843 | 6069 / 67108864 | 0.009273908 | True |
| 1048576 | K12ScalarOrControl | 32452843 | 5715 / 67108864 | 0.008739673 | True |
| 65536 | K12PrefetchLineOrCandidate | 32452843 | 5862 / 67108864 | 0.008961541 | True |
| 65536 | Split64RangeBloomFilter | 32452843 | 5989 / 67108864 | 0.009153194 | True |
| 65536 | K12ScalarOrControl | 32452843 | 5862 / 67108864 | 0.008961541 | True |
| 4194304 | Split64RangeBloomFilter | 49979687 | 6060 / 67108864 | 0.009260328 | True |
| 4194304 | K12ScalarOrControl | 49979687 | 5772 / 67108864 | 0.008825708 | True |
| 4194304 | K12PrefetchLineOrCandidate | 49979687 | 5772 / 67108864 | 0.008825708 | True |
| 33554432 | Split64RangeBloomFilter | 49979687 | 5997 / 67108864 | 0.009165266 | True |
| 33554432 | K12ScalarOrControl | 49979687 | 6122 / 67108864 | 0.009353875 | True |
| 33554432 | K12PrefetchLineOrCandidate | 49979687 | 6122 / 67108864 | 0.009353875 | True |
| 65536 | Split64RangeBloomFilter | 49979687 | 6107 / 67108864 | 0.009331243 | True |
| 65536 | K12ScalarOrControl | 49979687 | 5855 / 67108864 | 0.008950976 | True |
| 65536 | K12PrefetchLineOrCandidate | 49979687 | 5855 / 67108864 | 0.008950976 | True |
| 1048576 | Split64RangeBloomFilter | 49979687 | 6237 / 67108864 | 0.009527374 | True |
| 1048576 | K12ScalarOrControl | 49979687 | 5778 / 67108864 | 0.008834763 | True |
| 1048576 | K12PrefetchLineOrCandidate | 49979687 | 5778 / 67108864 | 0.008834763 | True |

## Every slower comparison

| Keys | Chunk | Seed | Numerator / denominator | Metric | Latency ratio |
|---:|---:|---:|---|---|---:|
| 65536 | 4 | 15485863 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.010019 |
| 65536 | 4 | 15485863 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.023330 |
| 65536 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 2.278274 |
| 65536 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 2.212286 |
| 65536 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.804773 |
| 65536 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.792731 |
| 65536 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.255674 |
| 65536 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 2.736429 |
| 65536 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.763627 |
| 65536 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.939045 |
| 65536 | 65536 | 15485863 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_hash_insert_ns | 1.016794 |
| 65536 | 65536 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 2.182693 |
| 65536 | 65536 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 2.615067 |
| 65536 | 65536 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.952656 |
| 65536 | 65536 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 2.355479 |
| 65536 | 65536 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.195082 |
| 65536 | 65536 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 2.638340 |
| 65536 | 65536 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.954726 |
| 65536 | 65536 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 2.316574 |
| 1048576 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.709205 |
| 1048576 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.688817 |
| 1048576 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.275015 |
| 1048576 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.271234 |
| 1048576 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.000298 |
| 1048576 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 2.140738 |
| 1048576 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.563362 |
| 1048576 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.683763 |
| 1048576 | 1048576 | 15485863 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.086439 |
| 1048576 | 1048576 | 15485863 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.015286 |
| 1048576 | 1048576 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.910352 |
| 1048576 | 1048576 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.903017 |
| 1048576 | 1048576 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.692586 |
| 1048576 | 1048576 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.847122 |
| 1048576 | 1048576 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.758362 |
| 1048576 | 1048576 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.947177 |
| 1048576 | 1048576 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.667102 |
| 1048576 | 1048576 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.980020 |
| 4194304 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.467841 |
| 4194304 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.455587 |
| 4194304 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.294006 |
| 4194304 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.289186 |
| 4194304 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.976609 |
| 4194304 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 2.056118 |
| 4194304 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.735537 |
| 4194304 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.788976 |
| 4194304 | 4194304 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.232543 |
| 4194304 | 4194304 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.226717 |
| 4194304 | 4194304 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.228165 |
| 4194304 | 4194304 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.317579 |
| 4194304 | 4194304 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.390703 |
| 4194304 | 4194304 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.477339 |
| 4194304 | 4194304 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.284344 |
| 4194304 | 4194304 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.377669 |
| 33554432 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.356671 |
| 33554432 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.340009 |
| 33554432 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.222397 |
| 33554432 | 4 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.213677 |
| 33554432 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.714693 |
| 33554432 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.679517 |
| 33554432 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.596912 |
| 33554432 | 4 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.573673 |
| 33554432 | 33554432 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.096955 |
| 33554432 | 33554432 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.091851 |
| 33554432 | 33554432 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.079130 |
| 33554432 | 33554432 | 15485863 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.075181 |
| 33554432 | 33554432 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.321364 |
| 33554432 | 33554432 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.301346 |
| 33554432 | 33554432 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.274447 |
| 33554432 | 33554432 | 15485863 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.262617 |
| 33554432 | 33554432 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.106712 |
| 33554432 | 33554432 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.100354 |
| 33554432 | 33554432 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.080738 |
| 33554432 | 33554432 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.076229 |
| 33554432 | 33554432 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.323950 |
| 33554432 | 33554432 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.306715 |
| 33554432 | 33554432 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.274194 |
| 33554432 | 33554432 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.259860 |
| 33554432 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.361836 |
| 33554432 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.335193 |
| 33554432 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.224953 |
| 33554432 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.217057 |
| 33554432 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.672404 |
| 33554432 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.630612 |
| 33554432 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.616185 |
| 33554432 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.595016 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.092931 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.192204 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.050588 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_hash_insert_ns | 1.135359 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.311145 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.422902 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.201980 |
| 4194304 | 4194304 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.188419 |
| 4194304 | 4194304 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.199659 |
| 4194304 | 4194304 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.193506 |
| 4194304 | 4194304 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.144102 |
| 4194304 | 4194304 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.046735 |
| 4194304 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.606761 |
| 4194304 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.695801 |
| 4194304 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.362739 |
| 4194304 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.422519 |
| 4194304 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.825718 |
| 4194304 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.803957 |
| 4194304 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.670935 |
| 4194304 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.659737 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.026449 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.276670 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.024938 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_hash_insert_ns | 1.140146 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.902123 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 2.297974 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.660195 |
| 1048576 | 1048576 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.394057 |
| 1048576 | 1048576 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.853109 |
| 1048576 | 1048576 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.799974 |
| 1048576 | 1048576 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.619801 |
| 1048576 | 1048576 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.222701 |
| 1048576 | 4 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.007239 |
| 1048576 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.796923 |
| 1048576 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 2.014005 |
| 1048576 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.345666 |
| 1048576 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.415558 |
| 1048576 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.028583 |
| 1048576 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.999530 |
| 1048576 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.622063 |
| 1048576 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.611557 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.014880 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.260202 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.034198 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_hash_insert_ns | 1.253855 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 2.202636 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.730007 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.957321 |
| 65536 | 65536 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.659956 |
| 65536 | 65536 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.170342 |
| 65536 | 65536 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.372801 |
| 65536 | 65536 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.892598 |
| 65536 | 65536 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.323882 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.036718 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.227528 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.006281 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_hash_insert_ns | 1.106381 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 2.138068 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 2.300900 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.434502 |
| 65536 | 4 | 32452843 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.571250 |
| 65536 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.062342 |
| 65536 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.874417 |
| 65536 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.425548 |
| 65536 | 4 | 32452843 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.420171 |
| 4194304 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.257218 |
| 4194304 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.147507 |
| 4194304 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.216439 |
| 4194304 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.142474 |
| 4194304 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.559822 |
| 4194304 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.418614 |
| 4194304 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.565881 |
| 4194304 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.466432 |
| 4194304 | 4194304 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.044046 |
| 4194304 | 4194304 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.042673 |
| 4194304 | 4194304 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.113197 |
| 4194304 | 4194304 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.031884 |
| 4194304 | 4194304 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.102632 |
| 4194304 | 4194304 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.006817 |
| 4194304 | 4194304 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.066234 |
| 4194304 | 4194304 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.139455 |
| 4194304 | 4194304 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.115157 |
| 33554432 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.348462 |
| 33554432 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.331117 |
| 33554432 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.227869 |
| 33554432 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.221061 |
| 33554432 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.701516 |
| 33554432 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.667186 |
| 33554432 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.593114 |
| 33554432 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.572478 |
| 33554432 | 33554432 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.083645 |
| 33554432 | 33554432 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.075161 |
| 33554432 | 33554432 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.079857 |
| 33554432 | 33554432 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.075900 |
| 33554432 | 33554432 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.312342 |
| 33554432 | 33554432 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.288297 |
| 33554432 | 33554432 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.276300 |
| 33554432 | 33554432 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.263012 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.026246 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.026443 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.033153 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_hash_insert_ns | 1.024806 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 2.060860 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.264734 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.557495 |
| 65536 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.308867 |
| 65536 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.008154 |
| 65536 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.232152 |
| 65536 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.507516 |
| 65536 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.277185 |
| 65536 | 65536 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.029008 |
| 65536 | 65536 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 2.150297 |
| 65536 | 65536 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.406580 |
| 65536 | 65536 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.911400 |
| 65536 | 65536 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.309959 |
| 65536 | 65536 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 2.089679 |
| 65536 | 65536 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.688993 |
| 65536 | 65536 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.940947 |
| 65536 | 65536 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.589251 |
| 1048576 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.662378 |
| 1048576 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.402386 |
| 1048576 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.263193 |
| 1048576 | 4 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.129492 |
| 1048576 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.983093 |
| 1048576 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.672096 |
| 1048576 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.632899 |
| 1048576 | 4 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.478476 |
| 1048576 | 1048576 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | insert_ns | 1.019612 |
| 1048576 | 1048576 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | allocate_insert_ns | 1.013824 |
| 1048576 | 1048576 | 49979687 | K12PrefetchLineOrCandidate / K12ScalarOrControl | hash_insert_ns | 1.061285 |
| 1048576 | 1048576 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | insert_ns | 1.845779 |
| 1048576 | 1048576 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_insert_ns | 1.496976 |
| 1048576 | 1048576 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | hash_insert_ns | 1.577538 |
| 1048576 | 1048576 | 49979687 | K12PrefetchLineOrCandidate / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.175493 |
| 1048576 | 1048576 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | insert_ns | 1.810276 |
| 1048576 | 1048576 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_insert_ns | 1.476564 |
| 1048576 | 1048576 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | hash_insert_ns | 1.486442 |
| 1048576 | 1048576 | 49979687 | K12ScalarOrControl / Split64RangeBloomFilter | allocate_hash_insert_ns | 1.235469 |

Quality has36 API records and24 proven mapping records; duplicate chunks and K12 aliases reuse one denominator. Pointwise Wilson endpoints are not simultaneous guarantees. Negative intervals are disjoint from inserted/query intervals within each construction; different filters/seeds do not create independent random functions or guaranteed disjoint streams.

Latin positions balance the three seeds per cell, not all six predecessor directions. Pure-before-common build phases remain fixed; seed/order/code-layout effects are not separately isolated. The small false branch has unchanged instructions but a distinct actual caller/code layout. These are the measured construction scopes only: no query, Rust, multithread, universal speed or significance claim, and no automatic promotion or further threshold search.
