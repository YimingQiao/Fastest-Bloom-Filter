"""Fail before any compiler: new build root and already-held inherited lease."""
import os,re
from pathlib import Path
from contract import need

def require_new_build_root(path):
    path=Path(path)
    need(not path.exists() and not path.is_symlink(),'Build root must not already exist')

def require_inherited_write_lock(cpu,name):
    need((cpu,name)==(2,'socket0'),'This preparation requires explicit CPU2/socket0')
    need(os.sched_getaffinity(0)=={2},'Pin the whole preflight to CPU2')
    expected='/tmp/fastest-bf-socket0.lock'
    descriptors=[]
    for entry in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/'+entry)!=expected:continue
            info=Path('/proc/self/fdinfo/'+entry).read_text()
            need(re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',info,re.M),
                 'Matching descriptor does not already inherit an exclusive flock')
            descriptors.append(int(entry))
        except FileNotFoundError:
            pass
    need(descriptors,'Missing already-held inherited socket0 write lock')
    return sorted(descriptors)
