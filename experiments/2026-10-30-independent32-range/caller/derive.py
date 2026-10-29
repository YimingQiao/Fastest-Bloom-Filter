#!/usr/bin/env python3
"""Derive only the declared public panel; no compiler/filter execution."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
CPP = 'ae6ab194e323801add38c3ed68d943f6849d8bbf'
CPP_PATH = 'experiments/2026-10-29-k12-singleton-external-plan/caller/'
PARENT = '944c1bae12d725dffeee900632baf1b95b67c259'
PARENT_PATH = 'experiments/2026-10-30-independent32-range/'


def digest(data): return hashlib.sha256(data).hexdigest()


def derive():
    outputs, inputs = {}, []
    def source(commit, path):
        data = subprocess.check_output(['git', 'show', commit + ':' + path], cwd=ROOT)
        inputs.append(dict(commit=commit, path=path, sha256=digest(data)))
        return data
    def cpp(name): return source(CPP, CPP_PATH + name)
    def section(text, first, last):
        assert text.count(first) == 1 and text.count(last) == 1
        return text[text.index(first):text.index(last)]

    for name in ['base.h', 'layout_detail.h', 'fast_pattern_BF.h', 'four_sector_bloom.h',
                 'byte_split_bloom.h', 'split64_bloom.h', 'budget.hpp', 'query_helpers.hpp', 'boost-adapters.hpp']:
        outputs[name] = cpp(name)
    for name in ['candidate.hpp', 'control.hpp']:
        outputs[name] = source(PARENT, PARENT_PATH + name)
    outputs['split64_range_size.h'] = source(PARENT, PARENT_PATH + 'snapshot/split64_range_size.h')
    for name in ['base.h', 'layout_detail.h']:
        assert outputs[name] == source(PARENT, PARENT_PATH + 'snapshot/' + name)
    full_cpp = cpp('cpp-adapters.hpp').decode()
    subset = '#pragma once\n#include "budget.hpp"\n#include <climits>\n#include <cstdint>\n#include <vector>\n'
    # bloom.h supplies the unchanged upstream include context (including vector).
    subset += '#include "bloom/bloom.h"\n#include "bloom/simd-block-fixed-fpp.h"\nnamespace external_bloom {\n'
    subset += section(full_cpp, 'struct IdentityHash {', 'inline int LogBytes(')
    subset += section(full_cpp, 'class Fixed16 {', 'template <int K, bool Branchless')
    subset += section(full_cpp, '// Versioned adapter-only control:', '} // namespace external_bloom')
    subset += '} // namespace external_bloom\nusing FastFilterFixed16 = external_bloom::Fixed16;\n'
    subset += 'using FastFilterFixed16SingleV1 = external_bloom::SingleShortcutV1<FastFilterFixed16>;\n'
    outputs['cpp-adapters.hpp'] = subset.encode()
    outputs['CPP_SUBSET.patch'] = ''.join(difflib.unified_diff(full_cpp.splitlines(True), subset.splitlines(True),
        fromfile='frozen-cpp616-cpp-adapters.hpp', tofile='only-fixed16-public-adapters.hpp')).encode()
    outputs['adapters.hpp'] = b'''#pragma once
#include "fast_pattern_BF.h"
#include "four_sector_bloom.h"
#include "byte_split_bloom.h"
#include "split64_bloom.h"
#include "candidate.hpp"
#include "control.hpp"
#include "cpp-adapters.hpp"
#include "boost-adapters.hpp"
using bloom_filters::FastPatternBF;
using bloom_filters::FourSectorBloomFilter;
using bloom_filters::ByteSplitBloomFilter;
using bloom_filters::Split64BloomFilter;
using bloom_filters::Independent32BloomFilter;
using bloom_filters::Independent32RangeBloomFilter;
'''
    geometry = cpp('geometry.hpp').decode()
    kept = section(geometry, '#pragma once', 'template<> struct Traits<external_bloom::SimdBlock>')
    kept += section(geometry, 'template<class BF, size_t Width, size_t Scale, int Probes>', 'template<bool Bulk> struct Traits<external_bloom::Fixed32')
    kept += section(geometry, 'template<class Base> struct Traits<external_bloom::SingleShortcutV1<Base>>', 'template<int K, bool Branchless, bool Bulk>')
    kept += section(geometry, 'template<size_t K, class Sub, size_t Stride>', 'template<int K, bool Bulk>')
    kept += '''template<> struct Traits<Independent32BloomFilter> : NativeTraits<Independent32BloomFilter, 8> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        auto g = NativeTraits<Independent32BloomFilter, 8>::Plan(n, bpk);
        g.unit_bytes = 32; g.units = g.allocated_bytes / 32;
        g.kind = "independent32_pow2_buckets"; g.origin = "retained_project";
        return g;
    }
};
template<> struct Traits<Independent32RangeBloomFilter> : ExternalMake<Independent32RangeBloomFilter> {
    static Geometry Plan(size_t n, uint32_t bpk) {
        const size_t budget = Bytes(n, bpk), allocated = FloorUnits(AtLeast(budget, 128), 64);
        Geometry g{budget, allocated, allocated, 32, allocated / 32, 8, "independent32_range_buckets"};
        g.constructor_argument = bpk; g.origin = "project_experiment";
        return g;
    }
};
} // namespace exact_budget
'''
    outputs['geometry.hpp'] = kept.encode()
    outputs['GEOMETRY.patch'] = ''.join(difflib.unified_diff(geometry.splitlines(True), kept.splitlines(True),
        fromfile='frozen-cpp616-geometry.hpp', tofile='same-recipes-independent32-panel.hpp')).encode()

    old = cpp('main.cpp').decode()
    new = old
    changes = [
        ('    filter.Insert(static_cast<uint32_t>(n),d.inserted.data());\n',
         '    filter.Insert(static_cast<uint32_t>(n),d.inserted.data());\n'
         '    uint64_t initial_bitmap = 0;\n'
         '    if constexpr(HasData<BF>::value) initial_bitmap = Digest(static_cast<const uint8_t*>(static_cast<const void*>(filter.Data())),filter.SizeInBytes());\n'),
        ('    const char* mode_names[]=',
         '    if constexpr(HasData<BF>::value)\n'
         '        if(initial_bitmap != Digest(static_cast<const uint8_t*>(static_cast<const void*>(filter.Data())),filter.SizeInBytes()))\n'
         '            throw std::runtime_error("query mutated bitmap");\n'
         '    const char* mode_names[]='),
        ('    std::cout<<",\\\"bitmap_digest\\\":";BitmapField(filter);',
         '    std::cout<<",\\\"bitmap_available\\\":"<<(HasData<BF>::value?"true":"false");\n'
         '    std::cout<<",\\\"bitmap_digest\\\":";BitmapField(filter);'),
        ('std::cout << ",\\\"allocation_only\\\":true}\\n"',
         'std::cout << ",\\\"bitmap_available\\\":" << (HasData<BF>::value?"true":"false") << ",\\\"allocation_only\\\":true}\\n"'),
    ]
    for before, after in changes:
        assert new.count(before) == 1, before
        new = new.replace(before, after)
    before = section(new, 'bool Diagnostic(', 'int main(int argc,char** argv)')
    after = '''std::vector<Job> Jobs(size_t n,bool proof) {
    std::vector<Job> jobs;
#define ADD(TYPE,NAME,ID,OWNER,N,BPK,BACKING,LOGICAL,UNIT_BYTES,UNITS,PROBES,ARG,KIND,POLICY,NATIVE_BPK) \\
    if(n==(N))jobs.push_back({{NAME,ID,OWNER,N,BPK,BACKING,LOGICAL,UNIT_BYTES,UNITS,PROBES,ARG,KIND,POLICY,NATIVE_BPK},&Run<TYPE>,&Allocation<TYPE>});
#include "points.inc"
    if(proof) {
#include "proof-point.inc"
    }
#undef ADD
    return jobs;
}
'''
    new = new.replace(before, after)
    before = section(new, '        if(c.order>1', '        Input d;d.inserted_raw.resize(n)')
    after = '''        if(c.order>1 || c.hit!=50 || (c.batch!=1&&c.batch!=31&&c.batch!=4096))
            throw std::invalid_argument("unsupported grid");
        const bool primary=c.batch==1;
        if(c.measure) {
            if((c.power!=16&&c.power!=25)||c.query_power!=22||c.repeats!=8||
               (c.seed!=982451653&&c.seed!=961748941)||c.calibration_power!=(primary&&c.order==0?26u:0u))
                throw std::invalid_argument("formal grid mismatch");
        } else if(c.seed!=74381||c.query_power!=12||c.repeats!=4||
                  (c.allocation_only?(c.power!=16&&c.power!=25):c.power!=16)||
                  c.calibration_power!=(primary&&!c.allocation_only?10u:0u))
            throw std::invalid_argument("proof grid mismatch");
        const size_t n=size_t{1}<<c.power,q=size_t{1}<<c.query_power;
        auto jobs=Jobs(n,!c.measure&&!c.allocation_only);
        if(c.allocation_only){for(const auto&job:jobs)job.allocation(job.point);return 0;}
'''
    new = new.replace(before, after)
    timed = section(old, '    const unsigned four[4][4]', '\n    if(Digest(d.inserted_raw.data(),n)')
    assert timed == section(new, '    const unsigned four[4][4]', '\n    if(Digest(d.inserted_raw.data(),n)')
    outputs['main.cpp'] = new.encode()
    outputs['MAIN.patch'] = ''.join(difflib.unified_diff(old.splitlines(True), new.splitlines(True),
        fromfile='proved-cpp616-caller', tofile='same-clocks-fixed-independent32-panel')).encode()

    plan = json.loads(source(PARENT, PARENT_PATH + 'protocol.json'))
    parent_points = json.loads(source('61f068907665fef2cb8ceafcc9c2f014f96b281e',
        'experiments/2026-10-29-k12-singleton-external-plan/selection.json'))['points']
    points = []
    def independent(n, bpk, candidate):
        size = n * bpk // 8
        name = 'Independent32RangeBloomFilter' if candidate else 'Independent32BloomFilter'
        mapping = ('independent32_range' if candidate else 'independent32_pow2') + f'/n{n}/bytes{size}'
        return dict(id=f'{name}/n{n}/bpk{bpk}', owner='candidate' if candidate else 'retained_independent',
            mapping_id=mapping, public_data_available=True, geometry=dict(filter=name,keys=n,requested_bpk=bpk,
            budget_bytes=size,filter_bytes=size,logical_bytes=size,unit_bytes=32,unit_count=size//32,
            effective_probes=8,constructor_argument=bpk if candidate else 8,
            geometry_kind='independent32_range_buckets' if candidate else 'independent32_pow2_buckets',
            probe_policy='fixed',native_constructor_bpk=0 if candidate else 8))
    def original(n, name, size):
        hits = [p for p in parent_points if p['geometry']['filter']==name and
                int(p['geometry']['keys'])==n and int(p['geometry']['filter_bytes'])==size]
        assert len(hits)==1
        p = dict(hits[0]); p.pop('selection_reasons',None); p['public_data_available']=False
        return p
    for power in (16,25):
        n = 1 << power
        points += [independent(n,12,True),independent(n,16,True),independent(n,16,False)]
        for name in ('FastPatternBF','FourSectorBloomFilter','ByteSplitBloomFilter','Split64BloomFilter'):
            points.append(original(n,name,n*2))
        for item in plan['conditional_timing_proposal']['external_panels'][str(n)]:
            points.append(original(n,item['filter'],item['filter_bytes']))
    assert len(points)==18
    proof = original(1<<25,'Boost192Multi32K8',50331647)
    proof['id']='proof-only/Boost192Multi32K8/n65536/bpk12'
    proof['mapping_id']='proof-only/boost32k8/n65536/bytes98303'
    proof['geometry']=dict(filter='Boost192Multi32K8',keys=65536,requested_bpk=12,budget_bytes=98304,
        filter_bytes=98303,logical_bytes=98240,unit_bytes=32,unit_count=3070,effective_probes=8,
        constructor_argument=785920,geometry_kind='boost_range',probe_policy='fixed',native_constructor_bpk=0)
    def registration(point):
        g = point['geometry']
        values = (g['filter'],g['filter'],point['id'],point['owner'],int(g['keys']),int(g['requested_bpk']),
            int(g['filter_bytes']),int(g['logical_bytes']),int(g['unit_bytes']),int(g['unit_count']),
            int(g['effective_probes']),int(g['constructor_argument']),g['geometry_kind'],g['probe_policy'],int(g.get('native_constructor_bpk',0)))
        return 'ADD(%s,"%s","%s","%s",%s,%s,%s,%s,%s,%s,%s,%s,"%s","%s",%s)\n' % values
    outputs['selection.json']=(json.dumps(dict(plan_commit=PARENT,points=points,proof_only_point=proof,
        counts=dict(formal_points=18,concrete_types=9,native_types=6,small_points=10,large_points=8,
                    proof_small_points=11,formal_rows=216)),indent=2)+'\n').encode()
    outputs['points.inc']=''.join(map(registration,points)).encode()
    outputs['proof-point.inc']=registration(proof).encode()

    pins = json.loads(cpp('upstream-pins.json'))
    pins['source_sha256']={p:h for p,h in pins['source_sha256'].items() if
        p.startswith('benchmarks/boost-external/.deps/boost_1_92_0/') or
        p in ['build/all-external-confirmation/_deps/fastfilter-src/src/bloom/bloom.h',
              'build/all-external-confirmation/_deps/fastfilter-src/src/bloom/simd-block-fixed-fpp.h',
              'build/all-external-confirmation/_deps/fastfilter-src/src/hashutil.h']}
    pins['scope']='Only pinned Boost1.92 and three unchanged FastFilter files; actual .d must reject all other repository inputs.'
    outputs['upstream-pins.json']=(json.dumps(pins,indent=2)+'\n').encode()
    outputs['lease.py']=cpp('lease.py')
    # Only semantic observations from the completed correctness proof are reused.
    # No previous latency is retained or compared.
    reference_path='experiments/2026-10-29-k12-singleton-external-plan/caller-v2/'
    commands=json.loads(source(CPP,reference_path+'validation-v2/commands.json'))
    reference={}
    retained={p['id'] for p in points if int(p['geometry']['keys'])==65536 and
              p['owner'] not in ('candidate','retained_independent')}
    assert len(retained)==7
    for profile in ('normal','asan'):
        record=next(r for r in commands if r['label']==profile+'-case-0')
        data=source(CPP,reference_path+record['stdout'])
        assert digest(data)==record['stdout_sha256'] and record['returncode']==0
        rows=[json.loads(line) for line in data.decode().splitlines()]
        rows=[{k:v for k,v in row.items() if k!='samples'} for row in rows if row['point_id'] in retained]
        assert len(rows)==7
        reference[profile]=dict(source_commit=CPP,source_path=reference_path+record['stdout'],rows=rows)
    outputs['old-reference.json']=(json.dumps(reference,indent=2)+'\n').encode()
    manifest=dict(source_only=True,parents=inputs,timed_block_sha256=digest(timed.encode()),
        exact_query_helpers_sha256=digest(outputs['query_helpers.hpp']),
        changes='selection/CLI, exact typed factories and outside-clock actual-Data metadata only; no hash/query/timed-block change',
        outputs={k:digest(v) for k,v in outputs.items()})
    outputs['DERIVATION.json']=(json.dumps(manifest,indent=2)+'\n').encode()
    return outputs


def main():
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');args=p.parse_args()
    outputs=derive()
    for name,data in outputs.items():
        path=HERE/name
        if args.write:path.write_bytes(data)
        elif path.read_bytes()!=data:raise ValueError('source derivation changed: '+name)
    print('Verified',len(outputs),'source artifacts; unchanged public helpers and timed block; no compiler/BF')


if __name__=='__main__':main()
