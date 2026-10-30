"""Prepared source and actual .d closure for the one focused public caller proof."""
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
from contract import need

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
CORE='6981a9139f6b10785036dd6a43c398a337cfce09'
OLD=ROOT/'experiments/2026-10-30-independent32-range/caller'
PROOF='aa21a91a8290ed31fdcfc5390cc548f9ec73a282'
ARCHIVE='2649d422a7d98f3ff54f0fbc6f31051e50cd48b407ceaefdb49560db9dce57d9'

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def blob(commit,path):
    need(bool(re.fullmatch('[0-9a-f]{40}',commit)),'full immutable commit required')
    return subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT)

def verify(commit):
    prepared={}
    def anchor(revision,path,digest=None):
        path=Path(path);need(not path.is_symlink(),'source symlink not permitted')
        content=path.read_bytes();observed=hashlib.sha256(content).hexdigest()
        need(content==blob(revision,path),'committed source drift: '+str(path))
        need(digest is None or observed==digest,'source SHA drift: '+str(path))
        prepared[str(path.resolve())]=observed
        return content
    for folder,revision in ((HERE,commit),(HERE.parent,CORE)):
        inventory=json.loads(anchor(revision,folder/'PREPARATION.json'))
        for name,item in inventory['files'].items():
            path=folder/name;need(path.resolve().is_relative_to(folder),'source path escape')
            data=anchor(revision,path,item['sha256']);need(len(data)==item['bytes'],'source byte count')
    derivation=json.loads((HERE/'DERIVATION.json').read_text())
    for item in derivation['parents']:anchor(item['commit'],ROOT/item['path'],item['sha256'])
    for name,digest in derivation['outputs'].items():need(sha(HERE/name)==digest,'derived source changed')
    archive=json.loads(anchor(PROOF,OLD/'COMPLETE_PROOF_ARCHIVE.json',ARCHIVE))
    need(archive['complete'] is True and len(archive['files'])==173,'old complete proof required')
    for name,digest in archive['files'].items():anchor(PROOF,OLD/name,digest)
    proof=json.loads((OLD/'COMPILED_PROOF.json').read_text())
    need(proof['complete'] is True and proof['manual_review']['complete'] is True,'old actual caller proof gate')
    upstream=json.loads((HERE/'upstream-pins.json').read_text())
    descriptor=json.loads(anchor(upstream['descriptor_commit'],ROOT/upstream['descriptor_path'],
                                 upstream['descriptor_sha256']))['source_sha256']
    for relative,digest in upstream['source_sha256'].items():
        path=(ROOT/relative).resolve()
        need(descriptor.get(relative)==digest and sha(path)==digest,'pinned upstream changed')
        prepared[str(path)]=digest
    return prepared

def consumed(dep,prepared):
    text=Path(dep).read_text().replace('\\\n',' ');need(':' in text,'missing depfile LHS')
    result={}
    for name in shlex.split(text.split(':',1)[1]):
        path=Path(name);path=(path if path.is_absolute() else ROOT/path).resolve()
        need(path.is_file(),'missing actual compiler input');observed=sha(path)
        if path.is_relative_to(ROOT):need(prepared.get(str(path))==observed,'unprepared repository input: '+str(path))
        result[str(path)]=observed
    for name in ('main.cpp','focused.hpp','pipeline.hpp','candidate.hpp','points.inc','proof-point.inc',
                 'base.h','layout_detail.h','split64_range_size.h','query_helpers.hpp','geometry.hpp',
                 'adapters.hpp','cpp-adapters.hpp','boost-adapters.hpp','fast_pattern_BF.h',
                 'four_sector_bloom.h','byte_split_bloom.h','split64_bloom.h'):
        need(str(HERE/name) in result,'required actual input absent: '+name)
    return result

def recheck(items):
    for path,digest in items.items():need(sha(path)==digest,'frozen file changed: '+path)
