"""Whole-operation socket1 correctness lease, never a performance grant."""
import fcntl
import os
from pathlib import Path
import re
from contract import need

FORBIDDEN=('LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','GLIBC_TUNABLES','MALLOC_ARENA_MAX',
           'CXXFLAGS','CFLAGS','CPPFLAGS','LDFLAGS','ASAN_OPTIONS','UBSAN_OPTIONS')

def require():
    need(os.environ.get('BF_SOCKET_LEASE')=='socket1-cpu3','explicit socket1 lease required')
    need(os.sched_getaffinity(0)=={3},'parent must be pinned to CPU3')
    environment={key:os.environ.get(key)for key in FORBIDDEN}
    need(not any(environment.values()),'compiler/runtime override')
    lock='/tmp/fastest-bf-socket1.lock';evidence={}
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name)!=lock:continue
            text=Path('/proc/self/fdinfo/'+name).read_text()
            need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',text,re.M),'lock not already exclusive')
            fcntl.flock(int(name),fcntl.LOCK_EX|fcntl.LOCK_NB);evidence[name]=text
        except FileNotFoundError:pass
    need(evidence,'matching inherited whole-operation lock required')
    cpu=Path('/sys/devices/system/cpu/cpu3')
    need(int((cpu/'topology/physical_package_id').read_text())==1 and (cpu/'node1').is_dir(),'wrong socket/node')
    return dict(cpu=3,socket=1,node=1,affinity=[3],lock=lock,fd_evidence=evidence,environment=environment,
                child_memory_policy='explicit numactl node1',purpose='correctness only')
