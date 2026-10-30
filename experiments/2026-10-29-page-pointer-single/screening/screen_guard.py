"""Committed source/proof/binary guards for the unchanged caller executable."""
import hashlib,json,os,platform,re
from pathlib import Path
from screen_contract import HERE,SOURCE,PREFLIGHT,ROOT,BASE,need
from source_guard import sha,committed,startup,module
PROOF_COMMIT='90a1a4e83e376c96b43114c24dceafeb8a88cd23'
CALLER_COMMIT='e4f0455b4354ef5d06840cc226ede4b3a5ca4e60'
CHECK_COMMIT='a4262bf21adfea64dc604f8a4b506ffebdcdfa93'
RAW_COMMIT='23b1ffe7216a693e31a2c3086299e94837fe42ad'
ANALYSIS_COMMIT='75dbe5c350035767bab775168a3298b716818934'
BINARY_SHA='2ed675b3edde017c51fcebf77ff6d2c89ea39f52e5e1229e29379c2f034e9dd5'
ANALYSIS=ROOT/'experiments/2026-10-29-vldb-raw32-analysis'
ENVIRONMENT=('LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','CFLAGS','CXXFLAGS','LDFLAGS')

def placement(lease):
    value=dict(lease=lease,affinity=sorted(os.sched_getaffinity(0)),
      host=platform.uname()._asdict(),environment={key:os.environ.get(key)for key in ENVIRONMENT})
    validate_placement(value);return value

def validate_placement(value):
    lease=value['lease']
    need(value['affinity']==[2]and lease['cpu']==2 and lease['lease']=='socket0'and lease['lock_path']=='/tmp/fastest-bf-socket0.lock','Wrong recorded placement')
    need(lease['inherited_write_verified']is True and lease['inherited_lock_descriptors'],'Missing actual inherited write proof')
    need(set(value['environment'])==set(ENVIRONMENT)and all(not v for v in value['environment'].values()),'Unfrozen loader/allocator/compiler environment')

def exact(commit,path,want=None):
    path=Path(path);data=path.read_bytes()
    need(committed(commit,path)==data,'Changed committed artifact: '+str(path))
    if want is not None:need(hashlib.sha256(data).hexdigest()==want,'Artifact digest differs')

def inventory(directory,commit):
    p=directory/'PREPARATION.json';exact(commit,p);obj=json.loads(p.read_text())
    for name,want in obj['files'].items():
        path=ROOT/name;need(path.resolve().is_relative_to(ROOT),'Inventory path escape');exact(commit,path,want)
    return obj

def verify(commit,live=True):
    need(__debug__,'Python -O unsupported')
    need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full source commit required')
    own=inventory(HERE,commit)
    inventory(SOURCE,CALLER_COMMIT);inventory(PREFLIGHT,CHECK_COMMIT)
    # Descendant runner commit must include the same earlier C++ and checker bytes.
    inventory(SOURCE,commit);inventory(PREFLIGHT,commit)
    path=SOURCE/'PREFLIGHT_ARCHIVE.json'
    exact(PROOF_COMMIT,path,'a1152d4133929796a0170e5ab8d44c69b35005d3b3517f1b613c562308edc5bc')
    archive=json.loads(path.read_text());need(len(archive['files'])==341,'Wrong proof scope')
    for name,want in archive['files'].items():
        p=SOURCE/name;need(p.resolve().is_relative_to(SOURCE),'Proof path escape');exact(PROOF_COMMIT,p,want)
    freeze=json.loads((SOURCE/'WORKER_FREEZE.json').read_text())
    need(freeze['preparation_commit']==CHECK_COMMIT and freeze['preparation_sha256']==sha(PREFLIGHT/'PREPARATION.json')and freeze['caller_preparation_sha256']==sha(SOURCE/'PREPARATION.json'),'Different compiled preparation')
    metadata=json.loads((ROOT/freeze['proof_metadata']).read_text())
    review=json.loads((ROOT/freeze['assembly_review']).read_text())
    need(metadata['complete']and metadata['all_sources_and_binaries_unchanged']and metadata['worker_rows']==96 and metadata['caller_query_checks']==19620,'Incomplete correctness proof')
    need(review['review_complete']and review['all_six_pointer_branches_use_input_address']and review['all_six_densecall_targets_match_value']and len(review['pairs'])==6,'Missing manual caller ASM proof')
    need(metadata['binaries']==freeze['binaries'],'Proof binaries disagree')
    binary=freeze['binaries']['native/page_pointer_control']
    need(binary['sha256']==review['binary_sha256']==BINARY_SHA,'Different measured caller binary')
    if live:
        for name,want in freeze['consumed_inputs'].items():need(sha(Path(name))==want,'Actual compiler input changed')
        for record in freeze['binaries'].values():
            need(sha(Path(record['path']))==sha(Path(record['retained']))==record['sha256'],'Frozen binary drift')
    return own,freeze

def baseline():
    # Reuse the previously frozen exact728 raw/provenance loader only. Its
    # ranking functions are never called; old latency fields are never compared.
    inventory(ANALYSIS,ANALYSIS_COMMIT)
    loader=module('page_frozen_raw32_loader',ANALYSIS/'summarize.py')
    return loader.load(RAW_COMMIT,BASE/'SCREEN_ARCHIVE.json')
