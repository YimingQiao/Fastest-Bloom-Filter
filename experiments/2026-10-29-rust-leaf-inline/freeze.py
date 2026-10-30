#!/usr/bin/env python3
"""Record the preflight only; no throughput run is launched or authorized."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
FROZEN = HERE/'validation/freeze.json'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(frozen, dependencies=True):
    for name, expected in frozen['source_sha256'].items():
        if sha(REPO/name) != expected:
            raise ValueError('Changed source: '+name)
    for binary in frozen['binaries']:
        if sha(Path(binary['path'])) != binary['sha256']:
            raise ValueError('Changed binary: '+binary['path'])
    for dependency in frozen['external_dependencies'] if dependencies else []:
        for name, expected in dependency['sha256'].items():
            if sha(Path(dependency['directory'])/name) != expected:
                raise ValueError('Changed dependency: '+dependency['name']+'/'+name)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verify',action='store_true')
    args = parser.parse_args()
    if args.verify:
        frozen=json.loads(FROZEN.read_text());verify(frozen)
        print(f"Verified {len(frozen['source_sha256'])} source inputs, {len(frozen['external_dependencies'])} dependencies and three binaries")
        return
    subprocess.run(['python3',str(HERE/'verify_copy.py')],cwd=REPO,check=True)
    base=json.loads((REPO/'experiments/2026-10-29-rust-visible-single/validation/freeze.json').read_text())
    source={name:expected for name,expected in base['source_sha256'].items() if name.startswith('rust/')}
    for directory in ('native','benchmark'):
        for path in (HERE/directory).rglob('*'):
            if path.is_file() and 'target' not in path.parts:
                source[str(path.relative_to(REPO))]=sha(path)
    for path in list(HERE.glob('*.py'))+[HERE/name for name in ('README.md','registry.json','protocol-preflight.json','protocol.json','copy-source.json','.gitignore','.gitattributes')]:
        source[str(path.relative_to(REPO))]=sha(path)
    binaries=[dict(role='three-hint candidate plus unchanged seven controls',path='/tmp/fastest-bf-rust-leaf-inline/release/compare_benchmark'),
              dict(role='preserved batch1-only preflight',path='/tmp/fastest-bf-rust-leaf-inline/batch1-preflight/compare_benchmark'),
              dict(role='unchanged visible28 reference',path='/tmp/fastest-bf-rust-visible-single/release/compare_benchmark')]
    for binary in binaries:binary['sha256']=sha(Path(binary['path']))
    frozen=dict(source_parent_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=REPO,text=True).strip(),
                source_sha256=dict(sorted(source.items())),external_dependencies=base['external_dependencies'],binaries=binaries,
                rustc=subprocess.check_output(['rustc','-Vv'],text=True),compiler_flags='-C target-cpu=native -C symbol-mangling-version=v0',
                performance_run=False,production_changed=False)
    verify(frozen)
    FROZEN.write_text(json.dumps(frozen,indent=2)+'\n')
    print(f"Frozen {len(source)} repository inputs, {len(frozen['external_dependencies'])} dependencies and three binaries")


if __name__ == '__main__':main()
