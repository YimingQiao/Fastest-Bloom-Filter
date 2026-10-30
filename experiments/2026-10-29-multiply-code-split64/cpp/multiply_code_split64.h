#pragma once
#include "base.h"
#include "range_size.hpp"
#include <algorithm>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
#if defined(__AVX2__)
#include <immintrin.h>
#endif

// Experimental fixed low32-to-u64 multiplication, then eight six-bit byte fields.
// The sector positions share only32 input bits and are NOT assumed independent.
// High32 range addressing remains disjoint from every mask input bit.
namespace bloom_filters {
class MultiplyCodeSplit64Range {
	static constexpr size_t Prefetch = 32;
	friend struct RangeLayoutInspector;
public:
	size_t CacheLineCount() const {
		return lines_.size();
	}
	size_t CacheLineIndex(uint64_t hash) const {
		return Block(hash);
	}
private:
	struct alignas(64) Line {
		uint64_t words[8] {};
	};
	std::vector<Line, AlignedAllocator<Line, 64>> lines_;
	uint32_t block_count_;
    inline static constexpr uint64_t multiplier_ = 0x9e3779b97f4a7c15ULL;
    static uint64_t Code(uint64_t hash) {
        return uint64_t(uint32_t(hash)) * multiplier_;
    }
    static uint32_t Position(uint64_t hash, size_t sector) {
        return (Code(hash) >> (sector * 8)) & 63;
    }
	uint32_t Block(uint64_t hash) const {
		return (uint64_t(static_cast<uint32_t>(hash >> 32)) * block_count_) >> 32;
	}
#if defined(__AVX512F__)
    static __m512i Mask(uint64_t hash) {
        const __m512i code = _mm512_set1_epi64(static_cast<long long>(Code(hash)));
        const __m512i positions = _mm512_srlv_epi64(code, _mm512_setr_epi64(0,8,16,24,32,40,48,56));
        // VPROLVQ reduces the count modulo64; explicit AND is unnecessary here.
        return _mm512_rolv_epi64(_mm512_set1_epi64(1), positions);
    }
    static __m512i WideMask(uint64_t hash) { return Mask(hash); }
#endif
#if defined(__AVX2__) && !defined(__AVX512F__)
    static void Mask256(uint64_t hash, __m256i &low, __m256i &high) {
        const __m256i code = _mm256_set1_epi64x(static_cast<long long>(Code(hash)));
        const __m256i a = _mm256_and_si256(_mm256_srlv_epi64(code, _mm256_setr_epi64x(0,8,16,24)), _mm256_set1_epi64x(63));
        const __m256i b = _mm256_and_si256(_mm256_srlv_epi64(code, _mm256_setr_epi64x(32,40,48,56)), _mm256_set1_epi64x(63));
        low = _mm256_sllv_epi64(_mm256_set1_epi64x(1), a);
        high = _mm256_sllv_epi64(_mm256_set1_epi64x(1), b);
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
			line.words[j] |= uint64_t {1} << Position(hash, j);
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
			missing |= ~line.words[j] & (uint64_t {1} << Position(hash, j));
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
			missing |= ~line.words[j] & (uint64_t {1} << Position(hash, j));
		return missing == 0;
#endif
	}

public:
	explicit MultiplyCodeSplit64Range(RangeBytes budget)
	    : lines_(range_detail::LineCount(budget.bytes)), block_count_(lines_.size()) {
		if (SizeInBytes() > budget.bytes) throw std::length_error("actual backing exceeds budget");
	}
	explicit MultiplyCodeSplit64Range(size_t n, uint32_t bpk)
	    : MultiplyCodeSplit64Range(RangeBytes{range_detail::BudgetBytes(n, bpk)}) {
	}
	size_t SizeInBytes() const {
		return lines_.capacity() * sizeof(Line);
	}
	bool ContainsHash(uint64_t hash) const { return LookupOne(hash); }
	const void *Data() const { return lines_.front().words; }
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
