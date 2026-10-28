#!/usr/bin/env python3
"""Check the exact production annotation and a small public-API codegen probe."""
import fcntl,hashlib,json,os,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPO=HERE.parent.parent
TARGET='/tmp/fastest-bf-byte-inline-production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def verify_source():
    proof=json.loads((HERE/'provenance.json').read_text())
    old=subprocess.check_output(['git','show',proof['parent_commit']+':'+proof['production_source']],cwd=REPO)
    pinned=subprocess.check_output(['git','show',proof['candidate_commit']+':'+proof['candidate_source']],cwd=REPO)
    current=(REPO/proof['production_source']).read_bytes()
    before=b'    #[inline]\n    pub fn contains_hash(&self, h: u64) -> bool {'
    after=b'    #[inline(always)]\n    pub fn contains_hash(&self, h: u64) -> bool {'
    assert old.count(before)==1 and old.replace(before,after,1)==current==pinned
    assert sha(REPO/proof['production_source'])==proof['after_sha256']
    assert subprocess.check_output(['git','diff','--',proof['production_source']],cwd=REPO)==(HERE/'production.patch').read_bytes()
    return proof

def main():
    if not __debug__:raise SystemExit('Run without Python -O')
    assert os.environ.get('BF_SOCKET_LEASE')=='socket1-cpu3' and os.sched_getaffinity(0)=={3}
    lock='/tmp/fastest-bf-socket1.lock';fds=[]
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name)==lock:
                fd=int(name);fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB);fds.append(fd)
        except FileNotFoundError:pass
    assert fds,'Actual inherited exclusive flock descriptor required'
    proof=verify_source()
    out=HERE/'validation';out.mkdir(exist_ok=False)
    commands=[('core-fmt.log',['cargo','fmt','--manifest-path',str(REPO/'rust/Cargo.toml'),'--','--check']),('probe-fmt.log',['cargo','fmt','--manifest-path',str(HERE/'probe/Cargo.toml'),'--','--check']),('core-tests.log',['env',f'CARGO_TARGET_DIR={TARGET}/library','RUSTFLAGS=','RUST_TEST_THREADS=1','cargo','test','--locked','--lib','--manifest-path',str(REPO/'rust/Cargo.toml')]),('core-clippy.log',['env',f'CARGO_TARGET_DIR={TARGET}/library','RUSTFLAGS=','cargo','clippy','--locked','--all-targets','--manifest-path',str(REPO/'rust/Cargo.toml'),'--','-D','warnings']),('probe-clippy.log',['env',f'CARGO_TARGET_DIR={TARGET}/probe','RUSTFLAGS=','cargo','clippy','--locked','--all-targets','--manifest-path',str(HERE/'probe/Cargo.toml'),'--','-D','warnings']),('probe-build.log',['env',f'CARGO_TARGET_DIR={TARGET}/probe','RUSTFLAGS=-C target-cpu=native -C symbol-mangling-version=v0','cargo','build','--locked','--release','--manifest-path',str(HERE/'probe/Cargo.toml')]),('probe-run.log',[TARGET+'/probe/release/byte-inline-production-probe'])]
    metadata=dict(cpu=3,affinity=sorted(os.sched_getaffinity(0)),lease=dict(lock_path=lock,inherited_lock_descriptors=fds),parent_commit=proof['parent_commit'],commands=commands,completed=[],performance_run=False)
    for name,command in commands:
        print(name,flush=True)
        with (out/name).open('w') as stream:r=subprocess.run(command,cwd=REPO,stdout=stream,stderr=subprocess.STDOUT)
        metadata['completed'].append(dict(log=name,returncode=r.returncode));(out/'commands.json').write_text(json.dumps(metadata,indent=2)+'\n')
        if r.returncode:raise SystemExit('Failed '+name)
    verify_source()
    binary=Path(TARGET+'/probe/release/byte-inline-production-probe')
    symbols=subprocess.check_output(['nm','-C',str(binary)],text=True)
    assembly=subprocess.check_output(['objdump','-d','-C','--no-show-raw-insn',str(binary)],text=True)
    bodies=[]
    for body in re.split(r'(?m)(?=^[0-9a-f]+ <)',assembly):
        title=body.splitlines()[0] if body else ''
        if '::byte_public_contains_loop>' in title:bodies.append(body)
    assert len(bodies)==1
    body=bodies[0]
    assert all(op in body for op in ['vpmulhw','vpshufb','vptest'])
    assert not any('contains_hash' in line for line in body.splitlines() if re.search(r'\bcall',line)), 'Public leaf remains an out-of-line call'
    (out/'probe-public-loop.asm').write_text(body)
    (out/'probe-symbols.txt').write_text(symbols)
    metadata.update(complete=True,source_verified_equal_to_frozen_candidate=True,production_sha256=sha(REPO/proof['production_source']),binary=str(binary),binary_sha256=sha(binary),public_loop_header=body.splitlines()[0],public_loop_calls=[line.strip() for line in body.splitlines() if re.search(r'\bcall',line)],public_leaf_inlined=True,rustc=subprocess.check_output(['rustc','-Vv'],text=True),probe_flags='-C target-cpu=native -C symbol-mangling-version=v0')
    (out/'commands.json').write_text(json.dumps(metadata,indent=2)+'\n')
    print('PASS: exact one-annotation production port, existing core checks, tiny public-query ASM; no timings')
if __name__=='__main__':main()
