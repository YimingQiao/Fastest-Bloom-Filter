#!/usr/bin/env python3
"""Pinned, randomized whole-build/phase measurements for cache partitions."""
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

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[2]

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--output',type=Path,required=True)
    p.add_argument('--binary',type=Path,default=REPO/'build/parallel-partitions-buffered/benchmark')
    p.add_argument('--key-powers',default='20,24')
    p.add_argument('--requested-bpk',default='8')
    p.add_argument('--threads',default='1,4,8')
    p.add_argument('--seeds',default='42')
    p.add_argument('--query-power',type=int,default=20)
    p.add_argument('--repeats',type=int,default=3)
    p.add_argument('--hit',type=int,default=50)
    p.add_argument('--families',default='all')
    p.add_argument('--cpus',default='3,5,7,9,11,13,15,17')
    p.add_argument('--numa-node',type=int,default=1)
    args = p.parse_args()
    out=args.output.resolve();out.mkdir(parents=True,exist_ok=False)
    binary=args.binary.resolve();cpus=args.cpus.split(',')
    sources=[f for f in (HERE.parent/'snapshot').rglob('*') if f.is_file()]+[HERE.parent/'snapshot.json',HERE.parent/'partitioned_build.hpp',HERE.parent/'FREEZE.json']+[HERE/n for n in ('buffered_build.hpp','benchmark.cpp','check.cpp','CMakeLists.txt','run.py','check_benchmark.py')]
    hashes={str(f.relative_to(REPO)):digest(f) for f in sources}
    meta={'utc_start':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'arguments':{**vars(args),'output':str(out),'binary':str(binary)},
          'binary_sha256':digest(binary),'sources':hashes,'snapshot':json.loads((HERE.parent/'snapshot.json').read_text()),
          'cpu':subprocess.check_output(['lscpu'],text=True),'cpu_topology':subprocess.check_output(['lscpu','-e=CPU,CORE,SOCKET,NODE'],text=True),
          'l2_per_core':Path(f'/sys/devices/system/cpu/cpu{cpus[0]}/cache/index2/size').read_text().strip(),
          'compiler':subprocess.check_output(['clang++','--version'],text=True),
          'compile_commands':json.loads((binary.parent/'compile_commands.json').read_text()),'runs':[],
          'affinity':'Each process is restricted to the first W listed physical CPUs; all worker threads inherit that mask. numactl binds allocation to the selected NUMA node. No per-thread fixed binding.',
          'timing_contract':'Bitmap allocation before timer; whole-build includes scratch allocation/count/prefix/scatter/insertion/thread setup+join/scratch release. All inserted and complete query outputs match serial reference outside timer.'}
    scenarios=list(itertools.product(*(v.split(',') for v in [args.key_powers,args.requested_bpk,args.threads,args.seeds])))
    random.Random(20261029).shuffle(scenarios)
    writer=None
    with (out/'timing.csv').open('w') as file:
        for power,bpk,workers,seed in scenarios:
            w=int(workers)
            if not 1<=w<=len(cpus):raise ValueError('explicit worker count must fit CPU list')
            mask=','.join(cpus[:w])
            cmd=['numactl',f'--physcpubind={mask}',f'--membind={args.numa_node}',str(binary),power,bpk,str(args.query_power),workers,str(args.repeats),seed,str(args.hit),args.families]
            started=time.monotonic()
            rows=list(csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True))))
            expected=27 if args.families=='all' else 9*len(args.families.split(','))
            assert len(rows)==expected,(len(rows),expected)
            for family in ('FastPattern','FourSector','Split64'):
                group=[r for r in rows if r['filter'].startswith(family)]
                if not group:continue
                assert len(group)==9
                for field in ('filter_bytes','result_checksum','false_positives','absent_queries'):
                    assert len({r[field] for r in group})==1,(family,field)
            if writer is None:
                writer=csv.DictWriter(file,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader()
            writer.writerows(rows);file.flush()
            meta['runs'].append({'command':cmd,'seconds':time.monotonic()-started})
            print(f'completed n=2^{power}, requested_bpk={bpk}, W={workers}, seed={seed}, affinity={mask}',flush=True)
    meta['utc_end']=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())
    meta['sources_changed_during_run']=[str(f.relative_to(REPO)) for f in sources if digest(f)!=hashes[str(f.relative_to(REPO))]]
    (out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')

if __name__=='__main__':main()
