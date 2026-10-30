#!/usr/bin/env python3
"""Source-only fixed geometry and exact reusable caller helpers; no BF/build."""
import argparse,csv,hashlib,io,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
CALLER='72625673e6b5bb57874a5fa53e04d23ffb8c6ab2'
CALLER_PATH='experiments/2026-10-29-four-sector-range12-rust-screen/caller/benchmark/src/main.rs'
POPPY='235090460f5bc063109c1cb3d40357673f36d50e'
POPPY_PATH='experiments/2026-10-29-poppy-public-speed-caller/benchmark/src/main.rs'
GEOMETRY='b94dc7b127ea9d26bd7f699aafc7f1d3caf76b6e'
GEOMETRY_PATH='experiments/2026-10-29-rust-fastbloom-fixed-probes/calibration-results/results.csv'
NATIVE='ba5530a4fc38930a9da4593f2a8af7d1de3c853a'
UPSTREAM='ea18d38eca9cb3a48f395f28ab67004b6f1ab83e'
def blob(c,p):return subprocess.check_output(['git','show',c+':'+p],cwd=ROOT)
def digest(data):return hashlib.sha256(data).hexdigest()
def derive():
 old=blob(CALLER,CALLER_PATH).decode();poppy=blob(POPPY,POPPY_PATH).decode();geometry=blob(GEOMETRY,GEOMETRY_PATH)
 # These are code/workload sources only. No Poppy result file is accessed.
 begin=old.index('// Benchmark buffers');end=old.index('#[inline(never)]\nfn lookup<',begin)
 helpers=old[begin:end]
 a=old.index('fn verify_dense_output(');b=old.index('#[inline(never)]\nfn insert<',a)
 c=old.index('fn consume(');d=old.index('fn run<F:',c)
 shared=helpers+old[a:b]+old[c:d]
 for part in [helpers,old[a:b],old[c:d]]:assert part in poppy
 rows=list(csv.DictReader(io.StringIO(geometry.decode())));assert len(rows)==112
 # Copy ONLY constructor geometry. Counts, quality and latency do not select rows.
 points=[]
 for row in rows:
  name=row['filter'];n=int(row['keys']);cap=int(row['requested_bpk'])
  origin=('production_native'if name in ['FastPatternBF','ByteSplitBloomFilter','FourSectorBloomFilter','Split64BloomFilter']else'optional_native_range'if name=='Split64RangeBloomFilter'else'retained_external')
  points.append(dict(configuration_id=f'{name}-n{n}-b{cap}',filter=name,keys=n,budget_bpk=cap,actual_bytes=int(row['filter_bytes']),logical_bytes=int(row['logical_bytes']),effective_probes=int(row['effective_probes']),probe_policy=row['probe_policy'],constructor_argument=int(row['constructor_argument']),owner=origin,raw_path='CommonHash',geometry_source='complete112 constructor records; quality columns not imported'))
 for n in[65536,33554432]:
  for cap in[16,24,32]:
   size=n*cap//8
   points.append(dict(configuration_id=f'FourSectorRange12BloomFilter-n{n}-b{cap}',filter='FourSectorRange12BloomFilter',keys=n,budget_bpk=cap,actual_bytes=size,logical_bytes=size,effective_probes=12,probe_policy='fixed',constructor_argument=size,owner='optional_native_k12',raw_path='CommonHash',geometry_source='proved current native public byte budget'))
   for k in range(1,25):
    name=f'FastbloomRsRawK{k}'
    points.append(dict(configuration_id=f'{name}-n{n}-b{cap}',filter=name,keys=n,budget_bpk=cap,actual_bytes=size,logical_bytes=size,effective_probes=k,probe_policy='public_from_size_and_hashes',constructor_argument=size*8,owner='fastbloom_rs_external',raw_path='DirectRaw8',geometry_source='fixed source-only public m/K panel',upstream_real_n_optimal_k={16:12,24:17,32:23}[cap],at_upstream_optimal_k=k=={16:12,24:17,32:23}[cap]))
 points.sort(key=lambda x:(x['keys'],x['budget_bpk'],x['filter']))
 assert len(points)==262 and len({p['configuration_id']for p in points})==262
 assert sum(p['owner']=='fastbloom_rs_external'for p in points)==144
 assert all(p['actual_bytes']*8<=p['keys']*p['budget_bpk']for p in points)
 sources=[dict(commit=c,path=p,sha256=digest(blob(c,p)))for c,p in[(CALLER,CALLER_PATH),(POPPY,POPPY_PATH),(GEOMETRY,GEOMETRY_PATH)]]
 return {'selection.json':json.dumps(dict(status='Source-only proposed fixed panel; not a formal execution authorization',new_geometries=144,retained_geometries=118,total_geometries=262,possible_three_batch_rows=786,points=points),indent=2)+'\n','REUSE.json':json.dumps(dict(caller_commit=CALLER,poppy_caller_commit=POPPY,native_commit=NATIVE,upstream_commit=UPSTREAM,source_inputs=sources,reused_helper_sha256=digest(shared.encode()),scope='Raw-only reporter changes clock body dispatch where required; no claim of whole timed-body byte identity. Data generation and listed helpers remain exact.'),indent=2)+'\n','proposed/reused_helpers.rs':shared}
def main():
 p=argparse.ArgumentParser();p.add_argument('--check',action='store_true');a=p.parse_args()
 for name,text in derive().items():
  path=HERE/name
  if a.check:assert path.read_text()==text,name
  else:path.write_text(text)
 print('Source-only262 geometries and exact reusable helpers verified; no compile/BF or partial Poppy data')
if __name__=='__main__':main()
