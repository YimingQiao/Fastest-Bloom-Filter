#!/usr/bin/env python3
"""Correctness and ASM only; run after explicit lease under one whole-job flock."""
import argparse,hashlib,json,os,subprocess,sys
from pathlib import Path
from source_guard import require_lease
HERE=Path(__file__).resolve().parent
REPO=HERE.parent.parent
TARGET='/tmp/fastest-bf-rust-byte-inline-only'
REFERENCE='/tmp/fastest-bf-rust-leaf-inline/release/compare_benchmark'

def main():
    if not __debug__:raise SystemExit('Run without Python -O')
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--cpu',type=int,choices=(2,3),required=True);a=p.parse_args()
    lease=require_lease(a.cpu,f'/tmp/fastest-bf-socket{a.cpu-2}.lock')
    dest=HERE/'validation';dest.mkdir(exist_ok=False)
    commands=[('source-before.log',[sys.executable,str(HERE/'verify_copy.py')]),('fmt-check.log',['cargo','fmt','--manifest-path',str(HERE/'benchmark/Cargo.toml'),'--all','--','--check'])]
    for variant in ['original','byte_only','triple_hint','benchmark']:
        for mode in ['normal','disable','asan']:
            target=TARGET+'-'+variant+'-'+mode
            command=['env','RUST_TEST_THREADS=1',f'CARGO_TARGET_DIR={target}']
            if mode=='asan':command+=['RUSTFLAGS=-Zsanitizer=address','cargo','+nightly','test','--locked','--target','x86_64-unknown-linux-gnu']
            else:command+=['RUSTFLAGS=','cargo','test','--locked']
            command+=['--manifest-path',str(HERE/variant/'Cargo.toml')]
            if variant!='benchmark':command+=['--lib']
            if mode=='disable':command+=['--features','disable-avx512']
            commands.append((f'{variant}-{mode}.log',command))
    manifest=str(HERE/'benchmark/Cargo.toml')
    commands += [('clippy.log',['env',f'CARGO_TARGET_DIR={TARGET}','RUSTFLAGS=','cargo','clippy','--locked','--all-targets','--manifest-path',manifest,'--','-D','warnings']),('release-build.log',['env',f'CARGO_TARGET_DIR={TARGET}','RUSTFLAGS=-C target-cpu=native -C symbol-mangling-version=v0','cargo','build','--locked','--release','--manifest-path',manifest]),('semantic-cli.log',[sys.executable,str(HERE/'check_preflight.py'),'--binary',TARGET+'/release/compare_benchmark','--reference',REFERENCE,'--cpu',str(a.cpu),'--output',str(dest/'preflight-results.json')]),('assembly.log',[sys.executable,str(HERE/'audit_assembly.py'),'--binary',TARGET+'/release/compare_benchmark']),('source-after.log',[sys.executable,str(HERE/'verify_copy.py')])]
    metadata=dict(cpu=a.cpu,lease=lease,timings_claimed=False,commands=commands,completed=[])
    for name,command in commands:
        print(name,flush=True)
        with (dest/name).open('w') as stream:r=subprocess.run(command,cwd=REPO,stdout=stream,stderr=subprocess.STDOUT)
        metadata['completed'].append(dict(log=name,returncode=r.returncode))
        (dest/'commands.json').write_text(json.dumps(metadata,indent=2)+'\n')
        if r.returncode:raise SystemExit('Failed '+name+'; retained log and previous stages')
    print('Correctness/ASM preflight complete; no throughput matrix run',flush=True)
if __name__=='__main__':main()
