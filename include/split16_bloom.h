// SPDX-License-Identifier: Apache-2.0
// Copyright 2018 the fastfilter_cpp authors.
// Eight-u16 mask adapted from FastFilter/fastfilter_cpp's AArch64
// SimdBlockFilterFixed, commit 7c5bf187d5096ccbcec6a16e02975d0af3328b01.
// Upstream credits Apache Impala (incubating). See third_party/FastFilter.
// Modified: direct addressing, owned storage, portable reference kernel,
// bounded batch prefetch, and exclusive parallel construction support.
#pragma once
#include "base.h"
#include "layout_detail.h"
#include <vector>
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON)
#include <arm_neon.h>
#endif

namespace bloom_filters {
// Eight 16-bit sectors in each 16-byte bucket; four buckets per storage line.
// Requires uniform 64-bit hashes. Insertion is exclusive; completed filters can
// be queried concurrently. This is a different bitmap mapping from ByteSplit.
class Split16BloomFilter {
private:
	template <class> friend class ParallelLayoutBloomFilter;
	struct alignas(16) Bucket { uint16_t words[8] {}; };
	struct alignas(64) Line { Bucket buckets[4]; };
	static_assert(sizeof(Bucket) == 16 && sizeof(Line) == 64, "dense split16 layout");
	std::vector<Line, AlignedAllocator<Line, 64>> lines_;
	uint32_t bucket_mask_;
	inline static constexpr uint16_t salts_[8] = {0x79d8, 0xe722, 0xf2fb, 0x21ec,
	                                             0x121b, 0x2302, 0x705a, 0x6e87};
	uint32_t BucketIndex(uint64_t h) const { return uint32_t(h >> 32) & bucket_mask_; }
	size_t CacheLineCount() const { return lines_.size(); }
	size_t CacheLineIndex(uint64_t h) const { return BucketIndex(h) >> 2; }
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON)
	static uint16x8_t Mask(uint64_t h) {
		const uint16x8_t products = vmulq_u16(vdupq_n_u16(uint16_t(h)), vld1q_u16(salts_));
		return vshlq_u16(vdupq_n_u16(1), vreinterpretq_s16_u16(vshrq_n_u16(products, 12)));
	}
#endif
	void InsertOne(uint64_t h) {
		const auto index = BucketIndex(h);
		auto *p = lines_[index >> 2].buckets[index & 3].words;
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON)
		vst1q_u16(p, vorrq_u16(vld1q_u16(p), Mask(h)));
#else
		for (unsigned j = 0; j < 8; ++j)
			p[j] |= uint16_t(1u << (uint16_t(uint32_t(uint16_t(h)) * salts_[j]) >> 12));
#endif
	}
	uint32_t LookupOne(uint64_t h) const {
		const auto index = BucketIndex(h);
		const auto *p = lines_[index >> 2].buckets[index & 3].words;
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON)
		const auto missing = vreinterpretq_u64_u16(vbicq_u16(Mask(h), vld1q_u16(p)));
		// Saturating narrowing preserves zero/nonzero in both 64-bit halves.
		return vget_lane_u64(vreinterpret_u64_u32(vqmovn_u64(missing)), 0) == 0;
#else
		uint16_t missing = 0;
		for (unsigned j = 0; j < 8; ++j)
			missing |= uint16_t(~p[j]) & uint16_t(1u << (uint16_t(uint32_t(uint16_t(h)) * salts_[j]) >> 12));
		return missing == 0;
#endif
	}
	template <bool Prefetch>
	void InsertBatch(uint32_t n, const uint64_t *h) {
#if defined(__clang__)
#pragma clang loop unroll_count(4)
#endif
		for (size_t i = 0; i < n; ++i) {
			if constexpr (Prefetch) {
				if (i + 64 < n) __builtin_prefetch(&lines_[BucketIndex(h[i + 64]) >> 2], 1, 3);
			}
			// Ordered read-modify-write operations preserve colliding updates.
			InsertOne(h[i]);
		}
	}
	template <bool Prefetch>
	uint32_t LookupBatch(uint32_t n, const uint64_t *h, uint32_t *out) const {
#if defined(__clang__)
#pragma clang loop unroll_count(4)
#endif
		for (size_t i = 0; i < n; ++i) {
			if constexpr (Prefetch) {
				if (i + 64 < n) __builtin_prefetch(&lines_[BucketIndex(h[i + 64]) >> 2], 0, 3);
			}
			out[i] = LookupOne(h[i]);
		}
		return n;
	}
public:
	explicit Split16BloomFilter(size_t n, uint32_t bpk)
	    : lines_(layout_detail::WordCount(n, bpk) / 16), bucket_mask_(lines_.size() * 4 - 1) {}
	size_t SizeInBytes() const { return lines_.capacity() * sizeof(Line); }
	void Insert(uint32_t n, const uint64_t *hashes) {
		if (n > 64 && SizeInBytes() > (1u << 23)) InsertBatch<true>(n, hashes);
		else InsertBatch<false>(n, hashes);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		if (n == 1) { out[0] = LookupOne(hashes[0]); return 1; }
		if (n > 64 && SizeInBytes() > (1u << 21)) return LookupBatch<true>(n, hashes, out);
		return LookupBatch<false>(n, hashes, out);
	}
};
} // namespace bloom_filters
