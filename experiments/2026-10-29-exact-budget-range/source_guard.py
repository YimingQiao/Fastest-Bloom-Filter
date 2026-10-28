"""Prove the committed source archive and the inherited measurement lease."""
import fcntl
import hashlib
import json
import os
import re
import subprocess
from pathlib import Path

def sha(data):
    return hashlib.sha256(data).hexdigest()

def verify_commit_inputs(root, here, commit, freeze):
    root, here = Path(root).resolve(), Path(here).resolve()
    if not re.fullmatch(r'[0-9a-f]{40}', commit):
        raise ValueError('An exact lowercase40-character source commit is required')
    resolved = subprocess.check_output(['git','rev-parse','--verify',commit+'^{commit}'],cwd=root,text=True).strip()
    if resolved != commit:
        raise ValueError('Source revision must identify that exact commit')
    prefix = here.relative_to(root).as_posix() + '/'
    mandatory = {prefix + name for name in ('protocol.json','planned-grid.json','registry.json',
        'run_screen.py','source_guard.py','geometry.hpp','compare_benchmark.cpp','CMakeLists.txt')}
    local = {name:digest for name,digest in freeze['source_sha256'].items() if name.startswith(prefix)}
    if not mandatory <= local.keys():
        raise ValueError('Frozen experiment source inventory is incomplete')
    # Freeze and inventory cannot self-hash. Their exact git blobs are checked
    # directly, anchoring the transitive source/binary hashes to the commit.
    for name in ('freeze.json','manifest.json'):
        local[prefix + name] = sha((here / name).read_bytes())
    for name,digest in local.items():
        current = root / name
        if sha(current.read_bytes()) != digest:
            raise ValueError('Frozen local source drift: ' + name)
        blob = subprocess.check_output(['git','show',commit + ':' + name],cwd=root)
        if sha(blob) != digest:
            raise ValueError('Commit does not contain the frozen source blob: ' + name)
    manifest = json.loads((here/'manifest.json').read_text())
    # All inventory entries, including proof/log/provenance artifacts, must be
    # present unchanged in the committed archive. Fetched dependencies live in
    # source_sha256 and are checked by the driver's ordinary freeze verifier.
    for name,digest in manifest['files_sha256'].items():
        current = (here / name).resolve()
        if not current.is_relative_to(here):
            raise ValueError('Inventory path escapes experiment')
        if sha(current.read_bytes()) != digest:
            raise ValueError('Inventory artifact drift: ' + name)
        blob = subprocess.check_output(['git','show',commit + ':' + current.relative_to(root).as_posix()],cwd=root)
        if sha(blob) != digest:
            raise ValueError('Commit inventory artifact mismatch: ' + name)
    return dict(source_commit=commit,local_source_blobs=len(local),inventory_artifacts=len(manifest['files_sha256']),
                freeze_sha256=sha((here/'freeze.json').read_bytes()),manifest_sha256=sha((here/'manifest.json').read_bytes()))

def require_lease(cpu, lease, lock_path='/tmp/fastest-bf-socket0.lock'):
    if cpu != 2 or lease != 'socket0':
        raise ValueError('This protocol requires explicit --lease socket0 --cpu2')
    if os.sched_getaffinity(0) != {cpu}:
        raise ValueError('Pin the entire matrix process to CPU2 with taskset')
    # util-linux flock leaves its locked descriptor inherited by the command.
    # Re-locking that same open-file description preserves the lock; an
    # unrelated process's lock cannot be mistaken for our lease.
    inherited = []
    for name in os.listdir('/proc/self/fd'):
        try:
            if os.readlink('/proc/self/fd/' + name) == str(Path(lock_path).resolve()):
                fd = int(name)
                fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
                inherited.append(fd)
        except FileNotFoundError:
            pass
    if not inherited:
        raise ValueError('Run the whole matrix under the specified flock lease')
    return dict(cpu=cpu,lease=lease,lock_path=lock_path,inherited_lock_descriptors=inherited)
