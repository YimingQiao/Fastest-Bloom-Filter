#!/usr/bin/env python3
from pathlib import Path
HERE = Path(__file__).resolve().parent
OUT = HERE.parents[1] / 'build/mac-split16-tune'
OUT.mkdir(parents=True, exist_ok=True)
headers, names = [], []
for narrow, unroll, insert_threshold in ((False, 1, 21), (False, 2, 21), (True, 1, 21),
                                        (True, 2, 21), (True, 4, 21), (True, 8, 21),
                                        (True, 2, 23), (True, 4, 23)):
    name = f'S16N{int(narrow)}U{unroll}T{insert_threshold}'
    text = (HERE / 'split16_v1.h').read_text().replace('Split16BloomFilter', name)
    text = text.replace('unroll_count(4)', f'unroll_count({unroll})')
    if narrow:
        text = text.replace('return vmaxvq_u16(vbicq_u16(Mask(h), vld1q_u16(p))) == 0;',
            'const auto missing = vreinterpretq_u64_u16(vbicq_u16(Mask(h), vld1q_u16(p)));\n'
            '\t\treturn vget_lane_u64(vreinterpret_u64_u32(vqmovn_u64(missing)), 0) == 0;')
    text = text.replace('if (SizeInBytes() > (1u << 21)) InsertBatch',
                        f'if (SizeInBytes() > (1u << {insert_threshold})) InsertBatch')
    (OUT / f'{name}.h').write_text(text)
    headers.append(f'#include "{name}.h"')
    names.append(name)
(OUT / 'adapters.hpp').write_text('\n'.join(headers) + '\n#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \\\n' + ' \\\n'.join(f'  ADD({name}, uint64_t);' for name in names) + '\n')
