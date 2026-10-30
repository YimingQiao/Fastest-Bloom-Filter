#!/usr/bin/env python3
"""The only formal execution entry: exact24 processes, no adaptive extensions."""
import argparse
import datetime
import json
import subprocess
import sys
if not __debug__:raise SystemExit('Python -O is unsupported')
from screen_contract import need,ledger,parse,validate_records
from pins import HERE,ROOT,sha,verify
from audit import RESULTS,command,validate_directory
import placement
def save(path,value):path.write_text(json.dumps(value,indent=2,allow_nan=False)+'\n')
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--source-commit',required=True);parser.add_argument('--execute-frozen',action='store_true');args=parser.parse_args()
    need(args.execute_frozen,'explicit frozen-execution flag required')
    freeze=verify(args.source_commit);lease=placement.require()
    need(not RESULTS.exists()and not RESULTS.is_symlink(),'fresh results path required')
    RESULTS.mkdir();records=[]
    metadata=dict(complete=False,source_commit=args.source_commit,started=now(),placement=lease,initial_freeze=freeze,cases=[])
    save(RESULTS/'metadata.json',metadata);save(RESULTS/'records.json',records)
    binary=freeze['normal_executable']['path'];expected_sha=freeze['normal_executable']['sha256']
    try:
        for index,case in enumerate(ledger()):
            need(sha(binary)==expected_sha,'normal executable changed')
            need(placement.require()==lease,'lease changed before case launch')
            inherited_fds=tuple(int(fd)for fd in lease['fd_evidence'])
            stdout=RESULTS/f'case-{index:03d}.stdout';stderr=RESULTS/f'case-{index:03d}.stderr';argv=command(binary,case)
            entry=dict(case=case,argv=argv,started=now(),stdout=stdout.name,stderr=stderr.name,binary_sha256=expected_sha,inherited_lock_fds=list(inherited_fds))
            metadata['cases'].append(entry);save(RESULTS/'metadata.json',metadata)
            with stdout.open('wb')as out,stderr.open('wb')as err:completed=subprocess.run(argv,cwd=ROOT,stdout=out,stderr=err,pass_fds=inherited_fds)
            entry.update(exit_code=completed.returncode,finished=now(),stdout_sha256=sha(stdout),stderr_sha256=sha(stderr));save(RESULTS/'metadata.json',metadata)
            need(completed.returncode==0 and stderr.read_bytes()==b'','formal process failed or unexpected diagnostic')
            actual=parse(stdout.read_text(),case);records.append(dict(case=case,rows=actual));save(RESULTS/'records.json',records)
            validate_records(records,complete=False)
            print(f'{index+1}/24 processes complete',flush=True)
        counts,quality=validate_records(records);save(RESULTS/'quality.json',quality)
        final_freeze=verify(args.source_commit);final_placement=placement.require()
        need(freeze==final_freeze and lease==final_placement,'final execution identity changed')
        metadata.update(complete=True,finished=now(),counts=counts,final_freeze=final_freeze,final_placement=final_placement)
        save(RESULTS/'metadata.json',metadata);validate_directory(args.source_commit)
        files={p.name:dict(sha256=sha(p),bytes=p.stat().st_size)for p in sorted(RESULTS.iterdir())if p.is_file()}
        need(len(files)==51,'wrong raw artifact inventory');save(RESULTS/'RAW_ARCHIVE.json',dict(files=files,files_count=51))
        print('Complete24 processes/192 rows; all final source/raw/semantic guards passed.',flush=True)
    except BaseException as exc:
        metadata.update(complete=False,error=repr(exc),finished=now());save(RESULTS/'metadata.json',metadata);raise
if __name__=='__main__':main()
