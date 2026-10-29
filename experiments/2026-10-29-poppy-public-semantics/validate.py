#!/usr/bin/env python3
"""Bounded public semantic fixtures, no calibration or timing."""
import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OLD = HERE.with_name("2026-10-29-poppy-public-geometry")
sys.path.insert(0, str(OLD))
spec = importlib.util.spec_from_file_location("geometry_validate", OLD / "validate.py")
geometry = importlib.util.module_from_spec(spec)
spec.loader.exec_module(geometry)
need, sha, write, lease = geometry.need, geometry.sha, geometry.write, geometry.lease
GEOMETRY_SOURCE = "82636d04e038d53c11cc96e5ce7f82cc7dc1ebb3"


def frozen(commit):
    need(re.fullmatch("[0-9a-f]{40}", commit), "Full source commit required")
    geometry.frozen(GEOMETRY_SOURCE)
    manifest = HERE / "PREPARATION.json"
    info = json.loads(manifest.read_text())
    for name, digest in {**info["files"], "PREPARATION.json": sha(manifest)}.items():
        path = HERE / name
        need(sha(path) == digest, "Changed source: " + name)
        need(
            path.read_bytes()
            == subprocess.check_output(
                ["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT
            ),
            "Uncommitted source: " + name,
        )
    for name, digest in info["geometry_proof_pins"].items():
        need(sha(OLD / name) == digest, "Changed constructor evidence: " + name)
    proof = json.loads((OLD / "GEOMETRY_PROOF.json").read_text())
    need(
        proof["complete"] and proof["constructor_rows"] == 86,
        "Missing constructor proof",
    )
    return info


def check_rows(rows):
    selected = json.loads((OLD / "selection.json").read_text())["rows"]
    need(len(rows) == 87, "Incomplete semantic output")
    for row, item in zip(rows[:-1], selected):
        for key in ("id", "n", "policy", "fpp_bits"):
            need(row[key] == item[key], "Wrong semantic identity")
        need(
            row["owned_bytes"] == item["backing_bytes"]
            and row["serialized_bytes"] == 56 + item["backing_bytes"],
            "Wrong allocation extent",
        )
        need(
            row["fixture_inserts"] == 1031 and row["fixture_queries"] == 8193,
            "Fixture scope changed",
        )
        need(0 < row["inserted_new"] <= 1030, "Duplicate/count mismatch")
        for key in (
            "full_byte_iterator_equal",
            "full_query_equal",
            "duplicate_unchanged",
            "uninitialized_rejected_unchanged",
            "clear_membership_empty",
        ):
            need(row[key] is True, "Incomplete public semantic proof")
        need(
            row["none_space_alias"] == (item["policy"] == "space")
            and row["timings"] is False,
            "Wrong alias/scope",
        )
    need(sum(r["none_space_alias"] for r in rows[:-1]) == 17, "Wrong alias count")
    need(
        rows[-1]
        == dict(
            error_policies=4,
            invalid_fpp_cases=16,
            zero_capacity_cases=4,
            full_capacity_cases=4,
            timings=False,
        ),
        "Incomplete error coverage",
    )


def main():
    need(__debug__, "Python -O forbidden")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    args = parser.parse_args()
    fds = lease(args.cpu)
    source = frozen(args.source_commit)
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
        "GLIBC_TUNABLES",
    ]
    inherited = {key: os.environ.get(key) for key in rejected}
    need(not any(inherited.values()), "Unfrozen compiler/loader flags")
    output = HERE / "validation-v1"
    target_root = ROOT / "build/poppy-public-semantics-v1"
    need(
        not output.exists()
        and not output.is_symlink()
        and not target_root.exists()
        and not target_root.is_symlink(),
        "Preserve prior attempts",
    )
    output.mkdir()
    configs = {}
    cargo_home = Path(os.environ.get("CARGO_HOME", Path.home() / ".cargo"))
    for base in [p / ".cargo" for p in [HERE, *HERE.parents]] + [cargo_home]:
        for name in ("config", "config.toml"):
            path = base / name
            if path.is_file():
                configs[str(path)] = sha(path)
    meta = dict(
        complete=False,
        source_commit=args.source_commit,
        preparation=source,
        cpu=args.cpu,
        inherited_lock_descriptors=fds,
        inherited_environment=inherited,
        cargo_config_hash_inventory=configs,
        commands=[],
        binaries={},
        actual_dep_info_files={},
        throughput_samples=0,
        calibration_samples=0,
    )

    def save():
        write(output / "metadata.json", meta)

    def run(label, argv, env):
        need(lease(args.cpu) == fds, "Lease changed")
        record = dict(
            label=label,
            command=list(map(str, argv)),
            complete=False,
            explicit_environment={
                key: env[key]
                for key in (
                    "CARGO_TARGET_DIR",
                    "CARGO_BUILD_JOBS",
                    "RUSTFLAGS",
                    "ASAN_OPTIONS",
                )
            },
        )
        meta["commands"].append(record)
        save()
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
        save()
        need(result.returncode == 0, "Preserved command failure: " + label)
        record["complete"] = True
        save()
        print(label, "PASS", flush=True)
        return result.stdout.decode()

    save()
    try:
        reference = None
        for backend in ("normal", "asan"):
            target = target_root / backend
            env = os.environ.copy()
            env.update(
                CARGO_TARGET_DIR=str(target),
                CARGO_BUILD_JOBS="1",
                ASAN_OPTIONS="detect_leaks=1:halt_on_error=1",
                RUSTFLAGS="-C target-cpu=native"
                + (" -Zsanitizer=address" if backend == "asan" else ""),
            )
            cargo = ["cargo"] + (["+nightly"] if backend == "asan" else [])
            rustc = ["rustc"] + (["+nightly"] if backend == "asan" else [])
            run(backend + "-version", rustc + ["-Vv"], env)
            run(
                backend + "-metadata",
                cargo + ["metadata", "--locked", "--offline", "--format-version=1"],
                env,
            )
            raw = run(
                backend + "-build",
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
            for line in raw.splitlines():
                item = json.loads(line)
                if (
                    item.get("reason") == "compiler-artifact"
                    and item["target"]["name"] == "poppy-public-semantics"
                    and item.get("executable")
                ):
                    need(
                        item["profile"]["test"] is False
                        and Path(item["manifest_path"]).resolve()
                        == HERE / "Cargo.toml",
                        "Wrong Cargo artifact",
                    )
                    artifacts.append(Path(item["executable"]))
            need(
                len(artifacts) == 1
                and artifacts[0].is_relative_to(target)
                and artifacts[0].is_file(),
                "Missing unique executable",
            )
            binary = artifacts[0]
            meta["binaries"][backend] = dict(path=str(binary), sha256=sha(binary))
            save()
            text = run(backend + "-fixtures", [binary, OLD / "constructors.tsv"], env)
            need(
                not (output / (backend + "-fixtures.stderr")).read_bytes(),
                "Unexpected fixture diagnostics",
            )
            rows = [json.loads(line) for line in text.splitlines()]
            check_rows(rows)
            need(
                reference is None or rows == reference, "Normal/ASan semantic mismatch"
            )
            reference = rows
            depdir = output / (backend + "-dep-info")
            depdir.mkdir()
            deps = {}
            for i, path in enumerate(sorted(target.rglob("*.d"))):
                local = depdir / f"{i:03d}.d"
                local.write_bytes(path.read_bytes())
                deps[str(path)] = dict(
                    artifact=str(local.relative_to(output)), sha256=sha(path)
                )
            need(deps, "Missing actual compiler dep-info")
            meta["actual_dep_info_files"][backend] = deps
            save()
        need(frozen(args.source_commit) == source, "Frozen source changed")
        for item in meta["binaries"].values():
            need(sha(item["path"]) == item["sha256"], "Executed binary changed")
        meta.update(
            complete=True,
            profiles=2,
            constructor_semantic_rows=172,
            none_space_full_alias_comparisons=34,
            full_byte_iterator_comparisons=172,
            query_outputs_per_profile=86 * 8193,
            invalid_fpp_cases=32,
            zero_capacity_cases=8,
            full_capacity_cases=8,
        )
        save()
    except BaseException as error:
        meta.update(complete=False, failure=repr(error))
        save()
        raise


if __name__ == "__main__":
    main()
