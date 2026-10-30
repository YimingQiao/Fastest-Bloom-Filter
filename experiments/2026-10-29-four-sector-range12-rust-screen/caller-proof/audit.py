#!/usr/bin/env python3
"""Offline complete caller evidence replay; no compiler/filter/timing calls."""
import csv,hashlib,io,json,re,struct,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1];CALLER=STAGE/'caller';RAW=CALLER/'validation-v1';ASM=STAGE/'caller-asm-v2/capture-v2'
sys.path.insert(0,str(CALLER/'preflight'))
from bindings import verify,sha,need
from contract import cases,argv,compare,semantic,TINY
from guard import validate_rows
SOURCE='72625673e6b5bb57874a5fa53e04d23ffb8c6ab2';RAW_COMMIT='0b2425682ad6435089aab89a84e55eedebbea86c'

def relocations(binary):
    data=Path(binary).read_bytes();need(data[:6]==b'\x7fELF\x02\x01','Expected little-endian ELF64');off=struct.unpack_from('<Q',data,0x28)[0];size,count=struct.unpack_from('<HH',data,0x3a)
    records={}
    for i in range(count):
        header=struct.unpack_from('<IIQQQQIIQQ',data,off+i*size)
        if header[1]!=4:continue
        for start in range(header[4],header[4]+header[5],header[9]):
            address,info,addend=struct.unpack_from('<QQq',data,start)
            if info&0xffffffff==8:records[address]=addend
    return records

def audit():
    pins,external,roots,old=verify(SOURCE);meta=json.loads((RAW/'metadata.json').read_text())
    raw_manifest=RAW/'ARCHIVE.json';need(raw_manifest.read_bytes()==subprocess.check_output(['git','show',RAW_COMMIT+':'+str(raw_manifest.relative_to(ROOT))],cwd=ROOT),'Original raw descriptor changed')
    for name,record in json.loads(raw_manifest.read_text())['files'].items():
        p=RAW/name;need(sha(p)==record['sha256']and p.stat().st_size==record['bytes'],'Original raw changed');need(p.read_bytes()==subprocess.check_output(['git','show',RAW_COMMIT+':'+str(p.relative_to(ROOT))],cwd=ROOT),'Original raw Git bytes differ')
    need(meta['complete']is True and meta['source_commit']==SOURCE and len(meta['commands'])==57,'Incomplete caller proof')
    commands={r['label']:r for r in meta['commands']};need(len(commands)==57,'Duplicate proof command')
    for label,record in commands.items():
        need(record['complete']is True,'Unfinished command')
        for stream in ['stdout','stderr']:need(sha(RAW/record[stream])==record[stream+'_sha256'],'Command output drift')
        if record['expected_success']:need(record['returncode']==0,'Unexpected command failure')
        else:need(record['returncode']!=0 and (RAW/record['stdout']).stat().st_size==0,'Bad CLI accepted/emitted output')
    expected=dict(focused_test_executions=6,caller_rows=84,retained_reference_rows=38,retained_semantic_comparisons=76,invalid_cli_cases=12,throughput_workloads=0,kernel_matrix_repeated=False)
    for key,value in expected.items():need(meta[key]==value,'Wrong bounded count '+key)
    source=(CALLER/'benchmark/src/main.rs').read_text();comparisons=0;normal=[];asan=[];quality={}
    for mode,all_rows in [('normal',normal),('asan',asan)]:
        for index,case in enumerate(cases(source)):
            record=commands[f'{mode}-case-{index}'];need(record['command']==argv(meta['mode_executables'][mode],case),'Changed tiny command')
            rows=list(csv.DictReader(io.StringIO((RAW/record['stdout']).read_text())));validate_rows(rows,case,TINY,source);all_rows.extend(rows)
            oldrows=list(csv.DictReader(io.StringIO((RAW/commands[f'reference-case-{index}']['stdout']).read_text())));comparisons+=compare(rows,oldrows)
            for row in rows:
                key=(row['filter'],row['filter_bytes']);value=(row['result_checksum'],row['false_positives'],row['calibration_false_positives'])
                need(key not in quality or quality[key]==value,'Cross-batch/mode semantic drift');quality[key]=value
    need(comparisons==76 and len(normal)==len(asan)==42 and list(map(semantic,normal))==list(map(semantic,asan)),'Incomplete exact semantic proof')
    for name,digest in meta['binaries'].items():need(sha(Path(name))==digest,'Changed binary')
    for group in meta['compiler_consumed_inputs_sha256'].values():
        for name,digest in group.items():need(sha(Path(name))==digest,'Changed actual consumed source')
    capture=json.loads((ASM/'CAPTURE.json').read_text());need(capture['complete']is True and capture['binary_sha256']==meta['assembly']['sha256'],'Incomplete corrected ASM')
    for record in capture['commands']:
        need(record['complete']is True and record['returncode']==0,'Failed corrected capture')
        for stream in ['stdout','stderr']:need(sha(ASM/record[stream])==record[stream+'_sha256'],'ASM output drift')
        text=(ASM/record['stdout']).read_text();insns=re.findall(r'^\s*([0-9a-f]+):\s+(\S+)',text,re.M)
        need(len(insns)==record['instructions'] and int(insns[0][0],16)==record['begin'],'Empty/changed corrected instructions')
    binary=Path(capture['binary']);relocs=relocations(binary);need(relocs[0xe41e0]==0xa11a0,'Bulk wrapper GOT target does not resolve to public lookup_hashes')
    for index,call in [(0,'2346b'),(1,'2354b')]:
        text=(ASM/f'query-{index}.stdout').read_text();need(re.search(r'\b'+call+r':\s+call\s+8dc40\b',text)is not None,'Changed visible per-key helper call')
    return dict(complete=True,source_commit=SOURCE,raw_commit=RAW_COMMIT,corrected_asm_source_commit=capture['source_commit'],**expected,commands=57,
        compiled_inputs_per_mode={k:len(v)for k,v in meta['compiler_consumed_inputs_sha256'].items()},
        actual_caller_binary=str(binary),actual_caller_sha256=sha(binary),binaries_sha256=meta['binaries'],prepared_input_sha256=pins,
        compiler_consumed_inputs_sha256=meta['compiler_consumed_inputs_sha256'],public_bulk_got=dict(offset='0xe41e0',target='0xa11a0'),
        codegen='Both visible loops still call the unchanged public scalar helper per key; no inline/throughput assumption',original_empty_captures_preserved=True)
if __name__=='__main__':print(json.dumps(audit(),indent=2))
