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

// Seven bits in two 32-bit sectors in one cache line. The bit layout and sizing
// match CacheSectorizedBF32Bit; only the execution strategy differs.
// Prehashed input, one 0/1 output per key, single-writer construction.
class PipelinedSectorizedBF {
public:
    explicit PipelinedSectorizedBF(size_t keys, uint32_t bits_per_key) {
        if (!bits_per_key || keys > std::numeric_limits<size_t>::max() / bits_per_key)
            throw std::invalid_argument("invalid Bloom filter size");
        const size_t bits = std::max<size_t>(512, keys * bits_per_key);
        if (bits >= (size_t{1} << 31))
            throw std::length_error("sectorized layout supports at most 256 MiB");
        size_t words = 32;
        while (words <= bits / 32) words *= 2;
        blocks_.resize(words);
        block_mask_ = static_cast<uint32_t>(words - 1);
    }
    size_t SizeInBytes() const { return blocks_.size() * sizeof(uint32_t); }
    void Insert(uint32_t num, const uint64_t *keys) {
        if (SizeInBytes() > (1u << 21)) InsertImpl<true>(num, keys);
        else InsertImpl<false>(num, keys);
    }
    uint32_t Lookup(uint32_t num, const uint64_t *keys, uint32_t *out) const {
        if (SizeInBytes() > (1u << 21)) LookupImpl<true>(num, keys, out);
        else LookupImpl<false>(num, keys, out);
        return num;
    }

private:
#if defined(__AVX512F__)
    struct Probe { __m512i index, mask; };
    Probe Prepare(const uint64_t *keys) const {
        const __m512i h = _mm512_loadu_si512(keys);
        const __m512i one = _mm512_set1_epi32(1), low5 = _mm512_set1_epi32(31);
        // Keep low/high halves interleaved. Adjacent lanes represent the two
        // sectors of one key, so no deinterleaving or second gather is needed.
        __m512i a = _mm512_or_si512(
            _mm512_and_si512(h, _mm512_set1_epi64((1u << 17) - 1)),
            _mm512_and_si512(_mm512_srli_epi64(h, 18), _mm512_set1_epi64(511u << 17)));
        a = _mm512_and_si512(a, _mm512_set1_epi64(block_mask_));
        a = _mm512_shuffle_epi32(a, static_cast<_MM_PERM_ENUM>(0xa0));
        const __m512i delta = _mm512_or_si512(_mm512_set1_epi64(uint64_t{8} << 32),
            _mm512_and_si512(h, _mm512_set1_epi64(uint64_t{7} << 32)));
        const __m512i index = _mm512_xor_si512(a, delta);
        const __m512i s1 = _mm512_set1_epi64((uint64_t{12} << 32) | 17);
        const __m512i s2 = _mm512_add_epi32(s1, _mm512_set1_epi32(5));
        const __m512i s3 = _mm512_add_epi32(s1, _mm512_set1_epi32(10));
        __m512i mask = _mm512_ternarylogic_epi32(
            _mm512_sllv_epi32(one, _mm512_and_si512(_mm512_srlv_epi32(h,s1),low5)),
            _mm512_sllv_epi32(one, _mm512_and_si512(_mm512_srlv_epi32(h,s2),low5)),
            _mm512_sllv_epi32(one, _mm512_and_si512(_mm512_srlv_epi32(h,s3),low5)),0xfe);
        mask = _mm512_or_si512(mask, _mm512_sllv_epi32(
            _mm512_set1_epi64(uint64_t{1} << 32), _mm512_srli_epi32(h,27)));
        return {index,mask};
    }
#endif

    template<bool Prefetch> void InsertImpl(uint32_t num, const uint64_t *keys) {
        size_t i=0;
#if defined(__AVX512F__)
        alignas(64) uint32_t indexes[16], masks[16];
        for (;i+8<=num;i+=8) {
            if constexpr(Prefetch) {
                if(i+72<=num) for(size_t j=0;j<8;++j)
                    __builtin_prefetch(blocks_.data()+Block(keys[i+64+j]),1,1);
            }
            const Probe p=Prepare(keys+i);
            _mm512_store_si512(indexes,p.index); _mm512_store_si512(masks,p.mask);
            // Scatter cannot implement colliding read-modify-write ORs safely.
            for(size_t j=0;j<16;++j) blocks_[indexes[j]] |= masks[j];
        }
#endif
        for(;i<num;++i) {
            const uint64_t h=keys[i];
            const uint32_t a=Block(h), hi=h>>32;
            blocks_[a]|=Mask1(static_cast<uint32_t>(h));
            blocks_[a^(8u+(hi&7))]|=Mask2(hi);
        }
    }

    template<bool Prefetch> void LookupImpl(uint32_t num, const uint64_t *BF_RESTRICT keys,
                                            uint32_t *BF_RESTRICT out) const {
        size_t i=0;
#if defined(__AVX512F__)
        for(;i+8<=num;i+=8) {
            if constexpr(Prefetch) {
                if(i+72<=num) for(size_t j=0;j<8;++j)
                    __builtin_prefetch(blocks_.data()+Block(keys[i+64+j]),0,1);
            }
            const Probe p=Prepare(keys+i);
            const __m512i words=_mm512_i32gather_epi32(p.index,blocks_.data(),4);
            const __m512i missing=_mm512_andnot_si512(words,p.mask);
            // A 64-bit comparison reduces the two sector tests for each key.
            const __mmask8 pass=_mm512_cmpeq_epi64_mask(missing,_mm512_setzero_si512());
            const __m512i result=_mm512_maskz_set1_epi64(pass,1);
            _mm256_storeu_si256(reinterpret_cast<__m256i*>(out+i),_mm512_cvtepi64_epi32(result));
        }
#endif
        for(;i<num;++i) {
            const uint64_t h=keys[i];
            const uint32_t a=Block(h), hi=h>>32;
            const uint32_t m1=Mask1(static_cast<uint32_t>(h)), m2=Mask2(hi);
            out[i]=((blocks_[a]&m1)==m1) & ((blocks_[a^(8u+(hi&7))]&m2)==m2);
        }
    }
    uint32_t Block(uint64_t h) const {
        return ((static_cast<uint32_t>(h)&((1u<<17)-1)) |
                ((static_cast<uint32_t>(h>>32)<<14)&(511u<<17)))&block_mask_;
    }
    static uint32_t Mask1(uint32_t lo) {
        return (1u<<((lo>>17)&31)) | (1u<<((lo>>22)&31)) | (1u<<(lo>>27));
    }
    static uint32_t Mask2(uint32_t hi) {
        return (1u<<((hi>>12)&31)) | (1u<<((hi>>17)&31)) |
               (1u<<((hi>>22)&31)) | (1u<<(hi>>27));
    }
    uint32_t block_mask_;
    std::vector<uint32_t,AlignedAllocator<uint32_t,64>> blocks_;
};
} // namespace bloom_filters
