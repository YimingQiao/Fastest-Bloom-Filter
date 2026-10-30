"""Source-only and binary guards for the separately versioned Multiply76 preflight."""
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
INITIAL = "aba1dbdaa6154540ced8fe466521625a23f69af8"
PARENT_COMMIT = "33ad882da3f5bff603f4b51559f3cd4833778fee"
PARENT = ROOT / "experiments/2026-10-29-cyclic-split64-screen"
REFERENCE = Path("/tmp/fastest-bf-cyclic-split64-screen/native/benchmark")


def require(value, message):
    if not value:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def blob(commit, path):
    require(bool(re.fullmatch(r"[0-9a-f]{40}", commit)), "Full source commit required")
    path = path.resolve()
    require(path.is_relative_to(ROOT), "Source path escapes repository")
    return subprocess.check_output(["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT)


def check_bytes(paths):
    for name, digest in paths.items():
        require(sha(ROOT / name) == digest, "Source/dependency drift: " + name)


def check_binaries(paths):
    for name, digest in paths.items():
        require(sha(Path(name)) == digest, "Binary drift: " + name)


def initial_snapshot():
    path = HERE / "PREPARATION.json"
    require(path.read_bytes() == blob(INITIAL, path), "Initial proposal manifest changed")
    records = json.loads(path.read_text())["files"]
    require(len(records) == 27, "Wrong original proposal cardinality")
    for name, digest in records.items():
        local = (HERE / name).resolve()
        require(local.is_relative_to(HERE), "Proposal path escapes directory")
        require(sha(local) == digest and hashlib.sha256(blob(INITIAL, local)).hexdigest() == digest, "Initial proposal byte changed: " + name)
    return records


def local_sources():
    return sorted(path for path in HERE.rglob("*") if path.is_file()
                  and not any(part.startswith("validation-") or part in ("__pycache__", "screen") for part in path.relative_to(HERE).parts)
                  and path.name not in ("FREEZE.json", "manifest.json"))


def snapshot(commit):
    require(__debug__, "Run without Python -O")
    initial_snapshot()
    inputs = {}
    for path in local_sources():
        expected = hashlib.sha256(blob(commit, path)).hexdigest()
        require(sha(path) == expected, "Uncommitted preflight source: " + str(path))
        inputs[str(path.relative_to(ROOT))] = expected
    parent_path = PARENT / "FREEZE.json"
    parent_blob = blob(PARENT_COMMIT, parent_path)
    require(parent_path.read_bytes() == parent_blob, "Parent freeze changed")
    parent = json.loads(parent_blob)
    require(len(parent["source_sha256"]) == 214 and len(parent["binary_sha256"]) == 27, "Wrong parent freeze cardinality")
    inputs.update(parent["source_sha256"])
    inputs[str(parent_path.relative_to(ROOT))] = hashlib.sha256(parent_blob).hexdigest()
    provenance = json.loads((HERE / "provenance.json").read_text())
    for record in provenance["copied"].values():
        path = ROOT / record["source"]
        require(hashlib.sha256(blob(record["commit"], path)).hexdigest() == record["sha256"], "Pinned source blob changed")
        require(sha(path) == record["sha256"], "Pinned source worktree changed")
        inputs[record["source"]] = record["sha256"]
    check_bytes(inputs)
    check_binaries(parent["binary_sha256"])
    require(parent["binary_sha256"].get(str(REFERENCE)) == "b77b90d92d5334b3b690d47a2e5d8fa7fcdbd786e5861ffa0fbd3757ea7e8b02", "Wrong retained75 executable")
    return dict(source_commit=commit, initial_commit=INITIAL, parent_commit=PARENT_COMMIT,
                source_sha256=inputs, parent_binary_sha256=parent["binary_sha256"])


def consumed_dependencies(build, inputs):
    """Reject unpinned repository headers; retain system header hashes separately."""
    repo, system = {}, {}
    files = sorted(build.rglob("*.o.d"))
    require(len(files) == 4, "Expected four translation-unit dependency files")
    for depfile in files:
        text = depfile.read_text().replace("\\\n", " ")
        require(":" in text, "Malformed compiler dependency file")
        for raw in shlex.split(text.split(":", 1)[1]):
            path = Path(raw)
            if not path.is_absolute():
                path = build / path
            path = path.resolve()
            require(path.is_file(), "Missing consumed dependency: " + str(path))
            digest = sha(path)
            if path.is_relative_to(ROOT):
                relative = str(path.relative_to(ROOT))
                require(inputs.get(relative) == digest, "Compiler consumed unpinned repository source: " + relative)
                repo[relative] = digest
            else:
                system[str(path)] = digest
    return dict(repository_sha256=repo, system_sha256=system)
