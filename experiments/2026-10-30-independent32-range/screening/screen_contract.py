"""Fixed24 processes/216 rows and unpooled calibration links; no rankings."""
import json
from pathlib import Path
import row_guard as guard
HERE=Path(__file__).resolve().parent;need=guard.need
INSERT_IDENTITY=(*guard.GEOMETRY,'seed','key_base','inserted_digest','inserted_hash_digest','bitmap_digest')
QUERY_IDENTITY=('queries','hit','query_digest','query_hash_digest','result_digest','present','absent','false_positives')
CALIBRATION=('calibration_negatives','calibration_fp','calibration_digest')

def read(path):return json.loads(Path(path).read_text(),object_pairs_hook=guard.unique)
def ledger():
    cases=read(HERE/'ledger.json');need(len(cases)==24 and [c['index']for c in cases]==list(range(24)),'fixed ledger changed')
    need(sum(len(c['point_ids'])for c in cases)==216,'fixed row count changed')
    for case in cases:
        need(case['power']in(16,25) and case['query_power']==22 and case['hit']==50 and case['repeats']==8
             and case['seed']in(982451653,961748941) and case['batch']in(1,31,4096),'formal dimensions')
        need(case['round']in(1,2)and case['order']==case['round']-1,'launch round/order')
        need(case['calibration_power']==(26 if case['round']==1 and case['batch']==1 else 0),'fresh calibration schedule')
        points,_=guard.selected(case);need([p['id']for p in points]==case['point_ids'],'source-shuffled API order')
    first=[dict(power=p,seed=s,batch=b)for p in(16,25)for s in(982451653,961748941)for b in(1,31,4096)]
    need([{k:c[k]for k in ('power','seed','batch')}for c in cases]==first+first[::-1],'whole ledger order')
    return cases
def arguments(case):return guard.arguments(case,'--measure')
def parse(text,case):
    rows=guard.parse(text,case)
    need([r['point_id']for r in rows]==case['point_ids'],'exact API list/order')
    return rows
def tuple_of(row,fields):return tuple(row[k]for k in fields)

def validate_records(records,complete=True):
    need((len(records)==24)if complete else(0<len(records)<=24),'incomplete process count')
    points={p['id']:p for p in guard.POINTS};insert_seen={};query_seen={};quality={};aliases={}
    total_rows=total_vectors=total_samples=reuse_rows=0
    for expected,record in zip(ledger()[:len(records)],records,strict=True):
        need(record['case']==expected,'case order/arguments changed')
        rows=parse('\n'.join(json.dumps(r,allow_nan=False)for r in record['rows']),expected)
        for index,row in enumerate(rows):
            total_rows+=1;total_vectors+=sum(bool(v)for v in row['samples'].values());total_samples+=sum(map(len,row['samples'].values()))
            key=(row['point_id'],row['seed']);insertion=tuple_of(row,INSERT_IDENTITY);query=tuple_of(row,QUERY_IDENTITY)
            need(key not in insert_seen or insert_seen[key]==insertion,'construction identity changed')
            need(key not in query_seen or query_seen[key]==query,'full mixed-query identity changed')
            insert_seen[key]=insertion;query_seen[key]=query
            if expected['calibration_power']:
                need(expected['round']==1 and expected['batch']==1 and key not in quality,'unexpected/duplicate fresh calibration')
                need(row['calibration_negatives']==1<<26,'fresh denominator')
                entry={k:row[k]for k in('point_id','keys','seed','actual_bytes','key_base','inserted_digest','inserted_hash_digest','bitmap_available','bitmap_digest',*CALIBRATION)}
                entry.update(mapping_id=points[row['point_id']]['mapping_id'],source_case_index=expected['index'],source_row_index=index,reuse_case_indices=[])
                quality[key]=entry;alias=(entry['mapping_id'],row['seed'])
                evidence=tuple_of(row,('keys','actual_bytes','key_base','inserted_digest','inserted_hash_digest','bitmap_available','bitmap_digest',*QUERY_IDENTITY,*CALIBRATION))
                need(alias not in aliases or aliases[alias]==evidence,'known equal-byte mapping alias differs');aliases[alias]=evidence
            else:
                need(key in quality,'reuse precedes its fresh source')
                need(row['calibration_negatives']==0 and row['calibration_fp']==0 and row['calibration_digest']is None,'cal0 row contains new calibration')
                quality[key]['reuse_case_indices'].append(expected['index']);reuse_rows+=1
    if complete:
        need((total_rows,total_vectors,total_samples)==(216,576,4608),'complete sample counts')
        need((len(quality),len(aliases),reuse_rows)==(36,34,180),'quality source/known group/reuse counts')
    counts=dict(processes=len(records),rows=total_rows,query_vectors=total_vectors,query_samples=total_samples,
        calibration_rows=len(quality),reuse_rows=reuse_rows,api_quality_records=len(quality),known_alias_records=len(aliases))
    links=dict(api_records=list(quality.values()),api_record_count=len(quality),known_mapping_record_count=len(aliases),
        calibration_rows=len(quality),reuse_rows=reuse_rows,pooling=False)
    return counts,links
