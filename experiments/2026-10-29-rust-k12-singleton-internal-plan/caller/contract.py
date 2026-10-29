"""Bounded check-only proof rows and exact immutable reference semantics."""
import json
import math
from guards import need, OLD

FOUR = [[0,1,3,2],[1,2,0,3],[2,3,1,0],[3,0,2,1]]
TWO = [[0,1],[1,0],[1,0],[0,1]]
SEMANTIC = ['filter','keys','queries','batch','hit','seed','repeats','filter_bytes','backend',
            'input_digest','insert_digest','bitmap_digest','output_digest','scratch_bytes','phase_order','calibration_queries']

def cases():
    return [dict(batch=b, reverse=False) for b in [1,3,31,4096]] + [dict(batch=1, reverse=True)]

def argv(binary, case):
    return [str(binary), '--check', '50', str(case['batch']), '74381'] + (['--reverse'] if case['reverse'] else [])

def validate_rows(rows, case, profile):
    order = ['Candidate','Control'] if case['reverse'] else ['Control','Candidate']
    need(len(rows) == 2 and [row['filter'] for row in rows] == order, 'wrong two-arm order')
    fixed = dict(keys=256,queries=4096,batch=case['batch'],hit=50,seed=74381,repeats=4,
                 filter_bytes=768,backend='avx512',scratch_bytes=min(case['batch'],4096)*8,
                 phase_order=FOUR if case['batch']==1 else TWO,calibration_queries=0,
                 round=2 if case['reverse'] else 1,stage='check')
    for row in rows:
        need(set(row) == set(fixed)|{'filter','input_digest','insert_digest','bitmap_digest','output_digest','trials_ns'}, 'row schema differs')
        need(all(row[k] == v for k,v in fixed.items()), 'fixed proof metadata/backend differs')
        for key in ['input_digest','insert_digest','bitmap_digest','output_digest']:
            need(type(row[key]) is int and 0 <= row[key] < 2**64, 'invalid digest')
        need(len(row['trials_ns']) == (4 if case['batch']==1 else 2), 'wrong mode count')
        for values in row['trials_ns']:
            need(len(values)==4 and all(type(v) in [int,float] and math.isfinite(v) and v>0 for v in values), 'invalid trial vector')
    index=4+[1,3,31,4096].index(case['batch'])
    original=[json.loads(line) for line in (OLD/f'repair-v2/validation-v1/{profile}-case-{index}.stdout').read_text().splitlines()]
    a={row['filter']:{k:row[k] for k in SEMANTIC} for row in rows}
    b={row['filter']:{k:row[k] for k in SEMANTIC} for row in original}
    need(a == b, 'immutable original caller semantic mismatch')
    need(all(rows[0][k] == rows[1][k] for k in SEMANTIC if k!='filter'), 'arm semantic mismatch')

def invalid(binary):
    return [
        ([str(binary),'--check','50','0','74381'], 'outside fixed check grid'),
        ([str(binary),'--measure','16','50','1','74381','1'], 'outside fixed formal grid'),
        ([str(binary),'--measure','64','50','1','6812364731','1'], 'outside fixed formal grid'),
        ([str(binary),'--measure','16','0','3','6812364731','1'], 'outside fixed formal grid'),
    ]
