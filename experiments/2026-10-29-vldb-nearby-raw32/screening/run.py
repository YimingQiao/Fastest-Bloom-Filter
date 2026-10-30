#!/usr/bin/env python3
"""Fixed160 fresh-process rows from the already-proven unchanged public caller."""
import argparse,json,subprocess,time
from pathlib import Path
from screen_contract import HERE,STAGE,ROOT,need,plan,command,validate,original,parity,compare_old
from screen_guard import (verify,audit,sha,SOURCE,PROOF,BINARY_SHA,placement,
                          require_inherited_write_lock,lease,tuner_file)

def main():
    need(__debug__,'Python -O unsupported')
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-commit',required=True)
    p.add_argument('--cpu',type=int,required=True);p.add_argument('--lease',required=True);a=p.parse_args()
    need((a.cpu,a.lease)==(2,'socket0'),'Fixed CPU2/socket0 lease required')
    fds=require_inherited_write_lock(a.cpu,a.lease);held=lease(a.cpu,a.lease)
    need(sorted(held['inherited_lock_descriptors'])==fds,'Inherited lock mismatch');held['inherited_write_verified']=True
    where=placement(held);binary,freeze=verify(a.source_commit);planned=plan()
    output=HERE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve every prior attempt')
    output.mkdir();before=tuner_file()
    meta=dict(complete=False,scope='Same executable; separate fresh process per API/geometry/round; no old latency correction',
              source_commit=a.source_commit,producer_source_commit=SOURCE,proof_commit=PROOF,binary=str(binary),binary_sha256=BINARY_SHA,
              runner_preparation_sha256=sha(HERE/'PREPARATION.json'),planned_grid_sha256=sha(HERE/'planned-grid.json'),
              protocol_sha256=sha(HERE/'protocol.json'),worker_freeze_sha256=sha(STAGE/'WORKER_FREEZE.json'),
              analysis_rules_sha256=sha(HERE/'ANALYSIS_RULES.json'),**where,tuner_file_before=before,commands=[],rows=[],
              started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    def save():(output/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
    save()
    try:
        for i,item in enumerate(planned):
            need(require_inherited_write_lock(a.cpu,a.lease)==fds and placement(held)==where,'Whole-operation placement drift')
            c=item['case'];label=f'row{i:03d}'
            record=dict(label=label,round=item['round'],case=c,command=command(binary,c),stdout=label+'.stdout',stderr=label+'.stderr',complete=False)
            meta['commands'].append(record);save();start=time.monotonic()
            result=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
            for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
                path=output/record[stream];path.write_bytes(data);record[stream+'_sha256']=sha(path)
            record.update(returncode=result.returncode,diagnostic_process_seconds=time.monotonic()-start);save()
            need(result.returncode==0 and not result.stderr,'Fixed invocation failed; all partial records retained')
            row=dict(round=item['round'],**validate(original.parse_one(result.stdout.decode()),c));compare_old(row)
            meta['rows'].append(row);parity(meta['rows']);record['complete']=True;save()
            need(tuner_file()==before,'User tuner changed')
            print(f'{i+1}/160 rows validated; round{item["round"]}; no partial ranking',flush=True)
        meta['tuner_file_after']=tuner_file();audit(output,meta,binary,a.source_commit,False)
        need(verify(a.source_commit)==(binary,freeze)and require_inherited_write_lock(a.cpu,a.lease)==fds and placement(held)==where,'Final frozen input/placement drift')
        meta.update(complete=True,all_frozen_inputs_unchanged=True,process_rows=160,query_mode_records=480,
                    api_geometry_quality_records=80,proven_mapping_records=48,semantic_reproductions=144,
                    finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
        save();audit(output,meta,binary,a.source_commit)
        print('PASS160 raw32 rows/480 modes, both rounds, all losses retained; no old timing import',flush=True)
    except BaseException as error:meta.update(complete=False,failure=repr(error));save();raise
if __name__=='__main__':main()
