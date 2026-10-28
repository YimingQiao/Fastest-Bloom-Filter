#!/usr/bin/env python3
"""Execute only the prespecified protocol; hold its socket flock externally."""
import csv
import hashlib
import io
import json
from pathlib import Path
import subprocess
import time

HERE=Path(__file__).resolve().parent
ARCHIVE=HERE.parent
ROOT=ARCHIVE.parents[1]
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def main():
    protocol=json.loads((HERE/'protocol.json').read_text())
    assert sha(ARCHIVE/'FREEZE.json')==protocol['archive_freeze_sha256']
    freeze=json.loads((ARCHIVE/'FREEZE.json').read_text())
    for relative,digest in freeze['files'].items():assert sha(ARCHIVE/relative)==digest,relative
    binary=ROOT/protocol['binary'];assert sha(binary)==protocol['binary_sha256']
    out=HERE/'results';out.mkdir(exist_ok=False)
    metadata={'utc_start':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'protocol':protocol,
              'protocol_sha256':sha(HERE/'protocol.json'),'runner_sha256':sha(Path(__file__)),
              'framework_freeze':freeze,'cpu':subprocess.check_output(['lscpu'],text=True),
              'cpu_topology':subprocess.check_output(['lscpu','-e=CPU,CORE,SOCKET,NODE'],text=True),
              'compile_commands':json.loads((binary.parent/'compile_commands.json').read_text()),'runs':[]}
    writer=None;count=0
    try:
        with (out/'results.csv').open('w',newline='') as file:
            for case in protocol['cases']:
                t=case['threads'];n=1<<case['key_power']
                mask=','.join(map(str,protocol['cpus'][:t]))
                cmd=['numactl',f'--physcpubind={mask}',f'--membind={protocol["numa_node"]}',str(binary),
                     str(case['key_power']),str(case['requested_bpk']),str(protocol['hit_percent']),str(protocol['query_power']),
                     str(protocol['batch']),str(protocol['repeats']),str(protocol['seed']),','.join(protocol['filters']),
                     str(n),str(protocol['calibration_power']),str(t),mask]
                started=time.monotonic()
                rows=list(csv.DictReader(io.StringIO(subprocess.check_output(cmd,text=True))))
                assert len(rows)==23 and {r['filter'] for r in rows}==set(protocol['filters'])
                for row in rows:
                    assert int(row['threads'])==t and int(row['spawned_threads'])==t-1
                    assert int(row['insert_batch'])==n and int(row['keys'])==n
                if writer is None:writer=csv.DictWriter(file,fieldnames=list(rows[0]),lineterminator='\n');writer.writeheader()
                writer.writerows(rows);file.flush();count+=len(rows)
                metadata['runs'].append({'case':case,'command':cmd,'seconds':time.monotonic()-started,'rows':len(rows)})
                print(f'completed n=2^{case["key_power"]}, requested_bpk={case["requested_bpk"]}, T={t}, rows={count}',flush=True)
        assert count==protocol['expected_rows']
    finally:
        metadata['utc_end']=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())
        metadata['rows']=count
        metadata['source_changes']=[name for name,digest in freeze['files'].items() if sha(ARCHIVE/name)!=digest]
        metadata['binary_changed']=sha(binary)!=protocol['binary_sha256']
        (out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    assert not metadata['source_changes'] and not metadata['binary_changed']

if __name__=='__main__':main()
