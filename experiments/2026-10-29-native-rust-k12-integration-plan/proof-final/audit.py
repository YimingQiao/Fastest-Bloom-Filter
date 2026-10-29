#!/usr/bin/env python3
"""Final read-only native packaging verification; no compiler or BF execution."""
import hashlib,importlib.util,json,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;PLAN=HERE.parent;ROOT=PLAN.parents[1]
sys.path.insert(0,str(PLAN/'proof-v4'))
from bindings import WORK,NATIVE,BASE,REF,REFERENCE,sha,save,need,verify
from audit_reuse import audit as reused
SOURCE='64a2cb2f4f847351e90848215564e5a9adfed771'
def blob(c,p):return subprocess.check_output(['git','show',c+':'+p],cwd=ROOT)
def main():
 prepared=verify(SOURCE);reuse=reused();need(reuse==json.loads((PLAN/'proof-v4/REUSE_CLOSURE.json').read_text()),'Preserved sources/binaries changed')
 current={p:subprocess.check_output(['git','show',NATIVE+':'+p],cwd=WORK)for p in ['rust/src/four_sector_range12.rs','rust/src/k12_parallel.rs','rust/src/four_sector_range12_tests.rs','rust/src/lib.rs']}
 changed=subprocess.check_output(['git','diff','--name-only',BASE,NATIVE],cwd=WORK).decode().splitlines();need(sorted(changed)==sorted(current),'Unscoped native delta')
 spec=importlib.util.spec_from_file_location('original_packaging',PLAN/'derive.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);expected=module.outputs()
 for p in ['rust/src/four_sector_range12.rs','rust/src/k12_parallel.rs']:need(current[p]==expected['proposed/'+p].encode(),'Kernel/owner packaging changed')
 test=expected['proposed/rust/src/four_sector_range12_tests.rs'];line='                        assert!((indices[sector]&15)<16);\n'
 need(test.count(line)==1 and current['rust/src/four_sector_range12_tests.rs']==test.replace(line,'').encode(),'Native test delta not the exact tautology deletion')
 oldlib=subprocess.check_output(['git','show',BASE+':rust/src/lib.rs'],cwd=WORK).decode();newlib=oldlib.replace('mod four_sector;','mod four_sector;\nmod four_sector_range12;\nmod k12_parallel;').replace('pub use four_sector::FourSectorBloomFilter;','pub use four_sector::FourSectorBloomFilter;\npub use four_sector_range12::FourSectorRange12BloomFilter;')
 need(current['rust/src/lib.rs']==newlib.encode(),'Existing native export changed')
 helper=(WORK/'rust/src/layout_parallel.rs').read_text();isolated=(REF/'src/layout_parallel.rs').read_text();common={}
 for name in ['backend','backends','build_workers','scratch_bytes','lookup']:
  a=module.function(helper,name)[2];b=module.function(isolated,name)[2];need(a==b,'Shared utility identity changed '+name);common[name]=hashlib.sha256(a.encode()).hexdigest()
 a=module.function((WORK/'rust/src/parallel.rs').read_text(),'workers')[2];b=module.function((REF/'src/parallel.rs').read_text(),'workers')[2];need(a==b,'Shared workers changed');common['workers']=hashlib.sha256(a.encode()).hexdigest()
 original=PLAN/'proof-v3/validation-v1';finish=PLAN/'proof-v4/validation-v1';m=json.loads((finish/'metadata.json').read_text());need(not m['complete']and all(c['complete']and c['returncode']==0 for c in m['commands']),'Wrong preserved assembly-stop ledger')
 need(set(m['fixtures'])=={'normal','disable-avx512','asan'}and len({v['checksum']for v in m['fixtures'].values()})==1,'Cross-profile parity differs')
 for mode,count,directory in [('normal',40,original),('disable-avx512',6,original),('asan',6,finish)]:
  text=(directory/(mode+'-native-tests.stdout')).read_text();need(f'test result: ok. {count} passed; 0 failed;'in text,'Missing successful runtime suite')
  need(len(m['fixtures'][mode]['cases'])==12,'Missing exact parity cases')
 capture=PLAN/'proof-v4/assembly-v2/results';c=json.loads((capture/'CAPTURE.json').read_text());need(c['complete']and len(c['selected'])==5 and c['BF_executions']==c['compiler_executions']==0,'Incomplete ELF capture')
 for command in c['commands']:
  need(command['returncode']==0,'Failed final capture command')
  for stream in ['stdout','stderr']:need(sha(capture/command[stream])==command[stream+'_sha256'],'Capture byte drift')
 rel=json.loads((capture/'RELOCATION.json').read_text());need(rel['slot']=='0x6e378'and rel['target']=='0x232f0'and rel['sha256']==c['sha256']and sha(capture/'relocations.stdout')==rel['stdout_sha256'],'Public batch relocation changed')
 inputs=dict(prepared['inherited_sources']);inputs.update({str((PLAN/'proof-v4'/p).resolve()):r['sha256']for p,r in prepared['local'].items()});inputs[str(PLAN/'proof-v4/PREPARATION.json')]=sha(PLAN/'proof-v4/PREPARATION.json')
 delta=subprocess.check_output(['git','diff','--binary',BASE,NATIVE],cwd=WORK);(HERE/'native-delta.patch').write_bytes(delta)
 save(HERE/'PROOF.json',dict(complete=True,native_base=BASE,native_commit=NATIVE,initial_native_commit='771262e3ba9aa8e51610e0981d86884361d19624',reference_commit=REFERENCE,normal_test_count=40,disabled_test_count=6,asan_test_count=6,total_test_executions=52,exact_public_parity_fixtures=36,full_output_checksum=m['fixtures']['asan']['checksum'],source_inputs=inputs,compiler_inputs={k:v['inputs_sha256']for k,v in reuse['modes'].items()},binaries=m['binaries'],native_delta_files={p:dict(sha256=hashlib.sha256(v).hexdigest(),bytes=len(v))for p,v in current.items()},byte_identical_shared_functions=common,execution_cpus=[3,5,7,9,11,13,15],assembly_source_commit=c['source_commit'],assembly_selected=c['selected'],public_batch_relocation=rel,scope='Packaging correctness and actual public codegen only; zero throughput/FPR samples',original_failed_metadata_unchanged=True))
 print('Final52 tests/36 fixtures, exact native delta/shared helpers and five ELF spans verified')
if __name__=='__main__':main()
