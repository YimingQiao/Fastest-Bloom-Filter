#!/usr/bin/env python3
"""Observe IN_CLOSE_WRITE metadata events on CPU4; preserve bytes, hashes and UTC."""
import ctypes
import datetime
import hashlib
import json
import os
from pathlib import Path
import select
import struct

HERE=Path(__file__).resolve().parent
SOURCE=HERE.parents[1]/'2026-10-29-rust-fastbloom-fixed-probes-screen/screen/metadata.json'
OUT=HERE/'inotify-checkpoints'
OUT.mkdir(exist_ok=False)
libc=ctypes.CDLL(None,use_errno=True)
fd=libc.inotify_init1(os.O_NONBLOCK|os.O_CLOEXEC)
if fd<0:raise OSError(ctypes.get_errno(),'inotify_init1')
wd=libc.inotify_add_watch(fd,os.fsencode(SOURCE.parent),0x8)
if wd<0:raise OSError(ctypes.get_errno(),'inotify_add_watch')
last=None;index=0

def capture(reason):
    global last,index
    raw=SOURCE.read_bytes()
    try:meta=json.loads(raw)
    except json.JSONDecodeError:return False
    digest=hashlib.sha256(raw).hexdigest()
    if digest==last:return False
    last=digest
    cases=meta['cases']
    if not isinstance(cases,list):
        print(json.dumps(dict(reason=reason,observed_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
            producer_final_complete=meta.get('complete'),cases_type=type(cases).__name__,sha256=digest)),flush=True)
        return bool(meta.get('complete'))
    complete=sum(bool(row.get('complete'))for row in cases)
    name=f'{index:03d}-cases{len(cases):02d}-complete{complete:02d}.json';index+=1
    (OUT/name).write_bytes(raw)
    print(json.dumps(dict(reason=reason,observed_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        file=name,sha256=digest,bytes=len(raw),cases=len(cases),complete_cases=complete,
        cpu_affinity=sorted(os.sched_getaffinity(0)))),flush=True)
    return len(cases)==complete==18

try:
    finished=capture('initial snapshot after installing IN_CLOSE_WRITE watch')
    while not finished:
        select.select([fd],[],[])
        data=os.read(fd,65536);offset=0
        while offset<len(data):
            observed_wd,mask,cookie,length=struct.unpack_from('iIII',data,offset);offset+=16
            name=data[offset:offset+length].rstrip(b'\0');offset+=length
            if observed_wd==wd and mask&0x8 and name==b'metadata.json':
                finished=capture('IN_CLOSE_WRITE')or finished
    print('Complete observer; producer source, process, raw outputs and timers were never changed',flush=True)
finally:os.close(fd)
