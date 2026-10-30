#!/usr/bin/env python3
"""Temporary git-fixture tests; never commits to or mutates the project repo."""
import hashlib,json,os,subprocess,tempfile
from pathlib import Path
from source_guard import verify_commit_inputs,require_lease

sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def rejected(fn):
    try:fn()
    except (ValueError,subprocess.CalledProcessError):return
    raise AssertionError('invalid source/lease accepted')

with tempfile.TemporaryDirectory(prefix='bf-source-guard-') as directory:
    root=Path(directory);here=root/'experiment';here.mkdir()
    subprocess.run(['git','init','-q'],cwd=root,check=True)
    sources={}
    for name in ('protocol.json','planned-grid.json','registry.json','run_screen.py','source_guard.py','geometry.hpp','compare_benchmark.cpp','CMakeLists.txt'):
        p=here/name;p.write_text('fixture '+name+'\n');sources['experiment/'+name]=sha(p)
    freeze=dict(source_sha256=sources,binary_sha256={})
    (here/'freeze.json').write_text(json.dumps(freeze))
    manifest={'files_sha256':{p.name:sha(p) for p in here.iterdir() if p.is_file()}}
    (here/'manifest.json').write_text(json.dumps(manifest))
    subprocess.run(['git','add','.'],cwd=root,check=True)
    subprocess.run(['git','-c','user.name=Fixture','-c','user.email=fixture@example.invalid','commit','-qm','fixture'],cwd=root,check=True)
    commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()
    verify_commit_inputs(root,here,commit,freeze)
    rejected(lambda:verify_commit_inputs(root,here,commit[:8],freeze))
    # Changing current file and rewriting the local freeze does not let us claim
    # that an existing old commit contains those new source bytes.
    p=here/'geometry.hpp';old=p.read_bytes();p.write_text('changed\n')
    altered=json.loads(json.dumps(freeze));altered['source_sha256']['experiment/geometry.hpp']=sha(p)
    rejected(lambda:verify_commit_inputs(root,here,commit,altered));p.write_bytes(old)
    p=here/'freeze.json';old=p.read_bytes();p.write_text(json.dumps(freeze,indent=2))
    rejected(lambda:verify_commit_inputs(root,here,commit,freeze));p.write_bytes(old)
    p=here/'manifest.json';old=p.read_bytes();p.write_text(json.dumps(manifest,indent=2))
    rejected(lambda:verify_commit_inputs(root,here,commit,freeze));p.write_bytes(old)
    rejected(lambda:require_lease(3,'socket0'))
    rejected(lambda:require_lease(2,'socket1'))
    lock=root/'test.lock'
    script=Path(__file__).resolve().parent
    code='from source_guard import require_lease; require_lease(2,"socket0",'+repr(str(lock))+')'
    proc=subprocess.run(['taskset','-c','2','python3','-c',code],cwd=script,text=True,capture_output=True)
    assert proc.returncode and 'flock lease' in proc.stderr
    subprocess.run(['flock',str(lock),'taskset','-c','2','python3','-c',code],cwd=script,check=True)
print('PASS: exact committed source/freeze/inventory blobs and inherited CPU2 whole-matrix lease guard.')
