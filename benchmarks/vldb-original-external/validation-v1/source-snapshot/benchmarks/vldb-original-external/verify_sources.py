#!/usr/bin/env python3
"""Read-only verification of the exact pinned Git trees and consumed DTL files."""
import hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent

def sha(path):
    h=hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda:f.read(1<<20),b''):h.update(block)
    return h.hexdigest()

def verify():
    lock=json.loads((HERE/'source-lock.json').read_text())
    for name in ('reproduction','dtl'):
        path=HERE/'.deps'/name;expected=lock[name]
        git=lambda *args:subprocess.check_output(['git','-C',str(path),*args],text=True).strip()
        if git('rev-parse','HEAD')!=expected['commit'] or git('rev-parse','HEAD^{tree}')!=expected['tree']:
            raise ValueError('Pinned revision/tree mismatch: '+name)
        if git('remote','get-url','origin')!=expected['url'] or git('status','--porcelain'):
            raise ValueError('Pinned source URL/worktree mismatch: '+name)
    dep=HERE/'.deps/dtl'
    for name,digest in lock['dtl_files_sha256'].items():
        if sha(dep/name)!=digest:raise ValueError('Pinned file changed: '+name)
    line=subprocess.check_output(['git','-C',str(HERE/'.deps/reproduction'),'ls-tree','HEAD','module/dtl'],text=True).split()
    if line[:3]!=['160000','commit',lock['dtl']['commit']]:raise ValueError('Artifact DTL gitlink mismatch')
    return {'source_lock_sha256':sha(HERE/'source-lock.json'),'dtl_files':len(lock['dtl_files_sha256']),
            'reproduction':lock['reproduction']['commit'],'dtl':lock['dtl']['commit']}

if __name__=='__main__':print(json.dumps(verify(),sort_keys=True))
