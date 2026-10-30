"""Pin the complete actual caller proof and this finite formal runner."""
import json,os,platform,re,subprocess
from screen_contract import HERE,STAGE,CALLER,ROOT,need,sha
from lease import require_lease
PROOF='094345ebf5050e4705540836441a6de09bc45931'
PROOF_SHA='94a3dfb6257ae87a5c56e57861258095b2f8de52ac88c7b41660594720845cba'
SOURCE='ec44c93cde22ea5c30ffd4d2bca5bc6e5eaaf63b'
PLAN_COMMIT='9f0ebb2f5b75c3be493e562024d01bbfc4a4c749'
ENVIRONMENT=('LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','MALLOC_ARENA_MAX','GLIBC_TUNABLES',
 'RUSTFLAGS','RUSTDOCFLAGS','CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','CARGO_ENCODED_RUSTFLAGS',
 'RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','CC','CXX','ASAN_OPTIONS','UBSAN_OPTIONS','TSAN_OPTIONS')


def exact(commit,path):
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'Committed artifact drift '+str(path))


def manifest(directory,name,commit):
    path=directory/name;exact(commit,path);result={str(path.relative_to(ROOT)):sha(path)}
    for relative,item in json.loads(path.read_text())['files'].items():
        p=directory/relative;exact(commit,p)
        need(p.is_file()and not p.is_symlink()and sha(p)==item['sha256']and p.stat().st_size==item['bytes'],'Frozen manifest drift')
        result[str(p.relative_to(ROOT))]=item['sha256']
    return result


def placement():
    lease=require_lease(3)
    record=dict(lease=lease,affinity=sorted(os.sched_getaffinity(0)),host=platform.uname()._asdict(),
                environment={name:os.environ.get(name)for name in ENVIRONMENT},inherited_write_verified=True)
    validate_placement(record);return record


def validate_placement(record):
    lease=record['lease']
    need(record['inherited_write_verified']is True and record['affinity']==[3],'Wrong archived parent affinity/lock')
    need(lease['cpu']==3 and lease['socket']==lease['node']==1 and lease['lock_path']=='/tmp/fastest-bf-socket1.lock','Wrong leased socket')
    need(lease['inherited_lock_descriptors']and all(type(x)is int and x>=0 for x in lease['inherited_lock_descriptors']),'No inherited WRITE lock evidence')
    need(lease['child_cpus']==list(range(3,18,2)),'Wrong ordered physical core budget')
    need([x['cpu']for x in lease['topology']]==lease['child_cpus']and all(x['socket']==1 and x['nodes']==[1]for x in lease['topology'])and len({x['core']for x in lease['topology']})==8,'Wrong topology')
    need(set(record['environment'])==set(ENVIRONMENT)and not any(record['environment'].values()),'Runtime/compiler override')
    need(isinstance(lease['environment'],dict)and not any(lease['environment'].values()),'Archived native lease override')


def verify(commit,live=True):
    need(__debug__ and re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full commit and active Python guards required')
    need(sha(CALLER/'COMPLETE_PROOF_ARCHIVE.json')==PROOF_SHA,'Wrong complete caller proof')
    sources=manifest(CALLER,'COMPLETE_PROOF_ARCHIVE.json',PROOF)
    sources.update(manifest(STAGE,'PREPARATION.json',PLAN_COMMIT))
    sources.update(manifest(HERE,'PREPARATION.json',commit))
    compiled=json.loads((CALLER/'COMPILED_PROOF.json').read_text())
    need(compiled['complete']and compiled['source_commit']==SOURCE,'Wrong compiled source')
    need(compiled['normal_asan_complete']and compiled['cpp_asm_gate_complete']and compiled['rust_asm_gate_complete'],'Missing caller/ASM gates')
    need(compiled['formal_fresh_inputs_executed']is False and compiled['performance_claim']is False,'Wrong proof scope')
    need((compiled['checked_records'],compiled['arms'],compiled['successful_timed_fresh_lifetimes'],compiled['commands'])==(24,96,640,52),'Wrong correctness coverage')
    for relative,digest in compiled['source_sha256'].items():
        p=ROOT/relative;exact(PROOF,p);need(sha(p)==digest,'Consumed source pin drift');sources[relative]=digest
    binaries=compiled['selected_normal_executables']
    need(binaries=={key:compiled['all_binaries']['normal/'+key]for key in ('cpp','rust')},'Wrong selected normal binary')
    need(len(compiled['all_binaries'])==4 and len(compiled['compiler_consumed_input_sha256'])==475,'Wrong compiled closure')
    cpp=json.loads((CALLER/'assembly/cpp-review/REVIEW.json').read_text())
    rust=json.loads((CALLER/'assembly/rust-review/evidence.json').read_text())
    need(cpp['binary']==binaries['cpp']and rust['binary']==binaries['rust'],'Wrong ASM artifacts')
    need(len(cpp['windows'])==12 and len(rust['after_clock_intervals'])==4,'Incomplete native timing gates')
    if live:
        for item in compiled['all_binaries'].values():need(sha(item['path'])==item['sha256'],'Executable drift')
        for path,digest in compiled['compiler_consumed_input_sha256'].items():need(sha(path)==digest,'Compiler-consumed input drift')
    return sources,compiled
