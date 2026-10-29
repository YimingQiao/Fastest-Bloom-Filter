"""Bind the completed four-binary preflight and the additive run scripts."""
import json
import os
import platform
import re
from pathlib import Path
from screen_contract import HERE, PRODUCER, ROOT, need, sha
import source_guard
from lease import require_lease

PROOF = "cc2b2e2a3a39f395ece3b8cf308cdca6bda406e2"
SOURCE = "b09b326127792882202f5c3cda8e3d927454aa1e"
PROOF_SHA = "cd8ea11666675162d01878465ec2a741655d6480ece90d472c83393585aa5658"
ENVIRONMENT = ("LD_PRELOAD", "LD_LIBRARY_PATH", "MALLOC_CONF", "MALLOC_ARENA_MAX", "GLIBC_TUNABLES",
               "RUSTFLAGS", "RUSTDOCFLAGS", "CFLAGS", "CXXFLAGS", "LDFLAGS")


def placement():
    lease = require_lease(3)
    result = dict(lease=lease, affinity=sorted(os.sched_getaffinity(0)), host=platform.uname()._asdict(),
                  environment={key: os.environ.get(key) for key in ENVIRONMENT}, inherited_write_verified=True)
    validate_placement(result)
    return result


def validate_placement(record):
    lease = record["lease"]
    need(record["inherited_write_verified"] is True, "Missing archived exclusive-lock verification")
    need(record["affinity"] == [3] and lease["cpu"] == 3 and lease["socket"] == lease["node"] == 1, "Wrong archived socket/affinity")
    need(lease["lock_path"] == "/tmp/fastest-bf-socket1.lock" and lease["inherited_lock_descriptors"], "Missing recorded inherited lock")
    need(lease["child_cpus"] == list(range(3, 18, 2)), "Wrong ordered eight-core budget")
    need([x["cpu"] for x in lease["topology"]] == lease["child_cpus"] and
         all(x["socket"] == 1 and x["nodes"] == [1] for x in lease["topology"]) and
         len({x["core"] for x in lease["topology"]}) == 8, "Wrong recorded physical topology")
    need(set(record["environment"]) == set(ENVIRONMENT) and not any(record["environment"].values()), "Loader/allocator/compiler environment override")


def verify(commit, live=True):
    need(__debug__, "Python -O unsupported")
    need(re.fullmatch("[0-9a-f]{40}", commit) is not None, "Full reviewed source commit required")
    sources = source_guard.verify(SOURCE)
    need(sha(PRODUCER / "PREFLIGHT_ARCHIVE.json") == PROOF_SHA, "Wrong focused proof inventory")
    sources.update(source_guard.manifest(PRODUCER, "PREFLIGHT_ARCHIVE.json", PROOF))
    sources.update(source_guard.manifest(HERE, "PREPARATION.json", commit))
    compiled = json.loads((PRODUCER / "COMPILED_FREEZE.json").read_text())
    need(compiled["complete"] is True and compiled["formal_performance_run"] is False and compiled["source_commit"] == SOURCE, "Wrong compiled source proof")
    need(compiled["source_sha256"] == source_guard.verify(SOURCE), "Compiled source closure differs")
    need(len(compiled["all_binaries"]) == 4 and len(compiled["compiler_consumed_input_sha256"]) == 437, "Wrong compiled coverage")
    binaries = compiled["selected_normal_executables"]
    need(binaries == {key: compiled["all_binaries"]["normal/" + key] for key in ("cpp", "rust")}, "Wrong selected normal binaries")
    note = compiled["cpp_timing_boundary_review"]
    review = json.loads((ROOT / note["path"]).read_text())
    need(sha(ROOT / note["path"]) == note["sha256"] and note["all_four_candidate_paths_inside_clocks"] is True,
         "Missing binary-specific timing-boundary evidence")
    need(review["binary_sha256"] == binaries["cpp"]["sha256"] and len(review["candidate_paths"]) == 4, "Timing-boundary review refers to another binary")
    if live:
        for entry in compiled["all_binaries"].values():
            need(sha(entry["path"]) == entry["sha256"], "Frozen executable changed")
        for path, want in compiled["compiler_consumed_input_sha256"].items():
            need(sha(path) == want, "Consumed compiler input changed")
    return sources, compiled
