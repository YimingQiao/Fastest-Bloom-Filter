"""Exact local/native provenance and inherited dependency pins, before compiler/BF."""
import hashlib,json,os,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def need(ok,msg):
 if not ok:raise ValueError(msg)
def exact(commit,path):
 need(re.fullmatch('[0-9a-f]{40}',commit)!=None,'full immutable commit required')
 need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'uncommitted source '+str(path))
def verify(commit):
 p=HERE/'PREPARATION.json';exact(commit,p);m=json.loads(p.read_text());pins={}
 for name,h in m['files'].items():
  path=HERE/name;need(path.resolve().is_relative_to(HERE),'source path escaped');need(sha(path)==h,'local source drift '+name);exact(commit,path);pins[str(path.resolve())]=h
 for name,item in m['origins'].items():
  path=ROOT/name;need(sha(path)==item['sha256'],'origin drift '+name);exact(item['commit'],path)
 deps=json.loads((HERE/'dependency-pins.json').read_text())
 parent=ROOT/deps['parent_manifest'];need(sha(parent)==deps['parent_manifest_sha256'],'parent dependency descriptor changed');exact(deps['parent_commit'],parent)
 inherited=json.loads(parent.read_text())['source_sha256']
 for name,h in deps['files'].items():
  need(inherited.get(name)==h,'dependency is not an exact inherited input')
  path=ROOT/name;need(sha(path)==h,'frozen dependency drift '+name);pins[str(path.resolve())]=h
 pins[str(p.resolve())]=sha(p);return pins

def lease():
 need(os.sched_getaffinity(0)=={2},'compiler parent must remain CPU2')
 fds=[]
 for p in Path('/proc/self/fd').iterdir():
  try:
   if p.resolve()==Path('/tmp/fastest-bf-socket0.lock') and 'FLOCK  ADVISORY  WRITE' in Path('/proc/self/fdinfo',p.name).read_text():fds.append(int(p.name))
  except OSError:pass
 need(fds,'actual inherited socket0 exclusive lock required');return sorted(fds)
