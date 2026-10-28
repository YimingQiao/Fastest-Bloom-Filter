"""Validate exact copied controls and public singleton delta without compilation."""
import hashlib
import json
from pathlib import Path
import tomllib

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if not __debug__:
        raise ValueError("Run source checks without Python -O")
    records = json.loads((HERE / "copy-source.json").read_text())["copied"]
    for local, record in records.items():
        if local.startswith(("original-native/", "leaf-native/")):
            assert sha(HERE / local) == record["sha256"], local
    main_source = (HERE / "benchmark/src/main.rs").read_text()
    for addition in ("use independent32_singleton::Independent32BloomFilter as Independent32SingletonV1;\n",
                     "native_filter!(Independent32SingletonV1);\n", '    "Independent32SingletonV1",\n',
                     '            "Independent32SingletonV1" => run::<Independent32SingletonV1>(name, &inserted, &query, &c),\n'):
        assert main_source.count(addition) == 1
        main_source = main_source.replace(addition, "")
    assert hashlib.sha256(main_source.encode()).hexdigest() == records["benchmark/src/main.rs"]["sha256"]
    tests = (HERE / "benchmark/src/tests.rs").read_text().replace("all_twelve_public_apis", "all_eleven_public_apis")
    tests = tests.replace("    public_api_parity::<Independent32SingletonV1>();\n", "")
    assert hashlib.sha256(tests.encode()).hexdigest() == records["benchmark/src/tests.rs"]["sha256"]
    addition = '        if hashes.len() == 1 {\n            out[0] = self.contains_hash(hashes[0]) as u32;\n            return;\n        }\n'
    native = (HERE / "native/src/independent32.rs").read_text()
    assert native.count(addition) == 1
    assert hashlib.sha256(native.replace(addition, "").encode()).hexdigest() == records["native/src/independent32.rs"]["sha256"]
    for local, record in records.items():
        if local.startswith("native/") and local != "native/src/independent32.rs":
            data = (HERE / local).read_text()
            if local in ("native/Cargo.toml", "native/Cargo.lock", "native/src/bin/parity.rs", "native/src/bin/codegen.rs"):
                data = data.replace("independent32-singleton-experiment", "independent32-native-experiment").replace("independent32_singleton_experiment", "independent32_native_experiment")
            if local == "native/src/independent32/tests.rs":
                data = data.removesuffix('\ninclude!("singleton_tests.rs");\n')
            assert hashlib.sha256(data.encode()).hexdigest() == record["sha256"], local
    reference = tomllib.loads((ROOT / records["benchmark/Cargo.lock"]["source"]).read_text())
    actual = tomllib.loads((HERE / "benchmark/Cargo.lock").read_text())
    external = lambda lock: {(p["name"], p["version"]): p for p in lock["package"] if "source" in p}
    assert external(actual) == external(reference)
    protocol = json.loads((HERE / "protocol.json").read_text())
    assert len(protocol["filters"]) == 12 and protocol["rows"] == 192 and protocol["workloads"] == 16
    assert protocol["cpu"] == 2 and protocol["batches"] == [1, 2, 31, 4096]
    assert sha(Path(protocol["reference_binary"])) == protocol["reference_binary_sha256"]
    if protocol["binary_sha256"] is not None:
        assert sha(Path(protocol["binary"])) == protocol["binary_sha256"]
    print("PASS:12 public registrations, exact four-line singleton delta, all11 frozen controls and external dependencies unchanged")


if __name__ == "__main__":
    main()
