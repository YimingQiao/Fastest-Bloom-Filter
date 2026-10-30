#!/usr/bin/env python3
"""Exact old timed caller plus one native public adapter, registry and geometry."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
OLD='experiments/2026-10-29-rust-fastbloom-fixed-probes/benchmark/'
COMMIT='571186b420bf7e5fc08269ed4a65feab42ac8400'
CANDIDATE='FourSectorRange12BloomFilter'
FILES=['Cargo.toml','Cargo.lock','src/main.rs','src/geometry.rs','src/sbbf.rs','src/fixed_fastbloom.rs','src/tests.rs','src/exact_tests.rs','src/support/filter_selection.rs','src/support/query_validation.rs']

def need(ok,why):
    if not ok:raise ValueError(why)
def parent(name):return subprocess.check_output(['git','show',COMMIT+':'+OLD+name],cwd=ROOT)
def transformed(name,raw):
    text=raw.decode()
    if name=='Cargo.toml':
        text=text.replace('name = "fastest-bloom-filter-fastbloom-fixed-probes"','name = "fastest-bloom-filter-rust-k12-public-caller"',1)
        text=text.replace('path = "../../2026-10-29-split64-range-rust-screen/native"','path = "../../../2026-10-29-split64-range-rust-screen/native"',1)
        text=text.replace('disable-avx512 = ["fastest-bloom-filter/disable-avx512"]','disable-avx512 = ["fastest-bloom-filter/disable-avx512", "four-sector-range12-isolated/disable-avx512"]',1)
        text=text.replace('[dependencies]\n','[dependencies]\nfour-sector-range12-isolated = { path = "../../../2026-10-29-four-sector-range12-rust-port/native" }\n',1)
    elif name=='Cargo.lock':
        text=text.replace('name = "fastest-bloom-filter-fastbloom-fixed-probes"','name = "fastest-bloom-filter-rust-k12-public-caller"',1)
        needle=' "fastest-bloom-filter",\n';need(text.count(needle)==1,'Unexpected root lock dependency');text=text.replace(needle,needle+' "four-sector-range12-isolated",\n',1)
        needle='[[package]]\nname = "fastrange-rs"';text=text.replace(needle,'[[package]]\nname = "four-sector-range12-isolated"\nversion = "0.0.0"\n\n'+needle,1)
    elif name=='src/main.rs':
        text='use four_sector_range12_isolated::FourSectorRange12BloomFilter;\n'+text
        needle='struct Fastbloom017(fastbloom::BloomFilter);';text=text.replace(needle,'include!("k12_adapter.rs");\n\n'+needle,1)
        needle='    "Fastbloom017K12",\n];';need(needle in text,'Unexpected registry end');text=text.replace(needle,'    "Fastbloom017K12",\n    "FourSectorRange12BloomFilter",\n];',1)
        needle='            "SbbfSafePinned" => run::<SbbfSafePinned>(name, &inserted, &query, &c),';need(text.count(needle)==1,'Unexpected dispatch');text=text.replace(needle,needle+'\n            "FourSectorRange12BloomFilter" => run::<FourSectorRange12BloomFilter>(name, &inserted, &query, &c),',1)
        text+='\n#[cfg(test)]\nmod k12_tests;\n'
    elif name=='src/geometry.rs':
        needle='        "Fastbloom017" => {';need(text.count(needle)==1,'Unexpected geometry');text=text.replace(needle,'        "FourSectorRange12BloomFilter" => {\n            g.logical_bytes = budget / 64 * 64;\n            g.allocated_bytes = g.logical_bytes;\n            g.kind = "top24_range_lines";\n            g.effective_probes = 12;\n            g.origin = "K12_experiment";\n        }\n'+needle,1)
    return text.encode()

def derive(write=False):
    files={};patches=[]
    for name in FILES:
        before=parent(name);after=transformed(name,before);out=HERE/'benchmark'/name
        if write:out.parent.mkdir(parents=True,exist_ok=True);out.write_bytes(after)
        need(out.read_bytes()==after,'Unexpected caller delta '+name)
        files[name]=dict(parent_commit=COMMIT,parent_path=OLD+name,parent_sha256=hashlib.sha256(before).hexdigest(),sha256=hashlib.sha256(after).hexdigest(),changed=before!=after)
        if before!=after:patches.extend(difflib.unified_diff(before.decode().splitlines(True),after.decode().splitlines(True),fromfile='old/'+name,tofile='new/'+name))
    # The entire actual timer, raw-hash, workload/phase helpers and validators
    # between Aligned and the registry are exactly unchanged.
    old=parent('src/main.rs').decode();new=(HERE/'benchmark/src/main.rs').read_text();start='// Benchmark buffers use the same 4096-byte alignment';end='const FILTER_NAMES:'
    need(old[old.index(start):old.index(end)]==new[new.index(start):new.index(end)],'Timed helper/body changed')
    patch=''.join(patches)
    if write:(HERE/'caller.patch').write_text(patch)
    else:need((HERE/'caller.patch').read_text()==patch,'Patch drift')
    return dict(parent_commit=COMMIT,derived_files=files,unchanged_timed_body=True,unchanged_old_adapter_bodies=True,new_public_adapter='benchmark/src/k12_adapter.rs',new_focused_tests='benchmark/src/k12_tests.rs',registry_size=21)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');args=p.parse_args();print(json.dumps(derive(args.write),indent=2))
