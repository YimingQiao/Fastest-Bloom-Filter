#!/usr/bin/env python3
"""Prespecified query-only grid. Requires root-reviewed freeze and source commit."""
import argparse,csv,hashlib,io,json,subprocess,time
from pathlib import Path
from validate_rows import validate
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-commit',required=True)
    p.add_argument('--output-dir',type=Path,required=True)
    a=p.parse_args()
    assert len(a.source_commit)==40 and all(c in '0123456789abcdef' for c in a.source_commit)
    subprocess.run(['git','cat-file','-e',a.source_commit+'^{commit}'],cwd=ROOT,check=True)
    protocol=json.loads((HERE/'protocol.json').read_text())
    freeze=json.loads((HERE/'freeze.json').read_text())
    def verify():
        for name,digest in freeze['source_sha256'].items():assert sha(ROOT/name)==digest,name
        for name,digest in freeze['binary_sha256'].items():assert sha(ROOT/name)==digest,name
    verify()
    plan=json.loads((HERE/'planned-grid.json').read_text())
    assert len(plan['registry'])==72 and len(plan['configurations'])==960 and not plan['unsupported']
    assert len(plan['cases'])==14
    a.output_dir.mkdir(parents=True,exist_ok=False)
    metadata=dict(protocol=protocol,source_commit=a.source_commit,freeze_sha256=sha(HERE/'freeze.json'),
                  start_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),cases=[])
    (a.output_dir/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    all_rows=[]
    for i,case in enumerate(plan['cases']):
        verify()
        power,budget=case['key_power'],case['budget_bpk']
        command=['taskset','-c',str(protocol['cpu']),str(ROOT/protocol['binary']),str(power),str(budget),
                 '50',str(protocol['query_power']),str(protocol['batch']),str(protocol['query_repeats']),
                 str(protocol['seed']),','.join(case['filters']),str(1<<power),str(protocol['calibration_power']),
                 'query-only','0']
        stem=f'case-{i:02d}-n{power}-b{budget}'
        proc=subprocess.run(command,cwd=ROOT,text=True,capture_output=True)
        (a.output_dir/(stem+'.stdout')).write_text(proc.stdout)
        (a.output_dir/(stem+'.stderr')).write_text(proc.stderr)
        assert proc.returncode==0,(stem,proc.stderr)
        rows=list(csv.DictReader(io.StringIO(proc.stdout)))
        expected={r['filter']:r for r in plan['configurations'] if r['key_power']==power and int(r['requested_bpk'])==budget}
        assert set(expected)==set(case['filters'])
        validate(rows,expected,power=power,budget=budget,query_power=protocol['query_power'],
                 batch=protocol['batch'],repeats=protocol['query_repeats'],seed=protocol['seed'],calibration_power=protocol['calibration_power'])
        for row in rows:
            g=expected[row['filter']]
            row.update(configuration_id=g['configuration_id'],calibration_identity=g['calibration_identity'])
        all_rows.extend(rows)
        with (a.output_dir/'results.csv').open('w',newline='') as stream:
            writer=csv.DictWriter(stream,fieldnames=list(all_rows[0]),lineterminator='\n');writer.writeheader();writer.writerows(all_rows)
        metadata['cases'].append(dict(case=case,command=command,rows=len(rows),stdout_sha256=sha(a.output_dir/(stem+'.stdout'))))
        (a.output_dir/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
        print(f'Validated {i+1}/14 cases; {len(all_rows)}/960 rows',flush=True)
    verify();assert len(all_rows)==960
    metadata.update(all_frozen_sources_and_binaries_unchanged=True,complete=True,
                    end_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    (a.output_dir/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')

if __name__=='__main__':main()
