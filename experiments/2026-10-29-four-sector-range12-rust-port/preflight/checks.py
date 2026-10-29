"""Focused correctness-only artifact/fixture/placement checks; no performance model."""
import hashlib,json,os,shlex
from pathlib import Path
CPUS=[3,5,7,9,11,13,15]
PACKAGE='four-sector-range12-isolated@0.0.0'
FORBIDDEN_ENV=('LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','RUSTC','RUSTDOC','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','RUSTFLAGS','RUSTDOCFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_ENCODED_RUSTDOCFLAGS','CARGO_BUILD_RUSTFLAGS','CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS','CARGO_BUILD_RUSTC','CARGO_BUILD_RUSTC_WRAPPER','CARGO_BUILD_TARGET','RUSTC_BOOTSTRAP','ASAN_OPTIONS','UBSAN_OPTIONS')
def need(ok,why):
    if not ok:raise ValueError(why)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2)+'\n')
def check_environment(environment):
    actual={k:environment.get(k)for k in FORBIDDEN_ENV};need(all(v is None for v in actual.values()),'Unfrozen loader/compiler/allocator environment');return actual

def artifact(stdout,target,name,test,manifest):
    manifest=manifest.resolve(strict=True);crate=manifest.parent;package='path+'+crate.as_uri()+'#'+PACKAGE;found=[]
    for line in stdout.splitlines():
        try:x=json.loads(line)
        except ValueError:continue
        if x.get('reason')!='compiler-artifact':continue
        need(x.get('package_id')==package and x.get('manifest_path')==str(manifest),'Wrong structured Cargo package/manifest identity')
        need(Path(x['target']['src_path']).resolve(strict=True).is_relative_to(crate),'Artifact source outside unique crate')
        if x['target']['name']==name and x.get('profile',{}).get('test')is test and x.get('executable'):
            p=Path(x['executable']);need(p.is_absolute()and p.is_file()and not p.is_symlink()and p.resolve(strict=True).is_relative_to(target.resolve()),'Wrong artifact boundary');found.append(p)
    need(len(found)==1,'Require one structured executable artifact');return found[0],crate

def topology():
    rows=[]
    for cpu in CPUS:
        root=Path(f'/sys/devices/system/cpu/cpu{cpu}');online=root/'online';need(not online.exists()or online.read_text().strip()=='1','Offline worker CPU')
        socket=int((root/'topology/physical_package_id').read_text());core=int((root/'topology/core_id').read_text());nodes=[int(x.name[4:])for x in root.glob('node[0-9]*')]
        need(socket==1 and nodes==[1],'Worker CPU not on granted socket1/node1');rows.append(dict(cpu=cpu,socket=socket,core=core,node=nodes[0]))
    need(len({(r['socket'],r['core'])for r in rows})==len(CPUS),'Worker mask must use distinct physical cores');return rows

def execution_stderr(raw,executable):
    lines=raw.split(b'\n',1);need(len(lines)==2,'Missing pre-exec affinity proof');record=json.loads(lines[0]);expected=dict(pre_exec_affinity=CPUS,executable=str(executable));need(record==expected,'Wrong actual execution mask/executable');return record,lines[1]

def fixture(data,stderr,lines,workers,backend):
    metadata=json.loads(stderr);need(metadata==dict(backend=backend,bytes=lines*64,**({}if workers is None else dict(workers=min(workers,lines)))),'Changed actual backend/allocation/workers')
    need(len(data)==lines*64+8193*4,'Truncated/extra full bitmap+dense outputs')
    return dict(raw_bytes=len(data),raw_sha256=hashlib.sha256(data).hexdigest(),metadata=metadata)

def dependencies(path,cwd):
    text=path.read_text().replace('\\\n',' ');need(': 'in text,'Malformed depfile');tokens=shlex.split(text.split(': ',1)[1].split('\n\n')[0]);result={}
    for token in tokens:
        if token.endswith(':'):break
        p=Path(token);p=p if p.is_absolute()else cwd/p;p=p.resolve(strict=True);need(p.is_file(),'Nonfile compiler input');result[str(p)]=sha(p)
    need(result,'Empty depfile');return result
