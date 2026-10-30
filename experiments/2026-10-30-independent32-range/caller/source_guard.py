"""Exact prepared sources and consumed compiler inputs; no filter execution."""
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
from contract import need

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
KERNEL_PROOF='dcb6ef3a5f8c2bb2dffb4828016426586e4e2441'
ACCURACY='344b72c14c2be92920d671ab01765ae9121f971f'

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def blob(commit,path):
    need(bool(re.fullmatch('[0-9a-f]{40}',commit)),'full immutable commit required')
    return subprocess.check_output(['git','show',commit+':'+str(Path(path).relative_to(ROOT))],cwd=ROOT)

def verify(commit):
    prepared={}
    def anchor(revision,path,digest=None):
        path=Path(path).resolve();content=path.read_bytes()
        need(content==blob(revision,path),'committed input changed: '+str(path))
        observed=hashlib.sha256(content).hexdigest()
        need(digest is None or observed==digest,'input hash changed: '+str(path))
        need(str(path) not in prepared or prepared[str(path)]==observed,'conflicting source identities')
        prepared[str(path)]=observed
        return content
    prep=HERE/'PREPARATION.json';inventory=json.loads(anchor(commit,prep))
    for name,item in inventory['files'].items():
        path=HERE/name;anchor(commit,path,item['sha256'])
        need(path.stat().st_size==item['bytes'],'prepared byte count differs')
    derivation=json.loads((HERE/'DERIVATION.json').read_text())
    for item in derivation['parents']:anchor(item['commit'],ROOT/item['path'],item['sha256'])
    for name,digest in derivation['outputs'].items():need(sha(HERE/name)==digest,'derived source differs')
    for folder,revision,name,count in ((HERE.parent,KERNEL_PROOF,'PROOF_ARCHIVE.json',45),
            (HERE.parent/'accuracy',ACCURACY,'ACCURACY_ARCHIVE.json',10)):
        archive=json.loads(anchor(revision,folder/name))
        need(archive['complete'] is True and len(archive['files'])==count,'incomplete ancestor proof')
        for relative,item in archive['files'].items():
            # The earlier kernel archive uses SHA strings; accuracy uses sized records.
            if name=='PROOF_ARCHIVE.json':
                need(type(item)is str,'kernel archive schema');digest=item
            else:
                need(type(item)is dict and set(item)=={'bytes','sha256'},'accuracy archive schema')
                need((folder/relative).stat().st_size==item['bytes'],'accuracy artifact byte count')
                digest=item['sha256']
            anchor(revision,folder/relative,digest)
    proof=json.loads((HERE.parent/'COMPILED_PROOF.json').read_text())
    need(proof['complete'] is True and set(proof['executables'])=={'native','avx2','scalar','native-asan'},'four-backend proof required')
    gate=json.loads((HERE.parent/'accuracy/results-v1/decision.json').read_text())
    need(gate['primary_12bpk_both_sizes_pass'] is True and gate['rows_retained']==16,'primary accuracy gate not passed')
    upstream=json.loads((HERE/'upstream-pins.json').read_text())
    descriptor=anchor(upstream['descriptor_commit'],ROOT/upstream['descriptor_path'],upstream['descriptor_sha256'])
    old=json.loads(descriptor)['source_sha256']
    for relative,digest in upstream['source_sha256'].items():
        path=(ROOT/relative).resolve()
        need(old.get(relative)==digest and sha(path)==digest,'frozen upstream changed')
        prepared[str(path)]=digest
    return prepared

def consumed(dep,prepared):
    text=Path(dep).read_text().replace('\\\n',' ');need(':' in text,'missing dependency LHS')
    result={}
    for value in shlex.split(text.split(':',1)[1]):
        path=Path(value);path=path if path.is_absolute() else ROOT/path
        need(path.is_file(),'consumed source missing')
        path=path.resolve();observed=sha(path)
        if path.is_relative_to(ROOT):
            need(prepared.get(str(path))==observed,'unprepared/changed repository compiler input: '+str(path))
        result[str(path)]=observed
    for name in ('main.cpp','points.inc','proof-point.inc','candidate.hpp','control.hpp','split64_range_size.h',
            'fast_pattern_BF.h','four_sector_bloom.h','split64_bloom.h','byte_split_bloom.h',
            'query_helpers.hpp','geometry.hpp','cpp-adapters.hpp','boost-adapters.hpp'):
        need(str((HERE/name).resolve()) in result,'required consumed input absent: '+name)
    return result

def recheck(items):
    for path,digest in items.items():need(sha(path)==digest,'frozen file changed: '+path)
