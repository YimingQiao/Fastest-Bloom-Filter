"""Reuse successful V2 builds only after their exact failure/source evidence binds."""
import hashlib,importlib.util,json,subprocess,sys
from pathlib import Path
SOURCE='2dd44627f85081dd8ba4f123992234f2dc09ac8f';FAILURE='f4fcd112c6ac205442ee1927d2bcbf47a6da2e03'
def inherited_v2(root,here):
 def need(ok,msg):
  if not ok:raise ValueError(msg)
 def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
 def blob(c,p):return subprocess.check_output(['git','show',c+':'+str(p.relative_to(root))],cwd=root)
 from repair_v3 import check
 check(here)
 old=here.parent/'proof-v2';sys.path.insert(0,str(old))
 try:
  spec=importlib.util.spec_from_file_location('immutable_v2_bindings',old/'bindings.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);f=module.verify(SOURCE)
 finally:sys.path.pop(0)
 files=dict(f['inherited_sources']);anchors=dict(f['inherited_anchors'])
 for name in [*f['local'],'PREPARATION.json']:
  p=old/name;need(p.read_bytes()==blob(SOURCE,p),'V2 source changed');files[str(p.resolve())]=digest(p);anchors[str(p.resolve())]=dict(commit=SOURCE,git_path=str(p.relative_to(root)))
 directory=old/'validation-v1';archive=directory/'ARCHIVE.json';need(archive.read_bytes()==blob(FAILURE,archive),'V2 archive changed')
 for name,r in {**json.loads(archive.read_text())['files'],'ARCHIVE.json':None}.items():
  p=directory/name;d=digest(p)
  if r:need(d==r['sha256']and p.stat().st_size==r['bytes'],'V2 raw changed')
  need(p.read_bytes()==blob(FAILURE,p),'Uncommitted V2 evidence');files[str(p.resolve())]=d;anchors[str(p.resolve())]=dict(commit=FAILURE,git_path=str(p.relative_to(root)))
 failed=json.loads((directory/'FAILED_V2.json').read_text());meta=json.loads((directory/'metadata.json').read_text())
 need(failed['tests_executed']==failed['BF_executions']==0 and failed['normal_builds_and_clippy_passed'],'Wrong V2 reuse scope')
 need(meta['source_commit']==SOURCE and not meta['complete']and not meta['fixtures']and len(meta['commands'])==6,'Wrong V2 original ledger')
 need([r['label']for r in meta['commands']]==['offline-guards','normal-compiler','normal-metadata','normal-native-test-build','normal-caller-build','normal-clippy'],'Wrong reused commands')
 for command in meta['commands']:
  need(command['complete']and command['returncode']==0,'Failed reused build command')
  for stream in ['stdout','stderr']:need(digest(directory/command[stream])==command[stream+'_sha256'],'Reused command output drift')
 for name,d in failed['binaries'].items():need(digest(name)==d,'Reused executable changed')
 for rule in failed['partial_dependency_rules']:need(digest(rule['actual_path'])==rule['sha256'],'Reused actual dependency changed')
 return files,anchors
