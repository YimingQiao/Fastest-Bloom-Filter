#!/usr/bin/env python3
"""One source-only K12 insertion variant; no compiler, constructor or workload."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
if not __debug__:
    raise SystemExit('Python -O is not supported by this source verifier')
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
COMMIT='2263cf29ebc87d589b49ca015133312993b7db73'
HEADER='experiments/2026-10-29-four-sector-range12-screen/four_sector_range12.h'
HARNESS='experiments/2026-10-29-four-sector-range12-screen/compare_benchmark.cpp'
BASE='experiments/2026-10-29-split64-range-parallel-screen/snapshot/include/base.h'
SIZING='experiments/2026-10-29-split64-range-parallel-screen/range-layouts/range_size.hpp'
OLD='''\t\t\t// Sequential ORs preserve every bit when different keys share a word.
\t\t\tfor (unsigned j = 0; j < 16; ++j)
\t\t\t\twords_[index[j]] |= mask[j];'''
NEW='''\t\t\t// Each key has one distinct, increasing word index per sector.
\t\t\t// Expand its four masks, then complete its line RMW before the next
\t\t\t// key: duplicate keys and different keys sharing a line retain all bits.
\t\t\tfor (unsigned key = 0; key < 4; ++key) {
\t\t\t\tconst unsigned first = key * 4;
\t\t\t\tconst uint32_t base = index[first] & ~uint32_t{15};
\t\t\t\tconst __mmask16 selected = static_cast<__mmask16>(
\t\t\t\t    (1u << (index[first] & 15)) | (1u << (index[first + 1] & 15)) |
\t\t\t\t    (1u << (index[first + 2] & 15)) | (1u << (index[first + 3] & 15)));
\t\t\t\tconst __m128i packed_masks =
\t\t\t\t    _mm_loadu_si128(reinterpret_cast<const __m128i *>(mask + first));
\t\t\t\tconst __m512i expanded = _mm512_maskz_expand_epi32(
\t\t\t\t    selected, _mm512_castsi128_si512(packed_masks));
\t\t\t\tconst __m512i value = _mm512_load_si512(words_.data() + base);
\t\t\t\t_mm512_store_si512(words_.data() + base, _mm512_or_si512(value, expanded));
\t\t\t}'''
def blob(path):return subprocess.check_output(['git','show',COMMIT+':'+path],cwd=ROOT)
def sha(data):return hashlib.sha256(data).hexdigest()
def outputs():
    original=blob(HEADER).decode();need=original.count(OLD);assert need==1,need
    include='#include "../2026-10-29-split64-range-parallel-screen/range-layouts/range_size.hpp"'
    assert original.count(include)==1
    routed=original.replace(include,'#include "range_size.hpp"')
    control=routed.replace('FourSectorRange12','K12ScalarOrControl')
    candidate=routed.replace(OLD,NEW).replace('FourSectorRange12','K12LineOrCandidate')
    assert candidate.replace(NEW,OLD).replace('K12LineOrCandidate','K12ScalarOrControl')==control
    diff=''.join(difflib.unified_diff(control.splitlines(True),candidate.splitlines(True),fromfile='control.hpp',tofile='candidate.hpp'))
    return {'control.hpp':control.encode(),'candidate.hpp':candidate.encode(),'base.h':blob(BASE),'range_size.hpp':blob(SIZING),'CHANGE.patch':diff.encode()},dict(commit=COMMIT,source_paths={p:sha(blob(p))for p in [HEADER,BASE,SIZING,HARNESS]},only_algorithm_change='Replace16 scalar word ORs by4 sequential whole-line vector RMWs; mask/index generation, prefetch, dispatch, scalar/tails and queries unchanged')
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--write',action='store_true');args=parser.parse_args();files,origin=outputs()
    descriptor=dict(origin=origin,files={n:sha(data)for n,data in files.items()})
    if args.write:
        for name,data in files.items():(HERE/name).write_bytes(data)
        (HERE/'DERIVATION.json').write_text(json.dumps(descriptor,indent=2)+'\n')
    else:
        assert json.loads((HERE/'DERIVATION.json').read_text())==descriptor
        for name,data in files.items():assert(HERE/name).read_bytes()==data,name
    print('PASS one source-only variant; no compiler/Bloom execution')
if __name__=='__main__':main()
