"""Require the parent-granted exclusive socket lease before any compiler/BF."""
import fcntl
import os
from pathlib import Path
import re
from contract import need

FORBIDDEN = ('LD_PRELOAD','LD_LIBRARY_PATH','MALLOC_CONF','GLIBC_TUNABLES','MALLOC_ARENA_MAX',
             'CFLAGS','CXXFLAGS','CPPFLAGS','LDFLAGS','CC','CXX','CPATH','CPLUS_INCLUDE_PATH',
             'LIBRARY_PATH','ASAN_OPTIONS','UBSAN_OPTIONS')

def require(cpu):
    need(cpu in (2,3), 'Only explicitly leased CPU2/3 supported')
    node = cpu - 2
    lock = f'/tmp/fastest-bf-socket{node}.lock'
    need(os.environ.get('BF_SOCKET_LEASE') == f'socket{node}-cpu{cpu}', 'Wrong lease environment')
    need(os.sched_getaffinity(0) == {cpu}, 'Parent must be pinned to the leased CPU')
    need(not any(os.environ.get(name) for name in FORBIDDEN), 'Compiler/allocator/environment override')
    descriptors = []
    for entry in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/' + entry) != lock: continue
            text = Path('/proc/self/fdinfo/' + entry).read_text()
            need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s', text, re.M), 'Socket lock is not exclusive')
            fd = int(entry); fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB); descriptors.append(fd)
        except FileNotFoundError:
            pass
    need(descriptors, 'Missing inherited whole-operation flock')
    topology = Path(f'/sys/devices/system/cpu/cpu{cpu}')
    package = int((topology / 'topology/physical_package_id').read_text())
    nodes = sorted(int(p.name[4:]) for p in topology.glob('node[0-9]*'))
    need(package == node and nodes == [node], 'Wrong CPU/socket/NUMA topology')
    return dict(cpu=cpu, socket=node, node=node, core=int((topology/'topology/core_id').read_text()),
                affinity=[cpu], lock_path=lock, inherited_lock_descriptors=descriptors,
                environment={name:os.environ.get(name) for name in FORBIDDEN},
                memory_policy='No explicit NUMA binding in this correctness-only preflight')
