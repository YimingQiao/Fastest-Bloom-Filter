#!/usr/bin/env python3
"""Snapshot native and exact-budget dependencies; derive query-only balanced caller."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
PARENT='35c97d584b600fdd71e6c086459433a53d4e567a'
NATIVE='6e7df603a02e2e7d1c226afaff6d37c14f841f3b'
BASE='experiments/2026-10-29-split64-range-parallel-screen/'
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
def build():
 out={};origins={}
 for path in subprocess.check_output(['git','ls-tree','-r','--name-only',NATIVE,'include'],cwd=ROOT).decode().splitlines():
  data=blob(NATIVE,path);dest='native/'+path;out[dest]=data;origins[dest]={'commit':NATIVE,'path':path,'sha256':hashlib.sha256(data).hexdigest()}
 for name in ['budget.hpp','cpp-adapters.hpp','boost-adapters.hpp','rocks-adapters.hpp','executor.hpp','placement.hpp','check_executor.cpp']:
  data=blob(PARENT,BASE+name);out[name]=data;origins[name]={'commit':PARENT,'path':BASE+name,'sha256':hashlib.sha256(data).hexdigest()}
 old=blob(PARENT,BASE+'geometry.hpp').decode();new=old
 start=new.index('template<> struct Traits<ByteSplitRangeExperiment>')
 stop=new.index('inline const char *GeometryHeader()',start)
 new=new[:start]+'''template<> struct Traits<Split64RangeBloomFilter> : RangeTraits<Split64RangeBloomFilter,64,8> {
    static Geometry Plan(size_t n,uint32_t bpk) { auto g=RangeTraits<Split64RangeBloomFilter,64,8>::Plan(n,bpk);g.origin="optional_native_range";return g; }
    static Split64RangeBloomFilter Make(size_t n,uint32_t bpk) { return Split64RangeBloomFilter(bloom_filters::RangeBytes{Plan(n,bpk).budget_bytes}); }
};
template<> struct Traits<FourSectorRange12BloomFilter> : RangeTraits<FourSectorRange12BloomFilter,64,12> {
    static Geometry Plan(size_t n,uint32_t bpk) { auto g=RangeTraits<FourSectorRange12BloomFilter,64,12>::Plan(n,bpk);g.origin="optional_native_k12";g.kind="native_k12_top24_lines";return g; }
    static FourSectorRange12BloomFilter Make(size_t n,uint32_t bpk) { return FourSectorRange12BloomFilter(bloom_filters::RangeBytes{Plan(n,bpk).budget_bytes}); }
};
'''+new[stop:]
 out['geometry.hpp']=new.encode();out['GEOMETRY.patch']=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen/geometry.hpp',tofile='geometry.hpp')).encode()
 old=blob(PARENT,BASE+'benchmark.cpp').decode();new=old
 start=new.index('#include "fast_pattern_BF.h"');stop=new.index('using namespace bloom_filters;',start)
 new=new[:start]+'#include "adapters.hpp"\n#include "geometry.hpp"\n#include "phase_order.hpp"\n'+new[stop:]
 new=new.replace('hashes(q), scratch(std::max(batch, insert_batch))','hashes(q), scratch(batch)')
 new=new.replace('using Clock = std::chrono::steady_clock;', 'template<class T> uint64_t Fingerprint(const T* data,size_t n) { uint64_t h=14695981039346656037ULL;for(size_t i=0;i<n;++i)h=(h^data[i])*1099511628211ULL;return h; }\nusing Clock = std::chrono::steady_clock;')
 start=new.index('\t// Keep one bitmap alive');stop=new.index('\tconst auto geometry =',start)
 new=new[:start]+'''    const uint64_t raw_insert_checksum=Fingerprint(raw_insert.data(),n),raw_query_checksum=Fingerprint(raw_query.data(),q);
    const uint64_t inserted_hash_checksum=Fingerprint(inserted.data(),n),query_hash_checksum=Fingerprint(hashes.data(),q);
    // Query-only: one complete setup bitmap, no construction timing samples.
    const double missing = std::numeric_limits<double>::quiet_NaN();
    const std::vector<double> insert_times{missing}, build_times{missing}, hash_insert_times{missing}, hash_build_times{missing};
'''+new[stop:]
 start=new.index('    for (unsigned r = 0; r < repeats; ++r) {');stop=new.index('\t// Independent negative calibration',start)
 new=new[:start]+'''    const auto phase_order = k12_phase::Schedule(seed,repeats);
    for (const auto &order : phase_order) for (unsigned phase : order) {
        if (phase == 0) {
            const auto start = Clock::now();
            for (size_t i=0;i<q;i+=batch)
                lookup_kernel(bf,std::min(batch,q-i),hashes.data()+i,output+i);
            const auto end = Clock::now(); lookup.push_back(ns(start,end)/q);
        } else if (phase == 1) {
            const auto start = Clock::now();
            for (size_t i=0;i<q;i+=batch) {
                const size_t len=std::min(batch,q-i);
                if constexpr (RawKeyApi<BF>::value) lookup_kernel(bf,len,raw_query.data()+i,output+i);
                else { HashVector(len,raw_query.data()+i,scratch.data());lookup_kernel(bf,len,scratch.data(),output+i); }
            }
            const auto end=Clock::now();total.push_back(ns(start,end)/q);
        } else if (phase == 2) pure_parallel.add(parallel_query(false),q);
        else hash_parallel.add(parallel_query(true),q);
        validate_timed_output("balanced timed query");
    }
'''+new[stop:]
 new=new.replace('\t\tif (checksum != result_checksum', '\t\tsink = checksum;\n\t\tif (checksum != result_checksum')
 new=new.replace('\tstd::cout << std::setprecision(17)', '    if(raw_insert_checksum!=Fingerprint(raw_insert.data(),n)||raw_query_checksum!=Fingerprint(raw_query.data(),q)||inserted_hash_checksum!=Fingerprint(inserted.data(),n)||query_hash_checksum!=Fingerprint(hashes.data(),q))throw std::runtime_error("input mutation");\n\tstd::cout << std::setprecision(17)')
 new=new.replace('    std::cout << ",exact_byte_ceiling_v1,fixed_serial_pure_serial_hash_parallel_pure_parallel_hash,";', '    std::cout << ",exact_byte_ceiling_v1," << k12_phase::Encode(phase_order) << \',\';')
 new=new.replace("    std::cout << '\\n';\n}",'''    std::cout << ",query_only,0," << raw_insert_checksum << ',' << raw_query_checksum << ',' << inserted_hash_checksum << ',' << query_hash_checksum << '\\n';
}''')
 new=new.replace('|| !repeats)','|| !repeats || repeats % 4)')
 start=new.index('#ifndef BF_EXTERNAL_ONLY',new.index('#define ADD'));stop=new.index('#undef ADD',start)
 new=new[:start]+'        BF_REGISTER_QUERY_FILTERS(ADD);\n'+new[stop:]
 new=new.replace('lookup_trials_ns,hash_lookup_trials_ns\\n','lookup_trials_ns,hash_lookup_trials_ns,measurement_mode,build_repeats,raw_insert_checksum,raw_query_checksum,inserted_hash_checksum,query_hash_checksum\\n')
 out['query.cpp']=new.encode();out['QUERY.patch']=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen/benchmark.cpp',tofile='query.cpp')).encode()
 return out,origins
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();files,origins=build()
 info={'parent_commit':PARENT,'native_commit':NATIVE,'origins':origins,'derived_files':{n:hashlib.sha256(b).hexdigest()for n,b in files.items()},'changes':['replace inactive registrations with exact15-type finite query panel','use pinned native optional Range/K12 headers','remove all repeated construction timers; single complete setup build','common hash scratch is batch-sized in query-only mode','balanced four-phase order and equal post-timer full-output validation','append explicit query-only/build_repeats0 metadata']}
 if a.write:
  for n,b in files.items():p=HERE/n;p.parent.mkdir(parents=True,exist_ok=True);p.write_bytes(b)
  (HERE/'DERIVATION.json').write_text(json.dumps(info,indent=2)+'\n')
 else:
  for n,b in files.items():assert (HERE/n).read_bytes()==b,n
  assert json.loads((HERE/'DERIVATION.json').read_text())==info
 print('PASS source-only derivation; no compiler/BF')
