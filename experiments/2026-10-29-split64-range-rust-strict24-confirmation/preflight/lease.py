"""Actual inherited exclusive socket lease for short correctness-only work."""
import fcntl
import os
from pathlib import Path
import re

def require_lease(cpu):
    if cpu not in (2,3):raise ValueError('Only the explicitly granted CPU2/CPU3 socket lease is supported')
    socket=cpu-2;label=f'socket{socket}-cpu{cpu}';path=f'/tmp/fastest-bf-socket{socket}.lock'
    if os.environ.get('BF_SOCKET_LEASE')!=label or os.sched_getaffinity(0)!={cpu}:raise ValueError('Wrong granted lease/affinity')
    descriptors=[]
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name)!=path:continue
            text=Path('/proc/self/fdinfo/'+name).read_text()
            if not re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',text,re.M):raise ValueError('Descriptor is not an inherited exclusive flock')
            fcntl.flock(int(name),fcntl.LOCK_EX|fcntl.LOCK_NB);descriptors.append(int(name))
        except FileNotFoundError:pass
    if not descriptors:raise ValueError('No actual inherited socket lock')
    return dict(cpu=cpu,socket=socket,lock_path=path,inherited_lock_descriptors=descriptors)
