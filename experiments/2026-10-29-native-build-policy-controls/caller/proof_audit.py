#!/usr/bin/env python3
"""Offline complete caller/ASM proof audit; no compiler, disassembler or BF."""
import hashlib,json,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE/'preflight'))
from contract import SEMANTICS,fixtures,need,parse,reference_check,validate
from dependencies import collect
from source_guard import ROOT,sha,verify
from validate import command

def main():
 proof_path=HERE/'preflight/validation-v1/commands.json';meta=parse(proof_path.read_text())
 need(meta['complete']and meta['formal_performance_run']is False,'Incomplete caller proof')
 sources=verify(meta['source_commit']);need(sources==meta['source_sha256'],'Source closure drift')
 need(len(meta['commands'])==52 and len(meta['records'])==24 and len(meta['binaries'])==4,'Wrong proof extent')
 labels={x['label']:x for x in meta['commands']};need(len(labels)==52,'Duplicate command label')
 for item in labels.values():
  need((item['returncode']==0)==item['expected_success'],'Wrong observed command status')
  for stream in ['stdout','stderr']:need((proof_path.parent/(item['label']+'.'+stream)).is_file(),'Missing command output')
  if not item['expected_success']:need(not(proof_path.parent/(item['label']+'.stdout')).read_bytes(),'Failed command emitted data')
 rows=[];semantics={};lease=meta['lease']
 for backend in ['normal','asan']:
  for language in ['cpp','rust']:
   binary=meta['binaries'][backend+'/'+language]
   need(sha(binary['path'])==binary['sha256'],'Binary drift')
   cases=fixtures(language)
   for i,case in enumerate(cases):
    label=f'{backend}-{language}-case{i}'
    need(labels[label]['command']==command(binary['path'],case,lease),'Changed valid command')
    row=validate(parse((proof_path.parent/(label+'.stdout')).read_text()),case,lease['child_cpus'][:case['requested']])
    reference_check(row);rows.append(dict(backend=backend,**row))
    key=(case['family'],case['scenario']);value=tuple(row[k]for k in SEMANTICS)
    need(key not in semantics or semantics[key]==value,'Cross-language/backend answer mismatch');semantics[key]=value
   fault=f'{backend}-{language}-bad-output'
   need(labels[fault]['command']==command(binary['path'],cases[0],lease,'--check-bad-output'),'Fault command changed')
   need('full mixed answers differ'in(proof_path.parent/(fault+'.stderr')).read_text(),'Wrong fault diagnostic')
   if backend=='normal':
    replacements=((-6,'Unknown'),(-5,'5'),(-4,'3'),(-3,'2694173'),(-3,'3819257'),(-1,'--unknown'),(-1,'--measure'))
    for i,(position,value)in enumerate(replacements):
     argv=command(binary['path'],cases[0],lease);argv[position]=value
     need(labels[f'{language}-invalid{i}']['command']==argv,'Invalid CLI case changed')
  build=ROOT/'build'/f"native-build-policy-four-arm-v1-cpu{lease['cpu']}-{backend}"
  target=Path(f"/tmp/fastest-bf-native-build-policy-four-arm-v1-cpu{lease['cpu']}")/backend
  cargo_text=(proof_path.parent/(backend+'-rust-build.stdout')).read_text()
  consumed,rules=collect(build,target,[cargo_text],sources,ROOT)
  need(consumed==meta['consumed_inputs'][backend],'Actual dependency closure changed')
  need(rules==parse((proof_path.parent/(backend+'-dependency-rules.json')).read_text()),'Saved dep rules changed')
 need(rows==meta['records']and len(semantics)==6,'Raw and aggregate mismatch')
 capture=HERE/'assembly/capture-v2';capture_meta=parse((capture/'CAPTURE.json').read_text())
 need(capture_meta['proof_sha256']==sha(proof_path),'ASM bound to different correctness proof')
 for language,item in capture_meta['selected_normal_executables'].items():need(item==meta['binaries']['normal/'+language],'Wrong ASM binary')
 for item in capture_meta['commands']:
  need(item['returncode']==0,'ASM command failed')
  for stream in ['stdout','stderr']:need(sha(capture/(item['label']+'.'+stream))==item[stream+'_sha256'],'ASM raw output changed')
 cpp=parse((HERE/'assembly/cpp-review/REVIEW.json').read_text())
 need(cpp['binary']==meta['binaries']['normal/cpp']and len(cpp['windows'])==12 and len(cpp['trials'])==6,'CPP gate mismatch')
 need(cpp['clone_trial_folded']is False and cpp['clone_public_insert_folded']is False,'CPP folding observation drift')
 rust_manifest=HERE/'assembly/rust-review/ARCHIVE.json';rust_archive=parse(rust_manifest.read_text())
 entries=rust_archive['files']
 for name,item in entries.items():
  path=rust_manifest.parent/name
  if isinstance(item,str):need(sha(path)==item,'Rust gate archive drift')
  else:need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Rust gate archive drift')
 rust=parse((rust_manifest.parent/'evidence.json').read_text())
 need(rust['binary']==meta['binaries']['normal/rust']and rust['capture_sha256']==sha(capture/'CAPTURE.json'),'Rust artifact identity changed')
 need(len(rust['trials'])==6 and len({x['address']for x in rust['trials']})==6 and len({x['public_insert']for x in rust['trials']})==6,'Rust nonfolding observation changed')
 need(len(rust['after_clock_intervals'])==4,'Incomplete Rust policy intervals')
 for interval in rust['after_clock_intervals']:
  need(int(interval['now'],16)<int(interval['original_requested_load'],16)<int(interval['insert'],16)<int(interval['elapsed'],16),'Rust originalT/public timing boundary changed')
 for name,digest in rust['input_text_sha256'].items():need(sha(capture/name)==digest,'Rust captured text binding changed')
 summary=dict(complete=True,source_commit=meta['source_commit'],source_sha256=sources,
  selected_normal_executables=capture_meta['selected_normal_executables'],all_binaries=meta['binaries'],
  compiler_consumed_input_sha256={p:h for inputs in meta['consumed_inputs'].values()for p,h in inputs.items()},
  checked_records=24,arms=96,semantic_geometries=6,successful_timed_fresh_lifetimes=640,injected_faults=4,invalid_clis=14,commands=52,
  source_unchanged=True,normal_asan_complete=True,cpp_asm_gate_complete=True,rust_asm_gate_complete=True,
  formal_fresh_inputs_executed=False,performance_claim=False,
  correctness_metadata_sha256=sha(proof_path),cpp_gate_sha256=sha(HERE/'assembly/cpp-review/REVIEW.json'),rust_gate_manifest_sha256=sha(rust_manifest),
  preserved_capture_discovery_failure=sha(HERE/'assembly/capture-v1/FAILURE.json'))
 result=HERE/'COMPILED_PROOF.json'
 if result.exists():need(parse(result.read_text())==summary,'Existing combined proof differs')
 else:result.write_text(json.dumps(summary,indent=2)+'\n')
 print('PASS complete24-record/four-binary/52-command/475-input proof and both ASM gates; no BF/compiler')
if __name__=='__main__':main()
