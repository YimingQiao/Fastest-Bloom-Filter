#!/usr/bin/env python3
"""Tune a bounded prefetch loop separately from the non-prefetched tail."""
from pathlib import Path
HERE = Path(__file__).resolve().parent
OUT = HERE.parents[1] / 'build/mac-pipeline'
OUT.mkdir(parents=True, exist_ok=True)
headers, names = [], []
for distance in (32, 64, 96, 128):
    for unroll in (4, 8):
        name = f'PipelineD{distance}U{unroll}'
        text = (HERE / 'byte_split_neon_v1.h').read_text().replace('ByteSplitBloomFilter', name)
        for store in (True, False):
            operation = 'InsertOne(hashes[i]);' if store else 'out[i] = LookupOne(hashes[i]);'
            old = '\t\tfor (size_t i = 0; i < n; ++i)\n\t\t\t' + operation
            new = f'''\t\tsize_t i = 0;
\t\tif (SizeInBytes() > (1u << 21)) {{
\t\t\t#pragma clang loop unroll_count({unroll})
\t\t\tfor (; i + {distance} < n; ++i) {{
\t\t\t\t__builtin_prefetch(&lines_[BucketIndex(hashes[i + {distance}]) >> 2], {int(store)}, 3);
\t\t\t\t{operation}
\t\t\t}}
\t\t}}
\t\t#pragma clang loop unroll_count(4)
\t\tfor (; i < n; ++i)
\t\t\t{operation}'''
            assert old in text
            text = text.replace(old, new)
        (OUT / f'{name}.h').write_text(text)
        headers.append(f'#include "{name}.h"')
        names.append(name)
(OUT / 'adapters.hpp').write_text('\n'.join(headers) + '\n#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \\\n' + ' \\\n'.join(f'  ADD({name}, uint64_t);' for name in names) + '\n')
print(OUT)
