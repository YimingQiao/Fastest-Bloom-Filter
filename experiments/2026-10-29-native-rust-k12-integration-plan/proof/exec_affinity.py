#!/usr/bin/env python3
"""Verify taskset-expanded actual child mask, then exec without changing it."""
import json,os,sys
from checks import CPUS,need,topology
need(len(sys.argv)>=2 and os.path.isabs(sys.argv[1]),'Absolute executable required')
need(sorted(os.sched_getaffinity(0))==CPUS,'Actual child mask must expose seven physical socket1 CPUs')
topology()
print(json.dumps(dict(pre_exec_affinity=sorted(os.sched_getaffinity(0)),executable=sys.argv[1])),file=sys.stderr,flush=True)
os.execv(sys.argv[1],sys.argv[1:])
