#!/usr/bin/env python3
"""Derive only local source snapshots. No compiler, constructor or workload execution."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
SHARED='6baeaeb88c89b9a4eed71f0a0aa1263c613289bd'
RANGE='81f40f16caa44586537d577f998c33fec4c22be8'
K12='e150be33b95a22dca9b75175e6174b9555c82393'

def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
def sha(data):return hashlib.sha256(data).hexdigest()
def derive():
    source={};out={}
    def read(commit,path):
        value=blob(commit,path);source[path]=dict(commit=commit,sha256=sha(value));return value
    base=read(SHARED,'benchmarks/vldb-raw32-stage3/native-snapshot/include/base.h')
    assert base==read(RANGE,'include/base.h')
    assert base==read(K12,'experiments/2026-10-29-split64-range-parallel-screen/snapshot/include/base.h')
    range_size=read(RANGE,'include/split64_range_size.h')
    old_size=read(K12,'experiments/2026-10-29-split64-range-parallel-screen/range-layouts/range_size.hpp')
    assert range_size==old_size
    out['snapshot/range/split64_range_bloom.h']=read(RANGE,'include/split64_range_bloom.h')
    out['snapshot/range/split64_range_size.h']=range_size
    raw_k12=read(K12,'experiments/2026-10-29-four-sector-range12-screen/four_sector_range12.h')
    old_include=b'#include "../2026-10-29-split64-range-parallel-screen/range-layouts/range_size.hpp"'
    assert raw_k12.count(old_include)==1
    def namespace(data):return re.sub(rb'\bbloom_filters\b',b'nearby_k12',data)
    out['snapshot/k12/base.h']=namespace(base)
    out['snapshot/k12/range_size.hpp']=namespace(old_size)
    out['snapshot/k12/four_sector_range12.h']=namespace(raw_k12.replace(old_include,b'#include "range_size.hpp"'))
    # Original public type for complete-byte fixture comparison. Only redirect an
    # include to the exact byte-identical sizing header already used by Range.
    out['snapshot/reference-k12/four_sector_range12.h']=raw_k12.replace(old_include,b'#include "../range/split64_range_size.h"')
    raw_hash=read(SHARED,'benchmarks/vldb-raw32-stage3/raw_hash.hpp').decode()
    begin=raw_hash.index('template<class F,class Policy> class RawHash {')
    end=raw_hash.index('using RawFastPattern=',begin)
    visible=raw_hash[begin:end].replace('RawHash','VisibleRawHash')
    point='  Geometry Info() const { return geometry_; }'
    assert visible.count(point)==1
    visible=visible.replace(point,point+'\n  const void* BitmapData() const { return filter_.Data(); }')
    out['snapshot/visible_raw_hash.hpp']=('#pragma once\n#include "raw_hash.hpp"\nnamespace raw32_stage3 {\n'+visible+'}\n').encode()
    return out,source

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--write',action='store_true');a=p.parse_args()
    out,source=derive()
    manifest=dict(scope='Only namespace/include routing plus read-only bitmap accessor; all timed method bodies unchanged',
                  source=source,files={name:sha(data)for name,data in out.items()})
    if a.write:
        for name,data in out.items():
            path=HERE/name;path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
        (HERE/'DERIVED.json').write_text(json.dumps(manifest,indent=2)+'\n')
    else:
        assert json.loads((HERE/'DERIVED.json').read_text())==manifest
        for name,data in out.items():assert(HERE/name).read_bytes()==data,name
    print('PASS exact source-only derivation; '+str(len(out))+' local headers')
if __name__=='__main__':main()
