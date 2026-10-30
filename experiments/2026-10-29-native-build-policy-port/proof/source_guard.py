"""Committed native snapshots and exact caller derivation; no live native dependency."""
import argparse,hashlib,json,re,subprocess
from pathlib import Path
import derive
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
STAGE=HERE.parent

def need(ok,message):
    if not ok:raise ValueError(message)
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def exact(commit,path):
    want=subprocess.check_output(['git','show',commit+':'+str(path.relative_to(ROOT))],cwd=ROOT)
    need(path.read_bytes()==want,'Committed source drift: '+str(path))
def verify(commit=None):
    need(__debug__,'Python -O unsupported')
    if commit:need(re.fullmatch('[0-9a-f]{40}',commit)is not None,'Full source commit required')
    result={}
    for directory in [STAGE,HERE]:
        manifest=directory/'PREPARATION.json'
        if commit:exact(commit,manifest)
        result[str(manifest.relative_to(ROOT))]=sha(manifest)
        for name,item in json.loads(manifest.read_text())['files'].items():
            path=directory/name
            need(path.is_file()and path.stat().st_size==item['bytes']and sha(path)==item['sha256'],'Source manifest drift: '+name)
            if commit:exact(commit,path)
            result[str(path.relative_to(ROOT))]=item['sha256']
    for name,data in derive.sources().items():
        need((HERE/name).read_bytes()==data,'Native/caller derivation changed: '+name)
    need((HERE/'fixed-plan/ledger.json').read_bytes()==(STAGE/'ledger.json').read_bytes(),'Ledger copy drift')
    pins=json.loads((STAGE/'native-source.json').read_text())
    need(pins['before_commit']==derive.BEFORE and pins['after_commit']==derive.AFTER,'Wrong native source versions')
    for name,entry in pins['candidate_files'].items():
        data=derive.blob(derive.AFTER,name)
        need(hashlib.sha256(data).hexdigest()==entry['sha256'],'Native delta drift')
    return result
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--source-commit');a=p.parse_args()
    print('PASS',len(verify(a.source_commit)),'frozen source inputs; no compiler/Bloom execution')
