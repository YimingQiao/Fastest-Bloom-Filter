#!/usr/bin/env python3
"""Offline final closure only: never execute a compiler or Bloom filter."""
import argparse,hashlib,json,re,subprocess,sys
from pathlib import Path
V3=Path(__file__).resolve().parent
V2=V3.parent/'resume-v2'
PROOF=V3.parent/'proof'
ROOT=PROOF.parents[2]
REPAIR='0c383615dfaaf0512af54fed4bd490d2f911b68d'
sys.path.insert(0,str(V2))
import repair_guard
from contract import need,validate,SEMANTICS,plan
from nightly_dependencies import collect,sha

def exact(commit,path):
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'Committed final-audit artifact drift')
def load(commit=None):
    sources=repair_guard.verify(REPAIR)
    if commit:need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Exact audit commit required')
    manifest=V3/'PREPARATION.json'
    if commit:exact(commit,manifest)
    sources[str(manifest.relative_to(ROOT))]=sha(manifest)
    for name,e in json.loads(manifest.read_text())['files'].items():
        path=V3/name
        need(sha(path)==e['sha256']and path.stat().st_size==e['bytes'],'Final audit source drift')
        if commit:exact(commit,path)
        sources[str(path.relative_to(ROOT))]=e['sha256']
    archive=json.loads((V3/'ASAN_ATTEMPT_ARCHIVE.json').read_text())
    need({str(p.relative_to(V2))for p in(V2/'validation-v2').rglob('*')if p.is_file()}==set(archive['files']),'ASan attempt inventory drift')
    for name,e in archive['files'].items():
        path=V2/name;need(sha(path)==e['sha256']and path.stat().st_size==e['bytes'],'ASan evidence drift')
        if commit:exact(commit,path)
        sources[str(path.relative_to(ROOT))]=e['sha256']
    first=json.loads((PROOF/'validation-v1/commands.json').read_text())
    second=json.loads((V2/'validation-v2/commands.json').read_text())
    need(second['source_commit']==REPAIR and second['complete'] is False and not second['formal_performance_run'],'Wrong ASan attempt')
    need(second['failure'].startswith("ValueError('No unique Cargo artifact owner for relative dep-info "),'Unexpected second failure')
    need(second['source_sha256']==repair_guard.verify(REPAIR),'ASan original compiled-source closure drift')
    need(second['reused_normal']['source_commit']==repair_guard.ORIGINAL and second['reused_normal']['metadata_sha256']==sha(PROOF/'validation-v1/commands.json'),'Normal reuse anchor drift')
    need(len(second['commands'])==24 and len(second['records'])==24,'Missing functional proof')
    need(second['records'][:12]==first['records'],'Normal records were changed/repeated')
    expected={'offline-guards','clang-version','rust-version','nightly-version','asan-cpp-configure','asan-cpp-build','asan-rust-build','asan-rust-boundary-build'}
    for language in ['cpp','rust']:
        expected.add('asan-'+language+'-native-boundaries');expected.add('asan-'+language+'-bad-output')
        expected.update('asan-'+language+'-case'+str(i)for i in range(6))
    need({c['label']for c in second['commands']}==expected,'Unexpected ASan command coverage')
    for command in second['commands']:need((command['returncode']==0)==command['expected_success'],'A functional command failed')
    references={};cpus=second['lease']['child_cpus']
    need(cpus==[2,4,6,8,10,12,14,16]and second['lease']['cpu']==2,'Wrong ASan placement')
    for i,row in enumerate(second['records']):
        backend='normal'if i<12 else'asan';j=i%12;k=j%6;language='cpp'if j<6 else'rust'
        directory=PROOF/'validation-v1'if backend=='normal'else V2/'validation-v2'
        raw=json.loads((directory/f'{backend}-{language}-case{k}.stdout').read_text())
        need(row==dict(backend=backend,**raw),'Raw/stored caller record mismatch')
        cases=[c for c in plan.ledger()if c['language']==language and c['seed']==plan.SEEDS[0]
            and((c['scenario']in(0,2)and c['requested']==4)or(c['scenario']==1 and c['requested']==8))]
        validate(raw,cases[k],cpus[:cases[k]['requested']])
        key=(row['family'],row['scenario']);value=tuple(row[x]for x in SEMANTICS)
        need(key not in references or references[key]==value,'Cross-language/backend semantic mismatch');references[key]=value
    need(len(references)==6,'Wrong semantic fixture coverage')
    binaries=dict(second['binaries']);binaries.update({'boundary/'+k:v for k,v in second['boundary_tests'].items()})
    need(len(binaries)==8,'Eight frozen actual binaries required')
    for item in binaries.values():need(sha(item['path'])==item['sha256'],'Native binary drift')
    saved=json.loads((V3/'ASAN_INPUTS.json').read_text())
    inputs,rules=collect(saved['actual_build'],saved['actual_target'],[(V2/'validation-v2'/name).read_text()for name in ['asan-rust-build.stdout','asan-rust-boundary-build.stdout']],sources,ROOT)
    need(inputs==saved['consumed_inputs'] and len(rules)==len(saved['dependency_rules']),'ASan consumed closure mismatch')
    for actual,stored in zip(rules,saved['dependency_rules']):
        text=actual.pop('text');row=dict(stored);path=V3/row.pop('archived_path')
        need(actual==row and path.read_text()==text,'ASan dep-info identity/text drift')
    need((Path(saved['actual_build'])/'compile_commands.json').read_bytes()==(V3/'asan-provenance/compile_commands.json').read_bytes(),'ASan compile database drift')
    normal=json.loads((V2/'NORMAL_REUSE.json').read_text())['consumed_inputs']
    required=[PROOF/'cpp/main.cpp',PROOF/'rust/src/main.rs',PROOF/'rust/src/bindings.rs',PROOF/'native/after/tests/test_split64_build_policy.cpp']
    for side in ['before','after']:
        required.extend(PROOF/'cpp'/side/name for name in ['parallel_layout_bloom.h','parallel_split64_range_bloom.h'])
        required.extend(PROOF/'native'/side/'rust/src'/name for name in ['lib.rs','split64.rs','split64_range.rs'])
    required.extend([PROOF/'native/after/include/split64_build_policy.h',PROOF/'native/after/rust/src/split64_build_policy_tests.rs'])
    for mode in [normal,inputs]:need(all(str(p)in mode for p in required),'Missing actual native/caller/test dependency')
    union=dict(normal)
    for path,digest in inputs.items():need(path not in union or union[path]==digest,'Input changed across modes');union[path]=digest
    return {'complete':bool(commit),'functional_complete':True,'provenance_complete':True,'final_audit_commit':commit,
            'native_before_commit':'e8b89cd3c7c090287d1d4222db981ec7f8fb86ab','native_after_commit':'2b3469f02c8dafc2219a132c681c14529e79995d',
            'caller_source_commit':repair_guard.ORIGINAL,'collector_resume_commit':REPAIR,'formal_performance_run':False,
            'compiler_or_bloom_executed_by_final_audit':False,'counts':{'paired_records':24,'native_boundary_cases':48,'helper_boundary_cases':768,'invalid_cli':10,'output_faults':4,'commands_across_two_attempts':58,'binaries':8,'normal_inputs':len(normal),'asan_inputs':len(inputs),'union_inputs':len(union)},
            'source_sha256':sources,'compiler_consumed_input_sha256':union,'all_binaries':binaries,
            'selected_normal_executables':{language:second['binaries']['normal/'+language]for language in ['cpp','rust']},'records':second['records'],
            'attempts':[{'source_commit':repair_guard.ORIGINAL,'session':73654,'exit_code':1,'scope':'Normal functional checks pass; relative Cargo test collector rejection'},
                        {'source_commit':REPAIR,'session':40920,'exit_code':1,'scope':'ASan functional checks pass; nightly relocated bin collector rejection'}]}

def main():
    p=argparse.ArgumentParser();p.add_argument('--source-commit');p.add_argument('--output',type=Path);a=p.parse_args();result=load(a.source_commit)
    if a.output:
        need(a.source_commit is not None,'Commit final offline audit before writing complete evidence')
        need(not a.output.exists()and not a.output.is_symlink(),'Preserve audit outputs');a.output.write_text(json.dumps(result,indent=2)+'\n')
    print('PASS offline native proof closure',json.dumps(result['counts']),'no build/Bloom run')
if __name__=='__main__':main()
