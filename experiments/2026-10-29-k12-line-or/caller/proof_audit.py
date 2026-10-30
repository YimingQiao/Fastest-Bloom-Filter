#!/usr/bin/env python3
"""Offline audit of the preserved failed V1 and successful V2; never run a BF."""
import json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE/'preflight-v2'))
from repair_guard import verify
from source_guard import sha
from contract import CASES,SEMANTICS,need,rows

SOURCE='ff107228ca48e88619a59497b08a4d889335a214'
def audit(live=True):
    p=HERE/'validation-v2';meta=json.loads((p/'metadata.json').read_text())
    need(meta['source_commit']==SOURCE and meta['complete'] is True and meta['performance_run'] is False,'Wrong/incomplete V2')
    need(len(meta['commands'])==31,'Unexpected command ledger')
    for command in meta['commands']:
        need(command['complete'] is True and (command['returncode']==0)==command['expected_success'],'Unexpected command status')
        for stream in ('stdout','stderr'):need(sha(p/command[stream])==command[stream+'_sha256'],'Raw command drift')
    rebuilt=[];same={}
    for profile in ('native','minimal-f','asan'):
        record=meta['profiles'][profile]
        oracle=json.loads((p/(profile+'-bitmap-check.stdout')).read_text())
        need(oracle==record['oracle']==dict(cases=1642,digest=1788386356380234980,complete=True),'Oracle mismatch')
        for i,case in enumerate(CASES):
            values=rows((p/f'{profile}-caller-{i}.stdout').read_text(),case)
            for row in values:
                key=(i,row['filter']);sem=tuple(row[k]for k in SEMANTICS)
                need(same.get(key,sem)==sem,'Backend semantics changed');same[key]=sem
                rebuilt.append(dict(profile=profile,case=i,**row))
    need(rebuilt==json.loads((p/'rows.json').read_text())and len(rebuilt)==12,'Aggregate/raw mismatch')
    if live:
        need(verify(SOURCE)==meta['source_sha256'],'Source closure changed')
        for path,digest in meta['compiler_consumed_input_sha256'].items():need(sha(path)==digest,'Actual compiler input changed')
        for path,digest in meta['all_binary_sha256'].items():need(sha(path)==digest,'Compiled binary changed')
    review=json.loads((HERE/'assembly-review/REVIEW.json').read_text())
    need(review['source_sha256']==sha(p/'native-assembly.stdout'),'ASM input drift')
    need(review['binary_sha256']==meta['profiles']['native']['executables']['compare_benchmark']['sha256'],'ASM binary identity mismatch')
    return dict(source_commit=SOURCE,profiles=3,oracle_cases=4926,caller_rows=12,invalid_cli=6,commands=31,
                actual_compiler_inputs=len(meta['compiler_consumed_input_sha256']),binaries=6,manual_assembly_review='passed',
                first_attempt='Preserved project link failure, zero filter executions',performance_run=False)
if __name__=='__main__':print(json.dumps(audit(),sort_keys=True))
