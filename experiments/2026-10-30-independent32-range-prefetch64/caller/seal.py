"""Replay existing bounded evidence and seal it; never compile or execute a filter."""
import json
from contract import need,parse,semantic,cross_batch,old_reference,CASES,ALLOCATION_CASES
from source_guard import HERE,sha,verify,recheck
from lease import require

def save(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def main():
    require();meta=json.loads((HERE/'validation-v1/metadata.json').read_text())
    need(meta['complete'] is True and meta['formal_workloads']==0,'complete bounded proof required')
    need(verify(meta['source_commit'])==meta['source_sha256'],'prepared closure changed')
    for key in ('compiler_consumed_input_sha256','all_binary_sha256','tools_sha256'):recheck(meta[key])
    need(len(meta['compiler_consumed_input_sha256'])==572 and len(meta['all_binary_sha256'])==3,'actual closure count')
    commands=json.loads((HERE/'validation-v1/commands.json').read_text());need(len(commands)==113,'command count')
    for command in commands:
        for stream in ('stdout','stderr'):need(sha(HERE/command[stream])==command[stream+'_sha256'],'command stream drift')
        need(command['returncode']==(0 if command['expected_success']else 1),'command outcome differs')
    need(sum(not c['expected_success']for c in commands)==8,'rejection count')
    records=json.loads((HERE/'validation-v1/records.json').read_text())
    allocations=json.loads((HERE/'validation-v1/allocation-records.json').read_text())
    for profile,backend in (('normal','avx512vbmi-vl'),('avx2','avx2'),('asan','avx512vbmi-vl')):
        command=next(c for c in commands if c['label']==profile+'-focused')
        expected='PASS backend='+backend+';4 geometry pairs;648 calls per arm;360 bulk requests;98304B representative allocation\n'
        need((HERE/command['stdout']).read_text()==expected and not(HERE/command['stderr']).read_bytes(),'focused result')
        need(meta['backend'][profile]==backend and meta['focused'][profile]==dict(calls_per_arm=648,bulk_requests=360,zero_null_per_arm=4),'focused metadata')
        need(len(records[profile])==len(CASES),'case count drift')
        for i,(case,record)in enumerate(zip(CASES,records[profile],strict=True)):
            command=next(c for c in commands if c['label']==f'{profile}-case-{i}')
            need(record==dict(case=case,rows=parse((HERE/command['stdout']).read_text(),case)),'stdout/records drift')
        cross_batch(records[profile]);old_reference(records[profile],'asan'if profile=='asan'else'normal')
    need(len(allocations)==len(ALLOCATION_CASES),'allocation count')
    for i,(case,record)in enumerate(zip(ALLOCATION_CASES,allocations,strict=True)):
        command=next(c for c in commands if c['label']==f'normal-allocation-{i}')
        need(record==dict(case=case,rows=parse((HERE/command['stdout']).read_text(),case,True)),'allocation evidence')
    for profile in ('avx2','asan'):
        for a,b in zip(records['normal'],records[profile],strict=True):
            need([semantic(r)for r in a['rows']]==[semantic(r)for r in b['rows']],'actual semantic parity')
    outcome=json.loads((HERE/'execution-outcome.json').read_text())
    need(outcome['session_id']==46093 and outcome['exit_code']==0 and outcome['terminal_tool_result']['exit_code']==0
         and outcome['terminal_tool_result']['output']=='' and 'session_id'not in outcome['terminal_tool_result'],'actual terminal')
    review=json.loads((HERE/'assembly-review/REVIEW.json').read_text())
    need(review['complete'] and review['manual_review']=='passed' and len(review['clocks'])==18,'manual gate')
    capture=json.loads((HERE/'assembly-review/callees/CAPTURE.json').read_text())
    need(capture['complete'] and capture['filter_executions']==capture['compiler_executions']==0,'same-binary capture')
    need(capture['original_metadata_sha256']==sha(HERE/'validation-v1/metadata.json'),'capture metadata identity')
    for profile,count in (('normal',6),('avx2',5)):
        asm=meta['assembly'][profile];extra=capture['profiles'][profile]
        need(len(asm['symbols'])==36 and len(extra['spans'])==count,'actual ASM scope')
        need(asm['sha256']==extra['binary_sha256']==review['binary_sha256'][profile],'actual ELF identity')
        for span in asm['symbols']:need(sha(HERE/span['stdout'])==span['sha256'],'original ASM drift')
        for span in extra['spans']:need(sha(HERE/'assembly-review/callees'/span['stdout'])==span['sha256'],'callee ASM drift')
    normal=meta['assembly']['normal']['binary']
    proof=dict(complete=True,source_commit=meta['source_commit'],preparation_sha256=sha(HERE/'PREPARATION.json'),
        scope='three-profile bounded actual-public-caller and fixed64 queue correctness; no formal192 timing',
        metadata='validation-v1/metadata.json',metadata_sha256=sha(HERE/'validation-v1/metadata.json'),
        normal_executable=dict(path=normal,sha256=meta['all_binary_sha256'][normal]),
        all_binary_sha256=meta['all_binary_sha256'],compiler_consumed_input_sha256=meta['compiler_consumed_input_sha256'],
        prepared_source_sha256=meta['source_sha256'],tools_sha256=meta['tools_sha256'],counts=meta['counts'],
        manual_review=dict(complete=True,json='assembly-review/REVIEW.json',sha256=sha(HERE/'assembly-review/REVIEW.json'),
            text='assembly-review/REVIEW.md',text_sha256=sha(HERE/'assembly-review/REVIEW.md')))
    save(HERE/'COMPILED_PROOF.json',proof)
    files=[p for folder in ('validation-v1','assembly-review')for p in(HERE/folder).rglob('*')if p.is_file()and'__pycache__'not in p.parts]
    files += [HERE/n for n in ('COMPILED_PROOF.json','REPORT.md','execution-outcome.json','preflight-v1.log','seal.py')]
    need(len(files)==len(set(files)),'archive duplicate')
    need(not any(p.read_bytes().startswith(b'\x7fELF') for p in files),'executable in archive')
    save(HERE/'COMPLETE_PROOF_ARCHIVE.json',dict(complete=True,source_commit=meta['source_commit'],session_id=46093,
        scope=proof['scope'],files={str(p.relative_to(HERE)):sha(p)for p in sorted(files)}))
    print('PASS 113 commands,90 rows,16 allocations,21 old semantics,3 binaries,572 inputs,72 roles+11 callees;',len(files),'archive artifacts')

if __name__=='__main__':main()
