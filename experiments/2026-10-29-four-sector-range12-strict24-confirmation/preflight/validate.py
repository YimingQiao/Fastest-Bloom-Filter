#!/usr/bin/env python3
"""Six existing-binary tiny commands/16 rows; no compiler or heldoutseed run."""
if not __debug__:raise RuntimeError('Use Python without -O')
import argparse
import json
import os
import platform
import subprocess
from bindings import HERE,STAGE,ROOT,need,sha,save,verify,require_lease
from subset_checks import CASES,SEED,SEMANTIC,command,order,validate_case,check_fixture_domain

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--source-commit',required=True);args=parser.parse_args()
    lease=require_lease(3);binaries,proof=verify(args.source_commit);fixture=check_fixture_domain()
    need(platform.uname()._asdict()==proof['host'],'Changed validated host')
    environment={k:os.environ.get(k)for k in proof['environment']};need(environment==proof['environment'],'Changed tested environment')
    output=STAGE/'validation-v1';need(not output.exists()and not output.is_symlink(),'Preserve old attempts');output.mkdir()
    meta=dict(complete=False,source_commit=args.source_commit,host=platform.uname()._asdict(),lease=lease,affinity=sorted(os.sched_getaffinity(0)),environment=environment,fixture=fixture,commands=[],binaries={k:dict(path=str(v),sha256=sha(v))for k,v in binaries.items()},compiler_runs=0,heldout_seed_runs=0)
    save(output/'metadata.json',meta)
    def run(label,cmd,asan=False,valid=True):
        need(require_lease(3)==lease,'Lease changed');env=os.environ.copy()
        if asan:env['ASAN_OPTIONS']='detect_leaks=1:halt_on_error=1'
        record=dict(label=label,command=cmd,complete=False,ASAN_OPTIONS=env.get('ASAN_OPTIONS'),stdout=label+'.stdout',stderr=label+'.stderr');meta['commands'].append(record);save(output/'metadata.json',meta)
        process=subprocess.run(cmd,cwd=ROOT,env=env,capture_output=True)
        for stream,data in [('stdout',process.stdout),('stderr',process.stderr)]:
            path=output/record[stream];path.write_bytes(data);record[stream+'_sha256']=sha(path)
        record['returncode']=process.returncode;save(output/'metadata.json',meta)
        need(process.returncode==0 and not process.stderr if valid else process.returncode!=0 and not process.stdout,'Unexpected subset/CLI result')
        record['complete']=True;save(output/'metadata.json',meta);return process.stdout.decode()
    try:
        records=[];reference={}
        for backend,binary in binaries.items():
            for i,case in enumerate(CASES):
                rows=validate_case(run(f'{backend}-{i}',command(binary,case),asan=backend=='asan'),case)
                for row in rows:
                    key=(case['cap'],row['filter']);value={k:row[k]for k in SEMANTIC}
                    need(key not in reference or reference[key]==value,'Normal/ASan full-output/quality/geometry drift');reference[key]=value;records.append(dict(backend=backend,**row))
        for label,seed in [('seed-overflow',1<<64),('seed-negative',-1)]:run(label,command(binaries['native'],CASES[0],seed),valid=False)
        need(len(records)==16 and len(reference)==8,'Wrong finite subset coverage');save(output/'semantic-records.json',records)
        final,final_proof=verify(args.source_commit);need(final==binaries and final_proof==proof and require_lease(3)==lease,'Final source/binary/lease drift')
        meta.update(complete=True,tiny_rows=16,semantic_geometries=8,invalid_seed_CLIs=2,final_frozen_inputs_equal=True);save(output/'metadata.json',meta)
        save(output/'ARCHIVE.json',dict(files={p.name:dict(sha256=sha(p),bytes=p.stat().st_size)for p in sorted(output.iterdir())if p.is_file()}))
        print('PASS16 tiny rows/8 union geometries native+ASan, maxu64 accepted, overflow/negative rejected; no compile or fresh seed',flush=True)
    except BaseException as error:meta.update(complete=False,failure=repr(error));save(output/'metadata.json',meta);raise
if __name__=='__main__':main()
