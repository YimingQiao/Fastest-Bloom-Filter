"""Bind the sealed actual-native proof, both compiled callers, and run scripts."""
import json
import os
import platform
import re
import subprocess
from screen_contract import HERE, PRODUCER, ROOT, need, sha
from lease import require_lease

STAGE = HERE.parent
PROOF = "b08163660bb3f69fade50d535e5906c1cb1d6f04"
AUDIT_COMMIT = "fe7c80762ab2e0e3020b87626b9ab2ad53376cf7"
PROOF_SHA = "151e7d20be847d38f8e2ab0441f835862243d4a3740940d0f154c6603246a63e"
SOURCE = "26232ad9b1412e64346e09f40de15f8ef77c52f7"
ENVIRONMENT = ("LD_PRELOAD", "LD_LIBRARY_PATH", "MALLOC_CONF", "MALLOC_ARENA_MAX", "GLIBC_TUNABLES",
               "RUSTFLAGS", "RUSTDOCFLAGS", "CFLAGS", "CXXFLAGS", "CPPFLAGS", "LDFLAGS",
               "CARGO_ENCODED_RUSTFLAGS", "RUSTC_WRAPPER", "RUSTC_WORKSPACE_WRAPPER", "CC", "CXX")


def exact(commit, path):
    need(path.read_bytes() == subprocess.check_output(
        ["git", "show", commit + ":" + str(path.relative_to(ROOT))], cwd=ROOT), "Committed source/proof drift")


def manifest(directory, name, commit):
    path = directory / name; exact(commit, path)
    result = {str(path.relative_to(ROOT)): sha(path)}
    for relative, entry in json.loads(path.read_text())["files"].items():
        item = directory / relative; exact(commit, item)
        need(sha(item) == entry["sha256"] and item.stat().st_size == entry["bytes"], "Manifest artifact drift")
        result[str(item.relative_to(ROOT))] = entry["sha256"]
    return result


def placement():
    lease = require_lease(2)
    result = dict(lease=lease, affinity=sorted(os.sched_getaffinity(0)), host=platform.uname()._asdict(),
                  environment={key: os.environ.get(key) for key in ENVIRONMENT}, inherited_write_verified=True)
    validate_placement(result)
    return result


def validate_placement(record):
    lease = record["lease"]
    need(record["inherited_write_verified"] is True, "Missing archived exclusive-lock verification")
    need(record["affinity"] == [2] and lease["cpu"] == 2 and lease["socket"] == lease["node"] == 0, "Wrong archived socket/affinity")
    need(lease["lock_path"] == "/tmp/fastest-bf-socket0.lock" and lease["inherited_lock_descriptors"], "Missing recorded inherited lock")
    need(lease["child_cpus"] == list(range(2, 17, 2)), "Wrong ordered eight-core budget")
    need([x["cpu"] for x in lease["topology"]] == lease["child_cpus"] and
         all(x["socket"] == 0 and x["nodes"] == [0] for x in lease["topology"]) and
         len({x["core"] for x in lease["topology"]}) == 8, "Wrong recorded physical topology")
    need(set(record["environment"]) == set(ENVIRONMENT) and not any(record["environment"].values()), "Loader/allocator/compiler environment override")
    need(isinstance(lease["environment"], dict) and not any(lease["environment"].values()), "Archived native lease environment override")


def verify(commit, live=True):
    need(__debug__, "Python -O unsupported")
    need(re.fullmatch("[0-9a-f]{40}", commit) is not None, "Full reviewed source commit required")
    need(sha(STAGE / "COMPLETE_PROOF_ARCHIVE.json") == PROOF_SHA, "Wrong actual-native proof inventory")
    sources = manifest(STAGE, "COMPLETE_PROOF_ARCHIVE.json", PROOF)
    sources.update(manifest(HERE, "PREPARATION.json", commit))
    compiled = json.loads((STAGE / "provenance-v3/combined-proof.json").read_text())
    need(compiled["complete"] is True and compiled["functional_complete"] is True and compiled["provenance_complete"] is True,
         "Incomplete actual-native functional/provenance proof")
    need(compiled["formal_performance_run"] is False and compiled["caller_source_commit"] == SOURCE and
         compiled["final_audit_commit"] == AUDIT_COMMIT, "Wrong compiled source proof")
    need(compiled["native_before_commit"] == "e8b89cd3c7c090287d1d4222db981ec7f8fb86ab" and
         compiled["native_after_commit"] == "2b3469f02c8dafc2219a132c681c14529e79995d", "Wrong actual-native snapshots")
    need(compiled["counts"] == dict(paired_records=24,native_boundary_cases=48,helper_boundary_cases=768,
         invalid_cli=10,output_faults=4,commands_across_two_attempts=58,binaries=8,normal_inputs=469,asan_inputs=470,union_inputs=470),
         "Wrong compiled coverage")
    for relative, digest in compiled["source_sha256"].items():
        item = ROOT / relative; exact(PROOF, item)
        need(sha(item) == digest, "Compiled source closure differs")
        sources[relative] = digest
    binaries = compiled["selected_normal_executables"]
    need(binaries == {key: compiled["all_binaries"]["normal/" + key] for key in ("cpp", "rust")}, "Wrong selected normal binaries")
    review = json.loads((STAGE / "assembly/TIMING_REVIEW.json").read_text())
    need(review["all_candidate_paths_inside_clocks"] is True and review["no_rebuild"] is True,
         "Missing actual native timing-boundary evidence")
    need(review["binary_sha256"] == {language: entry["sha256"] for language,entry in binaries.items()} and
         {language:len(paths) for language,paths in review["candidate_paths"].items()} == {"cpp":4,"rust":4},
         "Timing-boundary review refers to another binary or incomplete paths")
    if live:
        for entry in compiled["all_binaries"].values():
            need(sha(entry["path"]) == entry["sha256"], "Frozen executable changed")
        for path, want in compiled["compiler_consumed_input_sha256"].items():
            need(sha(path) == want, "Consumed compiler input changed")
    return sources, compiled
