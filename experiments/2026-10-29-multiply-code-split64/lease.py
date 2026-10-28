"""Verify an actual inherited exclusive socket lock and matching CPU lease."""
import fcntl,os
from pathlib import Path

def require_lease(cpu):
    if cpu not in (2,3):raise ValueError('CPU2 orCPU3 explicit lease required')
    socket=cpu-2;lock=f'/tmp/fastest-bf-socket{socket}.lock'
    if os.environ.get('BF_SOCKET_LEASE')!=f'socket{socket}-cpu{cpu}' or os.sched_getaffinity(0)!={cpu}:raise ValueError('Wrong explicit CPU/socket lease')
    descriptors=[]
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+name)==lock:
                fd=int(name);fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB);descriptors.append(fd)
        except FileNotFoundError:pass
    if not descriptors:raise ValueError('Actual inherited exclusive flock descriptor required')
    return dict(cpu=cpu,socket=socket,lock_path=lock,inherited_lock_descriptors=descriptors)
