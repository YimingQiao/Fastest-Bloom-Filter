"""Bind V1 immutable failure/three binaries and the new continuation source."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

REPAIR=Path(__file__).resolve().parent
HERE=REPAIR.parent
ROOT=HERE.parents[2]
sys.path.insert(1,str(HERE))
import guards as parent
need,sha,save,artifacts=parent.need,parent.sha,parent.save,parent.artifacts
SOURCE='1f409288eb288bae109cd9bcfce99977631efd99'
FAILED='4f7e55823f0d8a61776650d7ef471dc6b85c1755'
FAILED_MANIFEST_SHA='00ad63fd9c060de03bee4794d76080ef70472c15e8544d514d0e9620c4122f38'
OLD=HERE/'validation-v1'

def exact(commit,path):
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+path.relative_to(ROOT).as_posix()],cwd=ROOT),'committed artifact differs: '+str(path))

def failed():
    manifest=HERE/'FAILED_V1_ARCHIVE.json';exact(FAILED,manifest)
    need(sha(manifest)==FAILED_MANIFEST_SHA,'wrong failure inventory')
    data=json.loads(manifest.read_text())
    for name,digest in data['files'].items():
        path=HERE/name;need(path.resolve().is_relative_to(HERE),'failure path escape')
        exact(FAILED,path);need(sha(path)==digest,'failure artifact drift')
    meta=json.loads((OLD/'metadata.json').read_text())
    need(meta['source_commit']==SOURCE and not meta['complete'] and not meta['cases'],'wrong failure/runtime state')
    need(len(meta['binaries'])==3 and all(r['returncode']==0 for r in meta['commands']),'native build did not pass')
    for group in [meta['binaries'],meta['toolchains']]:
        for path,digest in group.items():need(sha(path)==digest,'reused binary/tool changed')
    observation=json.loads((OLD/'DEPINFO_OBSERVATION.json').read_text())
    for record in observation['depinfo_observations']:
        path=Path(record['actual_path'])
        need(path.is_relative_to('/tmp/fastest-bf-rust-k12-simd-caller-v1-cpu3/native'),'unexpected original dep-info path')
        need(sha(path)==record['sha256'],'original actual dep-info changed')
    return meta

def verify(commit):
    need(re.fullmatch('[0-9a-f]{40}',commit),'full source commit required')
    manifest=REPAIR/'PREPARATION.json';exact(commit,manifest)
    for name,digest in json.loads(manifest.read_text())['files'].items():
        path=REPAIR/name;need(path.resolve().is_relative_to(REPAIR),'repair path escape')
        exact(commit,path);need(sha(path)==digest,'repair source drift')
    failed()
    return parent.verify(SOURCE)

def packages(text):
    data=json.loads(text);known=parent.packages(text)
    workspace=Path(data['workspace_root']).resolve()
    need(workspace==HERE and set(data['workspace_members'])==set(known),'unexpected structured workspace')
    for value in known.values():value['_workspace_root']=str(workspace)
    return known

def reuse_native():
    meta=failed()
    known=packages((OLD/'native-metadata.stdout').read_text())
    descriptor=dict(failure_commit=FAILED,failure_manifest_sha256=FAILED_MANIFEST_SHA,
                    compiled_source_commit=SOURCE,binaries_sha256=meta['binaries'],
                    metadata_sha256=sha(OLD/'native-metadata.stdout'),
                    tests_build_sha256=sha(OLD/'native-tests-build.stdout'),
                    caller_build_sha256=sha(OLD/'native-caller-build.stdout'),
                    original_native_commands=[r for r in meta['commands']if r['label'].startswith('native-')],
                    native_compiler_or_cargo_reexecution=False)
    expected=json.loads((REPAIR/'NATIVE_REUSE.json').read_text())
    need(all(expected[key]==value for key,value in descriptor.items()),'native reuse descriptor differs')
    need(len(expected['actual_inputs_sha256'])==30 and len(expected['actual_depinfo'])==6,'wrong recovered closure')
    for path,digest in expected['actual_inputs_sha256'].items():need(sha(path)==digest,'reused native source changed')
    for record in expected['actual_depinfo']:need(sha(record['path'])==record['sha256'],'reused native dependency changed')
    return dict(packages=known,tests=(OLD/'native-tests-build.stdout').read_text(),
                build=(OLD/'native-caller-build.stdout').read_text(),
                toolchains=meta['toolchains'],descriptor=descriptor,
                target='/tmp/fastest-bf-rust-k12-simd-caller-v1-cpu3/native')
