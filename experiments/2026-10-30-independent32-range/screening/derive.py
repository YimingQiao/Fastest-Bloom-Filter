"""Source-only derivation from reviewed CPP616 producer and actual caller guards."""
import argparse
import difflib
import hashlib
import json
from pathlib import Path
import subprocess
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
CPP='4beef70009394a839a17d01b22ad9700363f23dc'
CALLER='968361dbcceabecdb2eb17daf069dee058c28bb4'
ANALYSIS='96e3e8a62ca59065fb61e04a1a34d67e02ceb229'
PARENT='944c1bae12d725dffeee900632baf1b95b67c259'
def main():
    p=argparse.ArgumentParser();p.add_argument('--write',action='store_true');args=p.parse_args()
    outputs={};parents=[]
    def source(commit,path):
        data=subprocess.check_output(['git','show',commit+':'+path],cwd=ROOT)
        parents.append(dict(commit=commit,path=path,sha256=hashlib.sha256(data).hexdigest()));return data
    def change(name,old,substitutions):
        new=old
        for a,b in substitutions:
            assert a in new,(name,a);new=new.replace(a,b)
        outputs[name]=new.encode()
        outputs[name+'.patch']=''.join(difflib.unified_diff(old.splitlines(True),new.splitlines(True),fromfile='frozen-parent/'+name,tofile='fixed216/'+name)).encode()
    prefix='experiments/2026-10-29-k12-singleton-external-plan/screening/'
    outputs['placement.py']=source(CPP,prefix+'placement.py')
    change('run.py',source(CPP,prefix+'run.py').decode(),[
        ('exact48 processes','exact24 processes'),('/48 processes complete','/24 processes complete'),
        ("len(files)==99","len(files)==51"),('files_count=99','files_count=51'),
        ('Complete48 processes/616 rows','Complete24 processes/216 rows')])
    change('audit.py',source(CPP,prefix+'audit.py').decode(),[
        ("len(metadata['cases'])==48","len(metadata['cases'])==24"),('range(48)','range(24)'),('len(files)==99','len(files)==51')])
    original=source(CALLER,'experiments/2026-10-30-independent32-range/caller/contract.py').decode()
    change('row_guard.py',original,[
        ('"""Fixed small actual-caller proof; no timing ranking or formal-data loader."""','"""Exact formal row guard derived from the proved small caller; no rankings."""'),
        ("    points.append(SELECTION['proof_only_point'])\n",''),
        ("expected=dict(queries=q,hit=case['hit'],batch=case['batch'],repeats=4,seed=74381,",
         "expected=dict(queries=q,hit=case['hit'],batch=case['batch'],repeats=case['repeats'],seed=case['seed'],"),
        ('measure=False,key_base=base','measure=True,key_base=base'),
        ('[m for trial in schedule for m in trial]','[m for trial in schedule*(case[\'repeats\']//4) for m in trial]'),
        ("len(v)==(4 if i<2 or case['batch']==1 else 0)","len(v)==(case['repeats'] if i<2 or case['batch']==1 else 0)")])
    outputs['selection.json']=source(CALLER,'experiments/2026-10-30-independent32-range/caller/selection.json')
    outputs['ledger.json']=source(ANALYSIS,'experiments/2026-10-30-independent32-range-analysis/ledger.json')
    outputs['ANALYSIS_RULES.json']=source(ANALYSIS,'experiments/2026-10-30-independent32-range-analysis/ANALYSIS_RULES.json')
    outputs['protocol.json']=source(PARENT,'experiments/2026-10-30-independent32-range/protocol.json')
    outputs['DERIVATION.json']=(json.dumps(dict(source_only=True,parents=parents,outputs={n:hashlib.sha256(b).hexdigest()for n,b in outputs.items()}),indent=2)+'\n').encode()
    for name,data in outputs.items():
        path=HERE/name
        if args.write:path.write_bytes(data)
        else:assert path.read_bytes()==data,name
    print('Verified',len(outputs),'finite producer/guard derivations; no filter/compiler.')
if __name__=='__main__':main()
