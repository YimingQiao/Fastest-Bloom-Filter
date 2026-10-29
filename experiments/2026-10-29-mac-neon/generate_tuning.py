#!/usr/bin/env python3
"""Generate isolated prefetch/unroll candidates from frozen kernels."""
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE.parents[1] / 'build/mac-tune'
OUT.mkdir(parents=True, exist_ok=True)
headers, names = [], []
for distance, unroll in ((0, 1), (16, 1), (32, 1), (64, 1), (128, 1), (32, 4), (64, 4), (64, 8)):
    name = f'ByteD{distance}U{unroll}'
    text = (HERE / 'byte_split_neon_v1.h').read_text().replace('ByteSplitBloomFilter', name)
    old = '\t\tfor (size_t i = 0; i < n; ++i)\n\t\t\tInsertOne(hashes[i]);'
    new = f'''\t\t#pragma clang loop unroll_count({unroll})
\t\tfor (size_t i = 0; i < n; ++i) {{
\t\t\tif ({distance} && SizeInBytes() > (1u << 21) && i + {distance} < n)
\t\t\t\t__builtin_prefetch(&lines_[BucketIndex(hashes[i + {distance}]) >> 2], 1, 3);
\t\t\tInsertOne(hashes[i]);
\t\t}}'''
    assert old in text
    text = text.replace(old, new)
    old = '\t\tfor (size_t i = 0; i < n; ++i)\n\t\t\tout[i] = LookupOne(hashes[i]);'
    new = f'''\t\t#pragma clang loop unroll_count({unroll})
\t\tfor (size_t i = 0; i < n; ++i) {{
\t\t\tif ({distance} && SizeInBytes() > (1u << 21) && i + {distance} < n)
\t\t\t\t__builtin_prefetch(&lines_[BucketIndex(hashes[i + {distance}]) >> 2], 0, 3);
\t\t\tout[i] = LookupOne(hashes[i]);
\t\t}}'''
    assert old in text
    text = text.replace(old, new)
    (OUT / f'{name}.h').write_text(text)
    headers.append(f'#include "{name}.h"')
    names.append(name)
for distance in (16, 32, 64, 128):
    name = f'PatternD{distance}'
    text = (HERE / 'fast_pattern_original.h').read_text().replace('FastPatternBF', name)
    # Only two scalar tails contain this exact line. AVX kernels are unchanged.
    needle = '\t\tfor (; i < num; ++i) {\n'
    assert text.count(needle) == 2
    first = needle + f'''\t\t\tif constexpr (Prefetch) {{
\t\t\t\tif (i + {distance} < num)
\t\t\t\t\t__builtin_prefetch(blocks_.data() + Block(keys[i + {distance}]), 1, 3);
\t\t\t}}
'''
    second = first.replace(', 1, 3);', ', 0, 3);')
    a, b, c = text.split(needle)
    text = a + first + b + second + c
    (OUT / f'{name}.h').write_text(text)
    headers.append(f'#include "{name}.h"')
    names.append(name)
(OUT / 'adapters.hpp').write_text('\n'.join(headers) + '\n#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \\\n' + ' \\\n'.join(f'  ADD({name}, uint64_t);' for name in names) + '\n')
print(OUT)
