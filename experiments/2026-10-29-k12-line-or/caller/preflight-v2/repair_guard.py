"""Bind unchanged V1 source, preserved failed attempt and this additive driver."""
import json
from pathlib import Path
import subprocess
from contract import need
from source_guard import ROOT,sha,verify as verify_parent,exact

HERE=Path(__file__).resolve().parent
PARENT='dd13d1e829d4482d70093497b8d470bd09be22ac'
def verify(commit):
    result=verify_parent(PARENT)
    manifest=HERE/'PREPARATION.json';exact(commit,manifest);data=json.loads(manifest.read_text())
    need(data['parent_source_commit']==PARENT,'Wrong driver parent')
    for name,item in data['files'].items():
        path=HERE/name;need(path.resolve().is_relative_to(HERE),'Repair path escaped')
        need(sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Repair source drift')
        exact(commit,path);result[str(path)]=sha(path)
    failure=HERE.parent/'validation-v1'/'FAILURE_ARCHIVE.json'
    need(sha(failure)==data['failed_attempt_manifest_sha256'],'Failed attempt manifest changed');exact(commit,failure)
    record=json.loads(failure.read_text())
    for name,item in record['files'].items():
        path=failure.parent/name
        need(path.resolve().is_relative_to(failure.parent)and sha(path)==item['sha256']and path.stat().st_size==item['bytes'],'Failed attempt changed')
        exact(commit,path);result[str(path)]=sha(path)
    result[str(failure)]=sha(failure);result[str(manifest)]=sha(manifest)
    return result
