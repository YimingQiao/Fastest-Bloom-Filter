#!/usr/bin/env python3
"""Prepared internal timing driver; invoke only after a root-approved socket lease."""
import argparse,csv,hashlib,json,math,subprocess,time
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--stage',choices=('small','large','full'),default='full')
parser.add_argument('--source-commit',required=True)
args=parser.parse_args()
preparation=json.loads((HERE/'timing-preparation.json').read_text())
for name,digest in preparation['files_sha256'].items():assert sha(ROOT/name)==digest,name
protocol=json.loads((HERE/'timing-protocol.json').read_text());freeze=json.loads((HERE/'freeze.json').read_text())
assert sha(HERE/'freeze.json')==protocol['correctness_freeze_sha256']
assert freeze['binary_sha256'][protocol['binary']]==protocol['binary_sha256']
inputs={str(p.relative_to(ROOT)):sha(p) for p in (HERE/'run_timing.py',HERE/'timing-protocol.json',ROOT/'scripts/run_comparison.py')}
def verify():
    for name,digest in {**freeze['source_sha256'],**freeze['binary_sha256'],**inputs}.items():assert sha(ROOT/name)==digest,name
verify();stage=protocol['prespecified_stages'][args.stage];output=HERE/('timing-'+args.stage)
assert not output.exists(),'Refusing to overwrite any timing evidence'
command=['python3',str(ROOT/'scripts/run_comparison.py'),'--executable',str(ROOT/protocol['binary']),'--output-dir',str(output),
 '--key-powers',','.join(map(str,stage['key_powers'])),'--bits-per-key',','.join(map(str,protocol['requested_bpk'])),
 '--hits',str(protocol['hit_percent']),'--batches',','.join(map(str,protocol['batches'])),'--seeds',str(protocol['seed']),
 '--query-power',str(protocol['query_power']),'--repeats',str(protocol['repeats']),'--cpu',str(protocol['cpu']),
 '--filters',','.join(protocol['filters']),'--insert-batch','0','--calibration-power','0','--binary-source-revision',args.source_commit]
manifest=dict(utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),stage=args.stage,command=command,protocol=protocol,runner_inputs_sha256=inputs,preparation_sha256=sha(HERE/'timing-preparation.json'),source_commit=args.source_commit)
(HERE/('timing-'+args.stage+'-freeze.json')).write_text(json.dumps(manifest,indent=2)+'\n')
subprocess.run(command,cwd=ROOT,check=True);verify()
rows=list(csv.DictReader((output/'results.csv').open()));assert len(rows)==stage['rows']
groups={}
for row in rows:
    key=tuple(int(row[k]) for k in ('keys','requested_bpk','batch'));groups.setdefault(key,[]).append(row)
    assert int(row['calibration_absent_queries'])==0
assert len(groups)==stage['workloads'];comparisons=[]
for key,group in sorted(groups.items()):
    assert len(group)==6 and {r['filter'] for r in group}==set(protocol['filters'])
    originals=[r for r in group if r['filter']=='Split64Original'];assert len(originals)==1;original=originals[0]
    for row in group:
        if row['filter']=='FastPatternBF':continue
        for field in ('filter_bytes','actual_bpk','result_checksum','false_positives','present_queries','absent_queries'):
            assert row[field]==original[field],(key,row['filter'],field)
        for metric in ('lookup_ns','hash_lookup_ns'):
            x,y=float(row[metric]),float(original[metric]);assert math.isfinite(x) and x>0 and math.isfinite(y) and y>0
            comparisons.append(dict(keys=key[0],requested_bpk=key[1],actual_bpk=float(row['actual_bpk']),batch=key[2],filter=row['filter'],metric=metric,candidate_ns=x,original_ns=y,candidate_over_original_latency=x/y))
result=dict(stage=args.stage,workloads=len(groups),rows=len(rows),all_split64_checksums_bytes_fp_equal=True,all_frozen_inputs_and_binaries_unchanged=True,
            scope='Exploratory seed42 internal query-kernel comparison, both metrics and all losses. No strongest-filter or held-out claim.',comparisons=comparisons)
(output/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
with (output/'comparisons.csv').open('w',newline='') as stream:
    writer=csv.DictWriter(stream,fieldnames=list(comparisons[0]),lineterminator='\n');writer.writeheader();writer.writerows(comparisons)
print('PASS internal timing stage',args.stage,stage['workloads'],'cases/',stage['rows'],'rows; exact Split64 semantics retained')
