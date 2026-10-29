#pragma once
#include "base.h"
#include "layout_detail.h"
#include "word_patterns.h"
#include <vector>
namespace mac_word_pattern {
template <unsigned K, unsigned Bits, unsigned Distance = 64>
class Filter {
    std::vector<uint64_t, bloom_filters::AlignedAllocator<uint64_t, 64>> words_;
    uint32_t word_mask_;
    uint32_t Index(uint64_t h) const { return uint32_t(h >> 32) & word_mask_; }
    static uint64_t Mask(uint64_t h) {
        const uint64_t p = (K == 4 ? patterns4 : patterns5)[h & ((1u << Bits) - 1)];
        const unsigned r = (h >> Bits) & 63;
        return (p << r) | (p >> ((-r) & 63));
    }
    template<bool Prefetch>
    void InsertImpl(uint32_t n, const uint64_t* h) {
        #pragma clang loop unroll_count(4)
        for (size_t i=0; i<n; ++i) {
            if constexpr(Prefetch) if (i+Distance<n) __builtin_prefetch(&words_[Index(h[i+Distance])],1,3);
            words_[Index(h[i])] |= Mask(h[i]);
        }
    }
    template<bool Prefetch>
    uint32_t LookupImpl(uint32_t n, const uint64_t* h, uint32_t* out) const {
        #pragma clang loop unroll_count(4)
        for (size_t i=0; i<n; ++i) {
            if constexpr(Prefetch) if (i+Distance<n) __builtin_prefetch(&words_[Index(h[i+Distance])],0,3);
            const auto mask=Mask(h[i]);
            out[i]=(words_[Index(h[i])] & mask)==mask;
        }
        return n;
    }
public:
    Filter(size_t n,uint32_t bpk):words_(bloom_filters::layout_detail::WordCount(n,bpk)/2),word_mask_(words_.size()-1) {}
    size_t SizeInBytes() const { return words_.capacity()*8; }
    void Insert(uint32_t n,const uint64_t* h) {
        if(SizeInBytes()>(1u<<23)) InsertImpl<true>(n,h); else InsertImpl<false>(n,h);
    }
    uint32_t Lookup(uint32_t n,const uint64_t* h,uint32_t* out) const {
        if(SizeInBytes()>(1u<<21)) return LookupImpl<true>(n,h,out);
        return LookupImpl<false>(n,h,out);
    }
};
}
using WordPattern4B4 = mac_word_pattern::Filter<4,4>;
using WordPattern4B5 = mac_word_pattern::Filter<4,5>;
using WordPattern4B6 = mac_word_pattern::Filter<4,6>;
using WordPattern5B6 = mac_word_pattern::Filter<5,6>;
using WordPattern4B6D128 = mac_word_pattern::Filter<4,6,128>;
#ifndef BF_REGISTER_EXTERNAL_FILTERS
#define BF_REGISTER_EXTERNAL_FILTERS(ADD) \
    ADD(WordPattern4B4,uint64_t); \
    ADD(WordPattern4B5,uint64_t); \
    ADD(WordPattern4B6,uint64_t); \
    ADD(WordPattern5B6,uint64_t); \
    ADD(WordPattern4B6D128,uint64_t)
#endif
