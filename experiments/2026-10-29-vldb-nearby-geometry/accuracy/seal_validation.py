#!/usr/bin/env python3
"""Seal completed caller proof without compiling or executing a Bloom filter."""
import json
from pathlib import Path
import shutil
from contract import GEOMETRY,cases,command,comparable,names,need,parse,untimed
from nearby_accuracy_guard import HERE,ROOT,sha,verify,validate_inputs

SOURCE='61297f000468ed498d5dc12df1bd4fcf129bbf12'
OUT=HERE/'validation-v1'
def save(path,value):path.write_text(json.dumps(value,indent=2,sort_keys=True)+'\n')

def main():
    archives,inputs=verify(SOURCE)
    meta=json.loads((OUT/'metadata.json').read_text())
    need(meta['complete']is True and meta['source_commit']==SOURCE,'Incomplete caller proof')
    need(meta['caller_rows']==12 and meta['old_reference_rows']==6 and meta['rejected_or_fault_cases']==12,
         'Wrong proof coverage')
    need(meta['formal_pilot_run']is False and meta['throughput_samples']==0 and meta['upstream_rebuilds']==0,
         'Changed proof scope')
    need(meta['frozen_sources_unchanged']is True and meta['tuner_file_before']==meta['tuner_file_after'],
         'Input/tuner drift')
    need(meta['lease']['cpu']==2 and meta['lease']['lease']=='socket0'and
         meta['lease']['lock_path']=='/tmp/fastest-bf-socket0.lock'and
         bool(meta['lease']['inherited_lock_descriptors']),'Wrong recorded placement')
    need(not any(meta['environment'].values()),'Unfrozen environment')
    records={r['label']:r for r in meta['commands']};expected=['compiler']
    for backend in ('native','native-asan'):
        expected += [backend+suffix for suffix in ('-configure','-build','-macros')]
        for i in range(6):
            expected.append(backend+'-case'+str(i))
            if i%2==0:expected.append(backend+'-case'+str(i)+'-old')
        expected += [backend+'-invalid'+str(i)for i in range(6)]
    need([r['label']for r in meta['commands']]==expected and len(records)==37,'Changed command ledger')
    for label,record in records.items():
        need(record['complete']is True and (record['returncode']!=0)==('-invalid'in label),'Command failure')
        for stream in ('stdout','stderr'):
            path=OUT/(label+'.'+stream)
            need(record[stream]==path.name and sha(path)==record[stream+'_sha256'],'Raw output drift')
        if '-case'in label:need(not(OUT/record['stderr']).read_bytes(),'Public API diagnostic')
        if '-invalid'in label:need(not(OUT/record['stdout']).read_bytes(),'Rejected invocation emitted row')
    consumed={};reference=None
    for backend in ('native','native-asan'):
        binary=meta['binaries'][backend];need(sha(binary['path'])==binary['sha256'],'Tested binary drift')
        rows=[]
        for name in names():
            for policy in ('original','nearby_odd'):
                case=dict(filter=name,power=16,cap=24,policy=policy)
                label=backend+'-case'+str(len(rows));record=records[label]
                need(record['command']==command(binary['path'],case,tiny=True),'Caller command drift')
                row=parse((OUT/record['stdout']).read_text());untimed(row,power=16,qpower=12,calpower=10)
                selected=[c for c in cases()if all(c[k]==case[k]for k in case)]
                need(len(selected)==1 and comparable({k:row[k]for k in GEOMETRY})==comparable(selected[0]['geometry']),
                     'Fixed public geometry drift')
                if policy=='original':
                    old=records[label+'-old'];old_binary=inputs['reference_binaries'][backend]['path']
                    need(old['command']==command(old_binary,case,tiny=True)[:-1],'Reference command changed')
                    need(comparable(row)==comparable(parse((OUT/old['stdout']).read_text())),'Old full-row parity failed')
                rows.append(row)
        need(rows==meta['rows'][backend],'Raw/metadata row drift')
        if reference is None:reference=rows
        need(rows==reference,'Native/sanitizer semantic drift')
        headers=json.loads((OUT/(backend+'-consumed-inputs.json')).read_text())
        actual=validate_inputs(headers,inputs['files'])
        for name,digest in actual.items():
            need(name not in consumed or consumed[name]==digest,'Cross-backend source drift');consumed[name]=digest
        build=Path(binary['path']).parent;prefix='CMakeFiles/vldb_nearby_accuracy.dir/'
        for name in ('CMakeCache.txt','compile_commands.json',prefix+'worker.cpp.o.d',prefix+'flags.make',
                     prefix+'link.txt',prefix+'build.make'):
            source=build/name;dest=OUT/'build-inputs'/backend/name;dest.parent.mkdir(parents=True,exist_ok=True)
            if dest.exists():need(dest.read_bytes()==source.read_bytes(),'Archived build input drift')
            else:shutil.copyfile(source,dest)
    freeze=dict(source_commit=SOURCE,commands=37,caller_rows=12,old_reference_rows=6,rejected_or_fault_cases=12,
                binaries=meta['binaries'],reference_binaries=inputs['reference_binaries'],original_archives=archives,
                compiler_consumed_inputs_sha256=consumed,nearby_geometry_proof_commit='11584813b8f300d0405c58d458bbf901c996468b',
                selection_sha256=sha(HERE/'selection.json'),protocol_sha256=sha(HERE/'protocol.json'),
                full36_pilot_run=False,throughput_samples=0,upstream_rebuilds=0,
                calibration_fixture_negatives_per_row=1024,fixture_keys=65536)
    save(HERE/'WORKER_FREEZE.json',freeze)
    files=sorted([p for p in OUT.rglob('*')if p.is_file()]+[HERE/'preflight-v1.log',HERE/'seal_validation.py',
        HERE/'VALIDATION.md',HERE/'WORKER_FREEZE.json'])
    save(HERE/'CALLER_ARCHIVE.json',dict(source_commit=SOURCE,files={str(p.relative_to(HERE)):sha(p)for p in files}))
    print('PASS12 caller/6old/12fault rows;37 commands;',len(consumed),'compiler inputs;',len(files),'proof artifacts; no BF executed')

if __name__=='__main__':main()
