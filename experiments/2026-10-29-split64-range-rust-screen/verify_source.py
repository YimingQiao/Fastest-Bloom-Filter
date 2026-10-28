#!/usr/bin/env python3
"""Source-only guards; never compiles or executes the Bloom filter."""
import hashlib
import json
from pathlib import Path
import re
import tomllib

HERE = Path(__file__).resolve().parent


def require(condition, message):
    if not condition:
        raise ValueError(message)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def region(source, start, end):
    return source[source.index(start):source.index(end, source.index(start))]


def main():
    require(__debug__, "Run source guards without Python -O")
    copied = json.loads((HERE / "copy-source.json").read_text())["copied"]
    for name, record in copied.items():
        if not name.startswith("native/") and "/support/" not in name:
            continue
        data = (HERE / name).read_bytes()
        if name == "native/src/lib.rs":
            suffix = b"\nmod range_parallel;\nmod split64_range;\npub use split64_range::Split64RangeBloomFilter;\n"
            require(data.endswith(suffix), "Wrong native exports")
            data = data[:-len(suffix)]
        elif name == "native/Cargo.toml":
            data = data.replace(b"validation = []\n", b"")
            suffix = b'\n[[example]]\nname = "parity"\nrequired-features = ["validation"]\n'
            require(data.endswith(suffix), "Wrong fixture declaration")
            data = data[:-len(suffix)]
        require(sha(data) == record["sha256"], "Changed copied source: " + name)
    for name in ("main.rs", "tests.rs", "sbbf.rs"):
        require(sha((HERE / "source-before" / name).read_bytes()) == copied["benchmark/src/" + name]["sha256"], "Changed frozen source evidence")
    before = (HERE / "source-before/main.rs").read_text()
    after = (HERE / "benchmark/src/main.rs").read_text()
    require(region(before, "// Benchmark buffers", "    let hash_lookup_min") ==
            region(after, "// Benchmark buffers", "    let geometry = geometry::plan"),
            "Changed workload buffers, helpers, build/query timers, phase order or validation")
    # Reporting is the only modification after all timed phases/calibration.
    old_report = region(before, "    let hash_lookup_min", '#[path = "support/filter_selection.rs"]')
    new_report = region(after, "    let hash_lookup_min", '#[path = "support/filter_selection.rs"]')
    new_report = new_report.replace('        ",{},{}",\n        orders', '        ",{}",\n        orders')
    new_report = new_report.replace('            .join(";"),\n        geometry.csv()', '            .join(";")')
    require(new_report == old_report, "Changed original reported timing/phase columns")
    # Every retained adapter hot-method segment is unchanged. Constructors may differ.
    for begin, end in (("impl<const P: bool> Filter", "macro_rules! native_filter"),
                       ("macro_rules! native_filter", "native_filter!(ByteSplitBloomFilter)"),
                       ("impl Filter for Fastbloom017", "struct BloomsdayPinned"),
                       ("impl Filter for BloomsdayPinned", "// Benchmark buffers")):
        a, b = region(before, begin, end), region(after, begin, end)
        # Remove only the constructor function, using brace depth.
        def remove_constructor(text):
            start = text.index("    fn new(")
            opening = text.index("{", start)
            depth = 1
            stop = opening + 1
            while depth:
                depth += (text[stop] == "{") - (text[stop] == "}")
                stop += 1
            return text[:start] + text[stop:]
        require(remove_constructor(a) == remove_constructor(b), "Changed retained hot adapter: " + begin)
    old_sbbf = (HERE / "source-before/sbbf.rs").read_text()
    new_sbbf = (HERE / "benchmark/src/sbbf.rs").read_text()
    require(region(old_sbbf, "impl SbbfSafePinned", "#[cfg(test)]") ==
            region(new_sbbf, "impl SbbfSafePinned", "#[cfg(test)]"), "Changed SBBF public API/allocator body")
    locked = tomllib.loads((HERE / "benchmark/Cargo.lock").read_text())
    require(locked["version"] == 4, "Unexpected lock format")
    for filename in ("Cargo.lock", "Cargo.toml"):
        data = (HERE / "benchmark" / filename).read_bytes()
        data = data.replace(b"fastest-bloom-filter-range-exact-capacity", b"fastest-bloom-filter-visible-single")
        if filename == "Cargo.toml":
            data = data.replace(b'path = "../native"', b'path = "../../../rust"')
        require(sha(data) == copied["benchmark/" + filename]["sha256"], "Changed retained dependency/toolchain manifest")
    dependencies = tomllib.loads((HERE / "benchmark/Cargo.toml").read_text())["dependencies"]
    require(dependencies["fastest-bloom-filter"]["path"] == "../native", "Mutable native dependency")
    require(dependencies["fastbloom"]["version"] == "=0.17.0", "Fastbloom pin changed")
    require(dependencies["bloomsday"]["rev"] == "11f16a91a1c8a20344cd263e908f957dac7cf5d0", "Bloomsday pin changed")
    require(dependencies["sbbf-rs"] == "=0.2.8" and dependencies["sbbf-rs-safe"] == "=0.3.2", "SBBF pin changed")
    protocol = json.loads((HERE / "protocol.json").read_text())
    registry = json.loads((HERE / "registry.json").read_text())
    registered = re.findall(r'"([A-Za-z0-9_]+)"', region(after, "const FILTER_NAMES", "fn main()"))
    require(registered == protocol["filters"] == list(registry), "Registry/source order mismatch")
    require(len(protocol["cases"]) == protocol["expected_cases"] == 18, "Wrong case count")
    require(sum(len(case["filters"]) for case in protocol["cases"]) == protocol["expected_rows"] == 120, "Wrong row count")
    unique = set()
    for case in protocol["cases"]:
        require(case["filters"] == [name for name in registered if case["budget_bpk"] != 24 or registry[name]["capacity_policy"] != "largest_fitting_native_pow2"], "Wrong alias selection")
        key = (case["key_power"], case["budget_bpk"], case["batch"], case["seed"])
        require(key not in unique, "Duplicate case")
        unique.add(key)
    print("PASS source-only: current native snapshot and Range kernels unchanged; seven retained hot APIs and entire timed body unchanged; exact18-case/120-row selection")


if __name__ == "__main__":
    main()
