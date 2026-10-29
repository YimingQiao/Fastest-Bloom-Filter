"""Narrow source derivation of the proved216 producer for the fixed192 panel."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
PRODUCER='796bd636eab59ce130923864c5d3c925189ec8e5'
CALLER='ac71d43cc64eb75edfc1a490f0429c4be6003c8a'
ANALYSIS='8d672c5b3eb3ef96f806eb3b4783b7a22bf39b84'
CORE='6981a9139f6b10785036dd6a43c398a337cfce09'

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--write',action='store_true');args=parser.parse_args()
    outputs={};parents=[]
    def source(commit,path):
        data=subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
        parents.append(dict(commit=commit,path=path,sha256=hashlib.sha256(data).hexdigest()));return data
    def change(name,old,substitutions):
        new=old
        for a,b in substitutions:
            assert a in new,(name,a);new=new.replace(a,b)
        outputs[name]=new.encode()
        outputs[name+'.patch']=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),
            fromfile='frozen-parent/'+name,tofile='fixed192/'+name)).encode()
    prefix='experiments/2026-10-30-independent32-range/screening/'
    for name in ('placement.py','audit.py'):outputs[name]=source(PRODUCER,prefix+name)
    change('run.py',source(PRODUCER,prefix+'run.py').decode(),[('Complete24 processes/216 rows','Complete24 processes/192 rows')])
    change('pins.py',source(PRODUCER,prefix+'pins.py').decode(),[
        ("len(archive['files'])==173","len(archive['files'])==272"),
        ("compiled['counts']['caller_rows']==66","compiled['counts']['caller_rows']==90"),
        ("len(closure['all_binary_sha256'])==2 and len(closure['compiler_consumed_input_sha256'])==570",
         "len(closure['all_binary_sha256'])==3 and len(closure['compiler_consumed_input_sha256'])==572")])
    change('screen_contract.py',source(PRODUCER,prefix+'screen_contract.py').decode(),[
        ('Fixed24 processes/216 rows','Fixed24 processes/192 rows'),("for c in cases)==216","for c in cases)==192"),
        ('(216,576,4608)','(192,512,4096)'),('(36,34,180)','(32,26,160)')])
    change('test_screen.py',source(PRODUCER,prefix+'test_screen.py').decode(),[
        ('rows=216,query_vectors=576,query_samples=4608','rows=192,query_vectors=512,query_samples=4096'),
        ('calibration_rows=36,reuse_rows=180,api_quality_records=36,known_alias_records=34',
         'calibration_rows=32,reuse_rows=160,api_quality_records=32,known_alias_records=26'),
        ("quality['api_records']),180)","quality['api_records']),160)"),
        ("('alias','opaque','bytes')","('alias','pipeline','opaque','bytes')"),
        ("            elif action=='opaque':", "            elif action=='pipeline':\n                row=next(r for r in bad[1]['rows']if r['owner']=='candidate');row['result_digest']^=1\n            elif action=='opaque':")])
    original=source(CALLER,'experiments/2026-10-30-independent32-range-prefetch64/caller/contract.py').decode()
    change('row_guard.py',original,[
        ('"""Fixed small actual-caller proof; no timing ranking or formal-data loader."""','"""Exact formal row guard derived from the proved small caller; no rankings."""'),
        ("    points.append(SELECTION['proof_only_point'])\n",''),
        ("expected=dict(queries=q,hit=case['hit'],batch=case['batch'],repeats=4,seed=74381,",
         "expected=dict(queries=q,hit=case['hit'],batch=case['batch'],repeats=case['repeats'],seed=case['seed'],"),
        ('measure=False,key_base=base','measure=True,key_base=base'),
        ('[m for trial in schedule for m in trial]',"[m for trial in schedule*(case['repeats']//4) for m in trial]"),
        ("len(v)==(4 if i<2 or case['batch']==1 else 0)","len(v)==(case['repeats'] if i<2 or case['batch']==1 else 0)")])
    outputs['selection.json']=source(CALLER,'experiments/2026-10-30-independent32-range-prefetch64/caller/selection.json')
    for name in ('ledger.json','ANALYSIS_RULES.json'):
        outputs[name]=source(ANALYSIS,'experiments/2026-10-30-independent32-range-prefetch64-analysis/'+name)
    outputs['protocol.json']=source(CORE,'experiments/2026-10-30-independent32-range-prefetch64/protocol.json')
    outputs['DERIVATION.json']=(json.dumps(dict(source_only=True,parents=parents,
        outputs={n:hashlib.sha256(b).hexdigest()for n,b in outputs.items()}),indent=2)+'\n').encode()
    for name,data in outputs.items():
        path=HERE/name
        if args.write:path.write_bytes(data)
        else:assert path.read_bytes()==data,name
    print('Verified',len(outputs),'finite producer/guard derivations; no filter/compiler.')

if __name__=='__main__':main()
