#!/usr/bin/env python3
"""Reconstruct the isolated range-addressed FourSector candidate from pinned source."""
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def replace_once(source, old, new, count=1):
    if source.count(old) != count:
        raise ValueError((old, source.count(old), count))
    return source.replace(old, new)


def generate(commit):
    source = subprocess.check_output(["git", "show", commit + ":include/four_sector_bloom.h"], cwd=ROOT, text=True)
    source = replace_once(source, '#include "layout_detail.h"', '#include "range_size.hpp"')
    source = source.replace("FourSectorBloomFilter", "FourSectorRange24")
    source = replace_once(source, "return ((h >> 32) & word_mask_) >> 4;", "return Block(static_cast<uint32_t>(h >> 32));")
    source = replace_once(source, "uint32_t word_mask_;", """uint32_t line_count_;
    uint32_t Block(uint32_t hi) const {
        return (uint64_t(hi >> 8) * line_count_) >> 24;
    }
    uint32_t Base(uint32_t hi) const { return (Block(hi) << 4) | (hi & 3); }
#if defined(__AVX512F__)
    __m512i Base512(__m512i hi) const {
        const __m512i address = _mm512_srli_epi32(hi, 8);
        const __m512i counts = _mm512_set1_epi32(line_count_);
        const __m512i even = _mm512_srli_epi64(_mm512_mul_epu32(address, counts), 24);
        const __m512i odd = _mm512_srli_epi64(_mm512_mul_epu32(_mm512_srli_epi64(address, 32), counts), 24);
        const __m512i blocks = _mm512_or_si512(even, _mm512_slli_epi64(odd, 32));
        return _mm512_or_si512(_mm512_slli_epi32(blocks, 4), _mm512_and_si512(hi, _mm512_set1_epi32(3)));
    }
#elif defined(__AVX2__)
    __m256i Base256(__m256i hi) const {
        const __m256i address = _mm256_srli_epi32(hi, 8);
        const __m256i counts = _mm256_set1_epi32(line_count_);
        const __m256i even = _mm256_srli_epi64(_mm256_mul_epu32(address, counts), 24);
        const __m256i odd = _mm256_srli_epi64(_mm256_mul_epu32(_mm256_srli_epi64(address, 32), counts), 24);
        const __m256i blocks = _mm256_or_si256(even, _mm256_slli_epi64(odd, 32));
        return _mm256_or_si256(_mm256_slli_epi32(blocks, 4), _mm256_and_si256(hi, _mm256_set1_epi32(3)));
    }
#endif""")
    source = replace_once(source, "index[0] = hi & word_mask_;", "index[0] = Base(hi);")
    for old, new in ((26, 2), (28, 4), (30, 6)):
        source = replace_once(source, f"(hi >> {old})", f"(hi >> {new})")
    old_ctor = """explicit FourSectorRange24(size_t n, uint32_t bpk)
	    : words_(layout_detail::WordCount(n, bpk)), word_mask_(words_.size() - 1) {
	}"""
    source = replace_once(source, old_ctor, """explicit FourSectorRange24(RangeBytes budget)
        : words_(range_detail::LineCount(budget.bytes) * 16), line_count_(words_.size() / 16) {
        if (SizeInBytes() > budget.bytes) throw std::length_error("actual backing exceeds budget");
    }
    explicit FourSectorRange24(size_t n, uint32_t bpk)
        : FourSectorRange24(RangeBytes{range_detail::BudgetBytes(n, bpk)}) {}
    const uint32_t* Data() const { return words_.data(); }
    uint32_t LineIndex(uint64_t h) const { return Block(static_cast<uint32_t>(h >> 32)); }
    bool ContainsHash(uint64_t h) const { uint32_t out; LookupScalar(1, &h, &out); return out != 0; }""")
    source = replace_once(source, "return words_.size() * 4;", "return words_.capacity() * 4;")
    for subscript, count in (("i", 1), ("i + 64 + j", 3)):
        source = replace_once(source, f"((h[{subscript}] >> 32) & word_mask_)", f"Base(static_cast<uint32_t>(h[{subscript}] >> 32))", count)
    source = replace_once(source, "_mm256_and_si256(hi, _mm256_set1_epi32(word_mask_))", "Base256(hi)")
    source = replace_once(source, "_mm512_and_si512(hi, _mm512_set1_epi32(word_mask_))", "Base512(hi)", 3)
    for width in (256, 512):
        for old, new in ((26, 2), (28, 4), (30, 6)):
            count = 2 if width == 512 and old == 26 else 1
            source = replace_once(source, f"_mm{width}_srli_epi32(hi, {old})", f"_mm{width}_srli_epi32(hi, {new})", count)
    source = replace_once(source, "_mm512_setr_epi32(26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30)",
                          "_mm512_setr_epi32(2, 2, 4, 6, 2, 2, 4, 6, 2, 2, 4, 6, 2, 2, 4, 6)")
    source = replace_once(source, "_mm512_setr_epi32(28, 28, 28, 28, 28, 28, 28, 28, 30, 30, 30, 30, 30, 30, 30, 30)",
                          "_mm512_setr_epi32(4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6)")
    if "word_mask_" in source or "layout_detail::" in source:
        raise ValueError("Unconverted power-of-two operation")
    return source


if __name__ == "__main__":
    import argparse
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("commit")
    p.add_argument("--verify", action="store_true")
    a = p.parse_args()
    result = generate(a.commit)
    target = HERE / "four_sector_range24.h"
    if a.verify:
        if target.read_text() != result:
            raise ValueError("Derived source mismatch")
    else:
        if target.exists():
            raise ValueError("Refuse source overwrite")
        target.write_text(result)
