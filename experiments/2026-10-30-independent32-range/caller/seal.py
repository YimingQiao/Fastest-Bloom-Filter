"""Replay the bounded proof and freeze its existing evidence; no compiler/filter runs."""
import json
from pathlib import Path
from contract import need,parse,semantic,cross_batch,old_reference,CASES,ALLOCATION_CASES
from source_guard import HERE,sha,verify,recheck
from lease import require

def save(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def main():
    require();meta=json.loads((HERE/'validation-v1/metadata.json').read_text())
    need(meta['complete'] is True and meta['formal_workloads']==0,'complete bounded proof required')
    need(verify(meta['source_commit'])==meta['source_sha256'],'prepared closure changed')
    recheck(meta['compiler_consumed_input_sha256']);recheck(meta['all_binary_sha256']);recheck(meta['tools_sha256'])
    commands=json.loads((HERE/'validation-v1/commands.json').read_text());need(len(commands)==66,'command count')
    for command in commands:
        for stream in ('stdout','stderr'):need(sha(HERE/command[stream])==command[stream+'_sha256'],'command stream drift')
        need(command['returncode']==(0 if command['expected_success']else 1),'command outcome differs')
    need(sum(not c['expected_success']for c in commands)==8,'rejection count')
    records=json.loads((HERE/'validation-v1/records.json').read_text())
    allocations=json.loads((HERE/'validation-v1/allocation-records.json').read_text())
    for profile in ('normal','asan'):
        for mode,cases,stored,allocation in (('case',CASES,records[profile],False),('allocation',ALLOCATION_CASES,allocations[profile],True)):
            need(len(stored)==len(cases),'case count drift')
            for i,(case,record)in enumerate(zip(cases,stored,strict=True)):
                command=next(c for c in commands if c['label']==f'{profile}-{mode}-{i}')
                need(record==dict(case=case,rows=parse((HERE/command['stdout']).read_text(),case,allocation)),'stdout/records drift')
        cross_batch(records[profile]);old_reference(records[profile],profile)
    need(allocations['normal']==allocations['asan'],'actual allocation parity')
    for a,b in zip(records['normal'],records['asan'],strict=True):
        need([semantic(r)for r in a['rows']]==[semantic(r)for r in b['rows']],'actual semantic parity')
    outcome=json.loads((HERE/'execution-outcome.json').read_text())
    need(outcome['session_id']==93501 and outcome['exit_code']==0 and outcome['terminal_tool_result']['exit_code']==0
        and outcome['terminal_tool_result']['output']=='' and 'session_id'not in outcome['terminal_tool_result'],'terminal proof')
    review=json.loads((HERE/'assembly-review/REVIEW.json').read_text())
    need(review['complete'] and review['manual_review']=='passed' and len(review['clocks'])==9,'actual manual gate')
    capture=json.loads((HERE/'assembly-review/callees/CAPTURE.json').read_text())
    need(capture['complete'] and len(capture['spans'])==6 and capture['binary_sha256']==review['binary_sha256'],'callee closure')
    for s in meta['assembly']['symbols']:need(sha(HERE/s['stdout'])==s['sha256'],'caller ASM drift')
    for s in capture['spans']:need(sha(HERE/'assembly-review/callees'/s['stdout'])==s['sha256'],'callee ASM drift')
    normal=meta['assembly']['binary'];need(meta['all_binary_sha256'][normal]==review['binary_sha256'],'review binary drift')
    proof=dict(complete=True,source_commit=meta['source_commit'],preparation_sha256=sha(HERE/'PREPARATION.json'),
        scope='two-build bounded actual-public-caller correctness; no formal216 timing',
        metadata='validation-v1/metadata.json',metadata_sha256=sha(HERE/'validation-v1/metadata.json'),
        normal_executable=dict(path=normal,sha256=review['binary_sha256']),
        all_binary_sha256=meta['all_binary_sha256'],compiler_consumed_input_sha256=meta['compiler_consumed_input_sha256'],
        prepared_source_sha256=meta['source_sha256'],tools_sha256=meta['tools_sha256'],counts=meta['counts'],
        manual_review=dict(complete=True,json='assembly-review/REVIEW.json',sha256=sha(HERE/'assembly-review/REVIEW.json'),
            text='assembly-review/REVIEW.md',text_sha256=sha(HERE/'assembly-review/REVIEW.md')))
    save(HERE/'COMPILED_PROOF.json',proof)
    files=[p for folder in ('validation-v1','assembly-review')for p in (HERE/folder).rglob('*')if p.is_file()and'__pycache__'not in p.parts]
    files += [HERE/n for n in ('COMPILED_PROOF.json','REPORT.md','execution-outcome.json','preflight-v1.log','seal.py')]
    need(len(files)==len(set(files)),'archive duplicate')
    archive=dict(complete=True,source_commit=meta['source_commit'],session_id=93501,scope=proof['scope'],
        files={str(p.relative_to(HERE)):sha(p)for p in sorted(files)})
    save(HERE/'COMPLETE_PROOF_ARCHIVE.json',archive)
    print('PASS:66commands,66rows,36allocations,14oldsemantics,2binaries,570inputs,36roles+6callees;',len(files),'archive artifacts')

if __name__=='__main__':main()
