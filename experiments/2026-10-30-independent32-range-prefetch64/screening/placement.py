"""One physical CPU3 and explicit NUMA1 under the inherited whole-run lock."""
import fcntl
import os
from pathlib import Path
import re
from screen_contract import need
FORBIDDEN=('LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','GLIBC_TUNABLES','MALLOC_ARENA_MAX',
    'CXXFLAGS','CFLAGS','CPPFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS')
DESCRIPTION='Parent CPU3; each measured child CPU3 with explicit NUMA1 memory binding'
def validate(value):
    need(value['cpu']==3 and value['socket']==1 and value['node']==1 and value['affinity']==[3],'wrong archived placement')
    need(type(value['core'])is int and value['core']>=0,'physical core missing')
    need(value['lock_path']=='/tmp/fastest-bf-socket1.lock' and value['lease_name']=='socket1-cpu3','wrong archived lease')
    need(value['memory_policy']==DESCRIPTION,'wrong memory policy')
    need(value['fd_evidence'],'missing inherited lock evidence')
    for fd,text in value['fd_evidence'].items():
        need(fd.isdigit()and re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',text,re.M),'non-exclusive archived lock')
    need(set(value['environment'])==set(FORBIDDEN)and not any(value['environment'].values()),'environment override')
    return value
def require():
    need(os.environ.get('BF_SOCKET_LEASE')=='socket1-cpu3'and os.sched_getaffinity(0)=={3},'explicit pinned socket1 lease required')
    lock='/tmp/fastest-bf-socket1.lock';evidence={}
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name)!=lock:continue
            text=Path('/proc/self/fdinfo/'+name).read_text()
            need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',text,re.M),'lock must already be exclusively held')
            fcntl.flock(int(name),fcntl.LOCK_EX|fcntl.LOCK_NB);evidence[name]=text
        except FileNotFoundError:pass
    cpu=Path('/sys/devices/system/cpu/cpu3');nodes=sorted(int(p.name[4:])for p in cpu.glob('node[0-9]*'));need(nodes==[1],'wrong physical node')
    return validate(dict(cpu=3,socket=int((cpu/'topology/physical_package_id').read_text()),node=1,core=int((cpu/'topology/core_id').read_text()),
        affinity=[3],lease_name=os.environ['BF_SOCKET_LEASE'],lock_path=lock,fd_evidence=evidence,
        environment={key:os.environ.get(key)for key in FORBIDDEN},memory_policy=DESCRIPTION))
