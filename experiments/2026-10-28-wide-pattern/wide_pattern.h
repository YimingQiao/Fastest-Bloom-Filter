#pragma once
#include "base.h"
#include <algorithm>
#include <vector>
#include <immintrin.h>
namespace wide_pattern {
alignas(64) inline constexpr uint32_t table64[64] = {
#include "../2026-10-28-mask-sweep/masks4-count64.txt"
};
alignas(64) inline constexpr uint32_t table128[128] = {
#include "../2026-10-28-mask-sweep/masks4-count128.txt"
};
template <unsigned Bits, bool Gather>
class Filter {
	static constexpr unsigned CodeBits = Bits + 5, Count = 1u << Bits;
	const uint32_t *table_ = Bits == 6 ? table64 : table128;
	std::vector<uint32_t, bloom_filters::AlignedAllocator<uint32_t, 64>> words_;
	uint32_t word_mask_;
	uint32_t first(uint64_t h) const {
		return (h >> 32) & word_mask_;
	}
	uint32_t partner(uint64_t h, uint32_t a) const {
		return a ^ (8 + ((uint32_t(h) >> (2 * CodeBits)) & 7));
	}
	uint32_t mask(uint32_t code) const {
		const uint32_t v = table_[code & (Count - 1)], r = (code >> Bits) & 31;
		return (v << r) | (v >> ((-r) & 31));
	}
	__m512i patterns(__m512i code) const {
		if constexpr (Gather)
			return _mm512_i32gather_epi32(_mm512_and_si512(code, _mm512_set1_epi32(Count - 1)), table_, 4);
		else {
			const __m512i t0 = _mm512_load_si512(table_), t1 = _mm512_load_si512(table_ + 16);
			const __m512i t2 = _mm512_load_si512(table_ + 32), t3 = _mm512_load_si512(table_ + 48);
			const __mmask16 hi32 = _mm512_test_epi32_mask(code, _mm512_set1_epi32(32));
			const __m512i low = _mm512_mask_blend_epi32(hi32, _mm512_permutex2var_epi32(t0, code, t1),
			                                            _mm512_permutex2var_epi32(t2, code, t3));
			if constexpr (Bits == 6)
				return low;
			const __m512i t4 = _mm512_load_si512(table_ + 64), t5 = _mm512_load_si512(table_ + 80);
			const __m512i t6 = _mm512_load_si512(table_ + 96), t7 = _mm512_load_si512(table_ + 112);
			const __m512i high = _mm512_mask_blend_epi32(hi32, _mm512_permutex2var_epi32(t4, code, t5),
			                                             _mm512_permutex2var_epi32(t6, code, t7));
			return _mm512_mask_blend_epi32(_mm512_test_epi32_mask(code, _mm512_set1_epi32(64)), low, high);
		}
	}
	__m512i masks(__m512i code) const {
		return _mm512_rolv_epi32(patterns(code), _mm512_srli_epi32(code, Bits));
	}
	template <bool Prefetch>
	void lookup(uint32_t n, const uint64_t *__restrict h, uint32_t *__restrict out) const {
		const __m512i even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30);
		const __m512i odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
		size_t i = 0;
		for (; i + 16 <= n; i += 16) {
			if constexpr (Prefetch)
				if (i + 80 <= n)
					for (size_t j = 0; j < 16; ++j)
						__builtin_prefetch(words_.data() + first(h[i + 64 + j]), 0, 3);
			const __m512i x = _mm512_loadu_si512(h + i), y = _mm512_loadu_si512(h + i + 8);
			const __m512i lo = _mm512_permutex2var_epi32(x, even, y), hi = _mm512_permutex2var_epi32(x, odd, y);
			const __m512i a = _mm512_and_si512(hi, _mm512_set1_epi32(word_mask_));
			const __m512i b = _mm512_xor_si512(
			    a, _mm512_or_si512(_mm512_set1_epi32(8),
				                   _mm512_and_si512(_mm512_srli_epi32(lo, 2 * CodeBits), _mm512_set1_epi32(7))));
			const __m512i m1 = masks(lo), m2 = masks(_mm512_srli_epi32(lo, CodeBits));
			const __m512i v1 = _mm512_i32gather_epi32(a, words_.data(), 4),
			              v2 = _mm512_i32gather_epi32(b, words_.data(), 4);
			const __mmask16 pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(v1, m1), m1) &
			                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v2, m2), m2);
			_mm512_storeu_si512(out + i, _mm512_maskz_set1_epi32(pass, 1));
		}
		if (i + 8 <= n) {
			const __m512i x = _mm512_loadu_si512(h + i);
			const __m512i a = _mm512_and_si512(_mm512_shuffle_epi32(x, static_cast<_MM_PERM_ENUM>(0xf5)),
			                                   _mm512_set1_epi32(word_mask_));
			const __m512i delta = _mm512_or_si512(
			    _mm512_set1_epi64(uint64_t {8} << 32),
			    _mm512_and_si512(_mm512_slli_epi64(x, 32 - 2 * CodeBits), _mm512_set1_epi64(uint64_t {7} << 32)));
			const __m512i code = _mm512_srlv_epi32(_mm512_shuffle_epi32(x, static_cast<_MM_PERM_ENUM>(0xa0)),
			                                       _mm512_set1_epi64(uint64_t {CodeBits} << 32));
			const __m512i mask = masks(code), v = _mm512_i32gather_epi32(_mm512_xor_si512(a, delta), words_.data(), 4);
			const __mmask8 pass = _mm512_cmpeq_epi64_mask(_mm512_and_si512(v, mask), mask);
			_mm256_storeu_si256(reinterpret_cast<__m256i *>(out + i),
			                    _mm512_castsi512_si256(_mm512_maskz_set1_epi32(pass, 1)));
			i += 8;
		}
		for (; i < n; ++i)
			out[i] = Contains(h[i]);
	}

public:
	Filter(size_t n, uint32_t bpk) {
		size_t w = 32;
		while (w <= std::max<size_t>(512, n * bpk) / 32)
			w *= 2;
		words_.resize(w);
		word_mask_ = w - 1;
	}
	size_t SizeInBytes() const {
		return words_.size() * 4;
	}
	void Insert(uint32_t n, const uint64_t *h) {
		for (size_t i = 0; i < n; ++i) {
			uint32_t a = first(h[i]), b = partner(h[i], a);
			words_[a] |= mask(h[i]);
			words_[b] |= mask(uint32_t(h[i]) >> CodeBits);
		}
	}
	bool Contains(uint64_t h) const {
		uint32_t a = first(h), b = partner(h, a), m1 = mask(h), m2 = mask(uint32_t(h) >> CodeBits);
		return ((words_[a] & m1) == m1) & ((words_[b] & m2) == m2);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
		if (SizeInBytes() > (1u << 21))
			lookup<true>(n, h, out);
		else
			lookup<false>(n, h, out);
		return n;
	}
};
} // namespace wide_pattern
