"""Bind the immutable V3 attempt; no previously successful operation is repeated."""
import hashlib,importlib.util,json,subprocess,sys,difflib
from pathlib import Path
SOURCE='d9afa73b2f4a1df60dc7bd8b02880a19f393e730';ARCHIVE='18b51be438b02ad46353b3cdae43f0a8a91a1496'
def inherited_v3(root,here):
 def need(ok,msg):
  if not ok:raise ValueError(msg)
 def digest(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
 def blob(c,p):return subprocess.check_output(['git','show',c+':'+str(p.relative_to(root))],cwd=root)
 old=here.parent/'proof-v3'
 for name in ['checks.py','exec_affinity.py','source_guard.py']:need((here/name).read_bytes()==(old/name).read_bytes(),'Inherited helper changed')
 before="if (dep.name==target_name+'.d' and dep.parent.name=='out'";after="if (dep.name in {target_name+'.d',target_name.replace('-', '_')+'.d'} and dep.parent.name=='out'"
 original=(old/'dependencies.py').read_text();need(original.count(before)==1 and original.replace(before,after)==(here/'dependencies.py').read_text(),'Not exact nightly identity repair')
 patch=''.join(difflib.unified_diff(original.splitlines(True),(here/'dependencies.py').read_text().splitlines(True),fromfile='proof-v3/dependencies.py',tofile='proof-v4/dependencies.py'))
 need(patch==(here/'dependencies.patch').read_text(),'Collector patch drift')
 sys.path.insert(0,str(old))
 try:
  spec=importlib.util.spec_from_file_location('immutable_v3_bindings',old/'bindings.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);f=module.verify(SOURCE)
 finally:sys.path.pop(0)
 files=dict(f['inherited_sources']);anchors=dict(f['inherited_anchors'])
 for name in [*f['local'],'PREPARATION.json']:
  p=old/name;need(p.read_bytes()==blob(SOURCE,p),'V3 source changed');files[str(p.resolve())]=digest(p);anchors[str(p.resolve())]=dict(commit=SOURCE,git_path=str(p.relative_to(root)))
 directory=old/'validation-v1';archive=directory/'ARCHIVE.json';need(archive.read_bytes()==blob(ARCHIVE,archive),'V3 archive changed')
 for name,r in {**json.loads(archive.read_text())['files'],'ARCHIVE.json':None}.items():
  p=directory/name;d=digest(p)
  if r:need(d==r['sha256']and p.stat().st_size==r['bytes'],'V3 evidence drift')
  need(p.read_bytes()==blob(ARCHIVE,p),'Uncommitted V3 evidence');files[str(p.resolve())]=d;anchors[str(p.resolve())]=dict(commit=ARCHIVE,git_path=str(p.relative_to(root)))
 failed=json.loads((directory/'FAILED_V3.json').read_text());meta=json.loads((directory/'metadata.json').read_text())
 need(failed['all_commands_passed']and failed['completed_tests']=={'normal':40,'disable-avx512':6}and failed['completed_public_parity_cases']==24 and failed['asan_runtime_executions']==failed['assembly_captures']==0,'Wrong V3 reuse scope')
 need(meta['source_commit']==SOURCE and not meta['complete']and len(meta['commands'])==13 and set(meta['fixtures'])=={'normal','disable-avx512'},'Wrong V3 ledger')
 for command in meta['commands']:
  need(command['complete']and command['returncode']==0,'Unsuccessful reused command')
  for stream in ['stdout','stderr']:need(digest(directory/command[stream])==command[stream+'_sha256'],'Reused output changed')
 for name,d in failed['binaries'].items():need(digest(name)==d,'Reused executable changed')
 for rule in failed['dependency_rules']:need(digest(rule['actual_path'])==rule['sha256'],'Reused actual dep-info changed')
 return files,anchors
