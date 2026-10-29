"""Explicit inherited whole-socket lease, with actual physical core evidence."""
import fcntl
import os
from pathlib import Path
import re
from contract import need


def require_lease(cpu):
    need(cpu in (2, 3), "Only reviewed primary CPU2/3 are supported")
    node = cpu - 2
    lock = f"/tmp/fastest-bf-socket{node}.lock"
    need(os.environ.get("BF_SOCKET_LEASE") == f"socket{node}-cpu{cpu}", "Wrong lease environment")
    need(os.sched_getaffinity(0) == {cpu}, "Parent must remain pinned to the primary CPU")
    forbidden = ("LD_PRELOAD", "LD_LIBRARY_PATH", "MALLOC_CONF", "GLIBC_TUNABLES", "MALLOC_ARENA_MAX",
                 "CFLAGS", "CXXFLAGS", "CPPFLAGS", "LDFLAGS", "CARGO_ENCODED_RUSTFLAGS",
                 "RUSTC_WRAPPER", "RUSTC_WORKSPACE_WRAPPER", "CC", "CXX")
    need(not any(os.environ.get(name) for name in forbidden), "Unrecorded compiler/loader/allocator override")
    descriptors = []
    for entry in os.listdir("/proc/self/fd"):
        try:
            if os.readlink("/proc/self/fd/" + entry) == lock:
                text = Path("/proc/self/fdinfo/" + entry).read_text()
                need(re.search(r"^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s", text, re.M), "Inherited socket lock is not exclusive")
                fd = int(entry)
                fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
                descriptors.append(fd)
        except FileNotFoundError:
            pass
    need(descriptors, "Missing inherited whole-operation socket lock")
    cpus = [cpu + 2 * i for i in range(8)]
    topology = []
    for child in cpus:
        root = Path(f"/sys/devices/system/cpu/cpu{child}")
        row = dict(cpu=child, socket=int((root / "topology/physical_package_id").read_text()),
                   core=int((root / "topology/core_id").read_text()),
                   nodes=sorted(int(p.name[4:]) for p in root.glob("node[0-9]*")))
        need(row["socket"] == node and row["nodes"] == [node], "Wrong child topology")
        topology.append(row)
    need(len({row["core"] for row in topology}) == 8, "Eight physical cores required")
    return dict(cpu=cpu, socket=node, node=node, lock_path=lock,
                inherited_lock_descriptors=descriptors, child_cpus=cpus, topology=topology,
                environment={name: os.environ.get(name) for name in forbidden})
