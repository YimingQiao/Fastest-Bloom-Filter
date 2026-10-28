// SPDX-License-Identifier: Apache-2.0
// Mask construction adapted from FastFilter Fixed16, commit
// 7c5bf187d5096ccbcec6a16e02975d0af3328b01; Copyright 2018 fastfilter_cpp authors.
// See ../../third_party/FastFilter/{LICENSE,NOTICE}.
// Experiment: widen the signed-i16/byte-shuffle construction to 32-byte buckets
// with sixteen salts; balance positive/negative salts in each source-word group.
#pragma once
#include "../../include/base.h"
#include "../../include/layout_detail.h"
#include <array>
#include <vector>
#ifdef __AVX2__
#include <immintrin.h>
#endif

class ByteSplit256Experiment {
    struct alignas(32) Bucket { std::array<uint8_t, 32> bytes {}; };
    static_assert(sizeof(Bucket) == 32, "bucket stride must be exactly 32 bytes");
    std::vector<Bucket, bloom_filters::AlignedAllocator<Bucket, 64>> buckets_;
    uint32_t bucket_mask_;
    inline static constexpr uint16_t salts_[16] = {
        0x47b5, 0x4497, 0x8823, 0xa2b7, 0x7053, 0x2df1, 0x9efc, 0x5c6b,
        0x3c6f, 0x9e37, 0xb529, 0x85eb, 0x1657, 0xc2b3, 0xd1b5, 0x7f4b
    };
    size_t Block(uint64_t h) const { return (h >> 32) & bucket_mask_; }
    static std::array<uint8_t, 32> ScalarMask(uint64_t h) {
        std::array<uint8_t, 32> mask {};
        for (size_t j = 0; j < 16; ++j) {
            const uint32_t bits = (h >> (16 * (j & 1))) & 65535;
            const int32_t word = bits < 32768 ? int32_t(bits) : int32_t(bits) - 65536;
            const int32_t salt = salts_[j] < 32768 ? int32_t(salts_[j]) : int32_t(salts_[j]) - 65536;
            const uint16_t high = uint32_t(word * salt) >> 16;
            for (size_t k = 0; k < 2; ++k) {
                const uint8_t c = high >> (8 * k);
                mask[2 * j + k] = (c & 128) ? 0 : (128 >> (c & 7));
            }
        }
        return mask;
    }
#ifdef __AVX2__
    static __m256i Mask(uint64_t h) {
        const auto salts = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(salts_));
        const auto product = _mm256_mulhi_epi16(salts, _mm256_set1_epi32(uint32_t(h)));
        return _mm256_shuffle_epi8(_mm256_set1_epi64x(0x0102040810204080LL), product);
    }
#endif
    void InsertOne(uint64_t h) {
        auto &bucket = buckets_[Block(h)];
#ifdef __AVX2__
        auto *p = reinterpret_cast<__m256i *>(bucket.bytes.data());
        _mm256_store_si256(p, _mm256_or_si256(_mm256_load_si256(p), Mask(h)));
#else
        const auto mask = ScalarMask(h);
        for (size_t j = 0; j < 32; ++j) bucket.bytes[j] |= mask[j];
#endif
    }
    uint32_t One(uint64_t h) const {
        const auto &bucket = buckets_[Block(h)];
#ifdef __AVX2__
        return _mm256_testc_si256(_mm256_load_si256(reinterpret_cast<const __m256i *>(bucket.bytes.data())), Mask(h));
#else
        const auto mask = ScalarMask(h);
        uint8_t missing = 0;
        for (size_t j = 0; j < 32; ++j) missing |= ~bucket.bytes[j] & mask[j];
        return missing == 0;
#endif
    }
public:
    ByteSplit256Experiment(size_t n, uint32_t bpk)
        : buckets_(bloom_filters::layout_detail::WordCount(n, bpk) / 8), bucket_mask_(buckets_.size() - 1) {}
    size_t SizeInBytes() const { return buckets_.capacity() * 32; }
    void Insert(uint32_t n, const uint64_t *h) { for (size_t i = 0; i < n; ++i) InsertOne(h[i]); }
    uint32_t Lookup(uint32_t n, const uint64_t *h, uint32_t *out) const {
        if (n == 1) { out[0] = One(h[0]); return 1; }
        for (size_t i = 0; i < n; ++i) out[i] = One(h[i]);
        return n;
    }
    // Experiment-only oracle view; this is not a public library API.
    const uint8_t *Data() const { return reinterpret_cast<const uint8_t *>(buckets_.data()); }
};
