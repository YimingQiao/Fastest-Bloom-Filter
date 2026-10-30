#!/usr/bin/env python3
"""Derive source only; never compile, resolve, instantiate or measure a filter."""
import argparse,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PLAN="1a4b37b8830e99f6091ab050096d62a4d431bb00"
PLAN_PATH="experiments/2026-10-29-fastbloom-rs-raw8-plan"
CALLER="72625673e6b5bb57874a5fa53e04d23ffb8c6ab2"
CALLER_PATH="experiments/2026-10-29-four-sector-range12-rust-screen/caller/benchmark"
NATIVE="ba5530a4fc38930a9da4593f2a8af7d1de3c853a"
UPSTREAM="ea18d38eca9cb3a48f395f28ab67004b6f1ab83e"
UPSTREAM_CHECKOUT=Path("/tmp/fastest-bf-fastbloom-rs-ea18d38")
def git(*args,cwd=ROOT):return subprocess.check_output(["git",*args],cwd=cwd)
def blob(commit,path):return git("show",commit+":"+path)
def digest(data):return hashlib.sha256(data).hexdigest()
def derived():
 out={};records=[]
 def copy(commit,path,dest):
  data=blob(commit,path);out[dest]=data;records.append(dict(commit=commit,path=path,destination=dest,sha256=digest(data)))
 for path in git("ls-tree","-r","--name-only",NATIVE,"rust").decode().splitlines():
  copy(NATIVE,path,"native/"+path.removeprefix("rust/"))
 assert git("rev-parse","HEAD",cwd=UPSTREAM_CHECKOUT).decode().strip()==UPSTREAM
 assert not git("status","--porcelain",cwd=UPSTREAM_CHECKOUT).strip()
 for path in git("ls-tree","-r","--name-only",UPSTREAM,"fastbloom-rs","README.md","LICENSE",cwd=UPSTREAM_CHECKOUT).decode().splitlines():
  data=git("show",UPSTREAM+":"+path,cwd=UPSTREAM_CHECKOUT);dest="upstream/"+path
  out[dest]=data;records.append(dict(repository="https://github.com/yankun1992/fastbloom",commit=UPSTREAM,path=path,destination=dest,sha256=digest(data)))
 for name in ["raw_contract.rs","fastbloom_rs_adapter.rs","reporter.rs"]:
  copy(PLAN,PLAN_PATH+"/proposed/"+name,"benchmark/src/"+name)
 # Test-only observer/fault hooks are absent from every normal measurement build.
 reporter=out["benchmark/src/reporter.rs"].decode()
 replacements=[
  ('        let a = Instant::now();','        let a = Instant::now();\n        #[cfg(test)] crate::tests::lifecycle("complete_start");'),
  ('        let mut build_scratch = Scratch::new(build_words);','        let mut build_scratch = Scratch::new(build_words);\n        #[cfg(test)] crate::tests::lifecycle("scratch_ready");'),
  ('        let mut fresh = F::new(c.n, c.bpk).unwrap();','        let mut fresh = F::new(c.n, c.bpk).unwrap();\n        #[cfg(test)] crate::tests::lifecycle("filter_ready");'),
  ('        let done = Instant::now();','        let done = Instant::now();\n        #[cfg(test)] crate::tests::lifecycle("insert_done");'),
  ('        drop(fresh);','        #[cfg(test)] crate::tests::lifecycle("validated");\n        drop(fresh);'),
  ('        drop(build_scratch);','        drop(build_scratch);\n        #[cfg(test)] crate::tests::lifecycle("build_dropped");'),
  ('    let mut filter=F::new(c.n,c.bpk).unwrap();','    let mut filter=F::new(c.n,c.bpk).unwrap();\n    #[cfg(test)] crate::tests::lifecycle("canonical_before_scratch");'),
  ('        let mut canonical_build_scratch=Scratch::new(build_words);','        let mut canonical_build_scratch=Scratch::new(build_words);\n        #[cfg(test)] crate::tests::lifecycle("canonical_scratch_ready");'),
  ('    // Only API-required batch workspace lives through the query phase.','    #[cfg(test)] crate::tests::lifecycle("canonical_scratch_dropped");\n    // Only API-required batch workspace lives through the query phase.'),
  ('    let mut query_scratch=Scratch::new(query_words);','    let mut query_scratch=Scratch::new(query_words);\n    #[cfg(test)] crate::tests::lifecycle("query_scratch_ready");'),
 ]
 for before,after in replacements:
  assert reporter.count(before)==1,before
  reporter=reporter.replace(before,after)
 reporter+='\n#[cfg(test)]\nmod tests { include!("reporter_tests.rs"); }\n'
 out["benchmark/src/reporter.rs"]=reporter.encode()
 raw=out["benchmark/src/raw_contract.rs"].decode()
 before='    for (&value, answer) in raw.iter().zip(out) { *answer = filter.contains_raw(value) as u32; }'
 assert raw.count(before)==1
 after='    #[cfg(test)] crate::tests::begin_visible();\n    for (&value, answer) in raw.iter().zip(out) {\n        #[cfg(test)] if crate::tests::skip_visible_write(value) { continue; }\n        *answer = filter.contains_raw(value) as u32;\n        #[cfg(test)] crate::tests::corrupt_visible_write(value, answer);\n    }'
 out["benchmark/src/raw_contract.rs"]=raw.replace(before,after).encode()
 out["benchmark/src/fastbloom_rs_adapter.rs"]+=b'\n#[cfg(test)]\nmod tests { include!("fastbloom_rs_tests.rs"); }\n'
 for name in ["support/filter_selection.rs","support/query_validation.rs","k12_adapter.rs"]:
  copy(CALLER,CALLER_PATH+"/src/"+name,"benchmark/src/"+name)
 # Keep public wrappers exactly, omit only previously proven old test modules.
 for name in ["sbbf.rs","fixed_fastbloom.rs"]:
  data=blob(CALLER,CALLER_PATH+"/src/"+name);head=data.split(b"#[cfg(test)]\nmod ",1)[0]
  out["benchmark/src/"+name]=head
  records.append(dict(commit=CALLER,path=CALLER_PATH+"/src/"+name,destination="benchmark/src/"+name,recipe="exact prefix before old cfg(test) module",sha256=digest(data),derived_sha256=digest(head)))
 old=blob(CALLER,CALLER_PATH+"/src/main.rs").decode()
 prefix=old[:old.index("// Benchmark buffers")]
 prefix=prefix.replace("use four_sector_range12_isolated::FourSectorRange12BloomFilter;","use fastest_bloom_filter::FourSectorRange12BloomFilter;").replace("    time::Instant,\n", "")
 helpers=blob(PLAN,PLAN_PATH+"/proposed/reused_helpers.rs").decode()
 registry=old[old.index("const FILTER_NAMES:"):old.index("fn main() {")]
 assert registry.endswith("];\n\n")
 registry=registry[:-4]+"".join('    "FastbloomRsRawK%d",\n'%k for k in range(1,25))+"];\n\n"
 main=old[old.index("fn main() {"):old.index("\n#[cfg(test)]\nmod tests;")]
 header_begin=main.index('    println!("language,filter,')
 header_end=main.index('\n    shuffle(&mut jobs,',header_begin)
 main=main[:header_begin]+'    report_header();'+main[header_end:]
 import re
 main=re.sub(r'run::<([^\n]+?)>\(name, &inserted, &query, &c\)',r'report::<CommonHash<\1>>(name, &inserted, &query, &c)',main)
 needle='            _ => unreachable!(),'
 assert main.count(needle)==1
 main=main.replace(needle,''.join('            "FastbloomRsRawK%d" => report::<FastbloomRsRaw<%d>>(name, &inserted, &query, &c),\n'%(k,k)for k in range(1,25))+needle)
 # Query batch never implicitly chooses the insertion workload.
 main=main.replace('let insert_batch = number(9, batch);','let insert_batch = number(9, 4096); // independent CLI default, formal choice remains unfrozen')
 declarations='\nmod raw_contract;\nmod fastbloom_rs_adapter;\nmod reporter;\nuse raw_contract::{CommonHash, RawFilter};\nuse fastbloom_rs_adapter::FastbloomRsRaw;\n#[path = "support/filter_selection.rs"]\nmod filter_selection;\n#[path = "support/query_validation.rs"]\nmod query_validation;\ninclude!("report.rs");\n'
 out["benchmark/src/main.rs"]=(prefix+helpers+declarations+registry+main+"\n#[cfg(test)]\nmod tests;\n").encode()
 geo=blob(CALLER,CALLER_PATH+"/src/geometry.rs").decode()
 newcase='        name if name.starts_with("FastbloomRsRawK") => {\n            let count: u32 = name.trim_start_matches("FastbloomRsRawK").parse()?;\n            if !(1..=24).contains(&count) { return Err("unknown raw8 probe count".into()); }\n            g.logical_bytes = budget / 8 * 8;\n            g.allocated_bytes = g.logical_bytes;\n            g.unit_bytes = 8;\n            g.kind = "raw8_classical_words";\n            g.effective_probes = count as i32;\n            g.probe_policy = "public_from_size_and_hashes";\n            g.constructor_argument = g.logical_bytes * 8;\n        }\n'
 geo=geo.replace('        _ => return Err("unknown geometry family".into()),',newcase+'        _ => return Err("unknown geometry family".into()),')
 geo=geo.replace('g.origin = "native_experimental";','g.origin = "optional_native_range";').replace('g.origin = "K12_experiment";','g.origin = "optional_native_k12";')
 out["benchmark/src/geometry.rs"]=geo.encode()
 for source in ["report.rs","allocation.rs","tests.rs","fastbloom_rs_tests.rs","reporter_tests.rs"]:out["benchmark/src/"+source]=(HERE/"authored"/source).read_bytes()
 for item in records:
  if "destination" in item and digest(out[item["destination"]]) != item["sha256"]:
   item.setdefault("recipe", "append cfg(test) proof or test-only observation hooks; normal body preserved")
   item["derived_sha256"]=digest(out[item["destination"]])
 out["SOURCE_RECIPES.json"]=(json.dumps(dict(proposal=PLAN,native=NATIVE,caller=CALLER,upstream=UPSTREAM,copy_or_test_derivations=records,parent_inputs=[dict(commit=CALLER,path=CALLER_PATH+"/src/"+name,sha256=digest(blob(CALLER,CALLER_PATH+"/src/"+name)))for name in ["main.rs","geometry.rs"]]+[dict(commit=PLAN,path=PLAN_PATH+"/proposed/reused_helpers.rs",sha256=digest(blob(PLAN,PLAN_PATH+"/proposed/reused_helpers.rs")))],main_recipe="retained public adapter prefix + exact proposed helpers/raw modules + authored raw CSV + original workload/CLI; registry adds24 direct controls; insertion default independently4096, future formal protocol must specify it",geometry_recipe="add public raw8 m/K, rename optional ownership metadata; unchanged retained constructor math"),indent=2)+"\n").encode()
 return out

def main():
 p=argparse.ArgumentParser();p.add_argument("--check",action="store_true");a=p.parse_args()
 for name,data in derived().items():
  dest=HERE/name
  if a.check:assert dest.read_bytes()==data,name
  else:dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
 print("Derived immutable native/upstream and45 public raw adapters; source-only")
if __name__=="__main__":main()
