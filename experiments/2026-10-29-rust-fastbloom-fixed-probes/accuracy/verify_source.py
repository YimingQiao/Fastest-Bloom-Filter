#!/usr/bin/env python3
"""Check the additive accuracy executable without invoking a compiler/filter."""
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
STAGE = HERE.parent
ROOT = STAGE.parents[1]
INITIAL = "bbc3474cdd15b2e3301384dff4afdc12505cbfe9"
PARENT = "2c7b1668880ab5a1e3ea0c73f2034b89da0d8650"


def require(ok, message):
    if not ok:
        raise ValueError(message)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    require(__debug__, "Use Python without -O")
    initial = json.loads((STAGE / "PREPARATION.json").read_text())["files"]
    initial["PREPARATION.json"] = {"sha256": sha(STAGE / "PREPARATION.json")}
    for name, record in initial.items():
        path = STAGE / name
        require(sha(path) == record["sha256"], "Changed initial source: " + name)
        blob = subprocess.check_output(["git", "show", INITIAL + ":" + str(path.relative_to(ROOT))], cwd=ROOT)
        require(hashlib.sha256(blob).hexdigest() == record["sha256"], "Changed original commit byte: " + name)
    source = (STAGE / "benchmark/src/main.rs").read_text()
    source = source.replace('mod geometry;', '#[path = "../../benchmark/src/geometry.rs"]\nmod geometry;', 1)
    source = source.replace('mod sbbf;', '#[path = "../../benchmark/src/sbbf.rs"]\nmod sbbf;', 1)
    source = source.replace('include!("fixed_fastbloom.rs");', 'include!("../../benchmark/src/fixed_fastbloom.rs");', 1)
    source = source.replace('#[path = "support/filter_selection.rs"]', '#[path = "../../benchmark/src/support/filter_selection.rs"]', 1)
    source = source.replace('#[path = "support/query_validation.rs"]', '#[path = "../../benchmark/src/support/query_validation.rs"]', 1)
    source = source.replace('fn main() {', 'fn retained_timing_main_never_called() {', 1)
    source = source.replace('#[cfg(test)]\nmod tests;', '#[cfg(test)]\n#[path = "../../benchmark/src/tests.rs"]\nmod tests;', 1)
    source = source.replace('#[cfg(test)]\nmod exact_tests;', '#[cfg(test)]\n#[path = "../../benchmark/src/exact_tests.rs"]\nmod exact_tests;', 1)
    source = '#![allow(dead_code)]\n// Exact retained implementation plus path relocation and an unused renamed timing entry.\n' + source + '\ninclude!("driver.rs");\n'
    require((HERE / "src/main.rs").read_text() == source, "Unplanned retained adapter/helper change")
    for name in ["Cargo.toml", "Cargo.lock"]:
        expected = (STAGE / "benchmark" / name).read_text().replace(
            "fastest-bloom-filter-fastbloom-fixed-probes", "fastest-bloom-filter-fastbloom-fixed-probes-accuracy")
        if name == "Cargo.toml":
            expected = expected.replace('name = "compare_benchmark"', 'name = "accuracy"')
        require((HERE / name).read_text() == expected, "Changed dependency or compiler setting")
    driver = (HERE / "src/driver.rs").read_text()
    for forbidden in ["Instant", ".elapsed(", "retained_timing_main_never_called", "run::<", "unsafe"]:
        require(forbidden not in driver, "Unexpected timed/private/unsafe path in accuracy entry")
    measure = driver.split("fn accuracy_measure<", 1)[1].split("fn accuracy_emit<", 1)[0]
    require(measure.count("F::new(") == 1 and measure.count("bf.insert_hashes(") == 1,
            "Accuracy must construct and insert one bitmap exactly once")
    for k in range(1, 13):
        require(f'"Fastbloom017K{k}" => accuracy_emit::<Fastbloom017K{k}>' in driver and
                f"formal::<{k}>();" in driver, "Missing fixed-K public dispatch or formal allocation audit")
    guard_path = "experiments/2026-10-29-split64-range-rust-screen/screening/source_guard.py"
    require((HERE / "source_guard.py").read_bytes() == subprocess.check_output(
        ["git", "show", PARENT + ":" + guard_path], cwd=ROOT), "Lease guard changed from reviewed parent")
    print("PASS additive source: initial25 immutable; public adapters/helpers exact; one-build untimed entry; all12 formal allocations; inherited exclusive lease guard")


if __name__ == "__main__":
    main()
