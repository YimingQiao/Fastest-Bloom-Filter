"""Single CPU2 parent and explicit NUMA0 child placement, whole socket0 lock."""
import os,re,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(HERE.parent/'caller'))
from lease import require as original_require,FORBIDDEN
from contract import need
CPU=2;NODE=0
PREFIX=['/usr/bin/numactl','--physcpubind=2','--membind=0']
DESCRIPTION='CPU2 parent affinity; each measured child explicitly bound to CPU2 and NUMA0'

def validate(record):
    need(record['cpu']==2 and record['socket']==0 and record['node']==0 and record['affinity']==[2],'Incorrect archived CPU placement')
    need(type(record['core'])is int and record['core']>=0,'Missing physical core')
    need(record['lock_path']=='/tmp/fastest-bf-socket0.lock','Wrong socket lock')
    fds=record['inherited_lock_descriptors'];need(fds and len(fds)==len(set(fds))and all(type(x)is int and x>=0 for x in fds),'Invalid inherited descriptors')
    need(set(record['environment'])==set(FORBIDDEN)and not any(record['environment'].values()),'Archived environment override')
    need(record['memory_policy']==DESCRIPTION,'Wrong memory placement description')
    need(set(record['exclusive_lock_evidence'])==set(map(str,fds)),'Incomplete lock evidence')
    for text in record['exclusive_lock_evidence'].values():
        need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',text,re.M),'Archived lease was not exclusive')
    return record

def require():
    record=original_require(CPU)
    record['memory_policy']=DESCRIPTION
    record['exclusive_lock_evidence']={str(fd):Path(f'/proc/self/fdinfo/{fd}').read_text()for fd in record['inherited_lock_descriptors']}
    return validate(record)
