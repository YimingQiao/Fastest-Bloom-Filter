#!/usr/bin/env python3
"""Alternate frozen native executables; retain every row and paired semantic check."""
import argparse
import csv
import hashlib
import io
import json
from pathlib import Path
import random
import subprocess
import time

ROOT = Path(__file__).resolve().parents[2]
ap = argparse.ArgumentParser(description=__doc__)
ap.add_argument('--before', default='build/early-rust-base/compare_benchmark')
ap.add_argument('--after', default='rust/target/release/compare_benchmark')
ap.add_argument('--output', required=True)
ap.add_argument('--cpu', type=int, default=2)
args = ap.parse_args()
out = Path(args.output)
out.mkdir(parents=True, exist_ok=False)
executables = {'before': (ROOT / args.before).resolve(), 'after': (ROOT / args.after).resolve()}
metadata = {'cpu_affinity': [args.cpu], 'utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
            'rustc': subprocess.check_output(['rustc','-Vv'],text=True),
            'RUSTFLAGS': '-C target-cpu=native',
            'cpu': subprocess.check_output(['lscpu'],text=True),
            'binary_sha256': {v: hashlib.sha256(p.read_bytes()).hexdigest() for v,p in executables.items()},
            'revision': subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),
            'runs': []}
(out/'source.patch').write_text(subprocess.check_output(['git','diff','HEAD'],cwd=ROOT,text=True))
rng = random.Random(2053)
with (out/'timing.csv').open('w',newline='') as f:
    writer = None
    for power in [16,24]:
        for bits in [8,16]:
            for batch in [1,3,4096]:
                for seed in [2053,4099]:
                    versions = list(executables)
                    rng.shuffle(versions)
                    pair = []
                    for version in versions:
                        command = ['taskset','-c',str(args.cpu),str(executables[version]),str(power),str(bits),'50','22',str(batch),'5',str(seed),'FastPatternBF',str(1<<power)]
                        start = time.monotonic()
                        run = subprocess.run(command,text=True,capture_output=True,check=True)
                        tag=f'k{power}-b{bits}-q{batch}-s{seed}-{version}'
                        (out/f'{tag}.csv').write_text(run.stdout)
                        if run.stderr:(out/f'{tag}.stderr').write_text(run.stderr)
                        rr=list(csv.DictReader(io.StringIO(run.stdout)))
                        assert len(rr)==1
                        r=rr[0];r['version']=version
                        if writer is None:
                            writer=csv.DictWriter(f,r.keys(),lineterminator='\n');writer.writeheader()
                        writer.writerow(r);f.flush();pair.append(r)
                        metadata['runs'].append({'command':command,'version':version,'seconds':time.monotonic()-start,'returncode':0})
                        (out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
                    for field in ['filter_bytes','result_checksum','false_positives','absent_queries']:
                        assert pair[0][field]==pair[1][field],(tag,field)
                    print(f'2^{power} requested{bits} batch{batch} seed{seed}: parity passed',flush=True)
for version,path in executables.items():
    assert hashlib.sha256(path.read_bytes()).hexdigest()==metadata['binary_sha256'][version], 'binary changed during run'
