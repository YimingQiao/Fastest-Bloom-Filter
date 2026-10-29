#!/usr/bin/env python3
"""Freeze/verify the complete focused preflight and additive336 runner sources."""
if not __debug__: raise RuntimeError('Use Python without -O')
import argparse
import hashlib
import json
from pathlib import Path
import re
import sys

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
sys.path.insert(0,str(STAGE))
from bindings import ROOT, blob, need, save, sha, verify_preparation

PREFLIGHT_SOURCE='7e548983bab6fe1ca6ade217eece2b67f61995ef'
COMPILED_ANCHOR='c5ed7d7d23f9c481dc61990544b0827502d187c4'


def verify(commit=None,light=False):
    frozen=json.loads((HERE/'freeze.json').read_text())
    inputs=dict(frozen['inputs_sha256'])
    inputs[str((HERE/'freeze.json').relative_to(ROOT))]=sha(HERE/'freeze.json')
    for name,digest in inputs.items():
        path=ROOT/name
        need(sha(path)==digest,'Frozen source/evidence drift '+name)
        if commit:
            need(re.fullmatch(r'[0-9a-f]{40}',commit),'Exact committed source required')
            need(hashlib.sha256(blob(commit,path)).hexdigest()==digest,'Uncommitted frozen input '+name)
    for path in [STAGE/'PERFORMANCE_COMPILED_FREEZE.json',STAGE/'PREFLIGHT_ARCHIVE.json']:
        need(path.read_bytes()==blob(COMPILED_ANCHOR,path),'Changed compiled preflight anchor')
    compiled=json.loads((STAGE/'PERFORMANCE_COMPILED_FREEZE.json').read_text())
    need(compiled['preflight_source_commit']==PREFLIGHT_SOURCE,'Changed focused preflight ancestry')
    need(compiled['performance_executable']==frozen['performance_executable'] and
        compiled['performance_executable_sha256']==frozen['performance_executable_sha256'],'Wrong timing executable')
    need(sha(Path(compiled['performance_executable']))==compiled['performance_executable_sha256'],'Timing executable drift')
    if not light:
        verify_preparation(PREFLIGHT_SOURCE)
        for name,digest in compiled['binaries_sha256'].items():need(sha(Path(name))==digest,'Focused validation artifact drift')
    return frozen,compiled


def create():
    target=HERE/'freeze.json'
    need(not target.exists()and not target.is_symlink(),'Preserve previous frozen source')
    pins,parent=verify_preparation(PREFLIGHT_SOURCE)
    metadata=json.loads((STAGE/'validation-v1/metadata.json').read_text())
    need(metadata['complete']and metadata['tiny_rows']==336 and metadata['source_commit']==PREFLIGHT_SOURCE,'Incomplete preflight')
    for path in [STAGE/'PERFORMANCE_COMPILED_FREEZE.json',STAGE/'PREFLIGHT_ARCHIVE.json']:
        need(path.read_bytes()==blob(COMPILED_ANCHOR,path),'Changed compiled preflight anchor')
    compiled=json.loads((STAGE/'PERFORMANCE_COMPILED_FREEZE.json').read_text())
    need(compiled['performance_executable']==metadata['mode_executables']['native'],'Wrong native executable')
    inputs=dict(parent['preserved_source_sha256'],**pins)
    archive=STAGE/'PREFLIGHT_ARCHIVE.json'
    for name,info in json.loads(archive.read_text())['files'].items():
        path=STAGE/name
        need(sha(path)==info['sha256'],'Changed focused preflight archive')
        inputs[str(path.relative_to(ROOT))]=info['sha256']
    inputs[str(archive.relative_to(ROOT))]=sha(archive)
    for path in sorted(HERE.rglob('*')):
        if path.is_file()and '__pycache__'not in path.parts and path!=target:
            inputs[str(path.relative_to(ROOT))]=sha(path)
    save(target,dict(scope='Full336 fixed publicK training protocol; source/binaries frozen before timing; explicit committed source and socket lease required.',
        preflight_source_commit=PREFLIGHT_SOURCE,compiled_anchor_commit=COMPILED_ANCHOR,performance_executable=compiled['performance_executable'],
        performance_executable_sha256=compiled['performance_executable_sha256'],inputs_sha256=inputs,
        expected_rows=336,expected_cases=18,quality_records=112,known_mapping_records=110))
    verify()
    print('Frozen',len(inputs),'source/evidence inputs; no benchmark executed')


if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--create',action='store_true');p.add_argument('--source-commit');a=p.parse_args()
    if a.create:create()
    else:verify(a.source_commit);print('PASS complete336 source/dependency/binary freeze')
