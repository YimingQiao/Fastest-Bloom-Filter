// Isolated Independent32 range-capacity candidate.
// Low40 probe fields/mask/insertion/query loops are unchanged.
// High24 disjoint address fields select a multiply-reduced 32-byte bucket.
#pragma once
#include "base.h"
#include "split64_range_size.h"
#include <vector>
#if defined(__AVX2__)
#include <immintrin.h>
#endif
namespace bloom_filters {
// Eight disjoint 5-bit fields select positions in eight u32 sectors.
// Bits0..39 are probes; bits40..63 address 2*floor(budget/64) buckets.
// The product is at most (2^24-1)*2^23 < 2^47. Every access is in range.
// Physical lines contain exactly two buckets; no partial line is allocated.
struct alignas(32) Independent32RangeBucket { uint32_t words[8] {}; };
class Independent32RangeBloomFilter {
	std::vector<Independent32RangeBucket, bloom_filters::AlignedAllocator<Independent32RangeBucket, 64>> buckets_;
	uint32_t bucket_count_;
	uint32_t Block(uint64_t hash) const {
		return static_cast<uint32_t>(((hash >> 40) * uint64_t(bucket_count_)) >> 24);
	}
#if defined(__AVX2__)
	static __m256i Mask(uint64_t hash) {
	#if defined(__AVX512VBMI__) && defined(__AVX512VL__)
		// Bytes select bits 0,5,...,35; rotate implicitly reduces each count mod32.
		const __m128i fields = _mm_multishift_epi64_epi8(
		    _mm_set1_epi64x(0x231e19140f0a0500LL), _mm_set1_epi64x(hash));
		return _mm256_rolv_epi32(_mm256_set1_epi32(1), _mm256_cvtepu8_epi32(fields));
	#else
		const __m256i fields = _mm256_srlv_epi64(_mm256_set1_epi64x(hash), _mm256_setr_epi64x(0, 10, 20, 30));
		const __m256i duplicated = _mm256_shuffle_epi32(fields, _MM_SHUFFLE(2, 2, 0, 0));
		const __m256i positions = _mm256_and_si256(
		    _mm256_srlv_epi32(duplicated, _mm256_setr_epi32(0, 5, 0, 5, 0, 5, 0, 5)), _mm256_set1_epi32(31));
		return _mm256_sllv_epi32(_mm256_set1_epi32(1), positions);
	#endif
	}
#endif
	void InsertOne(uint64_t hash) {
		auto &bucket = buckets_[Block(hash)];
#if defined(__AVX2__)
		auto *p = reinterpret_cast<__m256i *>(bucket.words);
		_mm256_store_si256(p, _mm256_or_si256(_mm256_load_si256(p), Mask(hash)));
#else
		for (size_t j = 0; j < 8; ++j) bucket.words[j] |= uint32_t {1} << ((hash >> (5 * j)) & 31);
#endif
	}
	uint32_t LookupOne(uint64_t hash) const {
		const auto &bucket = buckets_[Block(hash)];
#if defined(__AVX2__)
		return _mm256_testc_si256(_mm256_load_si256(reinterpret_cast<const __m256i *>(bucket.words)), Mask(hash));
#else
		uint32_t missing = 0;
		for (size_t j = 0; j < 8; ++j) missing |= ~bucket.words[j] & (uint32_t {1} << ((hash >> (5 * j)) & 31));
		return missing == 0;
#endif
	}
public:
	size_t CacheLineCount() const { return buckets_.size() / 2; }
	size_t CacheLineIndex(uint64_t hash) const { return Block(hash) / 2; }
	bool ContainsHash(uint64_t hash) const { return LookupOne(hash) != 0; }
	explicit Independent32RangeBloomFilter(RangeBytes budget)
	    : buckets_(range_detail::LineCount(budget.bytes) * 2), bucket_count_(buckets_.size()) {
		if (SizeInBytes() > budget.bytes)
			throw std::length_error("actual Independent32 range backing exceeds byte budget");
	}
	Independent32RangeBloomFilter(size_t n, uint32_t bpk)
	    : Independent32RangeBloomFilter(RangeBytes{range_detail::BudgetBytes(n, bpk)}) {}
	size_t SizeInBytes() const { return buckets_.capacity() * sizeof(Independent32RangeBucket); }
	const void *Data() const { return buckets_.data(); }
	size_t LogicalBytes() const { return buckets_.size() * sizeof(Independent32RangeBucket); }
	void Insert(uint32_t n, const uint64_t *hashes) { for (size_t i = 0; i < n; ++i) InsertOne(hashes[i]); }
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i) out[i] = LookupOne(hashes[i]);
		return n;
	}
};

}
