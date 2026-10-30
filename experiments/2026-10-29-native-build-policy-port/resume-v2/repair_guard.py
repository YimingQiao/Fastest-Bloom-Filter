"""Bind original successful normal work and the additive collector-only repair."""
import hashlib,json,re,subprocess,sys
from pathlib import Path
RESUME=Path(__file__).resolve().parent
HERE=RESUME.parent/'proof'
ROOT=HERE.parents[2]
ORIGINAL='26232ad9b1412e64346e09f40de15f8ef77c52f7'
sys.path.insert(0,str(HERE))
import source_guard as original_guard
from contract import need,validate,SEMANTICS,plan
from dependencies import collect,sha

def exact(commit,path):
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),'Committed repair/proof drift: '+str(path))
def reused_normal(sources):
    failed=json.loads((HERE/'validation-v1/commands.json').read_text())
    reuse=json.loads((RESUME/'NORMAL_REUSE.json').read_text())
    need(failed['source_commit']==ORIGINAL and failed['complete'] is False and not failed['formal_performance_run'],'Wrong prior attempt')
    need(failed['failure']=="ValueError('Missing actual compiler input')",'Unexpected prior failure')
    need(failed['source_sha256']==sources,'Normal compiled source closure changed')
    need(len(failed['commands'])==34 and len(failed['records'])==12,'Incomplete normal proof')
    for command in failed['commands']:
        need((command['returncode']==0)==command['expected_success'],'Failed normal command '+command['label'])
    expected_labels={'offline-guards','clang-version','rust-version','nightly-version','normal-cpp-configure','normal-cpp-build','normal-rust-build','normal-rust-boundary-build'}
    for language in ['cpp','rust']:
        expected_labels.add('normal-'+language+'-native-boundaries');expected_labels.add('normal-'+language+'-bad-output')
        expected_labels.update('normal-'+language+'-case'+str(i)for i in range(6))
        expected_labels.update(language+'-invalid'+str(i)for i in range(5))
    need({x['label']for x in failed['commands']}==expected_labels,'Normal command coverage changed')
    need(failed['binaries']==reuse['binaries'] and failed['boundary_tests']==reuse['boundary_tests'],'Normal artifact identity drift')
    for item in list(failed['binaries'].values())+list(failed['boundary_tests'].values()):
        need(sha(item['path'])==item['sha256'],'Normal binary changed')
    cpus=failed['lease']['child_cpus'];need(cpus==[2,4,6,8,10,12,14,16]and failed['lease']['cpu']==2,'Wrong original placement')
    for i,row in enumerate(failed['records']):
        cases=[c for c in plan.ledger()if c['language']==row['language']and c['seed']==plan.SEEDS[0]
            and((c['scenario']in(0,2)and c['requested']==4)or(c['scenario']==1 and c['requested']==8))]
        case=cases[i%6];need(row['backend']=='normal','Wrong normal record backend')
        raw=json.loads((HERE/'validation-v1'/f"normal-{row['language']}-case{i%6}.stdout").read_text())
        need(row==dict(backend='normal',**raw),'Stored/raw normal mismatch')
        validate(raw,case,cpus[:case['requested']])
    need(hashlib.sha256(json.dumps(failed['records'],sort_keys=True).encode()).hexdigest()==reuse['record_sha256'],'Normal records changed')
    inputs,rules=collect(reuse['actual_build'],reuse['actual_target'],[(HERE/'validation-v1'/n).read_text()for n in ['normal-rust-build.stdout','normal-rust-boundary-build.stdout']],sources,ROOT)
    need(inputs==reuse['consumed_inputs'],'Normal consumed inputs changed')
    need(len(rules)==len(reuse['dependency_rules']),'Normal dependency coverage changed')
    for actual,saved in zip(rules,reuse['dependency_rules']):
        text=actual.pop('text');copy=dict(saved);archive=RESUME/copy.pop('archived_path')
        need(actual==copy and archive.read_text()==text,'Normal dependency/provenance drift')
    need((Path(reuse['actual_build'])/'compile_commands.json').read_bytes()==(RESUME/'normal-provenance/compile_commands.json').read_bytes(),'Normal compile commands changed')
    return failed,reuse

def verify(commit):
    need(__debug__ and re.fullmatch('[0-9a-f]{40}',commit)is not None,'Exact repair commit required')
    original=original_guard.verify(ORIGINAL);result=dict(original)
    prep=RESUME/'PREPARATION.json';exact(commit,prep);result[str(prep.relative_to(ROOT))]=sha(prep)
    for name,e in json.loads(prep.read_text())['files'].items():
        p=RESUME/name;exact(commit,p);need(sha(p)==e['sha256']and p.stat().st_size==e['bytes'],'Repair manifest drift')
        result[str(p.relative_to(ROOT))]=e['sha256']
    archive=json.loads((RESUME/'NORMAL_ATTEMPT_ARCHIVE.json').read_text())
    actual={str(p.relative_to(HERE))for p in(HERE/'validation-v1').rglob('*')if p.is_file()}
    need(actual==set(archive['files']),'Original attempt inventory changed')
    for name,e in archive['files'].items():
        p=HERE/name;exact(commit,p);need(sha(p)==e['sha256']and p.stat().st_size==e['bytes'],'Original attempt artifact drift')
        result[str(p.relative_to(ROOT))]=e['sha256']
    reused_normal(original)
    return result
