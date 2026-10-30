"""Source-only fixed36-process/486-row ledger, never executes a filter."""
import hashlib,json,re,subprocess
from pathlib import Path
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
PLAN_DIR=ROOT/'experiments/2026-10-29-poppy-public-speed-plan'
CALLER=ROOT/'experiments/2026-10-29-poppy-public-speed-caller'
PLAN_COMMIT='4d2b7f69d941991f3a9f4cebeb2c7c87514cd8f0'
CALLER_COMMIT='235090460f5bc063109c1cb3d40357673f36d50e'
SOURCE=CALLER/'benchmark/src/main.rs'
def need(ok,message):
    if not ok:raise ValueError(message)
def exact(commit,path):
    data=subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
    need(path.read_bytes()==data,'Changed immutable source: '+str(path));return data
def selection():return json.loads(exact(PLAN_COMMIT,PLAN_DIR/'selection.json'))
def registry():
    source=exact(CALLER_COMMIT,SOURCE).decode();match=re.search(r'const FILTER_NAMES: &\[&str\] = &\[(.*?)\];',source,re.S)
    need(match is not None,'Missing source registry');names=re.findall(r'"([A-Za-z0-9_]+)"',match[1])
    need(len(names)==len(set(names))==68,'Changed68-name registry');return names
def derive():
    selected=selection();points=selected['configurations'];names=registry()
    need(len(points)==81 and len({p['configuration_id']for p in points})==81,'Wrong frozen geometry union')
    need(sum(p['owner']=='poppy_external'for p in points)==47,'Changed Poppy canonical union')
    need(sum(p['owner']=='optional_native_k12'for p in points)==2,'Changed original K12 controls')
    base=[]
    for n in (65536,33554432):
        for cap in (16,24,32):
            group=[p for p in points if p['keys']==n and p['run_budget_bpk']==cap]
            filters=[name for name in names if any(p['filter']==name for p in group)]
            need(len(group)==len(filters)>0,'Duplicate/empty selected group')
            ids={p['filter']:p['configuration_id']for p in group}
            for batch in (4096,1,31):
                base.append(dict(key_power=n.bit_length()-1,keys=n,budget_bpk=cap,batch=batch,seed=42,
                    filters=filters,configuration_ids=[ids[name]for name in filters]))
    cases=[]
    for round_index,ordered in [(1,base),(2,list(reversed(base)))]:
        for cell in ordered:
            cases.append(dict(index=len(cases),round=round_index,order='original'if round_index==1 else'reverse',
                calibration_power=26 if round_index==1 and cell['batch']==4096 else 0,**cell))
    need(len(cases)==36 and sum(len(c['filters'])for c in cases)==486,'Changed finite counts')
    calibration={}
    for case in cases:
        for ident in case['configuration_ids']:
            if case['calibration_power']:
                need(ident not in calibration,'Repeated calibration');calibration[ident]=case['index']
            need(ident in calibration,'Calibration must precede reused geometry')
    need(len(calibration)==81,'Missing quality construction')
    return dict(plan_commit=PLAN_COMMIT,caller_source_commit=CALLER_COMMIT,cases=cases,
                calibration_case_by_geometry=calibration,processes=36,rows=486,calibrated_rows=81,reuse_rows=405)
if __name__=='__main__':
    value=derive();content=json.dumps(value,indent=2)+'\n';path=HERE/'ledger.json'
    if path.exists():need(path.read_text()==content,'Preserve prior fixed ledger')
    else:path.write_text(content)
    print(json.dumps({k:value[k]for k in ('processes','rows','calibrated_rows','reuse_rows')}))
