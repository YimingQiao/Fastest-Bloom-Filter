"""Fixed240 caller workload; no timing selection and no old-context ratios."""
import json,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
SOURCE=HERE.parent
PREFLIGHT=SOURCE/'preflight'
sys.path.insert(0,str(PREFLIGHT))
from checks import ROOT,BASE,PROTOCOL,NAMES,WORKER,ALIASES,original,need,validate,parity,compare_baseline

def panel(round_index):
    need(round_index in (0,1),'Unknown launch round')
    expected=['forward_registry','reverse_registry']
    need(PROTOCOL['rounds']==[dict(round=i,alias_order=expected[i])for i in (0,1)],'Changed round policy')
    order=NAMES if round_index==0 else list(reversed(NAMES))
    result=[];seen=set()
    for power in PROTOCOL['key_powers']:
        for cap in PROTOCOL['caps_bpk']:
            for name in order:
                g=original.geometry('modern',ALIASES.get(name,name),power,cap)
                key=(name,power)+tuple(str(g[k])for k in original.SEMANTICS)
                if key in seen:continue
                seen.add(key)
                g.update(worker=WORKER,filter=name)
                if name in ALIASES:g['surface']='upstream_raw4_input_pointer_single_v1'
                result.append(g)
    need(len(result)==PROTOCOL['rows_per_round']==120,'Wrong per-round geometry count')
    return result

def plan():
    result=[]
    for round_index in (0,1):
        for g in panel(round_index):
            c=dict(worker=WORKER,filter=g['filter'],power=g['keys'].bit_length()-1,
              cap=g['requested_bpk'],qpower=PROTOCOL['query_power'],hit=PROTOCOL['hit_percent'],
              seed=PROTOCOL['seed'],calpower=PROTOCOL['calibration_power'],repeats=PROTOCOL['repeats'])
            result.append(dict(round=round_index,case=c,geometry=g))
    need(len(result)==PROTOCOL['total_rows']==240,'Wrong full caller grid')
    need(PROTOCOL['repeats']==6 and PROTOCOL['build_repeats']==0 and PROTOCOL['modes']==original.MODES,'Changed clock/build contract')
    return result

def command(binary,case):return [str(binary),*original.arguments(case,'--measure')]

def audit(metadata,raws,baseline,binary):
    expected=plan();records=metadata['commands'];saved=metadata['rows']
    need(len(records)==len(saved)==len(raws)==len(expected),'Incomplete/extra measured rows')
    rows=[]
    for i,(item,record,row_saved,raw)in enumerate(zip(expected,records,saved,raws,strict=True)):
        label=f'row{i:03d}';c=item['case']
        need(record['label']==label and record['round']==item['round'] and record['case']==c,'Actual launch order/geometry drift')
        need(record['complete']is True and record['returncode']==0,'Unfinished/failed measurement')
        need(record['command']==command(binary,c),'Recorded command differs')
        need(record['stdout']==label+'.stdout'and record['stderr']==label+'.stderr','Wrong raw filenames')
        need(not raw['stderr'],'Unexpected worker diagnostic')
        row=validate(original.parse_one(raw['stdout']),c)
        row=dict(round=item['round'],**row);need(row==row_saved,'Metadata/raw output differ');rows.append(row)
    need(parity(rows)==PROTOCOL['unpooled_quality_identities']==72,'Wrong unpooled alias coverage')
    need(compare_baseline(rows,baseline)==72,'Missing old-context semantic parity')
    return rows
