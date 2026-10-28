"""Check the exact V2 annotation and unchanged thirteen-way public harness."""
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
        raise ValueError("Source checks require Python without -O")
    records = json.loads((HERE / "copy-source.json").read_text())["copied"]
    for record in records.values():
        assert sha(ROOT / record["source"]) == record["sha256"]
    for local, record in records.items():
        if not local.startswith("native/"):
            continue
        data = (HERE / local).read_text()
        if local == "native/src/independent32.rs":
            frozen = ROOT / "experiments/2026-10-29-independent32-rust-singleton-v2/candidate-v2.rs"
            assert (HERE / local).read_bytes() == frozen.read_bytes()
            before = "    #[inline]\n    fn contains_scalar(&self, hash: u64) -> bool {"
            after = before.replace("#[inline]", "#[inline(always)]")
            assert data.count(after) == 1
            data = data.replace(after, before)
        if local in ("native/Cargo.toml", "native/Cargo.lock", "native/src/bin/parity.rs", "native/src/bin/codegen.rs"):
            data = data.replace("independent32-scalar-inline-experiment", "independent32-singleton-experiment").replace("independent32_scalar_inline_experiment", "independent32_singleton_experiment")
        assert hashlib.sha256(data.encode()).hexdigest() == record["sha256"], local
    main_source = (HERE / "benchmark/src/main.rs").read_text()
    for addition in (
        "use independent32_scalar_inline::Independent32BloomFilter as Independent32ScalarInlineV2;\n",
        "native_filter!(Independent32ScalarInlineV2);\n",
        '    "Independent32ScalarInlineV2",\n',
        '            "Independent32ScalarInlineV2" => run::<Independent32ScalarInlineV2>(name, &inserted, &query, &c),\n',
    ):
        assert main_source.count(addition) == 1, addition
        main_source = main_source.replace(addition, "")
    assert hashlib.sha256(main_source.encode()).hexdigest() == records["benchmark/src/main.rs"]["sha256"]
    tests = (HERE / "benchmark/src/tests.rs").read_text().replace("all_thirteen_public_apis", "all_twelve_public_apis")
    addition = "    public_api_parity::<Independent32ScalarInlineV2>();\n"
    assert tests.count(addition) == 1
    tests = tests.replace(addition, "")
    assert hashlib.sha256(tests.encode()).hexdigest() == records["benchmark/src/tests.rs"]["sha256"]
    reference = tomllib.loads((ROOT / records["benchmark/Cargo.lock"]["source"]).read_text())
    actual = tomllib.loads((HERE / "benchmark/Cargo.lock").read_text())
    external = lambda lock: {(p["name"], p["version"]): p for p in lock["package"] if "source" in p}
    assert external(actual) == external(reference)
    print("PASS: exact one-annotation V2, unchanged V1/native controls, four timed contracts and external dependency versions")


if __name__ == "__main__":
    main()
