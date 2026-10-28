#pragma once

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
#include "base.h"
#if defined(__AVX2__)
#include <immintrin.h>
#endif

namespace bloom_filters {

// Two 32-bit sectors in one cache line, with 32 cyclic mask patterns per sector.
// Six probes below 12 actual bits/key, eight otherwise; uniformly prehashed input.
// High hash bits select the first sector; disjoint low fields select masks and
// the second sector. Single-writer construction; read-only lookups can be shared.
class FastPatternBF {
public:
	explicit FastPatternBF(size_t keys, uint32_t bits_per_key) {
		const size_t words = WordCount(keys, bits_per_key);
		blocks_.resize(words);
		block_mask_ = static_cast<uint32_t>(words - 1);
		patterns_ = keys > words * 32 / 12 ? sparse_patterns_ : dense_patterns_;
	}
	size_t SizeInBytes() const {
		return blocks_.size() * sizeof(uint32_t);
	}
	void Insert(uint32_t num, const uint64_t *keys) {
		if (SizeInBytes() > (1u << 21))
			InsertImpl<true>(num, keys);
		else
			InsertImpl<false>(num, keys);
	}
	uint32_t Lookup(uint32_t num, const uint64_t *keys, uint32_t *out) const {
		if (SizeInBytes() > (1u << 21))
			LookupImpl<true>(num, keys, out);
		else
			LookupImpl<false>(num, keys, out);
		return num;
	}

private:
	friend class ParallelFastPatternBF;
	friend class AtomicFastPatternBF;
	static size_t WordCount(size_t keys, uint32_t bits_per_key) {
		if (!bits_per_key || keys > std::numeric_limits<size_t>::max() / bits_per_key)
			throw std::invalid_argument("invalid Bloom filter size");
		const size_t bits = std::max<size_t>(512, keys * bits_per_key);
		if (bits >= (size_t {1} << 31))
			throw std::length_error("sectorized layout supports at most 256 MiB");
		size_t words = 32;
		while (words <= bits / 32)
			words *= 2;
		return words;
	}

#if defined(__AVX512F__)
	struct Probe {
		__m512i index, mask;
	};
	Probe Prepare(const uint64_t *keys) const {
		const __m512i h = _mm512_loadu_si512(keys);
		// Insert preparation keeps the two sectors of each key in adjacent lanes.
		const __m512i a =
		    _mm512_and_si512(_mm512_shuffle_epi32(h, static_cast<_MM_PERM_ENUM>(0xf5)), _mm512_set1_epi32(block_mask_));
		const __m512i delta =
		    _mm512_or_si512(_mm512_set1_epi64(uint64_t {8} << 32),
			                _mm512_and_si512(_mm512_slli_epi64(h, 12), _mm512_set1_epi64(uint64_t {7} << 32)));
		const __m512i index = _mm512_xor_si512(a, delta);
		const __m512i code = _mm512_srlv_epi32(_mm512_shuffle_epi32(h, static_cast<_MM_PERM_ENUM>(0xa0)),
		                                       _mm512_set1_epi64(uint64_t {10} << 32));
		const __m512i table0 = _mm512_loadu_si512(patterns_);
		const __m512i table1 = _mm512_loadu_si512(patterns_ + 16);
		const __m512i mask =
		    _mm512_rolv_epi32(_mm512_permutex2var_epi32(table0, code, table1), _mm512_srli_epi32(code, 5));
		return {index, mask};
	}
#endif

	template <bool Prefetch>
	void InsertImpl(uint32_t num, const uint64_t *keys) {
		size_t i = 0;
#if defined(__AVX512F__)
		alignas(64) uint32_t indexes[16], masks[16];
		for (; i + 8 <= num; i += 8) {
			if constexpr (Prefetch) {
				if (i + 72 <= num)
					for (size_t j = 0; j < 8; ++j)
						__builtin_prefetch(blocks_.data() + Block(keys[i + 64 + j]), 1, 1);
			}
			const Probe p = Prepare(keys + i);
			_mm512_store_si512(indexes, p.index);
			_mm512_store_si512(masks, p.mask);
			// Scatter cannot implement colliding read-modify-write ORs safely.
			for (size_t j = 0; j < 16; ++j)
				blocks_[indexes[j]] |= masks[j];
		}
#endif
		for (; i < num; ++i) {
			const uint64_t h = keys[i];
			const uint32_t a = Block(h);
			blocks_[a] |= Pattern(static_cast<uint32_t>(h));
			blocks_[a ^ (8u + ((static_cast<uint32_t>(h) >> 20) & 7))] |= Pattern(static_cast<uint32_t>(h) >> 10);
		}
	}

	template <bool Prefetch>
	void LookupImpl(uint32_t num, const uint64_t *BF_RESTRICT keys, uint32_t *BF_RESTRICT out) const {
		size_t i = 0;
#if defined(__AVX512F__)
		const __m512i even = _mm512_setr_epi32(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30);
		const __m512i odd = _mm512_add_epi32(even, _mm512_set1_epi32(1));
		const __m512i table0 = _mm512_loadu_si512(patterns_);
		const __m512i table1 = _mm512_loadu_si512(patterns_ + 16);
		for (; i + 16 <= num; i += 16) {
			if constexpr (Prefetch) {
				if (i + 80 <= num)
					for (size_t j = 0; j < 16; ++j)
						__builtin_prefetch(blocks_.data() + Block(keys[i + 64 + j]), 0, 3);
			}
			const __m512i x = _mm512_loadu_si512(keys + i), y = _mm512_loadu_si512(keys + i + 8);
			const __m512i lo = _mm512_permutex2var_epi32(x, even, y);
			const __m512i hi = _mm512_permutex2var_epi32(x, odd, y);
			const __m512i a = _mm512_and_si512(hi, _mm512_set1_epi32(block_mask_));
			const __m512i b =
			    _mm512_xor_si512(a, _mm512_or_si512(_mm512_set1_epi32(8),
				                                    _mm512_and_si512(_mm512_srli_epi32(lo, 20), _mm512_set1_epi32(7))));
			const __m512i m1 =
			    _mm512_rolv_epi32(_mm512_permutex2var_epi32(table0, lo, table1), _mm512_srli_epi32(lo, 5));
			const __m512i m2 = _mm512_rolv_epi32(_mm512_permutex2var_epi32(table0, _mm512_srli_epi32(lo, 10), table1),
			                                     _mm512_srli_epi32(lo, 15));
			const __m512i v1 = _mm512_i32gather_epi32(a, blocks_.data(), 4);
			const __m512i v2 = _mm512_i32gather_epi32(b, blocks_.data(), 4);
			const __mmask16 pass = _mm512_cmpeq_epi32_mask(_mm512_and_si512(v1, m1), m1) &
			                       _mm512_cmpeq_epi32_mask(_mm512_and_si512(v2, m2), m2);
			_mm512_storeu_si512(out + i, _mm512_maskz_set1_epi32(pass, 1));
		}
#endif
		for (; i < num; ++i) {
			const uint64_t h = keys[i];
			const uint32_t a = Block(h);
			const uint32_t m1 = Pattern(static_cast<uint32_t>(h)), m2 = Pattern(static_cast<uint32_t>(h) >> 10);
			out[i] =
			    ((blocks_[a] & m1) == m1) & ((blocks_[a ^ (8u + ((static_cast<uint32_t>(h) >> 20) & 7))] & m2) == m2);
		}
	}
	uint32_t Block(uint64_t h) const {
		return (h >> 32) & block_mask_;
	}
	static uint32_t Rotate(uint32_t v, uint32_t r) {
		return (v << (r & 31)) | (v >> ((-r) & 31));
	}
	uint32_t Pattern(uint32_t code) const {
		return Rotate(patterns_[code & 31], code >> 5);
	}
	inline static constexpr uint32_t sparse_patterns_[32] = {
	    0xbu,   0x211u,   0x2041u, 0x40101u, 0x1003u,  0x8005u,  0x10011u, 0x109u,   0x8041u, 0x40081u, 0x403u,
	    0x25u,  0x411u,   0x8081u, 0x2003u,  0x4009u,  0x10005u, 0x811u,   0x2021u,  0x8201u, 0x1005u,  0x13u,
	    0x821u, 0x20081u, 0x203u,  0x4005u,  0x10009u, 0x1011u,  0x4021u,  0x20041u, 0x409u,  0x4003u};
	inline static constexpr uint32_t dense_patterns_[32] = {
	    0x8bu,    0x402021u, 0x5003u,  0x10091u, 0x4109u,  0x8023u,   0x8105u,  0x200403u, 0x40025u, 0x1411u,  0x80c1u,
	    0x22009u, 0x210201u, 0x53u,    0x40103u, 0x2205u,  0x100121u, 0x80803u, 0x41201u,  0x20811u, 0x10805u, 0x81005u,
	    0x641u,   0x3101u,   0x24041u, 0x4085u,  0x12401u, 0x202011u, 0x2a1u,   0xc09u,    0x20007u, 0x80421u};
	const uint32_t *patterns_;
	uint32_t block_mask_;
	std::vector<uint32_t, AlignedAllocator<uint32_t, 64>> blocks_;
};
} // namespace bloom_filters
