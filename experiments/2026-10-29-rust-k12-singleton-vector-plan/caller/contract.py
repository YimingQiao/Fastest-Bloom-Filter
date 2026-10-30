"""Finite correctness-only caller schema; no performance summarizer."""
import itertools
import math

FOUR=[[0,1,3,2],[1,2,0,3],[2,3,1,0],[3,0,2,1]]
TWO=[[0,1],[1,0],[1,0],[0,1]]
SEMANTIC=['keys','queries','batch','hit','seed','repeats','filter_bytes','input_digest',
          'insert_digest','bitmap_digest','output_digest','scratch_bytes','phase_order','calibration_queries']

def need(ok,message):
    if not ok: raise ValueError(message)

def cases():
    return [{'hit':h,'batch':b} for h,b in itertools.product([0,50,100],[1,3,31,4096])]

def argv(binary,case):
    return [str(binary),'--check',str(case['hit']),str(case['batch']),'74381']

def validate_rows(rows,case,disabled=False):
    need(len(rows)==2,'exactly two public rows required')
    need([r['filter'] for r in rows]==['Control','Candidate'],'public arm order differs')
    fixed=dict(keys=256,queries=4096,batch=case['batch'],hit=case['hit'],seed=74381,
               repeats=4,filter_bytes=768,scratch_bytes=min(case['batch'],4096)*8,
               phase_order=FOUR if case['batch']==1 else TWO,calibration_queries=0)
    for row in rows:
        need(set(row)==set(fixed)|{'filter','backend','input_digest','insert_digest',
                                 'bitmap_digest','output_digest','trials_ns'},'row schema differs')
        need(all(row[k]==v for k,v in fixed.items()),'fixed workload/schema differs')
        # This proof is fixed to the already identified AVX512-capable CPU3.
        # Portable flags must still exercise runtime AVX512, not silently pass
        # by falling back to the unchanged scalar/AVX2 route.
        need(row['backend']==('avx2' if disabled else 'avx512'),'required runtime backend was not exercised')
        for k in ['input_digest','insert_digest','bitmap_digest','output_digest']:
            need(type(row[k]) is int and 0<=row[k]<2**64,'invalid digest')
        need(len(row['trials_ns'])==(4 if case['batch']==1 else 2),'wrong mode count')
        for values in row['trials_ns']:
            need(len(values)==4 and all(type(v) in [int,float] and math.isfinite(v) and v>0 for v in values),'invalid trial vector')
    need(all(rows[0][k]==rows[1][k] for k in SEMANTIC),'arm semantic drift')

def invalid(binary):
    return [
        ([str(binary)],'expected --check HIT BATCH SEED [--fault NAME]'),
        ([str(binary),'--measure','50','1','74381'],'only fixed check seed74381 is permitted'),
        ([str(binary),'--check','50','1','74382'],'only fixed check seed74381 is permitted'),
        ([str(binary),'--check','51','1','74381'],'outside fixed check grid'),
        ([str(binary),'--check','50','0','74381'],'outside fixed check grid'),
        ([str(binary),'--check','50','3','74381','--fault','visible-wrong'],'invalid fixed fault case'),
    ]
