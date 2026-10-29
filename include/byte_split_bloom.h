// SPDX-License-Identifier: Apache-2.0
// Copyright 2018 the fastfilter_cpp authors.
// Mask adapted from FastFilter/fastfilter_cpp SimdBlockFilterFixed16, commit
// 7c5bf187d5096ccbcec6a16e02975d0af3328b01. Upstream credits Apache Impala
// (incubating). See ../third_party/FastFilter/LICENSE and NOTICE.
// Modified: direct power-of-two bucket addressing, owned cache-line storage,
// scalar fallback, batch/single-query API, and cache-line partition support.
#pragma once
#include "base.h"
#include "layout_detail.h"
#include <array>
#include <vector>
#if defined(__SSSE3__) && defined(__SSE4_1__)
#include <immintrin.h>
#endif
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON) && defined(__AARCH64EL__)
#include <arm_neon.h>
#endif

namespace bloom_filters {
// Four independent 16-byte buckets share each owned 64-byte cache line.
// Serial mutation requires exclusive access. Read-only queries can overlap once
// construction has completed; ParallelByteSplitBloomFilter partitions full lines.
class ByteSplitBloomFilter {
private:
	template <class>
	friend class ParallelLayoutBloomFilter;
	struct alignas(16) Bucket {
		uint8_t bytes[16] {};
	};
	struct alignas(64) Line {
		Bucket buckets[4];
	};
	static_assert(sizeof(Bucket) == 16 && sizeof(Line) == 64, "dense byte-split layout");
	std::vector<Line, AlignedAllocator<Line, 64>> lines_;
	uint32_t bucket_mask_;
	inline static constexpr uint16_t salts_[8] = {0x47b5, 0x4497, 0x8823, 0xa2b7,
	                                             0x7053, 0x2df1, 0x9efc, 0x5c6b};
	uint32_t BucketIndex(uint64_t hash) const {
		return static_cast<uint32_t>(hash >> 32) & bucket_mask_;
	}
	size_t CacheLineCount() const {
		return lines_.size();
	}
	size_t CacheLineIndex(uint64_t hash) const {
		return BucketIndex(hash) >> 2;
	}
	static std::array<uint8_t, 16> ScalarMask(uint64_t hash) {
		std::array<uint8_t, 16> mask {};
		for (unsigned j = 0; j < 8; ++j) {
			const uint32_t word = (hash >> ((j & 1) * 16)) & 65535;
			const int32_t signed_word = word < 32768 ? int32_t(word) : int32_t(word) - 65536;
			const int32_t salt = salts_[j] < 32768 ? int32_t(salts_[j]) : int32_t(salts_[j]) - 65536;
			// Signed i16 products fit i32. Unsigned conversion before the shift
			// makes the signed-high-word encoding independent of signed shifts.
			const uint16_t high = static_cast<uint32_t>(signed_word * salt) >> 16;
			for (unsigned b = 0; b < 2; ++b) {
				const uint8_t control = high >> (8 * b);
				// pshufb zeros lanes whose control sign bit is set. Preserve those
				// zero masks, including hashes with an entirely empty query mask.
				mask[j * 2 + b] = (control & 128) ? 0 : (128 >> (control & 7));
			}
		}
		return mask;
	}
#if defined(__SSSE3__) && defined(__SSE4_1__)
	static __m128i Mask(uint64_t hash) {
		const __m128i salts = _mm_setr_epi16(0x47b5, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b);
		const __m128i products = _mm_mulhi_epi16(salts, _mm_set1_epi32(static_cast<uint32_t>(hash)));
		return _mm_shuffle_epi8(_mm_set_epi8(1, 2, 4, 8, 16, 32, 64, -128, 1, 2, 4, 8, 16, 32, 64, -128), products);
	}
#endif
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON) && defined(__AARCH64EL__)
	static uint8x16_t NeonMask(uint64_t hash) {
		const int16x8_t salts = {18357, 17559, -30685, -23881, 28755, 11761, -24836, 23659};
		const int16x8_t words = vreinterpretq_s16_u32(vdupq_n_u32(static_cast<uint32_t>(hash)));
		// No salt is -32768: doubling these signed products cannot saturate.
		// Arithmetic halving of SQDMULH is exactly the signed high 16 bits.
		const uint8x16_t products = vreinterpretq_u8_s16(vshrq_n_s16(vqdmulhq_s16(words, salts), 1));
		const uint8x16_t table = {128, 64, 32, 16, 8, 4, 2, 1, 128, 64, 32, 16, 8, 4, 2, 1};
		// TBL zeros out-of-range indices. Keep the pshufb sign bit so that
		// signed controls, including the all-zero mask, match x86 exactly.
		return vqtbl1q_u8(table, vandq_u8(products, vdupq_n_u8(0x8f)));
	}
#endif
	void InsertOne(uint64_t hash) {
		const uint32_t index = BucketIndex(hash);
#if defined(__SSSE3__) && defined(__SSE4_1__)
		// The dense owned allocation contains exactly four buckets per line.
		// index <= bucket_mask_ keeps this aligned 16-byte access within it.
		// A flat byte offset avoids separate line/slot address instructions.
		auto *p = reinterpret_cast<__m128i *>(reinterpret_cast<uint8_t *>(lines_.data()) + size_t(index) * 16);
		_mm_store_si128(p, _mm_or_si128(_mm_load_si128(p), Mask(hash)));
#elif defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON) && defined(__AARCH64EL__)
		auto *p = lines_[index >> 2].buckets[index & 3].bytes;
		vst1q_u8(p, vorrq_u8(vld1q_u8(p), NeonMask(hash)));
#else
		auto &bucket = lines_[index >> 2].buckets[index & 3];
		const auto mask = ScalarMask(hash);
		for (size_t j = 0; j < 16; ++j)
			bucket.bytes[j] |= mask[j];
#endif
	}
	uint32_t LookupOne(uint64_t hash) const {
		const uint32_t index = BucketIndex(hash);
#if defined(__SSSE3__) && defined(__SSE4_1__)
		const auto *p = reinterpret_cast<const __m128i *>(reinterpret_cast<const uint8_t *>(lines_.data()) + size_t(index) * 16);
		return _mm_testc_si128(_mm_load_si128(p), Mask(hash));
#elif defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON) && defined(__AARCH64EL__)
		const auto *p = lines_[index >> 2].buckets[index & 3].bytes;
		return vmaxvq_u8(vbicq_u8(NeonMask(hash), vld1q_u8(p))) == 0;
#else
		const auto &bucket = lines_[index >> 2].buckets[index & 3];
		const auto mask = ScalarMask(hash);
		uint8_t missing = 0;
		for (size_t j = 0; j < 16; ++j)
			missing |= ~bucket.bytes[j] & mask[j];
		return missing == 0;
#endif
	}

#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON) && defined(__AARCH64EL__)
	void InsertNeonPrefetched(uint32_t n, const uint64_t *hashes) {
		// Loads/ORs/stores stay in input order, even when buckets collide.
#if defined(__clang__)
#pragma clang loop unroll_count(4)
#endif
		for (size_t i = 0; i < n; ++i) {
			if (i + 64 < n)
				__builtin_prefetch(&lines_[BucketIndex(hashes[i + 64]) >> 2], 1, 3);
			InsertOne(hashes[i]);
		}
	}
	template <bool Prefetch>
	uint32_t LookupNeon(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
#if defined(__clang__)
#pragma clang loop unroll_count(4)
#endif
		for (size_t i = 0; i < n; ++i) {
			if constexpr (Prefetch) {
				if (i + 64 < n)
					__builtin_prefetch(&lines_[BucketIndex(hashes[i + 64]) >> 2], 0, 3);
			}
			out[i] = LookupOne(hashes[i]);
		}
		return n;
	}
#endif

public:
	explicit ByteSplitBloomFilter(size_t n, uint32_t bpk)
	    : lines_(layout_detail::WordCount(n, bpk) / 16), bucket_mask_(lines_.size() * 4 - 1) {
	}
	size_t SizeInBytes() const {
		return lines_.capacity() * sizeof(Line);
	}
	void Insert(uint32_t n, const uint64_t *hashes) {
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON) && defined(__AARCH64EL__)
		if (n > 64 && SizeInBytes() > (1u << 21)) {
			InsertNeonPrefetched(n, hashes);
			return;
		}
#endif
		for (size_t i = 0; i < n; ++i)
			InsertOne(hashes[i]);
	}
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		if (n == 1) {
			out[0] = LookupOne(hashes[0]);
			return 1;
		}
#if defined(__aarch64__) && defined(__ARM_NEON) && !defined(BF_DISABLE_NEON) && defined(__AARCH64EL__)
		if (n > 64 && SizeInBytes() > (1u << 21))
			return LookupNeon<true>(n, hashes, out);
		return LookupNeon<false>(n, hashes, out);
#endif
		for (size_t i = 0; i < n; ++i)
			out[i] = LookupOne(hashes[i]);
		return n;
	}
};
} // namespace bloom_filters
