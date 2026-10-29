#pragma once
#include "base.h"
#include "layout_detail.h"
#if defined(__AVX2__)
#include <immintrin.h>
#endif
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <vector>
namespace native_before {
// Four distinct 32-bit sectors in one cache line, two cyclic mask bits per sector.
// Single-writer insertion; immutable queries can run concurrently. Uniform 64-bit
// hashes are required. Empirical FPR is workload-dependent; this is not a hard cap.
class FourSectorBloomFilter {
	template <class>
	friend class ParallelLayoutBloomFilter;
	size_t CacheLineCount() const {
		return words_.size() / 16;
	}
	size_t CacheLineIndex(uint64_t h) const {
		return ((h >> 32) & word_mask_) >> 4;
	}
	inline static constexpr uint32_t patterns2[16] = {0x3,   0x5,   0x9,   0x11,   0x21,   0x41,   0x81,   0x101,
	                                                  0x201, 0x401, 0x801, 0x1001, 0x2001, 0x4001, 0x8001, 0x10001};
	std::vector<uint32_t, AlignedAllocator<uint32_t, 64>> words_;
	uint32_t word_mask_;
	static uint32_t mask(uint32_t code) {
		const uint32_t pattern = patterns2[code & 15], shift = (code >> 4) & 31;
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
			masks[j] = mask(code);
		}
	}

public:
	explicit FourSectorBloomFilter(size_t n, uint32_t bpk)
	    : words_(layout_detail::WordCount(n, bpk)), word_mask_(words_.size() - 1) {
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
		if (!n)
			return;
#if defined(__AVX512F__)
		if (SizeInBytes() > (1u << 21))
			InsertVector<true>(n, h);
		else
			InsertVector<false>(n, h);
		return;
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
		if (!n)
			return 0;
#if defined(__AVX512F__)
		if (n < 4)
			return LookupScalar(n, h, out);
		if (n < 64) {
			const bool large = SizeInBytes() > (1u << 21);
			if (large)
				for (size_t i = 0; i < n; ++i)
					__builtin_prefetch(words_.data() + ((h[i] >> 32) & word_mask_), 0, 3);
			if (n <= 8 || large)
				return LookupShort(n, h, out);
		}
		if (SizeInBytes() > (1u << 21))
			return LookupVector<true>(n, h, out);
		return LookupVector<false>(n, h, out);
#elif defined(__AVX2__)
		if (SizeInBytes() > (1u << 21))
			return LookupAvx2<true>(n, h, out);
		return LookupAvx2<false>(n, h, out);
#else
		return LookupScalar(n, h, out);
#endif
	}

private:
#if defined(__AVX2__) && !defined(__AVX512F__)
	template <bool Prefetch>
	uint32_t LookupAvx2(uint32_t n, const uint64_t *h, uint32_t *out) const {
		const __m256i order = _mm256_setr_epi32(0, 2, 4, 6, 1, 3, 5, 7);
		const __m256i ones = _mm256_set1_epi32(1);
		auto match = [&](const __m256i index, const __m256i code) {
			// The dictionary is exactly 1 | (2 << (code & 15)). Forming it
			// arithmetically avoids an extra AVX2 gather for this small table.
			const __m256i pattern = _mm256_or_si256(
			    ones, _mm256_sllv_epi32(_mm256_set1_epi32(2), _mm256_and_si256(code, _mm256_set1_epi32(15))));
			const __m256i shift = _mm256_and_si256(_mm256_srli_epi32(code, 4), _mm256_set1_epi32(31));
			const __m256i mask =
			    _mm256_or_si256(_mm256_sllv_epi32(pattern, shift),
				                _mm256_srlv_epi32(pattern, _mm256_sub_epi32(_mm256_set1_epi32(32), shift)));
			const __m256i value = _mm256_i32gather_epi32(reinterpret_cast<const int *>(words_.data()), index, 4);
			return _mm256_cmpeq_epi32(_mm256_and_si256(value, mask), mask);
		};
		size_t i = 0;
		for (; i + 8 <= n; i += 8) {
			if constexpr (Prefetch) {
				if (i + 72 <= n)
					for (unsigned j = 0; j < 8; ++j)
						__builtin_prefetch(words_.data() + ((h[i + 64 + j] >> 32) & word_mask_), 0, 3);
			}
			const __m256i x =
			    _mm256_permutevar8x32_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(h + i)), order);
			const __m256i y =
			    _mm256_permutevar8x32_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(h + i + 4)), order);
			const __m256i lo = _mm256_permute2x128_si256(x, y, 0x20), hi = _mm256_permute2x128_si256(x, y, 0x31);
			const __m256i a = _mm256_and_si256(hi, _mm256_set1_epi32(word_mask_));
			const __m256i b =
			    _mm256_xor_si256(a, _mm256_or_si256(_mm256_set1_epi32(4),
				                                    _mm256_and_si256(_mm256_srli_epi32(hi, 26), _mm256_set1_epi32(3))));
			const __m256i c =
			    _mm256_xor_si256(a, _mm256_or_si256(_mm256_set1_epi32(8),
				                                    _mm256_and_si256(_mm256_srli_epi32(hi, 28), _mm256_set1_epi32(3))));
			const __m256i d =
			    _mm256_xor_si256(a, _mm256_or_si256(_mm256_set1_epi32(12),
				                                    _mm256_and_si256(_mm256_srli_epi32(hi, 30), _mm256_set1_epi32(3))));
			const __m256i rb = _mm256_or_si256(_mm256_srli_epi32(lo, 8), _mm256_slli_epi32(lo, 24));
			const __m256i rc = _mm256_or_si256(_mm256_srli_epi32(lo, 16), _mm256_slli_epi32(lo, 16));
			const __m256i rd = _mm256_or_si256(_mm256_srli_epi32(lo, 24), _mm256_slli_epi32(lo, 8));
			const __m256i pass = _mm256_and_si256(_mm256_and_si256(match(a, lo), match(b, rb)),
			                                      _mm256_and_si256(match(c, rc), match(d, rd)));
			_mm256_storeu_si256(reinterpret_cast<__m256i *>(out + i), _mm256_and_si256(pass, ones));
		}
		LookupScalar(n - i, h + i, out + i);
		return n;
	}
#endif
#if defined(__AVX512F__)
	template <bool Prefetch>
	void InsertVector(uint32_t n, const uint64_t *h) {
		const __m512i even = _mm512_setr_epi32(0, 0, 0, 0, 2, 2, 2, 2, 4, 4, 4, 4, 6, 6, 6, 6);
		const __m512i odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
		const __m512i rotations = _mm512_setr_epi32(0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24, 0, 8, 16, 24);
		const __m512i quarters = _mm512_setr_epi32(0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12, 0, 4, 8, 12);
		const __m512i offset_shifts = _mm512_setr_epi32(26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30, 26, 26, 28, 30);
		const __m512i offset_masks = _mm512_setr_epi32(0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3, 0, 3, 3, 3);
		const __m512i table2 = _mm512_loadu_si512(patterns2);
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
			__m512i patterns = _mm512_permutexvar_epi32(code, table2);
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
	void QueryChunk(const uint64_t *h, uint32_t *out, __mmask16 valid, __m512i table2) const {
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
		const __m512i m1 = maskv(lo, table2), m2 = maskv(_mm512_ror_epi32(lo, 8), table2);
		const __m512i m3 = maskv(_mm512_ror_epi32(lo, 16), table2), m4 = maskv(_mm512_ror_epi32(lo, 24), table2);
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
	uint32_t LookupShort(uint32_t n, const uint64_t *h, uint32_t *out) const {
		// Eight keys per group; lower/upper lanes probe two sectors of each key.
		const __m512i even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 0, 2, 4, 6, 8, 10, 12, 14);
		const __m512i odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
		const __m512i rotations = _mm512_setr_epi32(0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8);
		const __m512i quarters = _mm512_setr_epi32(0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4);
		const __m512i offset_mask = _mm512_setr_epi32(0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3);
		const __m512i shifts2 = _mm512_setr_epi32(28, 28, 28, 28, 28, 28, 28, 28, 30, 30, 30, 30, 30, 30, 30, 30);
		const __m512i table = _mm512_loadu_si512(patterns2);
		const __m512i zero = _mm512_setzero_si512();
		for (size_t i = 0; i < n; i += 8) {
			const unsigned count = std::min<size_t>(8, n - i), valid = (1u << count) - 1;
			const __m512i packed =
			    count == 8 ? _mm512_loadu_si512(h + i) : _mm512_maskz_loadu_epi64(static_cast<__mmask8>(valid), h + i);
			const __m512i lo = _mm512_permutexvar_epi32(even, packed), hi = _mm512_permutexvar_epi32(odd, packed);
			const __m512i code = _mm512_rorv_epi32(lo, rotations);
			const __m512i mask = _mm512_rolv_epi32(_mm512_permutexvar_epi32(code, table), _mm512_srli_epi32(code, 4));
			const __m512i base = _mm512_and_si512(hi, _mm512_set1_epi32(word_mask_));
			const __m512i offsets = _mm512_and_si512(_mm512_srli_epi32(hi, 26), offset_mask);
			const __m512i index = _mm512_xor_si512(base, _mm512_xor_si512(quarters, offsets));
			const __mmask16 lanes = valid * 0x101u;
			const __m512i words = _mm512_mask_i32gather_epi32(zero, lanes, index, words_.data(), 4);
			const __m512i offsets2 = _mm512_and_si512(_mm512_srlv_epi32(hi, shifts2), _mm512_set1_epi32(3));
			const __m512i index2 =
			    _mm512_xor_si512(base, _mm512_xor_si512(_mm512_add_epi32(quarters, _mm512_set1_epi32(8)), offsets2));
			const __m512i code2 = _mm512_ror_epi32(code, 16);
			const __m512i mask2 =
			    _mm512_rolv_epi32(_mm512_permutexvar_epi32(code2, table), _mm512_srli_epi32(code2, 4));
			const __m512i words2 = _mm512_mask_i32gather_epi32(zero, lanes, index2, words_.data(), 4);
			unsigned pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(words, mask), mask) &
			                _mm512_cmpeq_epi32_mask(_mm512_and_si512(words2, mask2), mask2);
			pass &= pass >> 8;
			_mm512_mask_storeu_epi32(out + i, valid, _mm512_maskz_set1_epi32(pass, 1));
		}
		return n;
	}
	template <bool Prefetch>
	uint32_t LookupVector(uint32_t n, const uint64_t *h, uint32_t *out) const {
		const __m512i table2 = _mm512_loadu_si512(patterns2);
		size_t i = 0;
		for (; i + 16 <= n; i += 16) {
			if constexpr (Prefetch) {
				if (i + 80 <= n)
					for (unsigned j = 0; j < 16; ++j)
						__builtin_prefetch(words_.data() + ((h[i + 64 + j] >> 32) & word_mask_), 0, 3);
			}
			QueryChunk<false>(h + i, out + i, 0xffff, table2);
		}
		if (i < n)
			QueryChunk<true>(h + i, out + i, static_cast<__mmask16>((1u << (n - i)) - 1), table2);
		return n;
	}
#endif
};
} // namespace native_before
