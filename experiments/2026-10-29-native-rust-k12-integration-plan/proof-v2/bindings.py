"""Exact local-source packaging pins, including the separate native worktree."""
import hashlib,json,subprocess,re
from pathlib import Path
from checks import need
HERE=Path(__file__).resolve().parent;PLAN=HERE.parent;ROOT=PLAN.parents[1]
WORK=Path('/home/yiming/projects/fastest-bf-rust-k12-integration')
NATIVE='3af9c6555bbd42b778c93075d1740e243ac9f11e';BASE='4d2d2258302ace258c19b7ab33c1d0a2e7d796ef'
REFERENCE='0c0eb382a817245e379b01339ecd71b747bd5cea';REF=ROOT/'experiments/2026-10-29-rust-k12-single-line/native'
PROVEN='2adefb87cd03051df163803e8710a5f0375573b1'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(p,v):Path(p).write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def blob(commit,name):return subprocess.check_output(['git','show',commit+':'+name],cwd=ROOT)
def source_files(root):return sorted(p for p in root.rglob('*')if p.is_file()and'__pycache__'not in p.parts and'target'not in p.parts)
def inherited():
 from repair import check_repair
 files,anchors=check_repair(ROOT,HERE)
 for commit,prefix,actual in [(NATIVE,'rust',WORK/'rust'),(REFERENCE,str(REF.relative_to(ROOT)),REF)]:
  names=subprocess.check_output(['git','ls-tree','-r','--name-only',commit,'--',prefix],cwd=ROOT).decode().splitlines()
  for name in names:
   p=actual/Path(name).relative_to(prefix);need(p.is_file(),'Missing pinned package file');need(p.read_bytes()==blob(commit,name),'Native/reference source drift')
   files[str(p.resolve())]=sha(p);anchors[str(p.resolve())]=dict(commit=commit,git_path=name)
 for name,old in [('dependencies.py','caller/preflight/dependencies.py'),('source_guard.py','caller/preflight/source_guard.py')]:
  need((HERE/name).read_bytes()==blob(PROVEN,'experiments/2026-10-29-rust-k12-single-line/'+old),'Reused guard changed')
 return files,anchors
def make_freeze():
 files,anchors=inherited();local=[p for p in source_files(HERE)if p.name!='PREPARATION.json'and not any(x.startswith('validation-')for x in p.parts)]
 return dict(status='Source-only actual native K12 packaging proof; no throughput or FPR workload',native_commit=NATIVE,native_base=BASE,reference_commit=REFERENCE,passed_isolated_proof=PROVEN,inherited_sources=files,inherited_anchors=anchors,local={str(p.relative_to(HERE)):dict(sha256=sha(p),bytes=p.stat().st_size)for p in local})
def verify(commit):
 need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Immutable full proof source commit required')
 f=json.loads((HERE/'PREPARATION.json').read_text());need((HERE/'PREPARATION.json').read_bytes()==blob(commit,str((HERE/'PREPARATION.json').relative_to(ROOT))),'Uncommitted preparation')
 for name,r in f['local'].items():
  p=HERE/name;need(sha(p)==r['sha256']and p.stat().st_size==r['bytes'],'Local source drift');need(p.read_bytes()==blob(commit,str(p.relative_to(ROOT))),'Uncommitted proof source')
 files,anchors=inherited();need(files==f['inherited_sources']and anchors==f['inherited_anchors'],'Package closure drift')
 need(subprocess.check_output(['git','rev-parse','HEAD'],cwd=WORK).decode().strip()==NATIVE,'Integration worktree HEAD changed')
 need(not subprocess.check_output(['git','status','--porcelain','--untracked-files=all'],cwd=WORK),'Integration worktree dirty')
 return f
def metadata(text,known):
 d=json.loads(text);out={}
 for p in d['packages']:
  manifest=Path(p['manifest_path']).resolve();need(str(manifest)in known and sha(manifest)==known[str(manifest)],'Unbound Cargo manifest')
  need(p['source']is None,'This bounded proof has no registry dependency')
  for t in p['targets']:
   source=Path(t['src_path']).resolve();need(str(source)in known and sha(source)==known[str(source)],'Unbound Cargo target')
  out[p['id']]=p
 return out
