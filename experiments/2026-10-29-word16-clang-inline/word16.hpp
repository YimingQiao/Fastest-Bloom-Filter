// SPDX-License-Identifier: Apache-2.0
// Experimental storage scaffold and first eight salts derived from the project's
// ByteSplit work, itself adapted from FastFilter Fixed16 (Copyright 2018 the
// fastfilter_cpp authors, commit 7c5bf187d5096ccbcec6a16e02975d0af3328b01).
// See ../../third_party/FastFilter/{LICENSE,NOTICE}.
// New mapping: sixteen u16 sectors, one nonzero bit in each; low16 multiplication
// and a four-bit position replace the signed-high/byte-shuffle construction.
#pragma once
#include "base.h"
#include "layout_detail.h"
#include <array>
#include <vector>
#if defined(__AVX2__) && defined(__AVX512BW__) && defined(__AVX512VL__) && !defined(BF_WORD16_FORCE_SCALAR)
#include <immintrin.h>
#define BF_WORD16_SIMD 1
#endif

class Word16Split256Experiment {
    struct alignas(32) Bucket { std::array<uint16_t, 16> words {}; };
    static_assert(sizeof(Bucket) == 32, "one dense 32-byte bucket");
    std::vector<Bucket, bloom_filters::AlignedAllocator<Bucket, 64>> buckets_;
    uint32_t bucket_mask_;
    inline static constexpr uint16_t salts_[16] = {
        0x47b5, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b,
        0x3c6f, 0x9e37, 0xb529, 0x85eb, 0x1657, 0xc2b3, 0xd1b5, 0x7f4b
    };
    size_t Block(uint64_t h) const { return (h >> 32) & bucket_mask_; }
    static std::array<uint16_t, 16> ScalarMask(uint64_t h) {
        std::array<uint16_t, 16> mask {};
        for (unsigned i = 0; i < 16; ++i) {
            const uint32_t word = uint16_t(h >> (16 * (i & 1)));
            const uint16_t product = word * salts_[i];
            mask[i] = uint16_t(1u << (product >> 12));
        }
        return mask;
    }
#ifdef BF_WORD16_SIMD
    static __m256i Mask(uint64_t h) {
        const auto salts = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(salts_));
        const auto products = _mm256_mullo_epi16(salts, _mm256_set1_epi32(uint32_t(h)));
        const auto positions = _mm256_srli_epi16(products, 12);
        return _mm256_sllv_epi16(_mm256_set1_epi16(1), positions);
    }
#endif
    void InsertOne(uint64_t h) {
        auto &bucket = buckets_[Block(h)];
#ifdef BF_WORD16_SIMD
        auto *p = reinterpret_cast<__m256i *>(bucket.words.data());
        _mm256_store_si256(p, _mm256_or_si256(_mm256_load_si256(p), Mask(h)));
#else
        const auto mask = ScalarMask(h);
        for (unsigned i = 0; i < 16; ++i) bucket.words[i] |= mask[i];
#endif
    }
    uint32_t One(uint64_t h) const {
        const auto &bucket = buckets_[Block(h)];
#ifdef BF_WORD16_SIMD
        return _mm256_testc_si256(
            _mm256_load_si256(reinterpret_cast<const __m256i *>(bucket.words.data())), Mask(h));
#else
        const auto mask = ScalarMask(h);
        uint16_t missing = 0;
        for (unsigned i = 0; i < 16; ++i) missing |= ~bucket.words[i] & mask[i];
        return missing == 0;
#endif
    }
public:
    Word16Split256Experiment(size_t n, uint32_t bpk)
        : buckets_(bloom_filters::layout_detail::WordCount(n, bpk) / 8),
          bucket_mask_(buckets_.size() - 1) {}
    size_t SizeInBytes() const { return buckets_.capacity() * sizeof(Bucket); }
    void Insert(uint32_t n, const uint64_t *h) {
        for (size_t i = 0; i < n; ++i) InsertOne(h[i]);
    }
    uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
        if (n == 1) { out[0] = One(h[0]); return 1; }
        for (size_t i = 0; i < n; ++i) out[i] = One(h[i]);
        return n;
    }
    // Experiment-only full-bitmap view, not a proposed production API.
    const uint8_t *Data() const { return reinterpret_cast<const uint8_t *>(buckets_.data()); }
};
#undef BF_WORD16_SIMD
