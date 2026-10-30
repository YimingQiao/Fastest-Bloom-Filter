#pragma once
#include "base.h"
#include "layout_detail.h"
#include <algorithm>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
#if defined(__AVX2__)
#include <immintrin.h>
#endif

// Widened split-block filter: the public Parquet/Impala multiply-
// shift construction, but eight 64-bit sectors instead of eight 32-bit sectors.
// This is not a Parquet-compatible layout or a claim of a new filter family.
namespace bloom_filters {
class NativeSplitAfterBF {
	static constexpr size_t Prefetch = 32;
	template <class>
	friend class ParallelLayoutBloomFilter;
	size_t CacheLineCount() const {
		return lines_.size();
	}
	size_t CacheLineIndex(uint64_t hash) const {
		return Block(hash);
	}
	struct alignas(64) Line {
		uint64_t words[8] {};
	};
	std::vector<Line, AlignedAllocator<Line, 64>> lines_;
	uint32_t block_mask_;
	alignas(32) inline static constexpr uint32_t salts_[8] = {0x47b6137bU, 0x44974d91U, 0x8824ad5bU, 0xa2b7289dU,
	                                                          0x705495c7U, 0x2df1424bU, 0x9efc4947U, 0x5c6bfb31U};
	uint32_t Block(uint64_t hash) const {
		return static_cast<uint32_t>(hash >> 32) & block_mask_;
	}
#if defined(__AVX512F__)
	static __m512i Mask(uint64_t hash) {
		const __m256i positions =
		    _mm256_srli_epi32(_mm256_mullo_epi32(_mm256_set1_epi32(static_cast<uint32_t>(hash)),
			                                     _mm256_load_si256(reinterpret_cast<const __m256i *>(salts_))),
			                  26);
		return _mm512_sllv_epi64(_mm512_set1_epi64(1), _mm512_cvtepu32_epi64(positions));
	}
	static __m512i WideMask(uint64_t hash) {
		const __m512i wide_salts = _mm512_setr_epi64(0x47b6137bULL, 0x44974d91ULL, 0x8824ad5bULL, 0xa2b7289dULL,
		                                             0x705495c7ULL, 0x2df1424bULL, 0x9efc4947ULL, 0x5c6bfb31ULL);
		// Both odd u32 lanes are zero: each u64 holds the wrapped low-u32 product.
		const __m512i products = _mm512_mullo_epi32(_mm512_set1_epi64(static_cast<uint32_t>(hash)), wide_salts);
		const __m512i positions = _mm512_srli_epi64(products, 26);
		return _mm512_sllv_epi64(_mm512_set1_epi64(1), positions);
	}
#endif
#if defined(__AVX2__) && !defined(__AVX512F__)
	static void Mask256(uint64_t hash, __m256i &low, __m256i &high) {
		const __m256i positions =
		    _mm256_srli_epi32(_mm256_mullo_epi32(_mm256_set1_epi32(static_cast<uint32_t>(hash)),
			                                     _mm256_load_si256(reinterpret_cast<const __m256i *>(salts_))),
			                  26);
		low = _mm256_sllv_epi64(_mm256_set1_epi64x(1), _mm256_cvtepu32_epi64(_mm256_castsi256_si128(positions)));
		high = _mm256_sllv_epi64(_mm256_set1_epi64x(1), _mm256_cvtepu32_epi64(_mm256_extracti128_si256(positions, 1)));
	}
#endif
	void InsertOne(uint64_t hash) {
		auto &line = lines_[Block(hash)];
#if defined(__AVX512F__)
		const __m512i mask = Mask(hash);
		auto *dst = reinterpret_cast<__m512i *>(line.words);
		_mm512_store_si512(dst, _mm512_or_si512(_mm512_load_si512(dst), mask));
#elif defined(__AVX2__)
		__m256i low, high;
		Mask256(hash, low, high);
		auto *dst = reinterpret_cast<__m256i *>(line.words);
		_mm256_store_si256(dst, _mm256_or_si256(_mm256_load_si256(dst), low));
		_mm256_store_si256(dst + 1, _mm256_or_si256(_mm256_load_si256(dst + 1), high));
#else
		for (size_t j = 0; j < 8; ++j)
			line.words[j] |= uint64_t {1} << ((static_cast<uint32_t>(hash) * salts_[j]) >> 26);
#endif
	}
	uint32_t LookupOne(uint64_t hash) const {
		const auto &line = lines_[Block(hash)];
#if defined(__AVX512F__)
		return _mm512_testn_epi64_mask(_mm512_load_si512(line.words), Mask(hash)) == 0;
#elif defined(__AVX2__)
		__m256i low, high;
		Mask256(hash, low, high);
		const auto *src = reinterpret_cast<const __m256i *>(line.words);
		return _mm256_testc_si256(_mm256_load_si256(src), low) & _mm256_testc_si256(_mm256_load_si256(src + 1), high);
#else
		uint64_t missing = 0;
		for (size_t j = 0; j < 8; ++j)
			missing |= ~line.words[j] & (uint64_t {1} << ((static_cast<uint32_t>(hash) * salts_[j]) >> 26));
		return missing == 0;
#endif
	}

	uint32_t LookupOneWide(uint64_t hash) const {
		const auto &line = lines_[Block(hash)];
#if defined(__AVX512F__)
		return _mm512_testn_epi64_mask(_mm512_load_si512(line.words), WideMask(hash)) == 0;
#elif defined(__AVX2__)
		__m256i low, high;
		Mask256(hash, low, high);
		const auto *src = reinterpret_cast<const __m256i *>(line.words);
		return _mm256_testc_si256(_mm256_load_si256(src), low) & _mm256_testc_si256(_mm256_load_si256(src + 1), high);
#else
		uint64_t missing = 0;
		for (size_t j = 0; j < 8; ++j)
			missing |= ~line.words[j] & (uint64_t {1} << ((static_cast<uint32_t>(hash) * salts_[j]) >> 26));
		return missing == 0;
#endif
	}

public:
	explicit NativeSplitAfterBF(size_t n, uint32_t bpk)
	    : lines_(layout_detail::WordCount(n, bpk) / 16), block_mask_(lines_.size() - 1) {
	}
	size_t SizeInBytes() const {
		return lines_.size() * 64;
	}
	void Insert(uint32_t n, const uint64_t *hashes) {
		size_t i = 0;
		if constexpr (Prefetch) {
			for (; i + Prefetch < n; ++i) {
				__builtin_prefetch(&lines_[Block(hashes[i + Prefetch])], 1, 3);
				InsertOne(hashes[i]);
			}
		}
		for (; i < n; ++i)
			InsertOne(hashes[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		if (n == 1) {
			out[0] = LookupOne(hashes[0]);
			return 1;
		}
#if defined(__AVX512F__)
		if (n < 16) {
			for (size_t i = 0; i < n; ++i)
				out[i] = LookupOneWide(hashes[i]);
			return n;
		}
#endif
		size_t i = 0;
		if constexpr (Prefetch) {
			for (; i + Prefetch < n; ++i) {
				__builtin_prefetch(&lines_[Block(hashes[i + Prefetch])], 0, 3);
				out[i] = LookupOne(hashes[i]);
			}
		}
		for (; i < n; ++i)
			out[i] = LookupOne(hashes[i]);
		return n;
	}
};
} // namespace bloom_filters
