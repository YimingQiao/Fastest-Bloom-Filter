#!/usr/bin/env python3
"""Only bounded public accuracy-caller checks; no full calibration invocation."""
import argparse
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from contract import HERE, ROOT, GEOMETRY, SEMANTICS, fixtures, validate, need

spec = importlib.util.spec_from_file_location(
    "poppy_semantic_helpers", SEMANTICS / "validate.py"
)
prior = importlib.util.module_from_spec(spec)
spec.loader.exec_module(prior)
sha, save, lease = prior.sha, prior.write, prior.lease
SEMANTIC_SOURCE = "722d91ed1258a4875957c71d867e7c652f122f12"


def frozen(commit):
    need(re.fullmatch("[0-9a-f]{40}", commit), "Full immutable source commit required")
    prior.frozen(SEMANTIC_SOURCE)
    path = HERE / "PREPARATION.json"
    info = json.loads(path.read_text())
    for name, digest in {**info["files"], "PREPARATION.json": sha(path)}.items():
        source = HERE / name
        need(sha(source) == digest, "Changed accuracy source: " + name)
        need(
            source.read_bytes()
            == subprocess.check_output(
                ["git", "show", commit + ":" + str(source.relative_to(ROOT))], cwd=ROOT
            ),
            "Uncommitted accuracy source: " + name,
        )
    for name, item in info["origins"].items():
        source = ROOT / name
        need(sha(source) == item["sha256"], "Changed provenance input: " + name)
        need(
            source.read_bytes()
            == subprocess.check_output(
                ["git", "show", item["commit"] + ":" + name], cwd=ROOT
            ),
            "Unbound provenance input: " + name,
        )
    worker = (HERE / "worker.rs").read_text()
    old_main = (ROOT / info["workload_source"]).read_text()
    old_lib = (ROOT / info["hash_source"]).read_text()
    # Exact helper bodies, not independently invented RNG/hash substitutes.
    helper = old_main[old_main.index("struct SplitMix64") : old_main.index("fn median")]
    need(helper in worker, "Common RNG/shuffle source changed")
    start = old_lib.index("pub fn hash64(")
    finalizer = old_lib[start : old_lib.index("\n}", start) + 2]
    need(finalizer in worker, "Common hash source changed")
    return info


def main():
    need(__debug__, "Python -O forbidden")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    args = parser.parse_args()
    fds = lease(args.cpu)
    sources = frozen(args.source_commit)
    rejected = [
        "RUSTFLAGS",
        "RUSTDOCFLAGS",
        "CARGO_ENCODED_RUSTFLAGS",
        "RUSTC_WRAPPER",
        "RUSTC_WORKSPACE_WRAPPER",
        "CARGO_TARGET_DIR",
        "LD_PRELOAD",
        "LD_LIBRARY_PATH",
        "MALLOC_CONF",
        "MALLOC_ARENA_MAX",
        "GLIBC_TUNABLES",
        "ASAN_OPTIONS",
        "UBSAN_OPTIONS",
    ]
    inherited = {name: os.environ.get(name) for name in rejected}
    need(not any(inherited.values()), "Unfrozen compiler/runtime override")
    output = HERE / "preflight-v1"
    target_root = ROOT / "build/poppy-public-accuracy-v1"
    need(
        not output.exists()
        and not output.is_symlink()
        and not target_root.exists()
        and not target_root.is_symlink(),
        "Preserve previous attempt",
    )
    output.mkdir()
    cargo_home = Path(os.environ.get("CARGO_HOME", Path.home() / ".cargo"))
    configs = {}
    for base in [p / ".cargo" for p in [HERE, *HERE.parents]] + [cargo_home]:
        for name in ("config", "config.toml"):
            path = base / name
            if path.is_file():
                configs[str(path)] = sha(path)
    meta = dict(
        complete=False,
        source_commit=args.source_commit,
        source_manifest=sources,
        cpu=args.cpu,
        inherited_write_descriptors=fds,
        inherited_environment=inherited,
        cargo_config_hash_inventory=configs,
        commands=[],
        binaries={},
        actual_dep_info_files={},
        full_accuracy_run=False,
        timing_samples=0,
    )

    def persist():
        save(output / "metadata.json", meta)

    def run(label, argv, env, success=True):
        need(lease(args.cpu) == fds, "Whole-operation lease drift")
        record = dict(
            label=label,
            command=list(map(str, argv)),
            complete=False,
            expected_success=success,
            explicit_environment={
                k: env[k]
                for k in (
                    "CARGO_TARGET_DIR",
                    "CARGO_BUILD_JOBS",
                    "RUSTFLAGS",
                    "ASAN_OPTIONS",
                )
            },
        )
        meta["commands"].append(record)
        persist()
        result = subprocess.run(
            record["command"],
            cwd=HERE,
            env=env,
            pass_fds=tuple(fds),
            capture_output=True,
        )
        for stream, data in [("stdout", result.stdout), ("stderr", result.stderr)]:
            path = output / (label + "." + stream)
            path.write_bytes(data)
            record[stream] = path.name
            record[stream + "_sha256"] = sha(path)
        record["returncode"] = result.returncode
        persist()
        need(
            (result.returncode == 0) == success,
            "Preserved unexpected command result: " + label,
        )
        if not success:
            need(
                not result.stdout and result.stderr,
                "Invalid CLI emitted a row or no diagnostic",
            )
        record["complete"] = True
        persist()
        print(label, "PASS", flush=True)
        return result.stdout.decode()

    persist()
    try:
        reference = None
        for profile in ("normal", "asan"):
            target = target_root / profile
            env = os.environ.copy()
            env.update(
                CARGO_TARGET_DIR=str(target),
                CARGO_BUILD_JOBS="1",
                ASAN_OPTIONS="detect_leaks=1:halt_on_error=1",
                RUSTFLAGS="-C target-cpu=native"
                + (" -Zsanitizer=address" if profile == "asan" else ""),
            )
            cargo = ["cargo"] + (["+nightly"] if profile == "asan" else [])
            run(
                profile + "-version",
                ["rustc"] + (["+nightly"] if profile == "asan" else []) + ["-Vv"],
                env,
            )
            run(
                profile + "-metadata",
                cargo + ["metadata", "--locked", "--offline", "--format-version=1"],
                env,
            )
            text = run(
                profile + "-build",
                cargo
                + [
                    "build",
                    "--locked",
                    "--offline",
                    "--release",
                    "--target",
                    "x86_64-unknown-linux-gnu",
                    "--message-format=json",
                ],
                env,
            )
            artifacts = []
            for line in text.splitlines():
                item = json.loads(line)
                if (
                    item.get("reason") == "compiler-artifact"
                    and item["target"]["name"] == "poppy-public-accuracy"
                    and item.get("executable")
                ):
                    need(
                        item["profile"]["test"] is False
                        and Path(item["manifest_path"]).resolve()
                        == HERE / "Cargo.toml",
                        "Wrong structured artifact",
                    )
                    artifacts.append(Path(item["executable"]))
            need(
                len(artifacts) == 1
                and artifacts[0].is_file()
                and artifacts[0].is_relative_to(target),
                "Missing unique accuracy worker",
            )
            binary = artifacts[0]
            meta["binaries"][profile] = dict(path=str(binary), sha256=sha(binary))
            persist()
            observed = []
            for index, case in enumerate(fixtures()):
                text = run(
                    profile + "-fixture-" + str(index),
                    [binary, "--check", case["id"]],
                    env,
                )
                need(
                    not (
                        output / (profile + "-fixture-" + str(index) + ".stderr")
                    ).read_bytes(),
                    "Unexpected fixture diagnostic",
                )
                row = json.loads(text)
                validate(row, case, True)
                observed.append(row)
            need(
                reference is None or reference == observed,
                "Normal/ASan public accuracy-caller mismatch",
            )
            reference = observed
            for index, argv in enumerate(
                (
                    [binary],
                    [binary, "--bogus", fixtures()[0]["id"]],
                    [binary, "--check", "missing"],
                    [binary, "--accuracy"],
                )
            ):
                run(profile + "-invalid-" + str(index), argv, env, False)
            depdir = output / (profile + "-dep-info")
            depdir.mkdir()
            deps = {}
            for index, source in enumerate(sorted(target.rglob("*.d"))):
                archived = depdir / f"{index:03d}.d"
                archived.write_bytes(source.read_bytes())
                deps[str(source)] = dict(
                    artifact=str(archived.relative_to(output)), sha256=sha(source)
                )
            need(deps, "Missing actual dep-info text")
            meta["actual_dep_info_files"][profile] = deps
            persist()
        need(
            frozen(args.source_commit) == sources and lease(args.cpu) == fds,
            "Final source/lease drift",
        )
        for item in meta["binaries"].values():
            need(sha(item["path"]) == item["sha256"], "Executed worker drift")
        meta.update(
            complete=True,
            fixture_rows=16,
            invalid_cli_cases=8,
            independent_input_oracle=True,
            public_iterator_query_parity=True,
            full_accuracy_run=False,
        )
        persist()
    except BaseException as error:
        meta.update(complete=False, failure=repr(error))
        persist()
        raise


if __name__ == "__main__":
    main()
