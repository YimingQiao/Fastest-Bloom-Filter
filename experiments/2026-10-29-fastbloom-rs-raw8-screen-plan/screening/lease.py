"""Require an already-held inherited exclusive socket0 lease and exact CPU2."""
import fcntl,os,re
from pathlib import Path
LOCK='/tmp/fastest-bf-socket0.lock'
def require_lease(lock_path=LOCK):
 if os.environ.get('BF_SOCKET_LEASE')!='socket0-cpu2' or os.sched_getaffinity(0)!={2}:raise ValueError('Requires explicit socket0-cpu2 lease and CPU2 affinity')
 expected=str(Path(lock_path).resolve());records=[]
 for name in os.listdir('/proc/self/fd'):
  try:
   if os.readlink('/proc/self/fd/'+name)!=expected:continue
   info=Path('/proc/self/fdinfo/'+name).read_text()
   if not re.search(r'^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s',info,re.M):raise ValueError('Descriptor did not inherit exclusive flock')
   fd=int(name);fcntl.flock(fd,fcntl.LOCK_EX|fcntl.LOCK_NB);records.append(dict(fd=fd,fdinfo=info))
  except FileNotFoundError:pass
 if not records:raise ValueError('No actual inherited exclusive socket0 flock')
 return dict(cpu=2,socket=0,lease='socket0-cpu2',lock_path=expected,inherited_lock_descriptors=[r['fd']for r in records],fdinfo_records=records)
