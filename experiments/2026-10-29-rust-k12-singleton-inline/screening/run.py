#!/usr/bin/env python3
"""Fixed24-command/72-row internal codegen comparison; no new calibration."""
if not __debug__:raise RuntimeError('Python -O is forbidden before any work')
import argparse,csv,datetime,json,os,subprocess,traceback
from pathlib import Path
from pins import *
from contract import configuration,command,rows,quality_context,audit,validate_case,validate_stderr

def utc():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit',required=True);a=p.parse_args()
    lease=require_lease(3);freeze=verify(a.source_commit);protocol,cases,source=configuration()
    output=STAGE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve prior attempts; no implicit resume')
    output.mkdir();meta=dict(complete=False,started_utc=utc(),source_commit=a.source_commit,proposal_commit=PROPOSAL,proof_commit=PROOF,prior_raw_commit=PRIOR_RAW,
        binary=freeze['binary'],binary_sha256=freeze['binary_sha256'],protocol_sha256=sha(STAGE/'protocol.json'),order_sha256=sha(STAGE/'ORDER.json'),execution_freeze_sha256=sha(HERE/'freeze.json'),
        host=host(),environment=environment(),lease=lease,affinity=sorted(os.sched_getaffinity(0)),cases=[],performance_run=True,measurement_sessions=1,new_calibration_samples=0,
        query_contracts=protocol['query_contracts'],build_contracts=protocol['build_contracts'],seed_scope=protocol['seed_scope'],numa_policy='not set',codegen_caveat='Candidate has no hot singleton helper call but larger stack frames and code; no presumed speedup')
    save(output/'metadata.json',meta);aggregate=[]
    try:
        for index,case in enumerate(cases):
            need(require_lease(3)==lease and sha(Path(freeze['binary']))==freeze['binary_sha256'],'Lease/binary drift')
            record=dict(index=index,case=case,command=command(freeze['binary'],case),started_utc=utc(),complete=False);meta['cases'].append(record);save(output/'metadata.json',meta)
            result=subprocess.run(record['command'],cwd=STAGE,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
            for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
                path=output/f'case-{index:02d}.{stream}';path.write_bytes(data);record[stream]=path.name;record[stream+'_sha256']=sha(path)
            record.update(returncode=result.returncode,ended_utc=utc());save(output/'metadata.json',meta)
            need(result.returncode==0,'Failed measurement; raw attempt retained');validate_stderr(result.stderr)
            group=rows(result.stdout.decode());validate_case(group,case,protocol,source);record.update(rows=len(group),complete=True);aggregate+=group
            with(output/'results.csv').open('w',newline='')as f:
                writer=csv.DictWriter(f,fieldnames=list(aggregate[0]),lineterminator='\n');writer.writeheader();writer.writerows(aggregate)
            save(output/'metadata.json',meta);print(f'Complete case {index+1}/24; validated rows {len(aggregate)}/72',flush=True)
        need(len(aggregate)==72,'Incomplete fixed row set');save(output/'quality-context.json',quality_context(aggregate))
        verify(a.source_commit);need(require_lease(3)==lease,'Final lease drift')
        meta.update(complete=True,ended_utc=utc(),case_count=24,row_count=72,mapping_records=12,results_sha256=sha(output/'results.csv'),quality_context_sha256=sha(output/'quality-context.json'))
        save(output/'metadata.json',meta);save(output/'AUDIT.json',audit(output,a.source_commit,freeze));print('Complete72; exact source, order, phase, mapping and final guards pass',flush=True)
    except BaseException as error:
        meta.update(complete=False,error=repr(error),traceback=traceback.format_exc(),failed_utc=utc());save(output/'metadata.json',meta);raise
if __name__=='__main__':main()
