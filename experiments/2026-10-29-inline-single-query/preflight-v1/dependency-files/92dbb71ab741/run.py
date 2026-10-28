#!/usr/bin/env python3
"""Run an explicitly selected MT-query matrix; caller must hold the socket lock."""
import argparse
import csv
import hashlib
import io
import itertools
import json
from pathlib import Path
import random
import subprocess
import time

HERE=Path(__file__).resolve().parent
REPO=HERE.parents[1]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--binary',type=Path,default=REPO/'build/external-parallel-query/benchmark')
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--filters',required=True)
    p.add_argument('--key-powers',default='16')
    p.add_argument('--requested-bpk',default='8,16')
    p.add_argument('--threads',default='1,4,8')
    p.add_argument('--batches',default='31,4096')
    p.add_argument('--hits',default='50')
    p.add_argument('--seeds',default='2053,4099')
    p.add_argument('--query-power',type=int,default=22)
    p.add_argument('--calibration-power',type=int,default=24)
    p.add_argument('--repeats',type=int,default=5)
    p.add_argument('--insert-batch',type=int,default=4096)
    p.add_argument('--cpus',default='3,5,7,9,11,13,15,17')
    p.add_argument('--numa-node',type=int,default=1)
    a=p.parse_args()
    selected=a.filters.split(',')
    if any(not v for v in selected) or len(set(selected))!=len(selected):raise ValueError('explicit unique filter names required')
    binary=a.binary.resolve();out=a.output.resolve();out.mkdir(parents=True,exist_ok=False)
    cpus=a.cpus.split(',')
    files=[f for f in HERE.rglob('*') if f.is_file() and not f.is_relative_to(out) and f.suffix in ('.cpp','.hpp','.h','.py','.cmake')]
    files += [HERE/'snapshot.json',HERE/'CMakeLists.txt']
    # Compiler-generated dependency list captures actual upstream/system headers
    # as well as the frozen experiment sources used by this executable.
    deps=binary.parent/'CMakeFiles/benchmark.dir/benchmark.cpp.o.d'
    if deps.exists():
        text=deps.read_text().replace('\\\n',' ')
        files += [Path(f).resolve() for f in text.split(':',1)[1].split() if Path(f).is_file()]
    files=sorted(set(files))
    hashes={str(f):sha(f) for f in files}
    meta={'utc_start':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),
          'arguments':{**vars(a),'binary':str(binary),'output':str(out)},
          'binary_sha256':sha(binary),'sources':hashes,
          'compile_commands':json.loads((binary.parent/'compile_commands.json').read_text()),
          'cpu':subprocess.check_output(['lscpu'],text=True),
          'cpu_topology':subprocess.check_output(['lscpu','-e=CPU,CORE,SOCKET,NODE'],text=True),
          'query_protocol':'One immutable bitmap; caller worker0 plus T-1 pinned threads; global batch boundaries preserved; original direct serial controls and gated/fresh-thread end-to-end query times reported independently.',
          'statistics':'Calibration is the same sample for repeated T rows; do not pool it repeatedly. Do not use the serial external ranker, which lacks T/timing-mode dimensions.',
          'runs':[]}
    cases=list(itertools.product(*(v.split(',') for v in (a.key_powers,a.requested_bpk,a.threads,a.batches,a.hits,a.seeds))))
    random.Random(20261029).shuffle(cases)
    writer=None
    with (out/'timing.csv').open('w') as file:
        for power,bpk,workers,batch,hit,seed in cases:
            count=int(workers)
            if count<1 or count>len(cpus):raise ValueError('worker count exceeds explicit CPU pool')
            mask=','.join(cpus[:count])
            cmd=['numactl',f'--physcpubind={mask}',f'--membind={a.numa_node}',str(binary),power,bpk,hit,str(a.query_power),batch,str(a.repeats),seed,a.filters,str(a.insert_batch),str(a.calibration_power),workers,mask]
            start=time.monotonic()
            rows=list(csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True))))
            if len(rows)!=len(selected) or {r['filter'] for r in rows}!=set(selected):raise ValueError('filter selection mismatch')
            if any(r['threads']!=workers for r in rows):raise ValueError('worker count mismatch')
            if writer is None:writer=csv.DictWriter(file,fieldnames=list(rows[0]));writer.writeheader()
            writer.writerows(rows);file.flush()
            meta['runs'].append({'command':cmd,'seconds':time.monotonic()-start})
            print(f'completed n=2^{power}, requested={bpk}, T={workers}, batch={batch}, hit={hit}, seed={seed}',flush=True)
    meta['utc_end']=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())
    meta['sources_changed_during_run']=[str(f) for f in files if sha(f)!=hashes[str(f)]]
    meta['binary_changed_during_run']=sha(binary)!=meta['binary_sha256']
    (out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    if meta['sources_changed_during_run'] or meta['binary_changed_during_run']:raise RuntimeError('source or executable drift')

if __name__=='__main__':main()
