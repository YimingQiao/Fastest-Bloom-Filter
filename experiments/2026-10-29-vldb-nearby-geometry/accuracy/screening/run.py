#!/usr/bin/env python3
"""Execute only the frozen36 accuracy-only public-constructor points."""
import argparse
import json
import os
import platform
import subprocess
import sys
import time
from pilot_guard import HERE,STAGE,ROOT,PARENT,ORIGINAL,CALLER_PROOF,BINARY_SHA,need,sha,verify,audit,cases,command,parse,validate,quality
sys.path.insert(0,str(PARENT))
from startup_guards import require_inherited_write_lock
sys.path.insert(0,str(ORIGINAL))
from validate import lease,tuner_file

def save(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def main():
    need(__debug__,'Python -O is forbidden')
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True)
    parser.add_argument('--cpu',type=int,required=True);parser.add_argument('--lease',required=True)
    parser.add_argument('--execute-accuracy',action='store_true');args=parser.parse_args()
    need(args.execute_accuracy and(args.cpu,args.lease)==(2,'socket0'),'Explicit fixed CPU2 accuracy execution required')
    fds=require_inherited_write_lock(args.cpu,args.lease);held=lease(args.cpu,args.lease)
    need(sorted(held['inherited_lock_descriptors'])==fds,'Inherited lock mismatch')
    binary,freeze=verify(args.source_commit)
    environment={k:os.environ.get(k)for k in ['LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF',
        'MALLOC_ARENA_MAX','CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS']}
    need(not any(environment.values()),'Unfrozen loader/compiler environment')
    output=HERE/'results-v1';need(not output.exists()and not output.is_symlink(),'Preserve every prior attempt')
    output.mkdir();before=tuner_file()
    meta=dict(complete=False,source_commit=args.source_commit,caller_proof_commit=CALLER_PROOF,
              binary=str(binary),binary_sha256=BINARY_SHA,selection_sha256=sha(STAGE/'selection.json'),
              protocol_sha256=sha(STAGE/'protocol.json'),lease=held,affinity=sorted(os.sched_getaffinity(0)),
              host=platform.uname()._asdict(),environment=environment,tuner_file_before=before,commands=[],
              started_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
    save(output/'metadata.json',meta);rows=[]
    try:
        for i,case in enumerate(cases()):
            need(require_inherited_write_lock(args.cpu,args.lease)==fds,'Whole-operation lock changed')
            record=dict(case=case,command=command(binary,case),complete=False)
            meta['commands'].append(record);save(output/'metadata.json',meta)
            start=time.monotonic();result=subprocess.run(record['command'],cwd=ROOT,capture_output=True)
            for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:
                path=output/(f'case-{i:02d}.'+stream);path.write_bytes(data)
                record[stream]=path.name;record[stream+'_sha256']=sha(path)
            record.update(returncode=result.returncode,diagnostic_process_seconds=time.monotonic()-start)
            save(output/'metadata.json',meta)
            need(result.returncode==0 and not result.stderr,'Accuracy invocation failed; preserve raw evidence')
            row=parse(result.stdout.decode());validate(row,case);rows.append(row)
            record.update(complete=True,row=row);save(output/'results.json',rows);save(output/'metadata.json',meta)
            need(tuner_file()==before,'User tuner file changed')
            print(f'{i+1}/36 fixed accuracy points validated; no timing or adaptive selection',flush=True)
        save(output/'quality.json',quality(rows));meta['tuner_file_after']=tuner_file()
        audit(output,meta,binary,args.source_commit,final=False)
        need(verify(args.source_commit)==(binary,freeze)and require_inherited_write_lock(args.cpu,args.lease)==fds,
             'Final source/binary/lease drift')
        meta.update(complete=True,all_frozen_inputs_unchanged=True,rows=36,old_reproductions=24,new_geometries=12,
                    throughput_samples=0,pooled=False,results_sha256=sha(output/'results.json'),
                    quality_sha256=sha(output/'quality.json'),finished_utc=time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()))
        save(output/'metadata.json',meta);audit(output,meta,binary,args.source_commit)
        print('PASS36 accuracy-only points;24 old reproductions,12 nearby geometries; no timing',flush=True)
    except BaseException as error:
        meta.update(complete=False,failure=repr(error));save(output/'metadata.json',meta);raise

if __name__=='__main__':main()
