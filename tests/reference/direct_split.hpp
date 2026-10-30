#pragma once
#include "base.h"
#include "layout_detail.h"
#include <array>
#include <vector>
#if defined(__SSE4_1__) || defined(__AVX2__)
#include <immintrin.h>
#endif

// ByteSplit128's mask is adapted from FastFilter/fastfilter_cpp's
// SimdBlockFilterFixed16 at commit 7c5bf187d5096ccbcec6a16e02975d0af3328b01.
// Copyright 2018 the fastfilter_cpp authors. Apache License, Version 2.0;
// see FastFilter-LICENSE. Upstream credits Apache Impala (incubating).
// Modified: typed aligned storage, direct power-of-two address reduction,
// scalar fallback/oracle support, and repository batch API. The original
// signed-mulhi16 / pshufb mask mapping is preserved exactly.
namespace direct_split_experiment {
struct alignas(16) ByteBucket { uint8_t bytes[16] {}; };
class ByteSplit128 {
	std::vector<ByteBucket, bloom_filters::AlignedAllocator<ByteBucket, 16>> buckets_;
	uint32_t block_mask_;
	static constexpr uint16_t salts_[8] = {0x47b5, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b};
	uint32_t Block(uint64_t hash) const { return static_cast<uint32_t>(hash >> 32) & block_mask_; }
	static std::array<uint8_t, 16> ScalarMask(uint64_t hash) {
		std::array<uint8_t, 16> mask {};
		for (unsigned j = 0; j < 8; ++j) {
			const uint32_t word = (hash >> ((j & 1) * 16)) & 65535;
			const int32_t signed_word = word < 32768 ? int32_t(word) : int32_t(word) - 65536;
			const int32_t salt = salts_[j] < 32768 ? int32_t(salts_[j]) : int32_t(salts_[j]) - 65536;
			const uint16_t high = static_cast<uint32_t>(signed_word * salt) >> 16;
			for (unsigned b = 0; b < 2; ++b) {
				const uint8_t control = high >> (8 * b);
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
	void InsertOne(uint64_t hash) {
		auto &bucket = buckets_[Block(hash)];
#if defined(__SSSE3__) && defined(__SSE4_1__)
		auto *p = reinterpret_cast<__m128i *>(bucket.bytes);
		_mm_store_si128(p, _mm_or_si128(_mm_load_si128(p), Mask(hash)));
#else
		const auto mask = ScalarMask(hash);
		for (size_t j = 0; j < 16; ++j) bucket.bytes[j] |= mask[j];
#endif
	}
	uint32_t LookupOne(uint64_t hash) const {
		const auto &bucket = buckets_[Block(hash)];
#if defined(__SSSE3__) && defined(__SSE4_1__)
		return _mm_testc_si128(_mm_load_si128(reinterpret_cast<const __m128i *>(bucket.bytes)), Mask(hash));
#else
		const auto mask = ScalarMask(hash);
		uint8_t missing = 0;
		for (size_t j = 0; j < 16; ++j) missing |= ~bucket.bytes[j] & mask[j];
		return missing == 0;
#endif
	}
public:
	ByteSplit128(size_t n, uint32_t bpk)
	    : buckets_(bloom_filters::layout_detail::WordCount(n, bpk) / 4), block_mask_(buckets_.size() - 1) {}
	size_t SizeInBytes() const { return buckets_.capacity() * sizeof(ByteBucket); }
	const void *Data() const { return buckets_.data(); }
	size_t LogicalBytes() const { return buckets_.size() * sizeof(ByteBucket); }
	void Insert(uint32_t n, const uint64_t *hashes) { for (size_t i = 0; i < n; ++i) InsertOne(hashes[i]); }
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i) out[i] = LookupOne(hashes[i]);
		return n;
	}
};

// Eight disjoint 5-bit fields select independent positions in eight u32
// sectors. Hash bits 41..63 address at most 2^23 buckets (256 MiB).
// Unlike multiply-salted split-block masks, all forty probe bits are retained.
struct alignas(32) WordBucket { uint32_t words[8] {}; };
class IndependentSplit32 {
	std::vector<WordBucket, bloom_filters::AlignedAllocator<WordBucket, 32>> buckets_;
	uint32_t block_mask_;
	uint32_t Block(uint64_t hash) const { return static_cast<uint32_t>(hash >> 41) & block_mask_; }
#if defined(__AVX2__)
	static __m256i Mask(uint64_t hash) {
		const __m256i fields = _mm256_srlv_epi64(_mm256_set1_epi64x(hash), _mm256_setr_epi64x(0, 10, 20, 30));
		const __m256i duplicated = _mm256_shuffle_epi32(fields, _MM_SHUFFLE(2, 2, 0, 0));
		const __m256i positions = _mm256_and_si256(
		    _mm256_srlv_epi32(duplicated, _mm256_setr_epi32(0, 5, 0, 5, 0, 5, 0, 5)), _mm256_set1_epi32(31));
		return _mm256_sllv_epi32(_mm256_set1_epi32(1), positions);
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
	IndependentSplit32(size_t n, uint32_t bpk)
	    : buckets_(bloom_filters::layout_detail::WordCount(n, bpk) / 8), block_mask_(buckets_.size() - 1) {}
	size_t SizeInBytes() const { return buckets_.capacity() * sizeof(WordBucket); }
	const void *Data() const { return buckets_.data(); }
	size_t LogicalBytes() const { return buckets_.size() * sizeof(WordBucket); }
	void Insert(uint32_t n, const uint64_t *hashes) { for (size_t i = 0; i < n; ++i) InsertOne(hashes[i]); }
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		for (size_t i = 0; i < n; ++i) out[i] = LookupOne(hashes[i]);
		return n;
	}
};

// Isolate dispatch overhead from the changed address/mask mapping. Giving the
// inlined base method a constant length avoids its general-loop setup for one
// key; the bitmap and every returned answer remain identical to the base type.
template <class Base>
class SingleShortcut : public Base {
public:
	using Base::Base;
	uint32_t Lookup(uint32_t n, const uint64_t *hashes, uint32_t *out) const {
		if (n == 1) return Base::Lookup(1, hashes, out);
		return Base::Lookup(n, hashes, out);
	}
};
} // namespace direct_split_experiment
