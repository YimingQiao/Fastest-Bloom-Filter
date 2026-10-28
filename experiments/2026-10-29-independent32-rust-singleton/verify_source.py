"""Check the source-only four-line delta; never compile or execute a filter."""
from pathlib import Path
import hashlib
import json

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ADDITION = ('        if hashes.len() == 1 {\n'
            '            out[0] = self.contains_hash(hashes[0]) as u32;\n'
            '            return;\n'
            '        }\n')


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if not __debug__:
        raise ValueError("Run source validation without Python -O")
    provenance = json.loads((HERE / "provenance.json").read_text())
    before, candidate = (HERE / "before.rs").read_text(), (HERE / "candidate.rs").read_text()
    assert sha(HERE / "before.rs") == provenance["before_sha256"]
    assert sha(HERE / "candidate.rs") == provenance["candidate_sha256"]
    assert candidate.count(ADDITION) == 1 and candidate.replace(ADDITION, "") == before
    anchor = '    pub fn lookup_hashes(&self, hashes: &[u64], out: &mut [u32]) {\n        assert_eq!(hashes.len(), out.len(), "one output is required per input");\n'
    assert anchor + ADDITION in candidate
    for name, expected in provenance["source_sha256"].items():
        assert sha(ROOT / name) == expected, name
    for name, expected in provenance["copied_license_sha256"].items():
        assert sha(HERE / name) == expected, name
    assert sha(Path(provenance["binary"])) == provenance["binary_sha256"]
    print("PASS: exact four-line post-assert singleton delta; frozen inputs unchanged; no compilation or timing")


if __name__ == "__main__":
    main()
