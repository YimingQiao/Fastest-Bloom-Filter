#pragma once
#ifdef BF_FOUR_EXTERNAL_BASE
#include "base.h"
#else
#include "base_snapshot.h"
#endif
#if defined(__AVX512F__)
#include <immintrin.h>
#endif
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <vector>
#ifndef MASK_TABLE_ENTRIES
#define MASK_TABLE_ENTRIES 8
#endif
namespace bloom_filters {
template <unsigned Mode>
class FourSectorBF {
	static constexpr uint32_t patterns2[MASK_TABLE_ENTRIES] = {
#if MASK_TABLE_ENTRIES == 16
#include "masks2-count16.txt"
#else
#include "masks2-count8.txt"
#endif
	};
	static constexpr uint32_t patterns3[MASK_TABLE_ENTRIES] = {
#if MASK_TABLE_ENTRIES == 16
#include "masks3-count16.txt"
#else
#include "masks3-count8.txt"
#endif
	};
	std::vector<uint32_t, AlignedAllocator<uint32_t, 64>> words_;
	uint32_t word_mask_;
	static uint32_t mask(uint32_t code, unsigned sector) {
		const bool three = Mode == 12 || (Mode == 10 && sector >= 2) || (Mode == 9 && sector == 3);
		const uint32_t pattern = (three ? patterns3 : patterns2)[code & (MASK_TABLE_ENTRIES - 1)],
		               shift = (code >> (MASK_TABLE_ENTRIES == 16 ? 4 : 3)) & 31;
		return (pattern << shift) | (pattern >> ((-shift) & 31));
	}
	void probe(uint64_t h, uint32_t *index, uint32_t *masks) const {
		const uint32_t hi = h >> 32, lo = h;
		index[0] = hi & word_mask_;
		index[1] = (index[0] ^ 4) ^ ((hi >> 26) & 3);
		index[2] = (index[0] ^ 8) ^ ((hi >> 28) & 3);
		index[3] = (index[0] ^ 12) ^ ((hi >> 30) & 3);
		for (unsigned j = 0; j < 4; ++j) {
			const unsigned rotate = j * 8;
			const uint32_t code = (lo >> rotate) | (lo << ((-rotate) & 31));
			masks[j] = mask(code, j);
		}
	}

public:
	FourSectorBF(size_t n, uint32_t bpk) {
		const size_t bits = std::max<size_t>(512, n * bpk);
		size_t words = 32;
		while (words <= bits / 32)
			words *= 2;
		words_.resize(words);
		word_mask_ = words - 1;
	}
	size_t SizeInBytes() const {
		return words_.size() * 4;
	}
	void Insert(uint32_t n, const uint64_t *h) {
		for (size_t i = 0; i < n; ++i) {
			uint32_t index[4], masks[4];
			probe(h[i], index, masks);
			for (unsigned j = 0; j < 4; ++j)
				words_[index[j]] |= masks[j];
		}
	}
	uint32_t LookupScalar(uint32_t n, const uint64_t *h, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i) {
			uint32_t index[4], masks[4];
			probe(h[i], index, masks);
			uint32_t pass = 1;
			for (unsigned j = 0; j < 4; ++j)
				pass &= (words_[index[j]] & masks[j]) == masks[j];
			out[i] = pass;
		}
		return n;
	}
	uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
#if defined(BF_FOUR_SIMD) && defined(__AVX512F__)
		if (SizeInBytes() > (1u << 21))
			return LookupVector<true>(n, h, out);
		return LookupVector<false>(n, h, out);
#else
		return LookupScalar(n, h, out);
#endif
	}

private:
#if defined(BF_FOUR_SIMD) && defined(__AVX512F__)
	template <bool Prefetch>
	uint32_t LookupVector(uint32_t n, const uint64_t *h, uint32_t *out) const {
		static_assert(MASK_TABLE_ENTRIES == 16, "SIMD experiment uses16-entry dictionaries");
		const __m512i even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30);
		const __m512i odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
		const __m512i table2 = _mm512_loadu_si512(patterns2);
		const __m512i table3 = Mode == 8 ? table2 : _mm512_loadu_si512(patterns3);
		size_t i = 0;
		for (; i + 16 <= n; i += 16) {
			if constexpr (Prefetch) {
				if (i + 80 <= n)
					for (unsigned j = 0; j < 16; ++j)
						__builtin_prefetch(words_.data() + ((h[i + 64 + j] >> 32) & word_mask_), 0, 3);
			}
			const __m512i x = _mm512_loadu_si512(h + i), y = _mm512_loadu_si512(h + i + 8);
			const __m512i lo = _mm512_permutex2var_epi32(x, even, y), hi = _mm512_permutex2var_epi32(x, odd, y);
			const __m512i a = _mm512_and_si512(hi, _mm512_set1_epi32(word_mask_));
			const __m512i b =
			    _mm512_xor_si512(a, _mm512_or_si512(_mm512_set1_epi32(4),
				                                    _mm512_and_si512(_mm512_srli_epi32(hi, 26), _mm512_set1_epi32(3))));
			const __m512i c =
			    _mm512_xor_si512(a, _mm512_or_si512(_mm512_set1_epi32(8),
				                                    _mm512_and_si512(_mm512_srli_epi32(hi, 28), _mm512_set1_epi32(3))));
			const __m512i d =
			    _mm512_xor_si512(a, _mm512_or_si512(_mm512_set1_epi32(12),
				                                    _mm512_and_si512(_mm512_srli_epi32(hi, 30), _mm512_set1_epi32(3))));
			auto maskv = [](__m512i code, __m512i table) {
				return _mm512_rolv_epi32(_mm512_permutexvar_epi32(code, table), _mm512_srli_epi32(code, 4));
			};
			const __m512i m1 = maskv(lo, Mode == 12 ? table3 : table2);
			const __m512i m2 = maskv(_mm512_ror_epi32(lo, 8), Mode == 12 ? table3 : table2);
			const __m512i m3 = maskv(_mm512_ror_epi32(lo, 16), Mode >= 10 ? table3 : table2);
			const __m512i m4 = maskv(_mm512_ror_epi32(lo, 24), Mode >= 9 ? table3 : table2);
			const __m512i v1 = _mm512_i32gather_epi32(a, words_.data(), 4);
			const __m512i v2 = _mm512_i32gather_epi32(b, words_.data(), 4);
			const __m512i v3 = _mm512_i32gather_epi32(c, words_.data(), 4);
			const __m512i v4 = _mm512_i32gather_epi32(d, words_.data(), 4);
			const __mmask16 pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(v1, m1), m1) &
			                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v2, m2), m2) &
			                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v3, m3), m3) &
			                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v4, m4), m4);
			_mm512_storeu_si512(out + i, _mm512_maskz_set1_epi32(pass, 1));
		}
		LookupScalar(n - i, h + i, out + i);
		return n;
	}
#endif
};
#ifndef BF_FOUR_EXTERNAL_BASE
using FastPatternBF = FourSectorBF<MASK_MODE>;
#endif
} // namespace bloom_filters
