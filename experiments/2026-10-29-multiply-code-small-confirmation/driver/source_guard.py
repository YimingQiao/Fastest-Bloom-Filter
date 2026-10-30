"""Immutable source ancestry and an actual inherited whole-matrix socket lock."""
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
INITIAL = "77fd38ef640caa6dbb257338896057a20e00de37"
COMPILED = "9e4362f1068d37d134ef8447a44146b52c1edc9f"
EVIDENCE = "0c8088f6316aa5933625fe278d7c21030896ed75"
PARENT = ROOT / "experiments/2026-10-29-multiply-code-split64-screen"


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_blob(commit, path):
    require(bool(re.fullmatch(r"[0-9a-f]{40}", commit)), "Full immutable commit required")
    path = path.resolve()
    require(path.is_relative_to(ROOT), "Git path escapes repository")
    return subprocess.check_output(["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT)


def initial():
    preparation = STAGE / "PREPARATION.json"
    require(preparation.read_bytes() == git_blob(INITIAL, preparation), "Changed initial preparation")
    paths = json.loads(preparation.read_text())["files"]
    require(len(paths) == 6, "Expected six initial inputs plus their preparation manifest")
    result = dict(paths, **{"PREPARATION.json": sha(preparation)})
    for name, digest in result.items():
        path = (STAGE / name).resolve()
        require(path.is_relative_to(STAGE), "Initial path escape")
        require(sha(path) == digest and hashlib.sha256(git_blob(INITIAL, path)).hexdigest() == digest,
                "Changed initial committed input: " + name)
    return result


def ancestry():
    """Read parent descriptors only after checking their immutable Git bytes."""
    initial()
    inputs = json.loads((STAGE / "inputs.json").read_text())
    for name, digest in inputs.items():
        path = (ROOT / name).resolve()
        require(path.is_relative_to(ROOT), "Input path escape")
        # The initial proposal fixed these hashes before the completed70-row
        # archive was committed. Its later immutable evidence commit seals them.
        require(sha(path) == digest and hashlib.sha256(git_blob(EVIDENCE, path)).hexdigest() == digest,
                "Changed initial external input: " + name)
    for name in ("manifest.json", "FREEZE.json"):
        path = PARENT / name
        require(path.read_bytes() == git_blob(COMPILED, path), "Changed compiled parent anchor: " + name)
    archive = json.loads((PARENT / "manifest.json").read_text())["files"]
    for name, digest in archive.items():
        path = (PARENT / name).resolve()
        require(path.is_relative_to(PARENT), "Parent archive path escape")
        require(sha(path) == digest and hashlib.sha256(git_blob(COMPILED, path)).hexdigest() == digest,
                "Changed compiled parent archive: " + name)
    frozen = json.loads((PARENT / "FREEZE.json").read_text())
    require(len(frozen["source_sha256"]) == 321 and len(frozen["binary_sha256"]) == 39,
            "Wrong consumed parent source/binary cardinality")
    source = dict(frozen["source_sha256"])
    source.update(inputs)
    context = json.loads((HERE / "policy-context.json").read_text())
    for name, digest in context["files"].items():
        path = ROOT / name
        require(sha(path) == digest and hashlib.sha256(git_blob(context["evidence_commit"], path)).hexdigest() == digest,
                "Changed separately committed Four precision context: " + name)
        source[name] = digest
    for name in ("manifest.json", "FREEZE.json"):
        path = PARENT / name
        source[str(path.relative_to(ROOT))] = sha(path)
    for name, digest in archive.items():
        source[str((PARENT / name).relative_to(ROOT))] = digest
    for name, digest in source.items():
        require(sha(ROOT / name) == digest, "Changed consumed source/dependency: " + name)
    for name, digest in frozen["binary_sha256"].items():
        require(sha(Path(name)) == digest, "Changed retained executable: " + name)
    return source, frozen["binary_sha256"]


def verify(commit):
    require(__debug__, "Do not use Python -O")
    source, binaries = ancestry()
    frozen = json.loads((HERE / "FREEZE.json").read_text())
    require(frozen["initial_commit"] == INITIAL and frozen["compiled_commit"] == COMPILED
            and frozen["evidence_commit"] == EVIDENCE,
            "Wrong confirmation ancestry")
    require(frozen["source_sha256"] == source and frozen["binary_sha256"] == binaries,
            "Changed source/binary closure")
    paths = dict(frozen["local_sha256"])
    paths["driver/FREEZE.json"] = sha(HERE / "FREEZE.json")
    manifest_path = HERE / "manifest.json"
    require(json.loads(manifest_path.read_text())["files"] == paths, "Local archive manifest differs from freeze")
    require(manifest_path.read_bytes() == git_blob(commit, manifest_path), "Uncommitted archive manifest")
    for name, digest in paths.items():
        path = (STAGE / name).resolve()
        require(path.is_relative_to(STAGE), "Local freeze path escape")
        require(sha(path) == digest and hashlib.sha256(git_blob(commit, path)).hexdigest() == digest,
                "Uncommitted or changed confirmation input: " + name)
    return dict(source_commit=commit, initial_commit=INITIAL, compiled_commit=COMPILED, evidence_commit=EVIDENCE,
                freeze_sha256=sha(HERE / "FREEZE.json"), manifest_sha256=sha(manifest_path), source_files=len(source),
                retained_binaries=len(binaries), local_files=len(paths))


def require_lease(cpu, lock_path=None):
    require(cpu in (2, 3), "Only explicitly assigned CPU2/CPU3 leases are supported")
    socket = cpu - 2
    expected = str(Path(lock_path or f"/tmp/fastest-bf-socket{socket}.lock").resolve())
    require(os.environ.get("BF_SOCKET_LEASE") == f"socket{socket}-cpu{cpu}", "Wrong socket lease environment")
    require(os.sched_getaffinity(0) == {cpu}, "Whole runner must have exact assigned CPU affinity")
    descriptors = []
    for name in os.listdir("/proc/self/fd"):
        try:
            if os.readlink("/proc/self/fd/" + name) != expected:
                continue
            # A matching open descriptor alone is insufficient: the inherited
            # open-file description must already carry an exclusive flock.
            info = Path("/proc/self/fdinfo/" + name).read_text()
            require(re.search(r"^lock:\s+\d+:\s+FLOCK\s+ADVISORY\s+WRITE\s", info, re.M),
                    "Matching descriptor does not inherit an exclusive flock")
            fd = int(name)
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
            descriptors.append(fd)
        except FileNotFoundError:
            pass
    require(descriptors, "Actual inherited exclusive flock descriptor required")
    return dict(cpu=cpu, socket=socket, lock_path=expected, inherited_lock_descriptors=descriptors,
                affinity=[cpu], numa_policy="CPU affinity only; no explicit NUMA memory binding")
