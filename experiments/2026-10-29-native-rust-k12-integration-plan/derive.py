#!/usr/bin/env python3
"""Source-only optional native packaging; never writes the production crate."""
import argparse,difflib,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
BASE='c7044ede8afb521cf6111954709e03da1d2775b6'
NATIVE='0c0eb382a817245e379b01339ecd71b747bd5cea'
PREFIX='experiments/2026-10-29-rust-k12-single-line/native/src/'
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT).decode()
def need(ok,msg):
 if not ok:raise ValueError(msg)
def function(source,name):
 start=source.index('pub(crate) fn '+name+'(')if'pub(crate) fn '+name+'('in source else source.index('pub(crate) fn '+name+'<')
 begin=source.index('{',start);level=1;end=begin+1
 while level:
  if source[end]=='{':level+=1
  elif source[end]=='}':level-=1
  end+=1
 return start,end,source[start:end]
def outputs():
 kernel=blob(NATIVE,PREFIX+'four_sector_range12.rs');helper=blob(NATIVE,PREFIX+'layout_parallel.rs');tests=blob(NATIVE,PREFIX+'tests.rs')
 common=blob(BASE,'rust/src/layout_parallel.rs');workers=blob(BASE,'rust/src/parallel.rs');oldworkers=blob(NATIVE,PREFIX+'parallel.rs')
 # Existing utility bodies have precisely the same bytes. Keep stable native
 # modules untouched; only the K12 generic insert needs its own physical owner.
 shared=['backends','backend','build_workers','scratch_bytes','lookup']
 for name in shared:
  need(function(helper,name)[2]==function(common,name)[2],'Shared utility differs: '+name)
 need(function(workers,'workers')[2]==function(oldworkers,'workers')[2],'Worker policy differs')
 for name in shared:
  start,end,_=function(helper,name);helper=helper[:start]+helper[end:]
 helper=helper.replace('use crate::parallel::workers;','pub(crate) use crate::layout_parallel::{backend, backends, build_workers, lookup, scratch_bytes};')
 kernel=kernel.replace('use crate::{layout_parallel, SizeError};','use crate::{k12_parallel as layout_parallel, SizeError};').replace('#[path = "tests.rs"]','#[path = "four_sector_range12_tests.rs"]')
 before=blob(BASE,'rust/src/lib.rs');after=before.replace('mod four_sector;','mod four_sector;\nmod four_sector_range12;\nmod k12_parallel;').replace('pub use four_sector::FourSectorBloomFilter;','pub use four_sector::FourSectorBloomFilter;\npub use four_sector_range12::FourSectorRange12BloomFilter;')
 need(before!=after,'Missing expected native exports')
 patch=''.join(difflib.unified_diff(before.splitlines(True),after.splitlines(True),fromfile='a/rust/src/lib.rs',tofile='b/rust/src/lib.rs'))
 return {'proposed/rust/src/four_sector_range12.rs':kernel,'proposed/rust/src/k12_parallel.rs':helper,'proposed/rust/src/four_sector_range12_tests.rs':tests,'lib.patch':patch}
def main():
 p=argparse.ArgumentParser();p.add_argument('--check',action='store_true');a=p.parse_args()
 for name,text in outputs().items():
  path=HERE/name
  if a.check:need(path.read_text()==text,'Derived source drift: '+name)
  else:path.parent.mkdir(parents=True,exist_ok=True);path.write_text(text)
 print('Exact source-only packaging verified; no production writes/build/BF')
if __name__=='__main__':main()
