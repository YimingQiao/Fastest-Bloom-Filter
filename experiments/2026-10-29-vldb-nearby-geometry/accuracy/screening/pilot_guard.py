"""Committed runner/worker provenance and complete36 raw-ledger audit."""
import json
from pathlib import Path
import re
import sys

HERE=Path(__file__).resolve().parent;STAGE=HERE.parent
sys.path.insert(0,str(STAGE))
from contract import cases,command,need,parse,quality,validate as validate_accuracy
from nearby_accuracy_guard import ORIGINAL,PARENT,ROOT,exact,sha,verify as caller_verify
CALLER_SOURCE='61297f000468ed498d5dc12df1bd4fcf129bbf12'
CALLER_PROOF='14a5a1cb7d96d41abd62ce05e82dcb29b6a42353'
BINARY_SHA='4e67b8e0351f574004c0db485ba4883d128dd8906120d49b5b0eacaab781e930'

def validate(row,case):
    if case['status']=='supported':
        columns=list(json.loads((STAGE/'validation-v1/metadata.json').read_text())['rows']['native'][0])
        need(list(row)==columns,'Changed tested caller CSV schema')
    return validate_accuracy(row,case)

def verify(commit):
    need(__debug__ and re.fullmatch('[0-9a-f]{40}',commit)is not None,'Exact runner commit and active checks required')
    caller_verify(CALLER_SOURCE)
    descriptor=STAGE/'CALLER_ARCHIVE.json';exact(CALLER_PROOF,descriptor)
    archive=json.loads(descriptor.read_text());need(archive['source_commit']==CALLER_SOURCE,'Wrong caller source')
    for name,digest in archive['files'].items():
        path=STAGE/name;need(sha(path)==digest,'Changed caller proof '+name);exact(CALLER_PROOF,path)
    freeze=json.loads((STAGE/'WORKER_FREEZE.json').read_text())
    need(freeze['source_commit']==CALLER_SOURCE and freeze['commands']==37 and freeze['caller_rows']==12 and
         freeze['old_reference_rows']==6 and freeze['rejected_or_fault_cases']==12,'Incomplete tested caller')
    need(freeze['full36_pilot_run']is False and freeze['throughput_samples']==0,'Wrong prior proof scope')
    for name,digest in freeze['compiler_consumed_inputs_sha256'].items():
        need(sha(name)==digest,'Compiler input drift')
    for item in freeze['binaries'].values():need(sha(item['path'])==item['sha256'],'Tested caller binary drift')
    binary=Path(freeze['binaries']['native']['path']);need(sha(binary)==BINARY_SHA,'Wrong accuracy binary')
    prep=HERE/'PREPARATION.json';exact(commit,prep)
    for name,digest in json.loads(prep.read_text())['files'].items():
        path=HERE/name;need(sha(path)==digest,'Runner source drift');exact(commit,path)
    need(freeze['selection_sha256']==sha(STAGE/'selection.json')and freeze['protocol_sha256']==sha(STAGE/'protocol.json'),
         'Frozen pilot geometry/protocol drift')
    return binary,freeze

def audit(output,meta,binary,commit,final=True):
    need(meta['source_commit']==commit and meta['caller_proof_commit']==CALLER_PROOF and
         meta['binary']==str(binary)and meta['binary_sha256']==BINARY_SHA,'Recorded identity drift')
    need(meta['selection_sha256']==sha(STAGE/'selection.json')and meta['protocol_sha256']==sha(STAGE/'protocol.json'),
         'Recorded fixed selection drift')
    held=meta['lease'];fds=held.get('inherited_lock_descriptors')
    need(isinstance(fds,list)and bool(fds)and all(type(fd)is int and fd>=0 for fd in fds)and
         len(set(fds))==len(fds),'Malformed inherited lock metadata')
    need(held['cpu']==2 and held['lease']=='socket0'and
        held['lock_path']=='/tmp/fastest-bf-socket0.lock'and bool(held['inherited_lock_descriptors'])and
        meta['affinity']==[2],'Wrong recorded placement')
    need(not any(meta['environment'].values()),'Recorded environment changed')
    need(meta['tuner_file_before']==meta['tuner_file_after'],'User tuner changed')
    need(len(meta['commands'])==36,'Incomplete fixed36 ledger')
    rows=[];inventory={'metadata.json','results.json','quality.json'}
    for i,(case,record)in enumerate(zip(cases(),meta['commands'],strict=True)):
        need(record['case']==case and record['command']==command(binary,case),'Changed finite command')
        need(record['complete']is True and record['returncode']==0,'Incomplete accuracy case')
        for stream in('stdout','stderr'):
            name=f'case-{i:02d}.'+stream;path=output/name;inventory.add(name)
            need(record[stream]==name and sha(path)==record[stream+'_sha256'],'Raw stream drift')
        need(not(output/record['stderr']).read_bytes(),'Unexpected public diagnostic')
        row=parse((output/record['stdout']).read_text());validate(row,case)
        need(record['row']==row,'Raw/record semantic mismatch');rows.append(row)
    need(rows==json.loads((output/'results.json').read_text()),'Raw/aggregate mismatch')
    q=quality(rows);need(q==json.loads((output/'quality.json').read_text()),'Quality interval/identity changed')
    need({p.name for p in output.iterdir()if p.is_file()}==inventory,'Unexpected raw artifact inventory')
    if final:
        need(meta['complete']is True and meta['all_frozen_inputs_unchanged']is True,'Incomplete final pilot')
        need(meta['rows']==36 and meta['old_reproductions']==24 and meta['new_geometries']==12 and
             meta['throughput_samples']==0 and meta['pooled']is False,'Changed final scope')
        need(meta['results_sha256']==sha(output/'results.json')and meta['quality_sha256']==sha(output/'quality.json'),
             'Final result digest changed')
    return rows,q
