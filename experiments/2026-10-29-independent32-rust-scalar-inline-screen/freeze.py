"""Freeze the actual thirteen-way preflight and inherited dependency inputs."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
FROZEN = HERE / "FREEZE.json"


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify(frozen, dependencies=True):
    for name, expected in frozen["source_sha256"].items():
        if sha(REPO / name) != expected:
            raise ValueError("Changed input: " + name)
    for binary in frozen["binaries"]:
        if sha(Path(binary["path"])) != binary["sha256"]:
            raise ValueError("Changed binary: " + binary["path"])
    for dependency in frozen["external_dependencies"] if dependencies else []:
        for name, expected in dependency["sha256"].items():
            if sha(Path(dependency["directory"]) / name) != expected:
                raise ValueError("Changed dependency: " + dependency["name"] + "/" + name)


def main():
    if not __debug__:
        raise ValueError("Run without Python -O")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verify", action="store_true")
    args = parser.parse_args()
    if args.verify:
        frozen = json.loads(FROZEN.read_text())
        verify(frozen)
        print("All frozen sources, dependencies and executables match")
        return
    subprocess.run(["python3", str(HERE / "verify_source.py")], cwd=REPO, check=True)
    checks = json.loads((HERE / "validation-v2/commands.json").read_text())
    assert checks["complete"] and checks["source_after_equal"]
    source = {}
    for name, expected in checks["inputs_sha256"].items():
        assert sha(REPO / name) == expected, name
        source[name] = expected
    parent_path = HERE.parent / "2026-10-29-independent32-rust-singleton-screen/validation/freeze.json"
    parent = json.loads(parent_path.read_text())
    # The retained controls resolve to these exact crates/dependencies. Verify
    # the complete prior input archive, then pin it alongside our local inputs.
    verify(parent)
    source.update(parent["source_sha256"])
    source[str(parent_path.relative_to(REPO))] = sha(parent_path)
    for path in HERE.rglob("*"):
        if path.is_file() and path not in (FROZEN, HERE / "manifest.json") and not set(path.relative_to(HERE).parts) & {"__pycache__", "target", "screen"}:
            source[str(path.relative_to(REPO))] = sha(path)
    protocol = json.loads((HERE / "protocol.json").read_text())
    binaries = [dict(role="thirteen-way V2 screen", path=protocol["binary"], sha256=protocol["binary_sha256"]),
                dict(role="twelve-way reference", path=protocol["reference_binary"], sha256=protocol["reference_binary_sha256"])]
    frozen = dict(source_parent_commit=subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=REPO, text=True).strip(), source_sha256=dict(sorted(source.items())), external_dependencies=parent["external_dependencies"], binaries=binaries,
                  rustc=subprocess.check_output(["rustc", "-Vv"], text=True), compiler_flags=protocol["compiler_flags"], performance_run=False, production_changed=False)
    verify(frozen)
    FROZEN.write_text(json.dumps(frozen, indent=2) + "\n")
    files = {str(path.relative_to(HERE)): sha(path) for path in sorted(HERE.rglob("*")) if path.is_file() and path != HERE / "manifest.json" and not set(path.relative_to(HERE).parts) & {"__pycache__", "target", "screen"}}
    (HERE / "manifest.json").write_text(json.dumps(dict(scope="Frozen preflight;208-row performance not run", files=files), indent=2) + "\n")
    print("Frozen", len(source), "inputs,", len(frozen["external_dependencies"]), "dependency sets,", len(binaries), "binaries and", len(files), "local artifacts")


if __name__ == "__main__":
    main()
