"""Read-only snapshot checks; never compiles or runs the benchmark."""
import hashlib
import json
from pathlib import Path
import tomllib

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def main():
    origin = json.loads((HERE / "copy-source.json").read_text())
    for local, record in origin["copied"].items():
        if local not in origin["adapted"]:
            # The provenance records the source at copy time. Later production
            # edits must not invalidate or alter these exact local snapshots.
            assert hashlib.sha256((HERE / local).read_bytes()).hexdigest() == record["sha256"], local
    main = (HERE / "benchmark/src/main.rs").read_text()
    for addition in (
        "use independent32_native::Independent32BloomFilter;\n",
        "native_filter!(Independent32BloomFilter);\n",
        '    "Independent32BloomFilter",\n',
        '            "Independent32BloomFilter" => run::<Independent32BloomFilter>(name, &inserted, &query, &c),\n',
    ):
        assert main.count(addition) == 1
        main = main.replace(addition, "")
    assert hashlib.sha256(main.encode()).hexdigest() == origin["copied"]["benchmark/src/main.rs"]["sha256"]
    test = (HERE / "benchmark/src/tests.rs").read_text().replace("all_eleven_public_apis", "all_ten_public_apis")
    test = test.replace("    public_api_parity::<Independent32BloomFilter>();\n", "")
    assert hashlib.sha256(test.encode()).hexdigest() == origin["copied"]["benchmark/src/tests.rs"]["sha256"]
    cargo = tomllib.loads((HERE / "benchmark/Cargo.toml").read_text())
    assert cargo["dependencies"]["fastest-bloom-filter"]["path"] == "../original-native"
    assert cargo["dependencies"]["leaf_inline_native"]["path"] == "../leaf-native"
    assert cargo["dependencies"]["independent32_native"]["path"] == "../../2026-10-29-independent32-native-rust/native"
    original_lock = tomllib.loads((ROOT / origin["copied"]["benchmark/Cargo.lock"]["source"]).read_text())
    actual_lock = tomllib.loads((HERE / "benchmark/Cargo.lock").read_text())
    external = lambda lock: {(p["name"], p["version"]): p for p in lock["package"] if "source" in p}
    assert external(actual_lock) == external(original_lock), "external dependency versions/checksums changed"
    protocol = json.loads((HERE / "protocol.json").read_text())
    registry = json.loads((HERE / "registry.json").read_text())
    assert len(registry) == 11 and set(protocol["filters"]) == set(registry)
    assert protocol["rows"] == 132 and protocol["workloads"] == 12
    assert protocol["batches"] == [1, 31, 4096]
    if protocol["binary_sha256"] is not None:
        assert hashlib.sha256(Path(protocol["binary"]).read_bytes()).hexdigest() == protocol["binary_sha256"]
    for name, field in (("2026-10-29-independent32-native-rust/FREEZE.json", "native_independent32_freeze_sha256"),
                        ("2026-10-29-rust-leaf-inline/validation/freeze.json", "leaf_source_freeze_sha256")):
        assert hashlib.sha256((HERE.parent / name).read_bytes()).hexdigest() == protocol[field]
    print("11-config source snapshots verified: timer body, public adapters and external dependency locks unchanged.")


if __name__ == "__main__":
    main()
