#!/usr/bin/env python3
"""Run the fixed paired raw32 screen only after a separately committed proof."""
import argparse,json,subprocess,time
from pathlib import Path
from contract import HERE,ROOT,need,protocol,panel,arguments,parse_one,validate,parity,calibration_key
from source_guard import verify,startup,sha,committed

def frozen(commit):
    p=HERE/'WORKER_FREEZE.json';need(p.is_file(),'Missing successful worker freeze')
    need(committed(commit,p)==p.read_bytes(),'Worker freeze must be exact in the requested source commit')
    f=json.loads(p.read_text());need(f['preparation_sha256']==sha(HERE/'PREPARATION.json'),'Different preparation')
    for name,want in f['proof_artifacts'].items():
        p=ROOT/name;need(sha(p)==want and committed(commit,p)==p.read_bytes(),'Proof archive is not committed unchanged: '+name)
    for name,want in f['consumed_inputs'].items():need(sha(Path(name))==want,'Consumed compiler input changed: '+name)
    for r in f['binaries'].values():need(sha(Path(r['path']))==r['sha256'],'Frozen worker binary changed')
    return f

def main():
    need(__debug__,'Python -O unsupported')
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True)
    p.add_argument('--cpu',type=int,required=True);p.add_argument('--lease',required=True);p.add_argument('--output',type=Path,required=True)
    a=p.parse_args()
    # startup's new-path check also prevents accidentally appending/resuming a
    # partially failed screen; no CMake invocation is made by this driver.
    held,tuner_file=startup(a.cpu,a.lease,a.output);verify(a.source_commit);f=frozen(a.source_commit)
    a.output.mkdir(parents=True,exist_ok=False);initial=tuner_file();p=protocol();s=p['screen']
    need(s['worker_orders']==[['legacy','modern'],['modern','legacy']] and s['query_repeats']==6,'Unreviewed launch/order policy')
    plans={w:panel(w) for w in ('legacy','modern')}
    need(plans==json.loads((HERE/'planned-grid.json').read_text())['panels'],'Frozen geometry plan drift')
    need({w:len(x) for w,x in plans.items()}==p['screen_rows_per_round'],'Wrong selected row count')
    m=dict(scope='Paired separate-executable raw-u32 API/context screen; no cross-context correction',source_commit=a.source_commit,
      worker_freeze_sha256=sha(HERE/'WORKER_FREEZE.json'),lease=held,tuner_file_before=initial,commands=[],rows=[],complete=False)
    def save():(a.output/'metadata.json').write_text(json.dumps(m,indent=2)+'\n')
    save()
    for round_index,order in enumerate(s['worker_orders']):
        for worker in order:
            binary=Path(f['binaries']['native/'+worker]['path'])
            for geometry in plans[worker]:
                c=dict(worker=worker,filter=geometry['filter'],power=geometry['keys'].bit_length()-1,cap=geometry['requested_bpk'],
                       qpower=s['query_power'],hit=s['hit_percent'],seed=s['seeds'][0],calpower=s['calibration_power'],repeats=s['query_repeats'])
                cmd=[str(binary),*arguments(c,'--measure')];label='row'+str(len(m['rows'])).zfill(3);start=time.monotonic()
                result=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True)
                (a.output/(label+'.stdout')).write_text(result.stdout);(a.output/(label+'.stderr')).write_text(result.stderr)
                m['commands'].append(dict(label=label,round=round_index,worker=worker,case=c,command=cmd,
                   returncode=result.returncode,diagnostic_process_seconds=time.monotonic()-start));save()
                need(result.returncode==0,label+' failed; partial evidence retained without replacement')
                row=validate(parse_one(result.stdout),c);m['rows'].append(dict(round=round_index,**row));parity(m['rows'])
                need(tuner_file()==initial,'Existing tuner file changed');save()
    need(len(m['rows'])==p['screen_total_rows'],'Incomplete fixed screen')
    need(len(set(calibration_key(r) for r in m['rows']))==p['screen_quality_identities'],'Unexpected calibration alias coverage')
    verify(a.source_commit);frozen(a.source_commit)
    m.update(complete=True,tuner_file_after=tuner_file(),all_sources_and_binaries_unchanged=True,quality_identities=parity(m['rows']));save()
    print('Fixed paired raw32 screen complete; all API/round aliases retained, calibration not pooled')

if __name__=='__main__':main()
