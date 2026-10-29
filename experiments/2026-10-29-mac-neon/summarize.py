#!/usr/bin/env python3
"""Report the complete held-out Mac run, including external wins and guardrails."""
import csv
from collections import defaultdict
import math
from pathlib import Path
import statistics as stats

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def wilson(row):
    n = int(row['calibration_absent_queries'])
    p = int(row['calibration_false_positives']) / n
    z = 1.959963984540054
    return (p + z*z/(2*n) + z*math.sqrt(p*(1-p)/n + z*z/(4*n*n))) / (1+z*z/n)


def main():
    rows = list(csv.DictReader((HERE / 'confirmation.csv').open()))
    assert len(rows) == 195, len(rows)
    for row in rows:
        assert int(row['filter_bytes']) <= int(row['keys'])*2
        assert wilson(row) < 0.01, row['filter']
    groups = defaultdict(list)
    for row in rows:
        groups[int(row['keys']), int(row['seed'])].append(row)
    assert len(groups) == 15
    native = {'Word64BloomFilter', 'Split16BloomFilter', 'ByteSplitBloomFilter', 'FastPatternBF', 'Split64BloomFilter'}
    external = lambda row: row['filter'].startswith(('Boost192', 'FastFilter'))
    text = ['# Apple M5 Pro bulk Bloom filters — 2026-10-29', '',
            'C++17 / Apple Clang 21, `-O3 -mcpu=native -fno-strict-aliasing`, single thread. '
            'All primary queries are absent. Each row uses five repetitions, 4,194,304 queries, '
            'batch 4096 for both insertion and lookup, and 4,194,304 separate FPR calibration negatives. '
            'Seeds 6007, 7001 and 8009 were held out from tuning. Job order is shuffled inside the same executable; '
            'case order is shuffled by the runner. No benchmark processes ran concurrently.', '',
            'The comparison ceiling is 16 actual bitmap bits/key and a pointwise 95% Wilson FPR upper bound below 1%. '
            'All reported candidates pass. Object fields, allocator metadata and shared read-only constants are excluded '
            'from bitmap bytes for every implementation. Word64 additionally shares a 512-byte dictionary. '
            'This is a measured comparison against the retained shortlist, not a claim of universal superiority.', '',
            '## Primary results', '',
            'Times are ns/key: lower is better. Values below are medians across three seed medians. '
            'The external column takes the fastest eligible external separately per seed, not one fixed external layout.', '',
            '| Bitmap | Word64 insert | Split16 insert | External insert | Word64 query | Split16 query | External query |',
            '|---|---:|---:|---:|---:|---:|---:|']
    for n in sorted({int(row['keys']) for row in rows}):
        selected = [row for row in rows if int(row['keys']) == n]
        values=[]
        for metric in ('insert_ns', 'lookup_ns'):
            for name in ('Word64BloomFilter', 'Split16BloomFilter'):
                values.append(stats.median(float(r[metric]) for r in selected if r['filter']==name))
            values.append(stats.median(min(float(r[metric]) for r in group if external(r))
                                      for (keys,_),group in groups.items() if keys==n))
        label = '128 KiB' if n == 65536 else f'{n*2//(1<<20)} MiB'
        text.append('| '+label+' | '+' | '.join(f'{value:.3f}' for value in values)+' |')
    text += ['', '## Wins, ties and losses', '',
             'A ±3% band is used for classification, not a statistical confidence interval. '
             'The native leader is selected per case from all five eligible native layouts; this does not imply '
             'that one layout is fastest everywhere. Hash-inclusive metrics include the same MurmurHash64 batch pass.', '',
             '| Metric | Native wins | Within ±3% | Native losses | Native/external speedup range |',
             '|---|---:|---:|---:|---:|']
    for metric in ('insert_ns','allocate_insert_ns','hash_insert_ns','allocate_hash_insert_ns','lookup_ns','hash_lookup_ns'):
        ratios=[]
        for group in groups.values():
            a=min(float(row[metric]) for row in group if row['filter'] in native)
            b=min(float(row[metric]) for row in group if external(row))
            ratios.append(b/a)
        text.append(f'| {metric} | {sum(x>1.03 for x in ratios)} | {sum(0.97<=x<=1.03 for x in ratios)} | '
                    f'{sum(x<0.97 for x in ratios)} | {min(ratios):.3f}–{max(ratios):.3f}× |')
    text += ['', '## Accuracy and preservation', '']
    for name in ('Word64BloomFilter','Split16BloomFilter','ByteSplitBloomFilter','FastPatternBF'):
        selected=[row for row in rows if row['filter']==name]
        ps=[int(row['calibration_false_positives'])/int(row['calibration_absent_queries']) for row in selected]
        text.append(f'- {name}: measured FPR {min(ps)*100:.4f}–{max(ps)*100:.4f}%; '
                    f'maximum Wilson upper bound {max(map(wilson,selected))*100:.4f}%.')
    for group in groups.values():
        by_name={row['filter']:row for row in group}
        for a,b in (('ByteSplitBloomFilter','MacOriginalByteSplit'),('FastPatternBF','MacOriginalPattern')):
            for field in ('result_checksum','false_positives','calibration_false_positives','filter_bytes'):
                assert by_name[a][field]==by_name[b][field],(a,field)
    text += ['', 'All ByteSplit/FastPattern checksums, timed and calibration FPR counts, and bitmap bytes '
             'exactly match their frozen pre-optimization controls in every primary case.', '',
             '## Limits and reproducibility', '',
             '- This machine is an Apple M5 Pro with 48 GiB RAM and 128-byte hardware cache lines. '
             'Other M-series and Intel Macs have not been timed. macOS scheduling and clock variation remain; cores were not pinned.',
             '- The 19-configuration Boost 1.92 screen selected five external leaders, then FastFilter’s pinned ARM implementation '
             'was added. The final shortlist is not a survey of every current Bloom filter library.',
             '- FastFilter ARM exposes Add/Find but its AddAll is only declared; its wrapper uses its real public per-key methods. '
             'Boost uses its public iterator batch APIs. Neither upstream implementation was patched.',
             '- Word64 and Split16 are new C++ layouts with different bitmaps. ByteSplit’s NEON path and FastPattern’s prefetch '
             'retain their existing mappings. The Rust implementation has not received the new layouts.',
             '- `confirmation.csv` contains all 195 primary rows, including losses and allocation/hash-inclusive timing. '
             '`confirmation.json` records binary hash, commands, hardware and compiler. Earlier screens and rejected '
             'prefetch/unroll alternatives remain alongside it.', '',
             'Run `python3 experiments/2026-10-29-mac-neon/run_confirmation.py` after building the local confirmation CMake project. '
             'Run this script to regenerate the tables. See `docs/mac-bulk.md` for build and API instructions.', '']
    (HERE / 'RESULTS.md').write_text('\n'.join(text))
    print('\n'.join(text))


if __name__ == '__main__':
    main()
