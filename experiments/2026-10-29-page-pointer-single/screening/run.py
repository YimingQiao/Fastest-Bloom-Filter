#!/usr/bin/env python3
"""Fixed240 whole-flock caller comparison using a previously frozen binary."""
import argparse,json,subprocess,time
from pathlib import Path
from screen_contract import HERE,SOURCE,ROOT,plan,command,audit,validate,parity,compare_baseline,original,need
from screen_guard import verify,baseline,startup,sha,PROOF_COMMIT,placement

def main():
    need(__debug__,'Python -O unsupported')
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source-commit',required=True);p.add_argument('--cpu',type=int,required=True)
    p.add_argument('--lease',required=True);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
    held,tuner_file=startup(a.cpu,a.lease,a.output)
    inventory,freeze=verify(a.source_commit);old,old_provenance=baseline();planned=plan()
    need(planned==json.loads((HERE/'planned-grid.json').read_text()),'Frozen planner/order drift')
    a.output.mkdir(parents=True,exist_ok=False);before=tuner_file();binary=freeze['binaries']['native/page_pointer_control']['path']
    metadata=dict(scope='Same-executable Page pointer/value caller comparison; old-context semantics only, no latency normalization',
      source_commit=a.source_commit,preparation_sha256=sha(HERE/'PREPARATION.json'),proof_commit=PROOF_COMMIT,
      worker_freeze_sha256=sha(SOURCE/'WORKER_FREEZE.json'),caller_protocol_sha256=sha(SOURCE/'protocol.json'),
      planned_grid_sha256=sha(HERE/'planned-grid.json'),executable=binary,executable_sha256=sha(Path(binary)),
      **placement(held),tuner_file_before=before,old_context_semantic_provenance=old_provenance,
      old_context_latency_comparison=False,commands=[],rows=[],complete=False)
    def save():(a.output/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
    save();raws=[]
    for i,item in enumerate(planned):
        c=item['case'];label=f'row{i:03d}';cmd=command(binary,c)
        record=dict(label=label,round=item['round'],case=c,command=cmd,stdout=label+'.stdout',stderr=label+'.stderr',complete=False)
        metadata['commands'].append(record);save() # Preserve even an interrupted launch.
        started=time.monotonic();result=subprocess.run(cmd,cwd=ROOT,text=True,capture_output=True)
        raw=dict(stdout=result.stdout,stderr=result.stderr)
        for stream,text in raw.items():(a.output/record[stream]).write_text(text)
        record.update(returncode=result.returncode,diagnostic_process_seconds=time.monotonic()-started,
          stdout_sha256=sha(a.output/record['stdout']),stderr_sha256=sha(a.output/record['stderr']));save()
        need(result.returncode==0 and not result.stderr,label+' failed; partial observations retained')
        row=validate(original.parse_one(result.stdout),c);row=dict(round=item['round'],**row)
        compare_baseline([row],old);metadata['rows'].append(row);raws.append(raw);parity(metadata['rows'])
        record['complete']=True;need(tuner_file()==before,'Existing tuner file changed')
        need(placement(held)=={k:metadata[k]for k in ('lease','affinity','host','environment')},'Placement/environment changed');save()
        print(f'{i+1}/240 validated; round{item["round"]}, no partial ranking',flush=True)
    need(audit(metadata,raws,old,binary)==metadata['rows'],'Final raw-ledger reconstruction differs')
    verify(a.source_commit);old_final,provenance_final=baseline()
    need(old_final==old and provenance_final==old_provenance,'Frozen semantic reference changed')
    metadata.update(complete=True,unpooled_quality_identities=72,tuner_file_after=tuner_file(),all_sources_and_binaries_unchanged=True)
    need(metadata['tuner_file_after']==before,'Tuner drift after final audit');save()
    print('Complete240 caller rows; all3 modes, both rounds, all semantic/phase/source checks passed; no old-context timing correction')

if __name__=='__main__':main()
