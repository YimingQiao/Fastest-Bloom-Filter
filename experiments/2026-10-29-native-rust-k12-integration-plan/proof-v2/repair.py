"""Exact test-only repair and unchanged failed V1 evidence; no execution."""
import hashlib,json,subprocess
from pathlib import Path
OLD='771262e3ba9aa8e51610e0981d86884361d19624';NEW='3af9c6555bbd42b778c93075d1740e243ac9f11e'
FAILURE='84ba908172c22dcae8f81a7f1d2756056d8f0137';SOURCE='76b6f7e4bddaf0c841207ca0d41b1d6f9e89bfe4'
def check_repair(root,here):
 def need(ok,msg):
  if not ok:raise ValueError(msg)
 def blob(commit,name):return subprocess.check_output(['git','show',commit+':'+name],cwd=root)
 path='rust/src/four_sector_range12_tests.rs';old=blob(OLD,path);line=b'                        assert!((indices[sector]&15)<16);\n'
 need(old.count(line)==1 and blob(NEW,path)==old.replace(line,b''),'Native repair exceeds one redundant test assertion')
 need(subprocess.check_output(['git','diff','--name-only',OLD,NEW],cwd=root).decode().splitlines()==[path],'Unexpected native production change')
 original='experiments/2026-10-29-native-rust-k12-integration-plan/proof/'
 need((here/'validate.py').read_bytes()==blob(SOURCE,original+'validate.py').replace(b'port-v1-cpu3',b'port-v2-cpu3'),'V2 driver scope changed')
 for name in ['checks.py','dependencies.py','source_guard.py','exec_affinity.py','test_checks.py','caller/Cargo.toml','caller/Cargo.lock','caller/src/main.rs']:
  need((here/name).read_bytes()==blob(SOURCE,original+name),'Unchanged proof fixture changed '+name)
 directory=root/original/'validation-v1';archive=directory/'ARCHIVE.json';need(archive.read_bytes()==blob(FAILURE,str(archive.relative_to(root))),'Changed failed archive')
 data=json.loads(archive.read_text());files={};anchors={}
 for name,record in {**data['files'],'ARCHIVE.json':None}.items():
  p=directory/name;digest=hashlib.sha256(p.read_bytes()).hexdigest()
  if record:need(digest==record['sha256']and p.stat().st_size==record['bytes'],'Failed evidence changed')
  git_path=str(p.relative_to(root));need(p.read_bytes()==blob(FAILURE,git_path),'Uncommitted V1 failure evidence');files[str(p.resolve())]=digest;anchors[str(p.resolve())]=dict(commit=FAILURE,git_path=git_path)
 failed=json.loads((directory/'FAILED_V1.json').read_text());need(failed['tests_executed']==failed['BF_executions']==0 and not failed['complete'],'Wrong failed-attempt scope')
 for name,digest in failed['binaries'].items():need(hashlib.sha256(Path(name).read_bytes()).hexdigest()==digest,'Preserved V1 executable changed')
 return files,anchors
