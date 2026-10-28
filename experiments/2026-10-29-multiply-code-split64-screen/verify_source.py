"""Check pinned copies and exact declared changes without constructing a filter."""
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def verify():
    if not __debug__:
        raise ValueError("Source assertions require normal Python")
    provenance = json.loads((HERE / "provenance.json").read_text())
    changes = json.loads((HERE / "source-deltas.json").read_text())
    for local, record in provenance["copied"].items():
        before = subprocess.check_output(["git", "show", record["commit"] + ":" + record["source"]], cwd=ROOT)
        assert hashlib.sha256(before).hexdigest() == record["sha256"], local
        text = before.decode()
        for change in changes.get(local, []):
            assert text.count(change["old"]) == 1, local
            text = text.replace(change["old"], change["new"], 1)
        assert text.encode() == (HERE / local).read_bytes(), local
    assert set(changes) <= set(provenance["copied"])
    for local in ("compare_benchmark.cpp", "check.cpp", "plan.cpp", "test-fixtures.hpp", "validate_rows.py", "cyclic_split64.h"):
        assert local not in changes, "Retained timer/semantic source changed"
    assert changes["multiply_code_split64.h"] == [dict(old='#include "range_size.hpp"', new='#include "range-layouts/range_size.hpp"')]
    parent = ROOT / "experiments/2026-10-29-exact-budget-range"
    pilot = ROOT / "experiments/2026-10-29-multiply-code-split64/cpp"
    assert (parent / "snapshot/include/base.h").read_bytes() == (pilot / "base.h").read_bytes()
    assert (parent / "range-layouts/range_size.hpp").read_bytes() == (pilot / "range_size.hpp").read_bytes()
    protocol = json.loads((HERE / "protocol.json").read_text())
    assert (protocol["registry"], protocol["planner_geometries"], protocol["rows"], protocol["cases"]) == (76,1016,70,13)
    assert protocol["candidate_bpk"] == [16,24,28,32] and protocol["key_powers"] == [16,25]
    assert (protocol["seed"],protocol["query_power"],protocol["batch"],protocol["query_repeats"],protocol["calibration_power"]) == (42,22,4096,6,24)
    print("Pinned76 source verified: unchanged retained timer/semantic translation units; candidate include-path change only; no filter execution")


if __name__ == "__main__":
    verify()
