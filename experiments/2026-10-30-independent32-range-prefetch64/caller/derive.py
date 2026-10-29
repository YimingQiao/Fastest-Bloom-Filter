#!/usr/bin/env python3
"""Copy proved public caller sources; add only the frozen pipeline and focused mode."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PARENT = '968361dbcceabecdb2eb17daf069dee058c28bb4'
PARENT_PATH = 'experiments/2026-10-30-independent32-range/caller/'
CORE = '6981a9139f6b10785036dd6a43c398a337cfce09'
CORE_PATH = 'experiments/2026-10-30-independent32-range-prefetch64/'
NEW = 'Independent32RangePrefetch64BloomFilter'

def derive():
    outputs, parents = {}, []
    def source(commit, path):
        data = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=ROOT)
        parents.append(dict(commit=commit,path=path,sha256=hashlib.sha256(data).hexdigest()))
        return data
    def old(name): return source(PARENT, PARENT_PATH + name)
    def delta(name, before, after):
        outputs[name] = after.encode()
        outputs[name + '.patch'] = ''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),
            fromfile=name+'@'+PARENT,tofile=name)).encode()
    for name in ('base.h','layout_detail.h','split64_range_size.h','fast_pattern_BF.h','four_sector_bloom.h',
                 'byte_split_bloom.h','split64_bloom.h','candidate.hpp','control.hpp','budget.hpp',
                 'cpp-adapters.hpp','boost-adapters.hpp','query_helpers.hpp','proof-point.inc',
                 'upstream-pins.json','contract.py','old-reference.json','lease.py'):
        outputs[name] = old(name)
    outputs['pipeline.hpp'] = source(CORE,CORE_PATH+'candidate.hpp')
    assert outputs['candidate.hpp'] == source(CORE,CORE_PATH+'control.hpp')
    selection = json.loads(source(CORE,CORE_PATH+'selection.json'))
    selection['proof_only_point'] = json.loads(old('selection.json'))['proof_only_point']
    outputs['selection.json'] = (json.dumps(selection,indent=2)+'\n').encode()
    lines=[]
    for p in selection['points']:
        g=p['geometry']
        values=[g['filter'],json.dumps(g['filter']),json.dumps(p['id']),json.dumps(p['owner']),
                g['keys'],g['requested_bpk'],g['filter_bytes'],g['logical_bytes'],g['unit_bytes'],
                g['unit_count'],g['effective_probes'],g['constructor_argument'],
                json.dumps(g['geometry_kind']),json.dumps(g['probe_policy']),g['native_constructor_bpk']]
        lines.append('ADD('+','.join(map(str,values))+')')
    outputs['points.inc']=('\n'.join(lines)+'\n').encode()
    before=old('adapters.hpp').decode()
    after=before+'#include "pipeline.hpp"\nusing bloom_filters::'+NEW+';\n'
    delta('adapters.hpp',before,after)
    before=old('geometry.hpp').decode()
    tail='} // namespace exact_budget\n';assert before.count(tail)==1
    after=before.replace(tail,'''template<> struct Traits<Independent32RangePrefetch64BloomFilter>
    : ExternalMake<Independent32RangePrefetch64BloomFilter> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        return Traits<Independent32RangeBloomFilter>::Plan(n, bpk);
    }
};
'''+tail)
    delta('geometry.hpp',before,after)
    before=old('main.cpp').decode()
    after='#include "focused.hpp"\n'+before
    token='int main(int argc,char** argv) {\n    try {\n';assert after.count(token)==1
    after=after.replace(token,token+'        if(argc==2 && std::string(argv[1])=="--prefetch-check")return prefetch64_proof::Run();\n')
    # Includes and the early untimed mode are the only main.cpp changes.
    assert after.split('    const unsigned four[4][4]',1)[1].split('int main(',1)[0] == \
           before.split('    const unsigned four[4][4]',1)[1].split('int main(',1)[0]
    delta('main.cpp',before,after)
    before=old('CMakeLists.txt').decode()
    after=before.replace('project(independent32_range_public_panel','project(independent32_prefetch64_public_panel')
    after=after.replace('target_compile_options(main PRIVATE -fno-strict-aliasing -march=native)', '''target_compile_options(main PRIVATE -fno-strict-aliasing)
set(BF_ISA "native" CACHE STRING "native or avx2")
if(BF_ISA STREQUAL "native")
  target_compile_options(main PRIVATE -march=native)
elseif(BF_ISA STREQUAL "avx2")
  target_compile_options(main PRIVATE -march=x86-64-v3)
else()
  message(FATAL_ERROR "unsupported fixed ISA profile")
endif()''')
    delta('CMakeLists.txt',before,after)
    before=old('asm.py').decode()
    after=before.replace('def capture(binary,tools,run):','def capture(binary,tools,run,profile="normal"):')
    after=after.replace("'normal-", "profile+'-")
    delta('asm.py',before,after)
    before=old('test_contract.py').decode()
    after=before.replace("for r in records),33)","for r in records),30)")
    after=after.replace("for case in c.ALLOCATION_CASES),18)","for case in c.ALLOCATION_CASES),16)")
    marker="if __name__=='__main__':unittest.main()"
    extra='''    def test_new_pipeline_mapping_alias_rejects_output_drift(self):
        rows=fixture(c.CASES[0])
        candidate=next(r for r in rows if r['owner']=='candidate')
        control=next(r for r in rows if r['owner']=='range_control')
        self.assertEqual(candidate['actual_bytes'],control['actual_bytes'])
        for field in ('bitmap_digest','false_positives','result_digest','calibration_fp'):
            bad=copy.deepcopy(rows)
            next(r for r in bad if r['owner']=='candidate')[field]+=1
            with self.assertRaises(ValueError):c.parse(stream(bad),c.CASES[0])

'''
    assert after.count(marker)==1;after=after.replace(marker,extra+marker)
    delta('test_contract.py',before,after)
    descriptor=dict(parents=parents,outputs={n:hashlib.sha256(d).hexdigest()for n,d in outputs.items()},
                    timed_block_unchanged=True,query_helpers_unchanged=True,
                    main_change='focused.hpp include and early untimed --prefetch-check only')
    outputs['DERIVATION.json']=(json.dumps(descriptor,indent=2)+'\n').encode()
    return outputs

def main():
    assert __debug__
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args()
    outputs=derive()
    for name,data in outputs.items():
        path=HERE/name
        if a.write:
            assert not path.exists(), 'preserve prepared source'
            path.write_bytes(data)
        else: assert path.read_bytes()==data,name
    print('PASS '+str(len(outputs))+' derived files;literal public timing block and query helpers retained')

if __name__=='__main__':main()
