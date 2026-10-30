#!/usr/bin/env python3
"""Run the preregistered isolated Rust tail before/after matrix serially."""
import argparse,csv,hashlib,io,json,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
EXP=Path(__file__).resolve().parent
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--mode',choices=['confirmation'],required=True)
p.add_argument('--cpu',type=int,default=3)
p.add_argument('--executable',type=Path,default=Path('/tmp/fastest-bf-rust-pattern-tail-selected/release/compare_benchmark'))
p.add_argument('--output',type=Path,required=True)
a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
protocol=json.loads((EXP/'selected-protocol.json').read_text())
config=protocol['initial' if a.mode=='initial' else 'confirmation_if_initial_justifies']
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
files=sorted((EXP/'benchmark-selected/src').glob('*.rs'))+[EXP/'benchmark-selected/Cargo.toml',EXP/'benchmark-selected/Cargo.lock',EXP/'selected-protocol.json']
metadata={'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'mode':a.mode,'cpu':a.cpu,'config':config,'revision':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip(),'rustc':subprocess.check_output(['rustc','-vV'],text=True),'rustflags':'-C target-cpu=native','source_sha256':{str(f.relative_to(ROOT)):sha(f) for f in files},'binary_sha256':sha(a.executable),'commands':[]}
fields=['filter_bytes','actual_bpk','result_checksum','false_positives','absent_queries','calibration_false_positives','calibration_absent_queries']
with (a.output/'results.csv').open('w',newline='') as f:
 writer=None
 for power in config['key_powers']:
  for bpk in config['requested_bpk']:
   for batch in config['batches']:
    for seed in config['seeds']:
     cmd=['taskset','-c',str(a.cpu),str(a.executable),str(power),str(bpk),str(config['hit_percent']),str(config['query_power']),str(batch),str(config['repeats']),str(seed),'',str(1<<power),str(config['calibration_power'])]
     result=subprocess.run(cmd,capture_output=True,text=True,check=True)
     rows=list(csv.DictReader(io.StringIO(result.stdout)))
     assert len(rows)==3 and {r['filter'] for r in rows}=={'FastPatternBefore','FastPatternMaskedTail','FastPatternGroupedTail'},cmd
     for field in fields:assert len({r[field] for r in rows})==1,(cmd,field,rows)
     if writer is None:writer=csv.DictWriter(f,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader()
     writer.writerows(rows);f.flush()
     (a.output/f'k{power}-p{bpk}-b{batch}-s{seed}.csv').write_text(result.stdout)
     metadata['commands'].append(cmd)
     (a.output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
     print(f'k{power} requested{bpk} batch{batch} seed{seed}: answers/bytes match',flush=True)
assert sha(a.executable)==metadata['binary_sha256']
assert all(sha(ROOT/f)==h for f,h in metadata['source_sha256'].items())
print(f'PASS: {len(metadata["commands"])} workloads / {3*len(metadata["commands"])} rows; source and binary unchanged')
