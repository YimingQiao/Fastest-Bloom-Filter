#!/usr/bin/env python3
"""Pin a source-only new protocol around the already measured, unchanged executable."""
import argparse,hashlib,json,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent
REPO=HERE.parent.parent
BASE=HERE.parent/'2026-10-29-rust-leaf-inline'
FROZEN=HERE/'validation/freeze.json'
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def verify(frozen,dependencies=True):
    for name,h in frozen['source_sha256'].items():
        if sha(REPO/name)!=h:raise ValueError('Changed source: '+name)
    for b in frozen['binaries']:
        if sha(Path(b['path']))!=b['sha256']:raise ValueError('Changed binary: '+b['path'])
    for dep in frozen['external_dependencies'] if dependencies else []:
        for name,h in dep['sha256'].items():
            if sha(Path(dep['directory'])/name)!=h:raise ValueError('Changed dependency: '+name)
def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--verify',action='store_true');args=ap.parse_args()
    if args.verify:
        f=json.loads(FROZEN.read_text());verify(f);print('Verified',len(f['source_sha256']),'source inputs and unchanged executable');return
    old=json.loads((BASE/'validation/freeze.json').read_text())
    sources=dict(old['source_sha256'])
    for path in [BASE/'validation/freeze.json',BASE/'validation/preflight-results.json',BASE/'screen/results.csv',*HERE.glob('*.py'),*[HERE/name for name in ['README.md','protocol.json','registry.json','filter-order-plan.json','.gitignore','.gitattributes']]]:
        sources[str(path.relative_to(REPO))]=sha(path)
    f=dict(source_parent_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip(),compiled_leaf_source_commit='9011d5228118373f89786d3a1a304f83ea689a85',source_sha256=dict(sorted(sources.items())),external_dependencies=old['external_dependencies'],binaries=[old['binaries'][0]],compiler_flags=old['compiler_flags'],rustc=old['rustc'],performance_run=False,production_changed=False)
    verify(f);FROZEN.parent.mkdir(exist_ok=True);FROZEN.write_text(json.dumps(f,indent=2)+'\n');print('Frozen',len(sources),'source inputs, 11 dependencies and one unchanged executable')
if __name__=='__main__':main()
