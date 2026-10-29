#!/usr/bin/env python3
"""Read-only normal artifact capture after complete old-seed correctness."""
import hashlib,json,os,shutil,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
PREFLIGHT=HERE.parent/'preflight'
sys.path.insert(0,str(PREFLIGHT))
from lease import require_lease
from source_guard import verify

def need(ok,message):
 if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def main():
 lease=require_lease(3);proof_path=PREFLIGHT/'validation-v1/commands.json';proof=json.loads(proof_path.read_text())
 need(proof['complete']and proof['checked_records']==24 and proof['formal_performance_run']is False,'Require complete caller proof')
 need(verify(proof['source_commit'])==proof['source_sha256'],'Source drift')
 out=HERE/'capture-v1';need(not out.exists()and not out.is_symlink(),'Preserve captures');out.mkdir()
 commands=[];tools={}
 def run(label,argv):
  executable=shutil.which(argv[0]);need(executable is not None,'Missing tool '+argv[0]);argv=[executable]+argv[1:]
  result=subprocess.run(argv,capture_output=True,pass_fds=tuple(lease['inherited_lock_descriptors']))
  for stream,data in [('stdout',result.stdout),('stderr',result.stderr)]:(out/(label+'.'+stream)).write_bytes(data)
  commands.append(dict(label=label,command=argv,returncode=result.returncode,stdout_sha256=sha(out/(label+'.stdout')),stderr_sha256=sha(out/(label+'.stderr'))))
  need(result.returncode==0,'Read-only tool failure '+label)
  tools[executable]=sha(executable)
 for tool in ['llvm-objdump','nm','objdump']:
  run(tool+'-version',[tool,'--version'])
 selected={}
 for language in ['cpp','rust']:
  item=proof['binaries']['normal/'+language];binary=item['path'];need(sha(binary)==item['sha256'],'Normal binary drift');selected[language]=item
  run(language+'-disassembly',['llvm-objdump','-d','--demangle',binary])
  run(language+'-symbols',['nm','--defined-only',binary])
  run(language+'-demangled-symbols',['nm','-C','--defined-only',binary])
  run(language+'-relocations',['objdump','-R',binary])
  need(sha(binary)==item['sha256'],'Normal binary changed during read')
 events=[json.loads(line)for line in(PREFLIGHT/'validation-v1/normal-rust-build.stdout').read_text().splitlines()]
 artifacts=[e for e in events if e.get('reason')=='compiler-artifact'and e.get('target',{}).get('name')=='fastest_bloom_filter']
 need(len(artifacts)==3,'Expected three immutable native Cargo artifacts')
 rlibs=[]
 for i,event in enumerate(artifacts):
  paths=[p for p in event['filenames']if p.endswith('.rlib')];need(len(paths)==1,'Unique rlib required')
  p=paths[0];run('rust-rlib-'+str(i),['nm','--defined-only',p]);rlibs.append(dict(path=p,sha256=sha(p),manifest_path=event['manifest_path'],package_id=event['package_id'],target=event['target'],symbol_artifact='rust-rlib-'+str(i)+'.stdout'))
 (out/'cargo-artifacts.json').write_text(json.dumps(artifacts,indent=2)+'\n')
 need(verify(proof['source_commit'])==proof['source_sha256'],'Final source drift')
 (out/'CAPTURE.json').write_text(json.dumps(dict(proof_path=str(proof_path),proof_sha256=sha(proof_path),selected_normal_executables=selected,rlibs=rlibs,commands=commands,tools_sha256=tools,lease=lease,compiler_or_filter_executed=False,manual_assembly_gate_complete=False),indent=2)+'\n')
 print('Read-only normal disassembly/symbol/relocation/three-rlib capture complete; no compiler or filter run')
if __name__=='__main__':main()
