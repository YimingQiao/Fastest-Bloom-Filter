"""Pinned initial integration, retained caller/reference, and actual compiler inputs."""
import difflib
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=STAGE.parents[1]
PARENT=ROOT/'experiments/2026-10-29-split64-range-parallel-screen'
OLD=ROOT/'experiments/2026-10-29-exact-budget-range'
INITIAL='2263cf29ebc87d589b49ca015133312993b7db73'
def need(ok,why):
    if not ok:raise ValueError(why)
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def save(path,value):path.write_text(json.dumps(value,indent=2)+'\n')
def blob(path,commit):return subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
def verify(commit=None):
    need(__debug__,'Use Python without -O')
    manifest=STAGE/'PREPARATION.json';need(manifest.read_bytes()==blob(manifest,INITIAL),'Changed initial descriptor')
    initial=json.loads(manifest.read_text());need(len(initial['files'])==13 and len(initial['inputs_sha256'])==42,'Wrong initial input cardinality')
    pins={str(manifest.relative_to(ROOT)):sha(manifest)}
    for name,digest in initial['files'].items():
        path=STAGE/name;need(sha(path)==digest and path.read_bytes()==blob(path,INITIAL),'Changed initial source '+name);pins[str(path.relative_to(ROOT))]=digest
    for name,digest in initial['inputs_sha256'].items():
        path=ROOT/name;need(sha(path)==digest and path.read_bytes()==blob(path,INITIAL),'Changed initial consumed pin '+name);pins[name]=digest
    parent=json.loads((PARENT/'PREFLIGHT_FREEZE.json').read_text());need(len(parent['source_sha256'])==523,'Wrong completed parent closure')
    pins.update(parent['source_sha256'])
    for name,digest in pins.items():need(sha(ROOT/name)==digest,'Changed frozen header/input '+name)
    extra=json.loads((HERE/'bindings.json').read_text())
    for name,digest in extra['extra_sources_sha256'].items():
        path=ROOT/name;need(sha(path)==digest and path.read_bytes()==blob(path,INITIAL),'Changed frozen auxiliary source '+name);pins[name]=digest
    need((HERE/'ref/compare_benchmark.cpp').read_bytes()==(OLD/'compare_benchmark.cpp').read_bytes()==(STAGE/'compare_benchmark.cpp').read_bytes(),'Reference/candidate timed caller drift')
    need(not(HERE/'ref/geometry.hpp').exists()and not(HERE/'ref/adapters.hpp').exists(),'Reference quote-include shadowing')
    for old,new in [(PARENT/'adapters.hpp',STAGE/'adapters.hpp'),(PARENT/'geometry.hpp',STAGE/'geometry.hpp'),(ROOT/'experiments/2026-10-29-four-sector-range12-vector/four_sector_range12.h',STAGE/'four_sector_range12.h')]:
        patch=''.join(difflib.unified_diff(old.read_text().splitlines(True),new.read_text().splitlines(True),fromfile=str(old.relative_to(ROOT)),tofile=str(new.relative_to(ROOT))))
        need(patch==(new.with_name(new.name+'.patch')).read_text(),'Integration patch changed')
    need((PARENT/'range-layouts/range_size.hpp').read_bytes()==(ROOT/'experiments/2026-10-29-four-sector-range24/range_size.hpp').read_bytes(),'Changed sizing include identity')
    old_names=json.loads((PARENT/'registry.json').read_text());names=json.loads((STAGE/'registry.json').read_text())
    need(len(old_names)==25 and names==old_names+['FourSectorRange12Experiment'],'Wrong retained/current registry')
    old_cases=json.loads((PARENT/'screening/protocol.json').read_text())['cases'];formal=json.loads((STAGE/'protocol.json').read_text())
    expected=[]
    for batch in (31,4096):
        for item in old_cases:
            case=dict(item,batch=batch);case['filters']=list(item['filters'])
            if item['budget_bpk']in(16,24,32):case['filters'].append('FourSectorRange12Experiment')
            expected.append(case)
    need(formal['cases']==expected and len(expected)==26 and sum(len(x['filters'])for x in expected)==296,'Changed formal296 fixed union')
    prep=HERE/'PREPARATION.json'
    if prep.exists():
        for name,entry in json.loads(prep.read_text())['files'].items():
            path=HERE/name;need(sha(path)==entry['sha256']and path.stat().st_size==entry['bytes'],'Changed additive source '+name)
            if commit:need(path.read_bytes()==blob(path,commit),'Uncommitted additive source '+name)
            pins[str(path.relative_to(ROOT))]=entry['sha256']
        if commit:need(re.fullmatch(r'[0-9a-f]{40}',commit)is not None and prep.read_bytes()==blob(prep,commit),'Changed committed additive descriptor')
        pins[str(prep.relative_to(ROOT))]=sha(prep)
    return pins

def consumed(build,pins,reference=False):
    dependencies={};units={}
    files=sorted(build.rglob('*.o.d'));need(files,'No actual compiler .o.d files')
    for file in files:
        text=file.read_text().replace('\\\n',' ');need(': 'in text,'Malformed compiler depfile')
        paths=[]
        for token in shlex.split(text.split(': ',1)[1]):
            path=Path(token);path=(path if path.is_absolute()else build/path).resolve(strict=True)
            digest=sha(path);dependencies[str(path)]=digest;paths.append(str(path))
            if path.is_relative_to(ROOT):
                name=str(path.relative_to(ROOT));need(name in pins and pins[name]==digest,'Unpinned compiler repository input '+name)
            else:need(str(path).startswith(('/usr/','/lib/')),'Unexpected external dependency '+str(path))
        units[str(file.relative_to(build))]=paths
    current=[paths for name,paths in units.items()if '/benchmark.dir/'in name]
    need(len(current)==1 and str(STAGE/'geometry.hpp')in current[0] and str(STAGE/'adapters.hpp')in current[0],'Actual26 caller included wrong geometry/adapters')
    refs=[paths for name,paths in units.items()if '/reference.dir/'in name]
    if reference:
        need(len(refs)==1 and str(PARENT/'geometry.hpp')in refs[0]and str(PARENT/'adapters.hpp')in refs[0],'Reference25 did not consume parent headers')
        need(str(STAGE/'geometry.hpp')not in refs[0] and str(STAGE/'adapters.hpp')not in refs[0]and str(STAGE/'four_sector_range12.h')not in refs[0],'Reference25 accidentally includes new26 integration')
    else:need(not refs,'Unexpected extra reference build')
    return dict(files_sha256={str(f.relative_to(build)):sha(f)for f in files},translation_units=units,consumed_sha256=dependencies)
