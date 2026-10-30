#!/usr/bin/env python3
"""Derive fixed geometry/semantic expectations solely from committed old proofs."""
import hashlib
import json
from pathlib import Path
import subprocess

HERE=Path(__file__).resolve().parent
STAGE=HERE.parent
ROOT=HERE.parents[2]
RAW=ROOT/'benchmarks/vldb-raw32-stage3'
RAW_COMMIT='23b1ffe7216a693e31a2c3086299e94837fe42ad'
NEARBY_SOURCE='9ece4af4db5089417aac119fe5166266b2716821'
CONFIGS=['sector32-u1','sector64-u1','register64-u0']
GEOMETRY=['filter','surface','implementation_origin','key_domain','keys','requested_bpk',
          'budget_bytes','filter_bytes','logical_bytes','unit_bytes','unit_count',
          'constructor_argument','effective_probes','probe_policy','geometry_kind','address','public_metadata']
SEMANTIC=['queries','seed','hit_percent','present_queries','absent_queries',
          'calibration_absent_queries','calibration_false_positives','false_positives',
          'result_checksum','inserted_checksum','query_checksum','calibration_checksum']

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def need(ok,message):
    if not ok:raise ValueError(message)
def committed(path,commit):
    need(path.read_bytes()==subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT),
         'Committed anchor drift '+str(path))

def derive():
    archive=RAW/'SCREEN_ARCHIVE.json';committed(archive,RAW_COMMIT)
    raw=RAW/'screen/metadata.json';committed(raw,RAW_COMMIT)
    need(json.loads(archive.read_text())['files']['screen/metadata.json']==sha(raw),'Raw metadata hash mismatch')
    old=json.loads(raw.read_text());need(old['complete']is True,'Incomplete raw728')
    proof=json.loads((STAGE/'validation-v1/metadata.json').read_text())
    need(proof['complete']is True and proof['source_commit']==NEARBY_SOURCE,'Incomplete nearby93')
    nearby_configs=['sector32-u1','sector32-u2','sector32-u4','sector64-u1','sector64-u2','sector64-u4','register64-u0']
    nearby_cases=[(c,n,b)for c in nearby_configs for n in(16,25)for b in(12,24)]
    rows=[]
    for config in CONFIGS:
        for power in(16,25):
            for cap in(12,16,24,32):
                name=config+'/artifact_pimpl'
                matches=[r for r in old['rows']if r['worker']=='legacy'and r['filter']==name and
                         int(r['keys'])==1<<power and int(r['requested_bpk'])==cap]
                need(len(matches)==2 and {r['round']for r in matches}=={0,1},'Missing old public row')
                for keys in(GEOMETRY,SEMANTIC):
                    need({k:matches[0][k]for k in keys}=={k:matches[1][k]for k in keys},'Old rounds differ semantically')
                base=dict(filter=name,power=power,cap=cap,policy='original',status='supported',
                          geometry={k:matches[0][k]for k in GEOMETRY},
                          old_semantics={k:matches[0][k]for k in SEMANTIC})
                rows.append(base)
                if cap not in(12,24):continue
                observed=proof['backend_rows']['native'][nearby_cases.index((config,power,cap))]
                case=dict(filter=name,power=power,cap=cap,policy='nearby_odd',status=observed['status'],
                          old_semantics=None)
                if observed['status']=='supported':
                    g=dict(base['geometry'])
                    g.update(filter_bytes=str(observed['backing_bytes']),logical_bytes=str(observed['logical_bytes']),
                             unit_count=str(observed['block_count']),constructor_argument=str(observed['constructor_bits']),
                             geometry_kind='original_blocked_bloom_nearby_odd',address=observed['address'],
                             public_metadata=json.dumps(observed['upstream_metadata'],separators=(',',':')))
                    case['geometry']=g
                else:case['unsupported_geometry']=observed
                rows.append(case)
    need(len(rows)==36 and sum(r['policy']=='original'for r in rows)==24,'Wrong fixed grid')
    return dict(raw728_commit=RAW_COMMIT,nearby93_source=NEARBY_SOURCE,
                nearby93_archive_sha256=sha(STAGE/'PREFLIGHT_ARCHIVE.json'),cases=rows)

if __name__=='__main__':
    print(json.dumps(derive(),indent=2)+'\n',end='')
