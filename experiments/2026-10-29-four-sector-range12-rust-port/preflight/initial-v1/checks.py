"""Focused correctness-only artifact/fixture checks, no performance model."""
import hashlib,json,re,shlex
from pathlib import Path

def need(ok,why):
    if not ok:raise ValueError(why)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2)+'\n')
def artifact(stdout,target,name,test):
    found=[]
    for line in stdout.splitlines():
        try:x=json.loads(line)
        except ValueError:continue
        if x.get('reason')=='compiler-artifact'and x.get('target',{}).get('name')==name and x.get('profile',{}).get('test')is test and x.get('executable'):
            p=Path(x['executable']);need(p.is_absolute()and p.resolve().is_relative_to(target.resolve())and not p.is_symlink(),'Wrong artifact boundary');found.append(p)
    need(len(found)==1,'Require one structured executable artifact');return found[0]
def fixture(data,stderr,lines,workers,backend):
    metadata=json.loads(stderr);need(metadata==dict(backend=backend,bytes=lines*64,**({}if workers is None else dict(workers=min(workers,lines)))),'Changed actual backend/allocation/workers')
    need(len(data)==lines*64+8193*4,'Truncated/extra full bitmap+dense outputs')
    return dict(raw_bytes=len(data),raw_sha256=hashlib.sha256(data).hexdigest(),metadata=metadata)
def dependencies(path,cwd):
    text=path.read_text().replace('\\\n',' ');need(': 'in text,'Malformed depfile');tokens=shlex.split(text.split(': ',1)[1].split('\n\n')[0])
    result={}
    for token in tokens:
        # Rust .d adds phony targets after the first dependency line.
        if token.endswith(':'):break
        p=Path(token);p=p if p.is_absolute()else cwd/p;p=p.resolve(strict=True);need(p.is_file(),'Nonfile compiler input');result[str(p)]=sha(p)
    need(result,'Empty depfile');return result
