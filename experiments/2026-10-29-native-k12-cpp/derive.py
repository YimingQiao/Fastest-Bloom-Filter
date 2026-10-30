#!/usr/bin/env python3
"""Source-only optional K12 packaging; original kernels are immutable."""
import argparse,hashlib,json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
BASE='81f40f16caa44586537d577f998c33fec4c22be8'
KERNEL='e150be33b95a22dca9b75175e6174b9555c82393'
PATH='experiments/2026-10-29-four-sector-range12-screen/four_sector_range12.h'

def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT).decode()
def sha(data):return hashlib.sha256(data.encode()).hexdigest()
def outputs():
    old=blob(KERNEL,PATH)
    serial=old.replace('FourSectorRange12','FourSectorRange12BloomFilter').replace(
      '#include "../2026-10-29-split64-range-parallel-screen/range-layouts/range_size.hpp"','#include "split64_range_size.h"')
    # Access-only removal; the old generic assumes power-of-two lines.
    generic='\ttemplate <class>\n\tfriend class ParallelLayoutBloomFilter;\n'
    assert serial.count(generic)==1
    serial=serial.replace(generic,'').replace('class FourSectorRange12BloomFilter {','class FourSectorRange12BloomFilter {\n\tfriend class ParallelFourSectorRange12BloomFilter;')
    restored=serial.replace('\n\tfriend class ParallelFourSectorRange12BloomFilter;','\n'+generic.rstrip('\n')).replace('FourSectorRange12BloomFilter','FourSectorRange12').replace('#include "split64_range_size.h"','#include "../2026-10-29-split64-range-parallel-screen/range-layouts/range_size.hpp"')
    assert restored==old
    original=blob(BASE,'include/parallel_split64_range_bloom.h')
    start=original.index('struct RangePartition {');end=original.index('// Exclusive construction',start)
    partition='''namespace parallel_detail {
// Ownership is computed from the already-reduced physical K12 cache line.
// In particular, using the unreduced high32 hash here would be incorrect.
struct K12LinePartition {
    const uint64_t lines, workers;
    K12LinePartition(size_t l, size_t w) : lines(l), workers(w) {
        if (!l || l > (size_t{1} << 22) || !w || w > l)
            throw std::invalid_argument("invalid K12 physical-line partition");
    }
    size_t OwnerLine(size_t line) const { return uint64_t(line) * workers / lines; }
    size_t BeginLine(size_t part) const { return (uint64_t(part) * lines + workers - 1) / workers; }
};
} // namespace parallel_detail

'''
    parallel=original[:start]+partition+original[end:]
    parallel=parallel.replace('split64_range_bloom.h','four_sector_range12_bloom.h').replace('ParallelSplit64RangeBloomFilter','ParallelFourSectorRange12BloomFilter').replace('using Filter = Split64RangeBloomFilter;','using Filter = FourSectorRange12BloomFilter;')
    parallel=parallel.replace('const RangePartition partition(', 'const parallel_detail::K12LinePartition partition(').replace('return partition.Owner(h);','return partition.OwnerLine(filter_.CacheLineIndex(h));')
    return {'include/four_sector_range12_bloom.h':serial,'include/parallel_four_sector_range12_bloom.h':parallel},dict(base_commit=BASE,kernel_commit=KERNEL,kernel_path=PATH,kernel_sha256=sha(old),parallel_source_sha256=sha(original),allowed_serial_edits=['class/constructor names','local sizing include','remove unsafe generic power-of-two wrapper friendship','add dedicated physical-line wrapper friendship'],kernel_expressions_changed=False)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--worktree',type=Path,required=True);a=p.parse_args();files,provenance=outputs()
    for name,data in files.items():(a.worktree/name).write_text(data)
    provenance['outputs']={name:sha(data)for name,data in files.items()}
    (Path(__file__).resolve().parent/'DERIVATION.json').write_text(json.dumps(provenance,indent=2)+'\n')
