"""Immutable committed source, successful preflight, and executable bindings."""
import hashlib
import json
import re
import subprocess
from pathlib import Path
from contract import need

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=STAGE.parents[1]
PREFLIGHT_COMMIT='a35ed9af797b78f78f1a88cad731cd7f0152d55c'

def sha(path):
    h=hashlib.sha256()
    with Path(path).open('rb')as f:
        for block in iter(lambda:f.read(1024*1024),b''):h.update(block)
    return h.hexdigest()

def committed(commit,path,digest):
    rel=str(Path(path).relative_to(ROOT))
    value=subprocess.check_output(['git','show',commit+':'+rel],cwd=ROOT)
    need(hashlib.sha256(value).hexdigest()==digest,'Changed committed artifact '+rel)

def verify(commit,live=True):
    need(re.fullmatch('[0-9a-f]{40}',commit),'Exact source commit required')
    freeze=json.loads((HERE/'freeze.json').read_text())
    need(freeze['preflight_commit']==PREFLIGHT_COMMIT,'Wrong completed preflight anchor')
    artifacts=dict(freeze['local_files_sha256']);artifacts[str((HERE/'freeze.json').relative_to(ROOT))]=sha(HERE/'freeze.json')
    for rel,digest in artifacts.items():
        need(sha(ROOT/rel)==digest,'Changed frozen source/evidence '+rel);committed(commit,ROOT/rel,digest)
    archive=json.loads((STAGE/'PREFLIGHT_ARCHIVE.json').read_text());compiled=json.loads((STAGE/'COMPILED_FREEZE.json').read_text())
    for rel,value in archive['files'].items():
        path=STAGE/rel;need(sha(path)==value['sha256'],'Changed preflight artifact '+rel);committed(PREFLIGHT_COMMIT,path,value['sha256'])
    committed(PREFLIGHT_COMMIT,STAGE/'PREFLIGHT_ARCHIVE.json',sha(STAGE/'PREFLIGHT_ARCHIVE.json'))
    need(compiled['complete']and not compiled['performance_run']and compiled['rows']==40 and compiled['malformed_cli_cases']==10,'Incomplete focused native preflight')
    need(compiled['source_commit']=='5fd487fe3381ce05be2ba823a6137107f4108854','Wrong consumed source revision')
    for rel,digest in compiled['source_sha256'].items():
        need(sha(ROOT/rel)==digest,'Changed compiled local source '+rel);committed(compiled['source_commit'],ROOT/rel,digest)
    need(compiled['selected_normal_executables']==freeze['selected_normal_executables'],'Changed selected normal executable bindings')
    for value in compiled['selected_normal_executables'].values():
        need(compiled['all_binary_sha256'].get(value['path'])==value['sha256'],'Selected executable absent from completed preflight')
    if live:
        for path,digest in compiled['compiler_consumed_input_sha256'].items():need(sha(path)==digest,'Changed actual compiler input '+path)
        for path,digest in compiled['all_binary_sha256'].items():need(sha(path)==digest,'Changed validated executable '+path)
    return dict(source_commit=commit,freeze_sha256=sha(HERE/'freeze.json'),local_artifacts=len(artifacts),
      preflight_commit=PREFLIGHT_COMMIT,preflight_archive_sha256=sha(STAGE/'PREFLIGHT_ARCHIVE.json'),compiled_freeze_sha256=sha(STAGE/'COMPILED_FREEZE.json'),
      compiler_inputs=len(compiled['compiler_consumed_input_sha256']),validated_binaries=len(compiled['all_binary_sha256']),
      selected_normal_executables=compiled['selected_normal_executables'])
