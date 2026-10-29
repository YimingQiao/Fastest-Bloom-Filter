#!/usr/bin/env python3
"""Derive one fixed bulk-only candidate and selection from committed sources."""
import argparse
import copy
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
KERNEL = '944c1bae12d725dffeee900632baf1b95b67c259'
CALLER = '968361dbcceabecdb2eb17daf069dee058c28bb4'
BASE = 'experiments/2026-10-30-independent32-range'
NEW = 'Independent32RangePrefetch64BloomFilter'

HELPER = '''
#if defined(__AVX2__)
	uint32_t LookupPrepared(uint32_t block, uint64_t hash) const {
		const auto &bucket = buckets_[block];
		return _mm256_testc_si256(_mm256_load_si256(reinterpret_cast<const __m256i *>(bucket.words)), Mask(hash));
	}
	void LookupPrefetched(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		uint32_t blocks[64];
		for (size_t j = 0; j < 64; ++j) {
			blocks[j] = Block(hashes[j]);
			_mm_prefetch(reinterpret_cast<const char *>(buckets_[blocks[j]].words), _MM_HINT_T0);
		}
		size_t i = 0;
		for (; i < size_t(n) - 64; ++i) {
			const uint32_t block = blocks[i & 63];
			const uint32_t next = Block(hashes[i + 64]);
			blocks[i & 63] = next;
			_mm_prefetch(reinterpret_cast<const char *>(buckets_[next].words), _MM_HINT_T0);
			out[i] = LookupPrepared(block, hashes[i]);
		}
		for (; i < n; ++i) out[i] = LookupPrepared(blocks[i & 63], hashes[i]);
	}
#endif
'''

def blob(commit, path):
    return subprocess.check_output(['git', 'show', commit + ':' + path], cwd=ROOT)

def products():
    old = blob(KERNEL, BASE + '/candidate.hpp').decode()
    new = old.replace('Independent32RangeBloomFilter', NEW).replace(
        'Independent32RangeBucket', 'Independent32RangePrefetch64Bucket')
    new = new.replace('// Low40 probe fields/mask/insertion/query loops are unchanged.',
        '// Singleton, probe mask and insertion are unchanged; AVX2 bulk uses a fixed64-slot queue.')
    assert new.count('\npublic:') == 1
    new = new.replace('\npublic:', '\n' + HELPER + 'public:')
    start = '\tuint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {\n'
    assert new.count(start) == 1
    new = new.replace(start, start + '''#if defined(__AVX2__)
		if (n >= 128) { LookupPrefetched(n, hashes, out); return n; }
#endif
''')
    parent_selection = json.loads(blob(CALLER, BASE + '/caller/selection.json'))
    # Preserve all previous external/production point identities and geometry.
    points = []
    source_points = parent_selection['points']
    for p in source_points:
        if p['geometry']['filter'] == 'Independent32BloomFilter':
            continue
        if p['geometry']['filter'] == 'Independent32RangeBloomFilter':
            if p['geometry']['requested_bpk'] != 12:
                continue
            pipeline = copy.deepcopy(p)
            pipeline['geometry']['filter'] = NEW
            pipeline['id'] = p['id'].replace('Independent32RangeBloomFilter', NEW)
            pipeline['owner'] = 'candidate'
            points.append(pipeline)
            p = copy.deepcopy(p)
            p['owner'] = 'range_control'
        points.append(p)
    assert len(points) == 16
    selection = dict(parent_caller_commit=CALLER, points=points)
    patch = ''.join(difflib.unified_diff(old.splitlines(True), new.splitlines(True),
                                       fromfile='control.hpp', tofile='candidate.hpp'))
    sources = {BASE + '/candidate.hpp': (KERNEL, old.encode()),
               BASE + '/caller/selection.json': (CALLER, blob(CALLER, BASE + '/caller/selection.json'))}
    provenance = dict(inputs=[dict(commit=c, path=p, sha256=hashlib.sha256(data).hexdigest())
                             for p, (c, data) in sources.items()],
                      fixed_depth=64, fixed_threshold=128,
                      changes='class/bucket names and introductory comment, new AVX2-only private pipeline, and Lookup bulk dispatch only')
    return {'control.hpp': old.encode(), 'candidate.hpp': new.encode(),
            'CHANGE.patch': patch.encode(),
            'selection.json': (json.dumps(selection, indent=2) + '\n').encode(),
            'DERIVATION.json': (json.dumps(provenance, indent=2) + '\n').encode()}

def main():
    assert __debug__
    p = argparse.ArgumentParser(); p.add_argument('--write', action='store_true'); args = p.parse_args()
    for name, expected in products().items():
        path = HERE / name
        if args.write:
            assert not path.exists(), 'preserve prepared source'
            path.write_bytes(expected)
        else:
            assert path.read_bytes() == expected, name
    print('PASS exact committed kernel/selection derivation; one64-slot bulk candidate;16 points')

if __name__ == '__main__':
    main()
