"""Derive finite expectations from committed proofs/complete data, never timings."""
import hashlib,json,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;STAGE=HERE.parent;ROOT=STAGE.parents[1]
sys.path.insert(0,str(STAGE))
from checks import NATIVE,SEMANTIC,geometry_key,need
PROOF='7b260fe8830ac93d73eb81bd42a32257e04fa72e'
ACCURACY='f8d1449cb5abb41609b426229bde11f77ad03921'
OLD='23b1ffe7216a693e31a2c3086299e94837fe42ad'
PROPOSAL='a46dab6fc0bc9f18b7fa1f00174ce55c3a63d78c'

def derive():
    inputs=[]
    def read(commit,path):
        path=Path(path);relative=str(path.relative_to(ROOT));data=subprocess.check_output(['git','show',commit+':'+relative],cwd=ROOT)
        need(data==path.read_bytes(),'Immutable derivation source drift '+relative)
        inputs.append(dict(commit=commit,path=relative,sha256=hashlib.sha256(data).hexdigest()));return json.loads(data)
    p=read(PROPOSAL,ROOT/'experiments/2026-10-29-vldb-nearby-performance-proposal/proposal.json')
    tiny=read(PROOF,STAGE/'validation-v1/metadata.json')['rows']['native']
    raw=read(ACCURACY,ROOT/'experiments/2026-10-29-vldb-nearby-geometry/accuracy/screening/results-v1/results.json')
    legacy=read(OLD,ROOT/'benchmarks/vldb-raw32-stage3/screen/metadata.json')['rows']
    source={}
    for row in raw:
        if row.get('status')=='unsupported':continue
        if row['requested_bpk']not in ('12','24'):continue
        # The accuracy worker declares policy through geometry kind.
        policy='nearby_odd'if row['geometry_kind'].endswith('_nearby_odd')else'original'
        source[(row['filter']+'/'+policy,row['keys'],row['requested_bpk'])]=row
    objects={r['filter']:r['adapter_object_bytes']for r in tiny}
    geometry={};semantics={}
    for power in p['key_powers']:
        n=1<<power
        for cap in p['bitmap_cap_bpk']:
            for name in p['ordered_apis']:
                key=f'{name}/{power}/{cap}'
                if name not in NATIVE:
                    base=source[(geometry_key(name),str(n),str(cap))]
                    g={k:base[k]for k in tiny[0]if k in ('worker','filter','surface','implementation_origin','key_domain','keys','requested_bpk','budget_bytes','filter_bytes','logical_bytes','unit_bytes','unit_count','constructor_argument','effective_probes','probe_policy','geometry_kind','address','public_metadata')}
                    g['worker']='nearby_legacy';g['filter']=name
                    meta=json.loads(g['public_metadata']);meta['u']=int(name.split('/')[0].split('-u')[1]);g['public_metadata']=json.dumps(meta,separators=(',',':'))
                    semantics[f'{geometry_key(name)}/{power}/{cap}']={k:base[k]for k in SEMANTIC}
                elif name in NATIVE[:4]:
                    actual=n*(8 if cap==12 else 16)//8
                    choices=[r for r in legacy if r['worker']=='legacy'and r['filter']==name and r['keys']==str(n)and r['filter_bytes']==str(actual)]
                    need(len(choices)==2,'Wrong two-round native reference');base=choices[0]
                    need(all({k:r[k]for k in SEMANTIC}=={k:base[k]for k in SEMANTIC}for r in choices),'Old native rounds differ')
                    g={k:base[k]for k in tiny[0]if k in ('worker','filter','surface','implementation_origin','key_domain','keys','requested_bpk','budget_bytes','filter_bytes','logical_bytes','unit_bytes','unit_count','constructor_argument','effective_probes','probe_policy','geometry_kind','address','public_metadata')}
                    g.update(worker='nearby_legacy',requested_bpk=str(cap),budget_bytes=str(n*cap//8));semantics[key]={k:base[k]for k in SEMANTIC}
                else:
                    base=next(r for r in tiny if r['filter']==name and r['requested_bpk']==str(cap))
                    g={k:base[k]for k in tiny[0]if k in ('worker','filter','surface','implementation_origin','key_domain','keys','requested_bpk','budget_bytes','filter_bytes','logical_bytes','unit_bytes','unit_count','constructor_argument','effective_probes','probe_policy','geometry_kind','address','public_metadata')}
                    b=n*cap//8;g.update(keys=str(n),budget_bytes=str(b),filter_bytes=str(b),logical_bytes=str(b),unit_count=str(b//64),constructor_argument=str(b))
                geometry[key]=g
    need(len(geometry)==80 and len(semantics)==40 and len(objects)==20,'Wrong finite model coverage')
    return {'protocol.json':p,'geometry-models.json':geometry,'object-bytes.json':objects,'semantic-references.json':semantics},inputs

if __name__=='__main__':
    outputs,inputs=derive()
    for name,value in outputs.items():(HERE/name).write_text(json.dumps(value,indent=2)+'\n')
    (HERE/'DERIVATION.json').write_text(json.dumps(dict(inputs=inputs,old_timing_fields_imported=False),indent=2)+'\n')
