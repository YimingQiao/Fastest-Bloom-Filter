#!/usr/bin/env python3
"""Offline verification of sealed Rust K12 correctness evidence; no BF/build."""
if not __debug__:raise RuntimeError('Use Python without -O')
import hashlib,json,re,subprocess,sys
from pathlib import Path
S=Path(__file__).resolve().parent;ROOT=S.parents[1];sys.path.insert(0,str(S/'preflight'))
from checks import need,sha,execution_stderr,CPUS

def verify():
    frozen=json.loads((S/'PREFLIGHT_FREEZE.json').read_text());m=json.loads((S/'validation-v2/metadata.json').read_text());commit=frozen['driver_source_commit']
    need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Immutable commit')
    need(sha(S/'validation-v2/metadata.json')==frozen['metadata_sha256'],'Metadata drift')
    for folder in(S,S/'preflight',S/'preflight-v2'):
        desc=folder/'PREPARATION.json';need(desc.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(desc.relative_to(ROOT))],cwd=ROOT),'Preparation commit drift')
        for name,item in json.loads(desc.read_text())['files'].items():
            p=folder/name;need(sha(p)==item['sha256']and p.stat().st_size==item['bytes'],'Prepared source drift');need(p.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(p.relative_to(ROOT))],cwd=ROOT),'Prepared blob drift')
    for folder in(S/'validation-v1',S/'validation-v2'):
        for name,item in json.loads((folder/'ARCHIVE.json').read_text())['files'].items():need(sha(folder/name)==item['sha256']and(folder/name).stat().st_size==item['bytes'],'Raw artifact drift')
    need(m['complete']and m['source_commit']==commit and m['rust_tests']==15 and m['full_cross_language_comparisons']==36 and m['cpp_reference_streams']==6 and m['performance_runs']==0,'Incomplete/incorrect scope')
    need(m['source_sha256']==frozen['prepared_inputs_sha256']and m['binaries']==frozen['binaries_sha256']and m['consumed_inputs']==frozen['actual_compiler_inputs_sha256']and m['tools']==frozen['tools_sha256'],'Frozen identity drift')
    for group in (m['source_sha256'],m['binaries'],m['tools'],*m['consumed_inputs'].values()):
        for name,digest in group.items():need(sha(Path(name))==digest,'Live consumed input/binary drift '+name)
    for name,item in frozen['depfiles'].items():need(sha(Path(name))==item['sha256']==sha(S/item['archive_path']),'Depfile drift')
    need(len(m['commands'])==62 and all(c['complete']and c['returncode']==0 for c in m['commands']),'Incomplete command ledger')
    count=0
    for c in m['commands']:
        label=c['label'];stderr=(S/'validation-v2'/(label+'.stderr')).read_bytes();need(hashlib.sha256(stderr).hexdigest()==c['stderr_sha256'],'Stderr drift')
        stdout=S/'validation-v2'/(label+'.stdout')
        if stdout.exists():need(sha(stdout)==c['stdout_sha256']and stdout.stat().st_size==c['stdout_bytes'],'Stdout drift')
        else:
            summary=json.loads((S/'validation-v2'/(label+'.stdout-summary.json')).read_text());need(summary==dict(bytes=c['stdout_bytes'],sha256=c['stdout_sha256'],raw_payload_retained=False),'Payload summary drift')
        if c['executes_filter']:
            count+=1;record,_=execution_stderr(stderr,c['program'][0]);need(record==c['actual_execution']and c['command'][0:3]==['taskset','-c',','.join(map(str,CPUS))],'Actual child mask drift')
    need(count==45 and m['execution_affinity']==CPUS and m['affinity']==[3],'Wrong real execution placement')
    checks=json.loads((S/'validation-v2/fixture-checks.json').read_text());need(len(checks)==42,'Wrong fixture coverage');refs={x['label']:x for x in checks if x['label'].startswith('cpp-')};need(len(refs)==6,'Wrong C++ coverage')
    comparisons=0
    for x in checks:
        need(x['raw_bytes']==x['metadata']['bytes']+8193*4,'Wrong full payload length')
        if x['label'].startswith('cpp-'):continue
        comparisons+=1;r=refs[x['cpp_reference']];need(x['complete_byte_equality']and x['raw_sha256']==r['raw_sha256']and x['raw_bytes']==r['raw_bytes'],'Recorded full-byte parity mismatch')
    need(comparisons==36,'Wrong parity coverage')
    for mode in('normal','disable','asan'):need(re.search(r'test result: ok\. 5 passed; 0 failed;', (S/'validation-v2'/(mode+'-tests.stdout')).read_text())is not None,'Missing focused suite')
    old=json.loads((S/'validation-v1/metadata.json').read_text());need(not old['complete']and len(old['commands'])==11 and all(not c['executes_filter']for c in old['commands']),'First attempt changed')
    return dict(complete=True,commands=62,rust_tests=15,full_byte_comparisons=36,observed_seven_core_executions=45,binaries=7,cpp_actual_inputs=len(m['consumed_inputs']['cpp']),rust_actual_inputs_per_mode=6,performance_runs=0,prior_zero_bf_failure_preserved=True)
if __name__=='__main__':print(json.dumps(verify(),indent=2))
