#!/usr/bin/env python3
"""Source-only preservation checks; never invoke Cargo or a BF executable."""
import hashlib
import json
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PARENT = "experiments/2026-10-29-split64-range-rust-screen"
COMMIT = "2c7b1668880ab5a1e3ea0c73f2034b89da0d8650"
KS = list(range(1, 13))


def need(ok, message):
    if not ok:
        raise ValueError(message)


def blob(name):
    return subprocess.check_output(["git", "show", COMMIT + ":" + PARENT + "/" + name], cwd=ROOT)


def digest(value):
    return hashlib.sha256(value).hexdigest()


def body(source, signature):
    start = source.index(signature)
    first = source.index("{", start)
    depth = 0
    for index in range(first, len(source)):
        depth += (source[index] == "{") - (source[index] == "}")
        if depth == 0:
            return source[first:index + 1]
    raise ValueError("Unclosed function")


def main():
    need(__debug__, "Use Python without -O")
    provenance = json.loads((HERE / "provenance.json").read_text())
    need(provenance["parent_commit"] == COMMIT, "Wrong source parent")
    for name, record in provenance["copied_from_git"].items():
        original = blob(name)
        need(digest(original) == record["sha256"] and record["commit"] == COMMIT, "Wrong original Git byte")
        if name not in provenance["derived_files"]:
            need((HERE / name).read_bytes() == original, "Changed retained support/test/adapter file: " + name)
    old = blob("benchmark/src/main.rs").decode()
    expected = old.replace("// Benchmark buffers use", 'include!("fixed_fastbloom.rs");\n\n// Benchmark buffers use', 1)
    expected = expected.replace('    "Split64RangeBloomFilter",\n];', '    "Split64RangeBloomFilter",\n' +
                                ''.join(f'    "Fastbloom017K{k}",\n' for k in KS) + '];', 1)
    line = '            "Fastbloom017" => run::<Fastbloom017>(name, &inserted, &query, &c),'
    expected = expected.replace(line, line + '\n' + ''.join(
        f'            "Fastbloom017K{k}" => run::<Fastbloom017K{k}>(name, &inserted, &query, &c),\n' for k in KS).rstrip('\n'), 1)
    current = (HERE / "benchmark/src/main.rs").read_text()
    need(current == expected, "Changes beyond additive public adapters/registration")
    region = lambda text: text.split("// Benchmark buffers", 1)[1].split("const FILTER_NAMES", 1)[0]
    need(region(current) == region(old), "Changed complete timed/workload helper region")
    original_adapter = old.split("struct Fastbloom017(", 1)[1].split("struct BloomsdayPinned", 1)[0]
    added = (HERE / "benchmark/src/fixed_fastbloom.rs").read_text()
    for signature in ("fn contains_hash", "fn size_in_bytes", "fn insert_hashes", "fn lookup_hashes"):
        need(body(added, signature) == body(original_adapter, signature), "Changed public hot adapter body: " + signature)
    need(".hashes(K)" in body(added, "fn new") and ".expected_items(" not in body(added, "fn new"), "Wrong fixed public constructor")
    for k in KS:
        need(f"type Fastbloom017K{k} = FastbloomFixed<{k}>;" in added and f"check::<{k}>();" in added,
             "Missing prespecified public K or correctness fixture")
    geometry = (HERE / "benchmark/src/geometry.rs").read_text()
    start = geometry.index('        "Fastbloom017K1" |')
    end = geometry.index('        "BloomsdayPinned" => {', start)
    need(geometry[:start] + geometry[end:] == blob("benchmark/src/geometry.rs").decode(), "Changed old geometry policy")
    for k in KS:
        need(f'"Fastbloom017K{k}" => {k},' in geometry[start:end], "Wrong fixed probe metadata")
    need('g.probe_policy = "public_fixed_hash_count";' in geometry[start:end], "Wrong public policy label")
    old_cargo = blob("benchmark/Cargo.toml").decode()
    expected_cargo = old_cargo.replace("fastest-bloom-filter-range-exact-capacity", "fastest-bloom-filter-fastbloom-fixed-probes").replace(
        'path = "../native"', 'path = "../../2026-10-29-split64-range-rust-screen/native"')
    need((HERE / "benchmark/Cargo.toml").read_text() == expected_cargo, "Unplanned compiler/dependency change")
    lock = blob("benchmark/Cargo.lock").decode().replace('name = "fastest-bloom-filter-range-exact-capacity"',
                                                        'name = "fastest-bloom-filter-fastbloom-fixed-probes"')
    need((HERE / "benchmark/Cargo.lock").read_text() == lock, "Changed dependency lock beyond package rename")
    native = (HERE / "benchmark/../../2026-10-29-split64-range-rust-screen/native").resolve()
    need(native == ROOT / PARENT / "native", "Wrong immutable native path dependency")
    archive = json.loads(blob("ARCHIVE.json"))
    count = 0
    for name, info in archive["files"].items():
        if name.startswith("native/"):
            need(digest((ROOT / PARENT / name).read_bytes()) == info["sha256"], "Changed inherited native source")
            count += 1
    need(count > 0, "No pinned native sources")
    proposal = json.loads((HERE / "proposal.json").read_text())
    registry = json.loads((HERE / "registry.json").read_text())
    names = list(registry)
    need(len(names) == 20 and len(set(names)) == 20, "Wrong registry cardinality")
    need(proposal["fixed_K"] == KS and proposal["registry_count"] == 20, "Wrong fixed public grid")
    need(proposal["parent_source_commit"] == COMMIT, "Wrong proposal ancestry")
    need(proposal["retained_default_K_by_actual_bpk"] == {"16": 11, "24": 17, "32": 22}, "Lost original default policy")
    cases = proposal["cases"]
    need([(case["key_power"], case["budget_bpk"]) for case in cases] ==
         [(n, cap) for n in [16, 25] for cap in [16, 24, 32]], "Wrong accuracy grid")
    row_count = sum(len(case["filters"]) for case in cases)
    fixed = {f"Fastbloom017K{k}" for k in KS}
    for case in cases:
        need(len(set(case["filters"])) == len(case["filters"]) and set(case["filters"]) <= set(names), "Bad selected API")
        need(fixed <= set(case["filters"]), "A fixed K disappeared before accuracy")
        need(set(case["filters"]) == set(names) -
             ({"FastPatternBF", "ByteSplitBloomFilter", "FourSectorBloomFilter", "Split64BloomFilter"}
              if case["budget_bpk"] == 24 else set()), "Wrong retained alias removal")
    need(row_count == proposal["expected_api_geometry_rows"] == 112, "Wrong proposed row count")
    need(proposal["new_fixed_K_rows"] == 72 and proposal["retained_api_geometry_rows"] == 40, "Lost original/new geometry split")
    need(not proposal["calibration_pooling"] and not proposal["build_authorization"] and
         not proposal["measurement_authorization"], "Source-only proposal authorization changed")
    print(f"PASS source-only: old8 public adapters and full timed helpers retained;12 fixed public K controls;20 registry;{count} immutable native files; dependency/compiler pins unchanged")


if __name__ == "__main__":
    main()
