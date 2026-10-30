#!/usr/bin/env python3
import csv, hashlib, io, json, subprocess, time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent
EXE=ROOT/'build/split64/compare_benchmark'
meta={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'revision':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),'binary_sha256':hashlib.sha256(EXE.read_bytes()).hexdigest(),'files':{},'runs':[],'cpu':3,'compiler':subprocess.check_output(['clang++','--version'],text=True)}
for path in [OUT/'split64.hpp',OUT/'adapters.hpp',ROOT/'src/compare_benchmark.cpp']:
 meta['files'][str(path.relative_to(ROOT))]=hashlib.sha256(path.read_bytes()).hexdigest()
(OUT/'compile_commands.json').write_bytes((EXE.parent/'compile_commands.json').read_bytes())
for name,kp,qp,reps,bpks in [('accuracy',20,24,1,[4,8,16]),('large-timing',24,22,3,[8])]:
 with (OUT/(name+'.csv')).open('w',newline='') as f:
  writer=None
  for bpk in bpks:
   for seed in [42,43,44]:
    cmd=['taskset','-c','3',str(EXE),str(kp),str(bpk),'0',str(qp),'4096',str(reps),str(seed),'',str(1<<kp)]
    print(name,bpk,seed,flush=True)
    p=subprocess.run(cmd,text=True,capture_output=True,check=True)
    rows=list(csv.DictReader(io.StringIO(p.stdout)))
    assert len(rows)==6
    native=[r for r in rows if r['filter'].startswith('Split64')]
    assert len({r['result_checksum'] for r in native})==1
    if writer is None:writer=csv.DictWriter(f,fieldnames=rows[0].keys(),lineterminator='\n');writer.writeheader()
    writer.writerows(rows);f.flush()
    meta['runs'].append({'command':cmd,'returncode':p.returncode})
    (OUT/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
print('finished',flush=True)
