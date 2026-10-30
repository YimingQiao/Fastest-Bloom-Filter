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
template <unsigned Mode, bool PreparedInsert = true>
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
	void InsertScalar(uint32_t n, const uint64_t *h) {
		for (size_t i = 0; i < n; ++i) {
			uint32_t index[4], masks[4];
			probe(h[i], index, masks);
			for (unsigned j = 0; j < 4; ++j)
				words_[index[j]] |= masks[j];
		}
	}
	void Insert(uint32_t n, const uint64_t *h) {
#if defined(BF_FOUR_SIMD) && defined(__AVX512F__)
		if constexpr (PreparedInsert) {
			if (SizeInBytes() > (1u << 21))
				InsertVector<true>(n, h);
			else
				InsertVector<false>(n, h);
			return;
		}
#endif
		InsertScalar(n, h);
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
		if (n < 4)
			return LookupScalar(n, h, out);
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
	void InsertVector(uint32_t n, const uint64_t *h) {
		static_assert(MASK_TABLE_ENTRIES == 16, "SIMD experiment uses 16-entry dictionaries");
		const __m512i even = _mm512_setr_epi32(0, 0, 0, 0, 2, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6);
		const __m512i odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
		const __m512i rotations = _mm512_setr_epi32(0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24);
		const __m512i quarters = _mm512_setr_epi32(0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12);
		const __m512i offset_shifts = _mm512_setr_epi32(26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30);
		const __m512i offset_masks = _mm512_setr_epi32(0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3);
		const __m512i table2 = _mm512_loadu_si512(patterns2);
		const __m512i table3 = Mode == 8 ? table2 : _mm512_loadu_si512(patterns3);
		size_t i = 0;
		for (; i + 4 <= n; i += 4) {
			if constexpr (Prefetch) {
				if (i + 68 <= n)
					for (unsigned j = 0; j < 4; ++j)
						__builtin_prefetch(words_.data() + ((h[i + 64 + j] >> 32) & word_mask_), 1, 3);
			}
			const __m512i packed = _mm512_castsi256_si512(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(h + i)));
			const __m512i lo = _mm512_permutexvar_epi32(even, packed), hi = _mm512_permutexvar_epi32(odd, packed);
			const __m512i code = _mm512_rorv_epi32(lo, rotations);
			__m512i patterns = _mm512_permutexvar_epi32(code, Mode == 12 ? table3 : table2);
			if constexpr (Mode == 9 || Mode == 10)
				patterns = _mm512_mask_mov_epi32(patterns, Mode == 9 ? 0x8888 : 0xcccc,
				                                 _mm512_permutexvar_epi32(code, table3));
			const __m512i masks = _mm512_rolv_epi32(patterns, _mm512_srli_epi32(code, 4));
			const __m512i offsets = _mm512_and_si512(_mm512_srlv_epi32(hi, offset_shifts), offset_masks);
			const __m512i indices = _mm512_xor_si512(_mm512_and_si512(hi, _mm512_set1_epi32(word_mask_)),
			                                         _mm512_xor_si512(quarters, offsets));
			alignas(64) uint32_t index[16], mask[16];
			_mm512_store_si512(index, indices);
			_mm512_store_si512(mask, masks);
			// Sequential ORs preserve every bit when different keys share a word.
			for (unsigned j = 0; j < 16; ++j)
				words_[index[j]] |= mask[j];
		}
		InsertScalar(n - i, h + i);
	}
	template <bool Masked>
	void QueryChunk(const uint64_t *h, uint32_t *out, __mmask16 valid, __m512i table2, __m512i table3) const {
		const __m512i even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30);
		const __m512i odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
		const __m512i x = Masked ? _mm512_maskz_loadu_epi64(static_cast<__mmask8>(valid), h) : _mm512_loadu_si512(h);
		// Do not form h+8 when the input has fewer than eight valid objects.
		const __m512i y = Masked ? ((valid >> 8) ? _mm512_maskz_loadu_epi64(static_cast<__mmask8>(valid >> 8), h + 8)
		                                         : _mm512_setzero_si512())
		                         : _mm512_loadu_si512(h + 8);
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
		const __m512i m1 = maskv(lo, Mode == 12 ? table3 : table2),
		              m2 = maskv(_mm512_ror_epi32(lo, 8), Mode == 12 ? table3 : table2);
		const __m512i m3 = maskv(_mm512_ror_epi32(lo, 16), Mode >= 10 ? table3 : table2),
		              m4 = maskv(_mm512_ror_epi32(lo, 24), Mode >= 9 ? table3 : table2);
		const __m512i zero = _mm512_setzero_si512();
		const __m512i v1 = _mm512_mask_i32gather_epi32(zero, valid, a, words_.data(), 4),
		              v2 = _mm512_mask_i32gather_epi32(zero, valid, b, words_.data(), 4);
		const __m512i v3 = _mm512_mask_i32gather_epi32(zero, valid, c, words_.data(), 4),
		              v4 = _mm512_mask_i32gather_epi32(zero, valid, d, words_.data(), 4);
		const __mmask16 pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(v1, m1), m1) &
		                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v2, m2), m2) &
		                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v3, m3), m3) &
		                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v4, m4), m4);
		if constexpr (Masked)
			_mm512_mask_storeu_epi32(out, valid, _mm512_maskz_set1_epi32(pass, 1));
		else
			_mm512_storeu_si512(out, _mm512_maskz_set1_epi32(pass, 1));
	}
	template <bool Prefetch>
	uint32_t LookupVector(uint32_t n, const uint64_t *h, uint32_t *out) const {
		static_assert(MASK_TABLE_ENTRIES == 16, "SIMD experiment uses16-entry dictionaries");
		const __m512i table2 = _mm512_loadu_si512(patterns2);
		const __m512i table3 = Mode == 8 ? table2 : _mm512_loadu_si512(patterns3);
		size_t i = 0;
		for (; i + 16 <= n; i += 16) {
			if constexpr (Prefetch) {
				if (i + 80 <= n)
					for (unsigned j = 0; j < 16; ++j)
						__builtin_prefetch(words_.data() + ((h[i + 64 + j] >> 32) & word_mask_), 0, 3);
			}
			QueryChunk<false>(h + i, out + i, 0xffff, table2, table3);
		}
		if (i < n)
			QueryChunk<true>(h + i, out + i, static_cast<__mmask16>((1u << (n - i)) - 1), table2, table3);
		return n;
	}
#endif
};
#ifndef BF_FOUR_EXTERNAL_BASE
using FastPatternBF = FourSectorBF<MASK_MODE>;
#endif
} // namespace bloom_filters
