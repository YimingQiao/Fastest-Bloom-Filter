"""Read-only source guard: original native dependencies plus one module/export."""
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def main():
    manifest = json.loads((HERE / "source-reference.json").read_text())
    for name, expected in manifest["original_files_sha256"].items():
        original = ROOT / name
        assert hashlib.sha256(original.read_bytes()).hexdigest() == expected, name
        copied = HERE / "native/src" / original.name
        data = copied.read_bytes()
        if original.name == "lib.rs":
            text = data.decode()
            for addition in manifest["lib_additions"]:
                assert text.count(addition + "\n") == 1, addition
                text = text.replace(addition + "\n", "")
            data = text.encode()
        assert hashlib.sha256(data).hexdigest() == expected, copied
    cpp = ROOT / manifest["cpp_reference"]
    assert hashlib.sha256(cpp.read_bytes()).hexdigest() == manifest["cpp_reference_sha256"]
    for name, expected in manifest["license_files_sha256"].items():
        original = ROOT / name
        copied = HERE / "native" / original.name
        assert original.read_bytes() == copied.read_bytes()
        assert hashlib.sha256(copied.read_bytes()).hexdigest() == expected
    print("Seven native source copies unchanged except the two declared lib.rs additions; frozen C++ reference unchanged.")


if __name__ == "__main__":
    main()
