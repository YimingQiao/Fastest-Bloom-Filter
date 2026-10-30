#!/usr/bin/env python3
"""One hints-only native clone and one added actual-public-caller configuration."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
NATIVE_COMMIT='645f397cd406fd7e89cc75020b0b6fe2f142b3ab';CALLER_COMMIT='72625673e6b5bb57874a5fa53e04d23ffb8c6ab2'
OLD_NATIVE='experiments/2026-10-29-four-sector-range12-rust-port/native/'
OLD_CALLER='experiments/2026-10-29-four-sector-range12-rust-screen/caller/benchmark/'
NAME='FourSectorRange12InlineV1'
def need(ok,msg):
    if not ok:raise ValueError(msg)
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
def replace(s,old,new):
    need(s.count(old)==1,'Nonunique derivation anchor '+old);return s.replace(old,new,1)
def transformed(kind,name,raw):
    s=raw.decode()
    if kind=='native':
        if name in ['Cargo.toml','Cargo.lock']:s=s.replace('four-sector-range12-isolated','four-sector-range12-inline-isolated').replace('four_sector_range12_isolated','four_sector_range12_inline_isolated')
        elif name=='src/bin/fixture.rs':s=replace(s,'use four_sector_range12_isolated::','use four_sector_range12_inline_isolated::')
        elif name=='src/four_sector_range12.rs':
            for fn in ['pub fn contains_hash','fn contains_scalar']:s=replace(s,'#[inline]\n    '+fn,'#[inline(always)]\n    '+fn)
    elif name=='Cargo.toml':
        s=replace(s,'fastest-bloom-filter-rust-k12-public-caller','fastest-bloom-filter-rust-k12-inline-caller');s=s.replace('path = "../../../2026-','path = "../../2026-')
        s=replace(s,'"four-sector-range12-isolated/disable-avx512"]','"four-sector-range12-isolated/disable-avx512", "k12_inline/disable-avx512"]')
        s=replace(s,'[dependencies]\n','[dependencies]\nk12_inline = { package = "four-sector-range12-inline-isolated", path = "../native" }\n')
    elif name=='Cargo.lock':
        s=replace(s,'fastest-bloom-filter-rust-k12-public-caller','fastest-bloom-filter-rust-k12-inline-caller')
        s=replace(s,' "four-sector-range12-isolated",',' "four-sector-range12-isolated",\n "four-sector-range12-inline-isolated",')
        s=replace(s,'[[package]]\nname = "four-sector-range12-isolated"','[[package]]\nname = "four-sector-range12-inline-isolated"\nversion = "0.0.0"\n\n[[package]]\nname = "four-sector-range12-isolated"')
    elif name=='src/main.rs':
        s='use k12_inline::FourSectorRange12BloomFilter as '+NAME+';\n'+s
        s=replace(s,'include!("k12_adapter.rs");','include!("k12_adapter.rs");\ninclude!("inline_adapter.rs");')
        s=replace(s,'    "FourSectorRange12BloomFilter",\n];','    "FourSectorRange12BloomFilter",\n    "'+NAME+'",\n];')
        old='            "FourSectorRange12BloomFilter" => run::<FourSectorRange12BloomFilter>(name, &inserted, &query, &c),'
        s=replace(s,old,old+'\n            "'+NAME+'" => run::<'+NAME+'>(name, &inserted, &query, &c),')
        s+='\n#[cfg(test)]\nmod inline_tests;\n'
    elif name=='src/geometry.rs':
        old='        "FourSectorRange12BloomFilter" => {\n            g.logical_bytes = budget / 64 * 64;\n            g.allocated_bytes = g.logical_bytes;\n            g.kind = "top24_range_lines";\n            g.effective_probes = 12;\n            g.origin = "K12_experiment";\n        }'
        new=old.replace('"FourSectorRange12BloomFilter"','"'+NAME+'"').replace('"K12_experiment"','"K12_inline_experiment"')
        s=replace(s,old,old+'\n'+new)
    return s.encode()
def derive(write=False):
    records={};patches=[]
    for kind,commit,base in [('native',NATIVE_COMMIT,OLD_NATIVE),('benchmark',CALLER_COMMIT,OLD_CALLER)]:
        names=subprocess.check_output(['git','ls-tree','-r','--name-only',commit,'--',base],cwd=ROOT,text=True).splitlines()
        for path in names:
            name=path.removeprefix(base);before=blob(commit,path);after=transformed(kind,name,before);out=HERE/kind/name
            if write:out.parent.mkdir(parents=True,exist_ok=True);out.write_bytes(after)
            need(out.read_bytes()==after,'Unexpected source delta '+str(out));records[str(out.relative_to(HERE))]=dict(commit=commit,path=path,parent_sha256=hashlib.sha256(before).hexdigest(),sha256=hashlib.sha256(after).hexdigest())
            if before!=after:patches+=difflib.unified_diff(before.decode().splitlines(True),after.decode().splitlines(True),fromfile='before/'+kind+'/'+name,tofile='after/'+kind+'/'+name)
    old=blob(CALLER_COMMIT,OLD_CALLER+'src/main.rs').decode();new=(HERE/'benchmark/src/main.rs').read_text();start='// Benchmark buffers use the same 4096-byte alignment';end='const FILTER_NAMES:'
    need(old[old.index(start):old.index(end)]==new[new.index(start):new.index(end)],'Timed/workload helper/body changed')
    adapter=blob(CALLER_COMMIT,OLD_CALLER+'src/k12_adapter.rs').decode().replace('FourSectorRange12BloomFilter',NAME)
    if write:(HERE/'benchmark/src/inline_adapter.rs').write_text(adapter)
    need((HERE/'benchmark/src/inline_adapter.rs').read_text()==adapter,'Added public adapter differs from old adapter')
    patch=''.join(patches)
    if write:(HERE/'source.patch').write_text(patch)
    need((HERE/'source.patch').read_text()==patch,'Patch drift')
    return dict(derived=records,native_algorithm_delta='Exactly two existing inline annotations become inline(always); all function bodies unchanged',package_identity_changed=True,all_old_adapters_unchanged=True,timed_workload_body_unchanged=True,registry_size=22)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');args=p.parse_args();print(json.dumps(derive(args.write),indent=2))
