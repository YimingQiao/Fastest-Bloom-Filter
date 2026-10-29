#!/usr/bin/env python3
"""Derive a collector-only continuation, preserving V1 and all Rust source."""
from pathlib import Path
import difflib
import hashlib
import json
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
SOURCE='1f409288eb288bae109cd9bcfce99977631efd99'
PREFIX='experiments/2026-10-29-rust-k12-singleton-vector-plan/caller/'

def original(name):return subprocess.check_output(['git','show',SOURCE+':'+PREFIX+name],cwd=ROOT).decode()
def emit(name,old,new):
    (HERE/name).write_text(new)
    (HERE/(name+'.patch')).write_text(''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen-v1/'+name,tofile='repair-v2/'+name)))

dep=original('dependencies.py')
needle="identity={'manifest':str(manifest),'package_id':package,'source':str(source)}"
replacement=needle+"\n                if '_workspace_root' in known:identity['workspace_root']=known['_workspace_root']"
assert dep.count(needle)==1
new=dep.replace(needle,replacement)
old_base="""            base=Path(owner['manifest']).parent
            need(Path(owner['source']) in [(base/t).resolve() for t in tokens],'Cargo target source absent from its dep-info')"""
assert new.count(old_base)==1
new=new.replace(old_base,"            base=select_dep_base(tokens,owner)")
selector='''
def select_dep_base(tokens,owner):
    """Exactly identify package-relative or metadata-workspace-relative RHS."""
    manifest_base=Path(owner['manifest']).parent.resolve()
    source=Path(owner['source']).resolve()
    need(source.is_relative_to(manifest_base),'Target source escapes package')
    bases={manifest_base}
    if 'workspace_root' in owner:
        workspace=Path(owner['workspace_root']).resolve()
        need(manifest_base.is_relative_to(workspace),'Package escapes structured workspace')
        bases.add(workspace)
    matches=[base for base in bases if source in [(base/t).resolve()for t in tokens]]
    need(len(matches)==1,'No unique structured target-source dep-info base')
    return matches[0]

'''
assert new.count('def collect(')==1
new=new.replace('def collect(',selector+'def collect(')
emit('dependencies.py',dep,new)

driver=original('validate.py')
changed=driver.replace('from guards import HERE,ROOT,need,sha,save,verify,packages,artifacts',
                       'from bindings import HERE,ROOT,need,sha,save,verify,packages,artifacts,reuse_native')
changed=changed.replace("TARGET=Path('/tmp/fastest-bf-rust-k12-simd-caller-v1-cpu3')", "TARGET=Path('/tmp/fastest-bf-rust-k12-simd-caller-v2-cpu3')")
changed=changed.replace("OUTPUT=HERE/'validation-v1'", "OUTPUT=HERE/'repair-v2/validation-v1'")
guard_line="        run('offline-guards',[sys.executable,'-m','unittest','discover','-s',HERE,'-p','test_contract.py'])"
assert changed.count(guard_line)==1
changed=changed.replace(guard_line,guard_line+"\n        run('workspace-dep-guards',[sys.executable,'-m','unittest','discover','-s',HERE/'repair-v2','-p','test_dependencies.py'])")
start=changed.index("            for tool in ['cargo','rustc']:")
stop=changed.index("            test_bins=artifacts(",start)
old_block=changed[start:stop]
new_block="""            build_path=TARGET/mode
            if mode=='native':
                reused=reuse_native()
                known=reused['packages'];test_text=reused['tests'];build_text=reused['build']
                build_path=Path(reused['target']);env['CARGO_TARGET_DIR']=str(build_path)
                meta['toolchains'].update(reused['toolchains'])
                meta['reused_native']=reused['descriptor'];persist();closure()
            else:
"""+''.join('    '+line+'\n'for line in old_block.splitlines())
changed=changed[:start]+new_block+changed[stop:]
changed=changed.replace("artifacts(test_text,True,TARGET/mode,known)","artifacts(test_text,True,build_path,known)")
changed=changed.replace("artifacts(build_text,False,TARGET/mode,known)","artifacts(build_text,False,build_path,known)")
changed=changed.replace("collect(TARGET/mode,TARGET/mode,[test_text,build_text],inventory,ROOT,known)","collect(build_path,build_path,[test_text,build_text],inventory,ROOT,known)")
emit('validate.py',driver,changed)
manifest={name:hashlib.sha256((HERE/name).read_bytes()).hexdigest()for name in ['dependencies.py','dependencies.py.patch','validate.py','validate.py.patch']}
(HERE/'DERIVED.json').write_text(json.dumps({'parent_source_commit':SOURCE,'files':manifest,'scope':'Python collector/continuation only; no Rust, timer, kernel, compiler flag or native binary changes'},indent=2)+'\n')
