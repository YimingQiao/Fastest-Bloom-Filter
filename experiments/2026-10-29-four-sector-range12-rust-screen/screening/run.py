#!/usr/bin/env python3
"""Fixed36-command/108-row public Rust K12 confirmation; no selection/tuning."""
if not __debug__:raise RuntimeError('Python -O is forbidden before any work')
import argparse,csv,datetime,io,json,os,subprocess,traceback
from pathlib import Path
from pins import HERE,STAGE,PROPOSAL,PROOF,CALLER,sha,save,need,verify,require_lease,host,environment
from contract import configuration,command,rows,quality,audit,validate_stderr
from guard import validate_rows

def utc():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(3);freeze=verify(args.source_commit);protocol,selection,measured,source=configuration()
    output=STAGE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve prior attempts; no implicit resume/replay')
    output.mkdir();meta=dict(complete=False,started_utc=utc(),source_commit=args.source_commit,proposal_commit=PROPOSAL,proof_commit=PROOF,caller_source_commit=CALLER,
       binary=freeze['binary'],binary_sha256=freeze['binary_sha256'],protocol_sha256=sha(STAGE/'protocol.json'),selection_sha256=sha(STAGE/'selection.json'),execution_freeze_sha256=sha(HERE/'freeze.json'),
       host=host(),environment=environment(),lease=lease,affinity=sorted(os.sched_getaffinity(0)),cases=[],performance_run=True,measurement_sessions=1,
       query_contracts=protocol['metrics']['query'],build_contracts=protocol['metrics']['build'],case_scope=protocol['case_scope'],build_scope=protocol['build_scope'],numa_policy='not set',codegen_caveat='Unchanged visible K12 calls contains_scalar once per key; no new hint')
    save(output/'metadata.json',meta);aggregate=[]
    try:
        for index,case in enumerate(selection['cases']):
            need(require_lease(3)==lease and sha(Path(freeze['binary']))==freeze['binary_sha256'],'Lease/binary drift before case')
            entry=dict(index=index,case=case,command=command(freeze['binary'],case),started_utc=utc(),complete=False);meta['cases'].append(entry);save(output/'metadata.json',meta)
            result=subprocess.run(entry['command'],cwd=STAGE,pass_fds=tuple(lease['inherited_lock_descriptors']),capture_output=True)
            for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
                path=output/f'case-{index:02d}.{stream}';path.write_bytes(data);entry[stream]=path.name;entry[stream+'_sha256']=sha(path)
            entry['returncode']=result.returncode;entry['ended_utc']=utc();save(output/'metadata.json',meta)
            need(result.returncode==0,'Measurement failed; raw attempt retained')
            validate_stderr(result.stderr)
            parsed=rows(result.stdout.decode());validate_rows(parsed,case,measured,source);entry['rows']=len(parsed);entry['complete']=True;aggregate.extend(parsed)
            with (output/'results.csv').open('w',newline='')as f:
                writer=csv.DictWriter(f,fieldnames=list(aggregate[0]),lineterminator='\n');writer.writeheader();writer.writerows(aggregate)
            save(output/'metadata.json',meta);print(f'Complete case {index+1}/36; validated rows {len(aggregate)}/108',flush=True)
        need(len(aggregate)==108,'Incomplete fixed row set');save(output/'quality.json',quality(aggregate))
        verify(args.source_commit);need(require_lease(3)==lease,'Final lease drift')
        meta.update(complete=True,ended_utc=utc(),case_count=36,row_count=108,quality_record_count=36,all_seed_gate_count=12,results_sha256=sha(output/'results.csv'),quality_sha256=sha(output/'quality.json'))
        save(output/'metadata.json',meta);save(output/'AUDIT.json',audit(output,args.source_commit,freeze));print('Complete108; all source, raw, phase, quality and final guards pass',flush=True)
    except BaseException as error:
        meta.update(complete=False,error=repr(error),traceback=traceback.format_exc(),failed_utc=utc());save(output/'metadata.json',meta);raise
if __name__=='__main__':main()
