"""Exact committed producer/proof/source guard and recorded placement audit."""
import json,os,platform,re,sys
from pathlib import Path
from screen_contract import HERE,STAGE,ROOT,need,plan,audit_rows
from derive_plan import derive,PROOF
sys.path.insert(0,str(STAGE))
from source_guard import sha,exact,verify as producer_verify,PARENT,ORIGINAL
sys.path.insert(0,str(PARENT))
from startup_guards import require_inherited_write_lock
sys.path.insert(0,str(ORIGINAL))
from validate import lease,tuner_file
SOURCE='6edb78425c86209aa366a4e04311b5317ffa27c5'
PROOF_SHA='6706357e23d4e4a6028659e31a1f94b8a14eaf12bf0bd5fe7e6eb379a3910e64'
BINARY_SHA='6da743aa2f31c3cbd7b713d748819b684f247408f7bcb55de3c0f334a039d7eb'
ENVIRONMENT=('LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX',
             'CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS')

def verify(commit,live=True):
    need(__debug__ and re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full immutable runner commit and active guards required')
    prep=HERE/'PREPARATION.json';exact(commit,prep)
    for name,digest in json.loads(prep.read_text())['files'].items():
        path=HERE/name;need(path.resolve().is_relative_to(HERE)and sha(path)==digest,'Runner source drift');exact(commit,path)
    producer_verify(SOURCE)
    descriptor=STAGE/'CALLER_ARCHIVE.json';exact(PROOF,descriptor);need(sha(descriptor)==PROOF_SHA,'Wrong proof manifest')
    archive=json.loads(descriptor.read_text());need(archive['source_commit']==SOURCE and len(archive['files'])==535,'Wrong caller scope')
    for name,digest in archive['files'].items():
        path=STAGE/name;need(path.resolve().is_relative_to(STAGE)and sha(path)==digest,'Caller evidence drift');exact(PROOF,path)
    freeze=json.loads((STAGE/'WORKER_FREEZE.json').read_text())
    need(freeze['source_commit']==SOURCE and freeze['commands']==229 and freeze['caller_rows']==80 and
         freeze['old_reference_rows']==56 and freeze['public_bitmap_payloads']==56 and
         freeze['native_full_bitmap_oracles']==16 and freeze['invalid_or_fault_cases']==12 and
         not freeze['formal160_launched']and freeze['query_timing_samples']==0,'Incomplete proof')
    review=STAGE/'validation-v1/assembly-review/REVIEW.json';r=json.loads(review.read_text())
    need(sha(review)==freeze['manual_assembly_review_sha256']and r['manual_review_complete']and
         r['binary']==freeze['binaries']['native/worker'],'Actual ASM proof mismatch')
    if live:
        for name,digest in freeze['compiler_consumed_inputs_sha256'].items():need(sha(name)==digest,'Actual compiler input drift')
        for item in freeze['binaries'].values():need(sha(item['path'])==item['sha256'],'Tested binary drift')
    binary=Path(freeze['binaries']['native/worker']['path']);need(freeze['binaries']['native/worker']['sha256']==BINARY_SHA,'Wrong native worker')
    outputs,inputs=derive();need(json.loads((HERE/'DERIVATION.json').read_text())==dict(inputs=inputs,old_timing_fields_imported=False),'Changed derivation input binding')
    for name,value in outputs.items():need(json.loads((HERE/name).read_text())==value,'Expected fixed geometry/reference changed')
    need(plan()==json.loads((HERE/'planned-grid.json').read_text()),'Fixed row order drift')
    # The phase/CSV helper is an unchanged source, independently anchored because
    # this runner imports it in addition to the compiled common header closure.
    exact('6baeaeb88c89b9a4eed71f0a0aa1263c613289bd',ROOT/'benchmarks/vldb-raw32-stage3/contract.py')
    return binary,freeze

def placement(held):
    value=dict(lease=held,affinity=sorted(os.sched_getaffinity(0)),host=platform.uname()._asdict(),
               environment={k:os.environ.get(k)for k in ENVIRONMENT})
    validate_placement(value);return value

def validate_placement(value):
    held=value['lease'];fds=held.get('inherited_lock_descriptors')
    need(held['cpu']==2 and held['lease']=='socket0'and held['lock_path']=='/tmp/fastest-bf-socket0.lock'and value['affinity']==[2], 'Wrong recorded CPU/socket')
    need(isinstance(fds,list)and fds and all(type(fd)is int and fd>=0 for fd in fds)and len(fds)==len(set(fds))and held.get('inherited_write_verified')is True,'Missing inherited advisory write proof')
    need(set(value['environment'])==set(ENVIRONMENT)and not any(value['environment'].values()),'Unfrozen environment')
    need(isinstance(value['host'],dict)and all(value['host'].get(k)for k in ('system','node','release','version','machine')),'Incomplete host metadata')

def identity(meta,binary,commit):
    need(meta['source_commit']==commit and meta['proof_commit']==PROOF and meta['producer_source_commit']==SOURCE and
         meta['binary']==str(binary)and meta['binary_sha256']==BINARY_SHA,'Wrong recorded identity')
    for field,path in [('runner_preparation_sha256',HERE/'PREPARATION.json'),('planned_grid_sha256',HERE/'planned-grid.json'),
                       ('protocol_sha256',HERE/'protocol.json'),('worker_freeze_sha256',STAGE/'WORKER_FREEZE.json'),
                       ('analysis_rules_sha256',HERE/'ANALYSIS_RULES.json')]:
        need(meta[field]==sha(path),'Wrong recorded '+field)
    validate_placement(meta)
    need(meta['tuner_file_before']==meta['tuner_file_after'],'Existing tuner changed')

def audit(output,meta,binary,commit,final=True):
    identity(meta,binary,commit);raws=[];files={'metadata.json'}
    for i,r in enumerate(meta['commands']):
        raw={}
        for stream in ('stdout','stderr'):
            filename=f'row{i:03d}.'+stream;files.add(filename);path=output/filename
            need(r[stream]==filename and sha(path)==r[stream+'_sha256'],'Raw stream digest changed')
            raw[stream]=path.read_text()
        raws.append(raw)
    rows=audit_rows(meta,raws,binary)
    need({p.name for p in output.iterdir()}==files,'Unexpected/incomplete raw artifact set')
    if final:
        need(meta['complete']is True and meta['all_frozen_inputs_unchanged']is True and meta['process_rows']==160 and
             meta['query_mode_records']==480 and meta['api_geometry_quality_records']==80 and
             meta['proven_mapping_records']==48 and meta['semantic_reproductions']==144,'Incomplete final closure')
    return rows
