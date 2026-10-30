#!/usr/bin/env python3
"""Original K12 native source plus one safe physical-line lookup reference."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PARENT='645f397cd406fd7e89cc75020b0b6fe2f142b3ab';BASE='experiments/2026-10-29-four-sector-range12-rust-port/native/'
BODY_OLD='''        let (indices, masks) = self.probe(hash);
        let mut pass = true;
        for (index, mask) in indices.into_iter().zip(masks) {
            pass &= self.lines[index as usize >> 4].0[index as usize & 15] & mask == mask;
        }
        pass'''
BODY_NEW='''        let (indices, masks) = self.probe(hash);
        // probe_mask changes only the low four word-index bits across sectors.
        let line = &self.lines[indices[0] as usize >> 4].0;
        let mut pass = true;
        for (index, mask) in indices.into_iter().zip(masks) {
            pass &= line[index as usize & 15] & mask == mask;
        }
        pass'''
def need(ok,msg):
    if not ok:raise ValueError(msg)
def blob(path):return subprocess.check_output(['git','show',PARENT+':'+path],cwd=ROOT)
def transformed(name,raw):
    s=raw.decode()
    if name in['Cargo.toml','Cargo.lock']:s=s.replace('four-sector-range12-isolated','four-sector-range12-single-line-isolated').replace('four_sector_range12_isolated','four_sector_range12_single_line_isolated')
    elif name=='src/bin/fixture.rs':s=s.replace('use four_sector_range12_isolated::','use four_sector_range12_single_line_isolated::',1)
    elif name=='src/four_sector_range12.rs':
        need(s.count(BODY_OLD)==1,'Expected unique original scalar lookup body');s=s.replace(BODY_OLD,BODY_NEW,1)
    elif name=='src/tests.rs':s+='\n'+(HERE/'line_invariant.rs').read_text()
    return s.encode()
def derive(write=False):
    records={};patch=[]
    for path in subprocess.check_output(['git','ls-tree','-r','--name-only',PARENT,'--',BASE],cwd=ROOT,text=True).splitlines():
        name=path.removeprefix(BASE);before=blob(path);after=transformed(name,before);out=HERE/'native'/name
        if write:out.parent.mkdir(parents=True,exist_ok=True);out.write_bytes(after)
        need(out.read_bytes()==after,'Native source drift '+name)
        records[name]=dict(parent_commit=PARENT,parent_path=path,parent_sha256=hashlib.sha256(before).hexdigest(),sha256=hashlib.sha256(after).hexdigest())
        if before!=after:patch+=difflib.unified_diff(before.decode().splitlines(True),after.decode().splitlines(True),fromfile='original/'+name,tofile='single-line/'+name)
    original=blob(BASE+'src/four_sector_range12.rs').decode();actual=(HERE/'native/src/four_sector_range12.rs').read_text()
    need(actual.replace(BODY_NEW,BODY_OLD,1)==original,'Additional production change')
    for fn in ['pub fn contains_hash','fn contains_scalar']:need('#[inline]\n    '+fn in actual,'Original inline hint changed')
    text=''.join(patch)
    if write:(HERE/'source.patch').write_text(text)
    need((HERE/'source.patch').read_text()==text,'Patch drift')
    return dict(parent_commit=PARENT,derived=records,production_body_changes=1,original_ordinary_inline_hints=True,new_unsafe=False,insert_dispatch_backend_parallel_unchanged=True,no_compilation_or_filter_execution=True)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');a=p.parse_args();print(json.dumps(derive(a.write),indent=2))
