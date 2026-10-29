"""Require the runner to hold its actual inherited exclusive socket0 lease."""
import fcntl
import os
import re
from pathlib import Path


def require_lease(cpu, lock_path='/tmp/fastest-bf-socket0.lock'):
    if cpu != 2 or os.environ.get('BF_SOCKET_LEASE') != 'socket0-cpu2':
        raise ValueError('This protocol requires the explicit socket0-cpu2 lease')
    if os.sched_getaffinity(0) != {2}:
        raise ValueError('Pin the whole matrix to CPU2')
    expected = str(Path(lock_path).resolve())
    inherited = []
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/' + name) == expected:
                info = Path('/proc/self/fdinfo/' + name).read_text()
                if not re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s', info, re.M):
                    raise ValueError('Descriptor does not already inherit an exclusive flock')
                fd = int(name)
                # Re-lock the same inherited open-file description. This cannot
                # mistake another process's separate lock for our own lease.
                fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
                inherited.append(fd)
        except FileNotFoundError:
            pass
    if not inherited:
        raise ValueError('Run the complete matrix under the specified flock lease')
    return dict(cpu=2, lease='socket0', lock_path=expected,
                inherited_lock_descriptors=inherited)
