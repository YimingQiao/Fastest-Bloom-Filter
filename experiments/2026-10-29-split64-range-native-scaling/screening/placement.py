"""Runtime and archived topology/lease checks, without changing host settings."""
import importlib.util
import os
from pathlib import Path
from contract import CPUS,need

_spec=importlib.util.spec_from_file_location('native_preflight_lease',Path(__file__).resolve().parents[1]/'preflight/lease.py')
_lease=importlib.util.module_from_spec(_spec);_spec.loader.exec_module(_lease)
FORBIDDEN=('LD_PRELOAD','LD_LIBRARY_PATH','GLIBC_TUNABLES','MALLOC_CONF','MALLOC_ARENA_MAX','RUSTFLAGS','RUSTDOCFLAGS')

def validate(record):
    need(record['parent_affinity']==[3],'Wrong recorded parent affinity')
    lease=record['lease'];need(lease['cpu']==3 and lease['lease']=='socket1'and lease['lock_path']=='/tmp/fastest-bf-socket1.lock','Wrong socket lease')
    need(lease['inherited_lock_descriptors']and all(isinstance(fd,int)and fd>=0 for fd in lease['inherited_lock_descriptors']),'Missing inherited lock descriptors')
    need(record['lease_mode']=='FLOCK ADVISORY WRITE','Missing exclusive inherited lease evidence')
    env=record['environment'];need(env.get('BF_SOCKET_LEASE')=='socket1-cpu3'and all(not env.get(key)for key in FORBIDDEN),'Unexpected loader/allocator/compiler override')
    topology=record['topology'];need([r['cpu']for r in topology]==CPUS,'Wrong ordered physical CPU budget')
    need(all(r['socket']==1 and r['nodes']==[1]for r in topology),'Wrong socket/NUMA node')
    need(len({(r['socket'],r['core'])for r in topology})==8,'CPU budget shares physical cores')
    return record

def current():
    lease=_lease.require_lease(3);topology=[]
    for cpu in CPUS:
        path=Path('/sys/devices/system/cpu')/f'cpu{cpu}'
        topology.append(dict(cpu=cpu,socket=int((path/'topology/physical_package_id').read_text()),core=int((path/'topology/core_id').read_text()),nodes=sorted(int(p.name[4:])for p in path.glob('node[0-9]*'))))
    return validate(dict(lease=lease,lease_mode='FLOCK ADVISORY WRITE',parent_affinity=sorted(os.sched_getaffinity(0)),topology=topology,environment={key:os.environ.get(key,'')for key in ('BF_SOCKET_LEASE',)+FORBIDDEN}))
