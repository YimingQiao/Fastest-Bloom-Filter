"""Require an actual inherited exclusive lock, environment and exact CPU affinity."""
import fcntl,os
from pathlib import Path

def require_lease(cpu,lock_path=None):
    if cpu not in (2,3):raise ValueError('Only explicitly assigned CPU2/CPU3 leases are supported')
    socket=cpu-2
    expected=str(Path(lock_path or f'/tmp/fastest-bf-socket{socket}.lock').resolve())
    if os.environ.get('BF_SOCKET_LEASE')!=f'socket{socket}-cpu{cpu}':raise ValueError('Missing explicit matching socket lease')
    if os.sched_getaffinity(0)!={cpu}:raise ValueError('Pin the entire job to its declared CPU')
    inherited=[]
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name)==expected:
                fd=int(name)
                fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB)
                inherited.append(fd)
        except FileNotFoundError:pass
    if not inherited:raise ValueError('Actual inherited exclusive flock lease descriptor required')
    return dict(cpu=cpu,lease=f'socket{socket}',lock_path=expected,inherited_lock_descriptors=inherited)
