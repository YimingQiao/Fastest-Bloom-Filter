#!/usr/bin/env python3
"""Derive one source-only candidate from the committed production header."""
import difflib
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
COMMIT = "36979eb4439abce1977accb505053f7b5fa74b1a"
HEADER = "include/four_sector_range12_bloom.h"
OLD_NAME = "FourSectorRange12BloomFilter"
NEW_NAME = "FourSectorRange12SingletonVectorExperiment"

HELPER = """#if defined(__AVX512F__)
    bool ContainsHash512(uint64_t h) const {
        const uint32_t hi = h >> 32, lo = h;
        const __m512i hi4 = _mm512_set1_epi32(hi);
        const __m512i offset_shifts = _mm512_setr_epi32(
            32, 2, 4, 6, 32, 2, 4, 6, 32, 2, 4, 6, 32, 2, 4, 6);
        const __m512i quarters = _mm512_setr_epi32(
            0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12);
        // VPSRLVD gives zero for count32, preserving the first sector's offset.
        const __m512i local = _mm512_xor_si512(quarters, _mm512_and_si512(
            _mm512_xor_si512(hi4, _mm512_srlv_epi32(hi4, offset_shifts)),
            _mm512_set1_epi32(3)));
        const __m512i line = _mm512_load_si512(
            words_.data() + static_cast<size_t>(Block(hi)) * 16);
        const __m512i selected = _mm512_permutexvar_epi32(local, line);
        const __m512i rotations = _mm512_setr_epi32(
            0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24);
        const __m512i code = _mm512_rorv_epi32(_mm512_set1_epi32(lo), rotations);
        // VPERMD uses only code bits0..3; no explicit dictionary-index AND.
        const __m512i pattern = _mm512_permutexvar_epi32(
            code, _mm512_loadu_si512(patterns3));
        // VPROLVD uses only shift bits0..4, exactly (code >> 4) & 31.
        const __m512i masks = _mm512_rolv_epi32(pattern, _mm512_srli_epi32(code, 4));
        return (_mm512_cmpeq_epi32_mask(_mm512_and_si512(selected, masks), masks) & 15) == 15;
    }
#endif

"""
OLD_CONTAINS = "    bool ContainsHash(uint64_t h) const { uint32_t out; LookupScalar(1, &h, &out); return out != 0; }"
NEW_CONTAINS = """    bool ContainsHash(uint64_t h) const {
#if defined(__AVX512F__)
        return ContainsHash512(h);
#else
        uint32_t out; LookupScalar(1, &h, &out); return out != 0;
#endif
    }"""
OLD_SHORT = "\t\tif (n < 4)\n\t\t\treturn LookupScalar(n, h, out);"
NEW_SHORT = """\t\tif (n < 4) {
\t\t\tfor (uint32_t i = 0; i < n; ++i)
\t\t\t\tout[i] = ContainsHash512(h[i]);
\t\t\treturn n;
\t\t}"""

def blob(path):
    return subprocess.check_output(["git", "show", f"{COMMIT}:{path}"], cwd=ROOT)

def main():
    original = blob(HEADER).decode()
    assert original.count("public:\n") == 1
    assert original.count(OLD_CONTAINS) == original.count(OLD_SHORT) == 1
    changed = original.replace("public:\n", HELPER + "public:\n", 1)
    changed = changed.replace(OLD_CONTAINS, NEW_CONTAINS).replace(OLD_SHORT, NEW_SHORT)
    # Exact reversal is the preservation proof, not a whitespace-normalized diff.
    restored = changed.replace(NEW_SHORT, OLD_SHORT).replace(NEW_CONTAINS, OLD_CONTAINS)
    restored = restored.replace(HELPER, "", 1)
    assert restored == original
    candidate = changed.replace(OLD_NAME, NEW_NAME)
    outputs = {"control.h": original.encode(), "candidate.h": candidate.encode()}
    sources = {}
    for source in (HEADER, "include/base.h", "include/split64_range_size.h", "LICENSE"):
        data = blob(source)
        sources[source] = {"commit": COMMIT, "sha256": hashlib.sha256(data).hexdigest()}
        if source != HEADER:
            outputs[Path(source).name] = data
    outputs["CHANGE.patch"] = "".join(difflib.unified_diff(
        original.splitlines(True), candidate.splitlines(True),
        fromfile="control.h", tofile="candidate.h")).encode()
    outputs["SOURCE.json"] = (json.dumps({"status": "source-only; no compiler or filter execution",
        "sources": sources, "candidate_count": 1, "exact_reverse_verified": True,
        "unchanged": ["mapping", "allocation", "insertion", "LookupScalar", "Lookup n>=4",
                      "AVX2/scalar lookup", "parallel ownership", "inline hints"]}, indent=2) + "\n").encode()
    for name, data in outputs.items():
        (HERE / name).write_bytes(data)
    print("Derived one source-only candidate; exact reversal matches committed header.")

if __name__ == "__main__":
    main()
