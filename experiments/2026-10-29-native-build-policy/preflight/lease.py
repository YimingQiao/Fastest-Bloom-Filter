"""Only explicit CPU2/socket0 or CPU3/socket1 whole-operation leases."""
import fcntl
import os
from pathlib import Path
import re
from contract import need

def require_lease(cpu):
    need(cpu in (2,3),'Only reviewed socket0/1 parent CPUs are supported')
    node=cpu-2;name=f'socket{node}-cpu{cpu}';lock=f'/tmp/fastest-bf-socket{node}.lock'
    need(os.environ.get('BF_SOCKET_LEASE')==name and os.sched_getaffinity(0)=={cpu},'Missing exact parent affinity/lease environment')
    inherited=[]
    for entry in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+entry)==lock:
                info=Path('/proc/self/fdinfo/'+entry).read_text()
                need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',info,re.M),'Missing inherited exclusive lock')
                fd=int(entry);fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB);inherited.append(fd)
        except FileNotFoundError:pass
    need(inherited,'The complete preflight must inherit the existing exclusive socket flock')
    children=[cpu,cpu+2,cpu+4];topology=[]
    for child in children:
        path=Path(f'/sys/devices/system/cpu/cpu{child}')
        info=dict(cpu=child,socket=int((path/'topology/physical_package_id').read_text()),core=int((path/'topology/core_id').read_text()),nodes=sorted(int(p.name[4:])for p in path.glob('node[0-9]*')))
        need(info['socket']==node and info['nodes']==[node],'Wrong correctness child topology');topology.append(info)
    need(len({r['core']for r in topology})==3,'Child set must use three distinct physical cores')
    return dict(cpu=cpu,socket=node,node=node,lock_path=lock,inherited_lock_descriptors=inherited,child_cpus=children,topology=topology)
