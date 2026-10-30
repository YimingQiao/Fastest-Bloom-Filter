#!/usr/bin/env python3
"""Resume ASan after retaining all successful normal work; collector-only repair."""
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "proof"))
if not __debug__:
    raise SystemExit("Python -O is forbidden before execution")
import argparse
import json
import os
from pathlib import Path
import shlex
import subprocess
from contract import SEMANTICS, audit, need, plan, validate
from lease import require_lease
from repair_guard import HERE, ROOT, RESUME, ORIGINAL, sha, verify, reused_normal
import source_guard as original_guard
from dependencies import collect


def dump(path, obj):
    path.write_text(json.dumps(obj, indent=2) + "\n")


def command(binary, case, lease, mode="--measure"):
    cpus = ",".join(map(str, lease["child_cpus"][:case["requested"]]))
    return ["taskset", "-c", cpus, "numactl", "--physcpubind=" + cpus,
            "--membind=" + str(lease["node"]), str(binary), case["family"], str(case["scenario"]),
            str(case["requested"]), str(case["seed"]), cpus, mode]


def artifact(text, target, test=False):
    found = []
    for line in text.splitlines():
        value = json.loads(line)
        if value.get("reason") == "compiler-artifact" and value.get("target", {}).get("name") == ("fastest_bloom_filter" if test else "policy_confirmation") and value.get("executable"):
            need(value["target"]["kind"] == (["lib"] if test else ["bin"]) and value["profile"]["test"] == test, "Wrong Cargo artifact")
            found.append(Path(value["executable"]))
    need(len(found) == 1 and found[0].is_file() and found[0].is_relative_to(target), "Missing unique structured Cargo binary")
    return found[0]


def fixtures(language):
    # Three representative new-timer cases/family: both metrics and serial
    # fallback, above-batch original workers, and populated insert-only.
    return [case for case in plan.ledger() if case["language"] == language and case["seed"] == plan.SEEDS[0]
            and ((case["scenario"] in (0, 2) and case["requested"] == 4)
                 or (case["scenario"] == 1 and case["requested"] == 8))]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-commit", required=True)
    parser.add_argument("--cpu", type=int, choices=(2, 3), required=True)
    parser.add_argument("--execute-correctness", action="store_true")
    args = parser.parse_args()
    need(args.execute_correctness, "Explicit correctness flag required")
    lease = require_lease(args.cpu)
    sources = verify(args.source_commit)
    output = RESUME / "validation-v2"
    need(not output.exists() and not output.is_symlink(), "Preserve all previous attempts")
    output.mkdir()
    meta = dict(complete=False, formal_performance_run=False, source_commit=args.source_commit,
                source_sha256=sources, lease=lease, commands=[], binaries={}, boundary_tests={}, consumed_inputs={}, records=[])
    prior, reuse = reused_normal(original_guard.verify(ORIGINAL))
    meta["reused_normal"] = dict(source_commit=ORIGINAL, metadata_path=str(HERE / "validation-v1/commands.json"),
        metadata_sha256=sha(HERE / "validation-v1/commands.json"), commands=34)
    meta["records"] = prior["records"]
    meta["binaries"] = prior["binaries"]
    meta["boundary_tests"] = prior["boundary_tests"]
    meta["consumed_inputs"] = {"normal": reuse["consumed_inputs"]}
    dump(output / "commands.json", meta)

    def run(label, argv, extra=None, valid=True, diagnostic=None):
        env = os.environ.copy()
        env.update(CARGO_BUILD_JOBS="1", RUSTFLAGS="", RUSTDOCFLAGS="",
                   ASAN_OPTIONS="detect_leaks=1:halt_on_error=1", UBSAN_OPTIONS="halt_on_error=1:print_stacktrace=1")
        env.update(extra or {})
        result = subprocess.run(list(map(str, argv)), cwd=ROOT, env=env, capture_output=True,
                                pass_fds=tuple(lease["inherited_lock_descriptors"]))
        (output / (label + ".stdout")).write_bytes(result.stdout)
        (output / (label + ".stderr")).write_bytes(result.stderr)
        meta["commands"].append(dict(label=label, command=list(map(str, argv)), env=extra or {},
                                     returncode=result.returncode, expected_success=valid))
        dump(output / "commands.json", meta)
        print(label, result.returncode, flush=True)
        need(result.returncode == 0 if valid else result.returncode != 0 and not result.stdout, "Unexpected command result " + label)
        if diagnostic:
            need(diagnostic in result.stderr.decode(), "Wrong fault diagnostic")
        return result.stdout.decode()

    try:
        run("offline-guards", [sys.executable, "-m", "unittest", "discover", "-s", RESUME, "-p", "test_*.py"])
        run("clang-version", ["clang++", "--version"])
        run("rust-version", ["rustc", "-Vv"])
        run("nightly-version", ["rustc", "+nightly", "-Vv"])
        references = {(row["family"], row["scenario"]): tuple(row[k] for k in SEMANTICS) for row in meta["records"]}
        for backend in ("asan",):
            build = ROOT / "build" / f"native-build-policy-port-v2-cpu{args.cpu}-{backend}"
            target = Path(f"/tmp/fastest-bf-native-build-policy-port-v2-cpu{args.cpu}") / backend
            need(not build.exists() and not build.is_symlink() and not target.exists() and not target.is_symlink(), "Fresh build paths required")
            run(backend + "-cpp-configure", ["cmake", "-S", HERE, "-B", build, "-DCMAKE_CXX_COMPILER=clang++",
                "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", "-DPOLICY_ASAN=" + ("ON" if backend == "asan" else "OFF")])
            run(backend + "-cpp-build", ["cmake", "--build", build, "--parallel", "1"])
            cargo = ["cargo"] + (["+nightly"] if backend == "asan" else [])
            flags = "-C target-cpu=native -C symbol-mangling-version=v0" + (" -Zsanitizer=address" if backend == "asan" else "")
            text = run(backend + "-rust-build", cargo + ["build", "--locked", "--offline", "--release", "--manifest-path", HERE / "rust/Cargo.toml",
                       "--target", "x86_64-unknown-linux-gnu", "--message-format=json"], dict(CARGO_TARGET_DIR=str(target), RUSTFLAGS=flags))
            binaries = dict(cpp=build / "policy_confirmation", rust=artifact(text, target))
            # Compile tests on the primary core; widen only executed test children.
            test_text = run(backend + "-rust-boundary-build", cargo + ["test", "--no-run", "--lib", "--locked", "--offline", "--release",
                "--manifest-path", HERE / "native/after/rust/Cargo.toml", "--target", "x86_64-unknown-linux-gnu",
                "--message-format=json"], dict(CARGO_TARGET_DIR=str(target), RUSTFLAGS=flags))
            tests = dict(cpp=build / "policy_boundaries", rust=artifact(test_text, target, True))
            test_cpus = ",".join(map(str, lease["child_cpus"][:3]))
            prefix = ["taskset", "-c", test_cpus, "numactl", "--physcpubind=" + test_cpus,
                      "--membind=" + str(lease["node"])]
            for language, binary in tests.items():
                meta["boundary_tests"][backend + "/" + language] = dict(path=str(binary), sha256=sha(binary), allowed_cpus=lease["child_cpus"][:3])
                test_args = ["build_policy_tests", "--test-threads=1"] if language == "rust" else []
                result = run(backend + "-" + language + "-native-boundaries", prefix + [binary] + test_args)
                need("2 passed; 0 failed" in result if language == "rust" else "12 incremental cases passed" in result,
                     "Missing complete focused native boundary checks")
            for language, binary in binaries.items():
                meta["binaries"][backend + "/" + language] = dict(path=str(binary), sha256=sha(binary))
                cases = fixtures(language)
                need(len(cases) == 6, "Representative case count changed")
                for i, case in enumerate(cases):
                    raw = run(f"{backend}-{language}-case{i}", command(binary, case, lease))
                    row = validate(json.loads(raw), case, lease["child_cpus"][:case["requested"]])
                    key = (case["family"], case["scenario"])
                    value = tuple(row[k] for k in SEMANTICS)
                    need(key not in references or references[key] == value, "Cross-language/backend semantics changed")
                    references[key] = value
                    meta["records"].append(dict(backend=backend, **row))
                    dump(output / "commands.json", meta)
                run(f"{backend}-{language}-bad-output", command(binary, cases[0], lease, "--check-bad-output"), valid=False,
                    diagnostic="full mixed answers differ")
                if backend == "normal":
                    original = command(binary, cases[0], lease)
                    for i, (index, value) in enumerate(((-6, "Unknown"), (-5, "6"), (-4, "3"), (-3, "42"), (-1, "--unknown"))):
                        invalid = original.copy(); invalid[index] = value
                        run(f"{language}-invalid{i}", invalid, valid=False)
            consumed, rules = collect(build, target, [text, test_text], sources, ROOT)
            for i, rule in enumerate(rules):
                (output / f"{backend}-dependency-{i}.d").write_text(rule.pop("text"))
                rule["archived_path"] = f"{backend}-dependency-{i}.d"
            dump(output / (backend + "-dependency-identities.json"), rules)
            required = [HERE / "cpp/main.cpp", HERE / "rust/src/main.rs", HERE / "rust/src/bindings.rs",
                        HERE / "native/after/tests/test_split64_build_policy.cpp"]
            for label in ("before", "after"):
                required += [HERE / "cpp" / label / name for name in ("parallel_layout_bloom.h", "parallel_split64_range_bloom.h")]
                required += [HERE / "native" / label / "rust/src" / name for name in ("lib.rs", "split64.rs", "split64_range.rs")]
            required += [HERE / "native/after/include/split64_build_policy.h", HERE / "native/after/rust/src/split64_build_policy_tests.rs"]
            need(all(str(path) in consumed for path in required), "Missing before/after native consumption proof")
            meta["consumed_inputs"][backend] = consumed
            (output / (backend + "-compile_commands.json")).write_bytes((build / "compile_commands.json").read_bytes())
            dump(output / "commands.json", meta)
        need(len(meta["records"]) == 24 and len(references) == 6, "Wrong focused harness coverage")
        need(verify(args.source_commit) == sources and require_lease(args.cpu) == lease, "Source/lease changed")
        for item in list(meta["binaries"].values()) + list(meta["boundary_tests"].values()):
            need(sha(item["path"]) == item["sha256"], "Built binary changed")
        for inputs in meta["consumed_inputs"].values():
            for path, digest in inputs.items():
                need(sha(path) == digest, "Actual compiler input changed")
        meta.update(complete=True, paired_records=24, variant_rows=48, semantic_geometries=6,
                    frozen_sources_equal=True, formal_performance_run=False, native_boundary_cases=48, helper_boundary_cases=768)
        dump(output / "commands.json", meta)
        print("PASS24 actual-native paired harness records and48 native boundary cases; formal96-pair confirmation has NOT run", flush=True)
    except BaseException as error:
        meta["failure"] = repr(error); dump(output / "commands.json", meta); raise


if __name__ == "__main__":
    main()
