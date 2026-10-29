"""Exclusive CPU2/socket0 lease with explicit child NUMA0 binding."""
import fcntl,os,re
from pathlib import Path
from plan import need
FORBIDDEN=('LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','GLIBC_TUNABLES','MALLOC_ARENA_MAX','RUSTFLAGS','CARGO_ENCODED_RUSTFLAGS','RUSTC_WRAPPER','RUSTC_WORKSPACE_WRAPPER','ASAN_OPTIONS','UBSAN_OPTIONS')
DESCRIPTION='Parent CPU2; each measured child CPU2 with explicit NUMA0 memory binding'
def validate(value):
    need(value['affinity']==[2]and value['cpu']==2 and value['socket']==0 and value['node']==0,'Wrong archived topology')
    need(type(value['core'])is int and value['core']>=0,'Missing physical core')
    need(value['lock_path']=='/tmp/fastest-bf-socket0.lock'and value['memory_policy']==DESCRIPTION,'Wrong lock or memory policy')
    fds=value['inherited_lock_descriptors'];need(fds and len(fds)==len(set(fds))and all(type(fd)is int and fd>=0 for fd in fds),'Missing inherited lock')
    need(set(value['lock_evidence'])==set(map(str,fds)),'Missing actual exclusive evidence')
    for evidence in value['lock_evidence'].values():need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',evidence,re.M),'Non-exclusive archived lock')
    need(set(value['environment'])==set(FORBIDDEN)and not any(value['environment'].values()),'Runtime environment override')
    return value
def require():
    need(os.environ.get('BF_SOCKET_LEASE')=='socket0-cpu2'and os.sched_getaffinity(0)=={2},'Explicit pinned socket0 lease required')
    lock='/tmp/fastest-bf-socket0.lock';evidence={};fds=[]
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name)!=lock:continue
            text=Path('/proc/self/fdinfo/'+name).read_text();need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',text,re.M),'Lock not already held exclusively')
            fd=int(name);fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB);fds.append(fd);evidence[name]=text
        except FileNotFoundError:pass
    cpu=Path('/sys/devices/system/cpu/cpu2');nodes=sorted(int(p.name[4:])for p in cpu.glob('node[0-9]*'));need(nodes==[0],'Wrong CPU NUMA node')
    return validate(dict(cpu=2,socket=int((cpu/'topology/physical_package_id').read_text()),node=nodes[0],core=int((cpu/'topology/core_id').read_text()),
        affinity=[2],lock_path=lock,inherited_lock_descriptors=fds,lock_evidence=evidence,environment={k:os.environ.get(k)for k in FORBIDDEN},memory_policy=DESCRIPTION))
