#!/usr/bin/env python3
"""Replay completed focused proof without compilation, filters or performance."""
import csv,hashlib,io,json,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1];CALLER=STAGE/'caller';RAW=CALLER/'validation-v1'
sys.path.insert(0,str(CALLER/'preflight'))
from contract import TINY,cases,argv,compare,semantic,invalid,NEW
from guard import validate_rows
from asm_audit import audit as assembly
SOURCE='c05d5a0f00e37aa53680af08792607f424afe773'
def need(ok,msg):
    if not ok:raise ValueError(msg)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def blob(commit,path):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
def audit():
    declaration=CALLER/'PREPARATION.json';need(declaration.read_bytes()==blob(SOURCE,declaration),'Original source manifest changed');prep=json.loads(declaration.read_text())
    pins={str(declaration.relative_to(ROOT)):sha(declaration)}
    for name,r in prep['files'].items():
        p=CALLER/name;need(sha(p)==r['sha256']and p.stat().st_size==r['bytes']and p.read_bytes()==blob(SOURCE,p),'Original prepared source changed '+name);pins[str(p.relative_to(ROOT))]=r['sha256']
    for name,r in prep['parents'].items():
        p=ROOT/name;need(sha(p)==r['sha256']and p.read_bytes()==blob(r['commit'],p),'Inherited source changed '+name);pins[name]=r['sha256']
    m=json.loads((RAW/'metadata.json').read_text());need(m['complete']and m['source_commit']==SOURCE and 'error'not in m,'Proof not complete')
    need(m['prepared_input_sha256']==pins,'Consumed preparation set changed')
    need(m['affinity']==[3]and m['lease']['cpu']==3 and m['lease']['lease']=='socket1'and m['lease']['inherited_lock_descriptors'],'Wrong recorded placement')
    for group in [m['binaries'],*m['compiler_consumed_inputs_sha256'].values()]:
        for name,digest in group.items():need(sha(Path(name))==digest,'Changed actual consumed input or binary '+name)
    commands={r['label']:r for r in m['commands']};need(len(commands)==len(m['commands'])==61,'Wrong unique command coverage')
    for r in commands.values():
        need(r['complete']and(r['returncode']==0)==r['expected_success'],'Incomplete or unexpected command status')
        for stream in ['stdout','stderr']:need(sha(RAW/r[stream])==r[stream+'_sha256'],'Command log changed')
    parent=ROOT/'experiments/2026-10-29-four-sector-range12-rust-screen/caller/validation-v1/metadata.json';parent_meta=json.loads(parent.read_text());reference=parent_meta['mode_executables']['normal'];need(sha(reference)==parent_meta['binaries'][reference],'Original reference executable changed')
    source=(CALLER/'benchmark/src/main.rs').read_text();rows_all={};comparisons=0
    for mode in ['normal','asan']:
        rows_all[mode]=[];binary=m['mode_executables'][mode]
        for i,case in enumerate(cases(source)):
            command=commands[f'{mode}-case-{i}'];need(command['command']==argv(binary,case),'Wrong actual caller invocation')
            rows=list(csv.DictReader(io.StringIO((RAW/command['stdout']).read_text())));validate_rows(rows,case,TINY,source)
            refcommand=commands[f'reference-case-{i}'];oldcase=dict(case,filters=[n for n in case['filters']if n!=NEW]);need(refcommand['command']==argv(reference,oldcase),'Wrong retained reference command')
            oldrows=list(csv.DictReader(io.StringIO((RAW/refcommand['stdout']).read_text())));comparisons+=compare(rows,oldrows);rows_all[mode]+=rows
        for i,command in enumerate(invalid(binary)):
            r=commands[f'{mode}-invalid-{i}'];need(r['command']==command and not(RAW/r['stdout']).read_bytes()and(RAW/r['stderr']).read_bytes(),'Malformed CLI guard failed')
        for test in ['actual_harness_detects_corrupt_last_output_in_every_timed_mode','four_mode_order_balances_positions_and_predecessors','single_line_bitmap_and_public_outputs','single_line_probe_physical_owner_invariant']:
            r=commands[mode+'-test-'+test];need('test result: ok. 1 passed'in(RAW/r['stdout']).read_text(),'Focused test not executed once')
    need(len(rows_all['normal'])==len(rows_all['asan'])==34 and comparisons==58,'Wrong fixture counts')
    need([semantic(r)for r in rows_all['normal']]==[semantic(r)for r in rows_all['asan']],'Normal/ASan semantic drift')
    asm=assembly();need(asm==json.loads((HERE/'ASM.json').read_text()),'Assembly audit drift')
    return dict(complete=True,source_commit=SOURCE,commands=61,focused_tests=8,focused_invariant_executions=2,actual_caller_rows=68,retained_reference_rows=29,retained_semantic_comparisons=58,invalid_cli_rejections=6,assembly_bodies=16,performance_workloads=0,new_calibration_samples=0,source_inputs_sha256=pins,binaries_sha256=m['binaries'],compiler_consumed_inputs_sha256=m['compiler_consumed_inputs_sha256'],performance_binary=m['mode_executables']['normal'],performance_binary_sha256=m['binaries'][m['mode_executables']['normal']])
if __name__=='__main__':print(json.dumps(audit(),indent=2))
