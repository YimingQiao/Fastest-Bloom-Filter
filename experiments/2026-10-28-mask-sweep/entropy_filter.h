#pragma once
#include "base_snapshot.h"
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <vector>
namespace bloom_filters {
// Accuracy-only scalar implementation. It deliberately does not claim throughput.
class FastPatternBF {
    static constexpr unsigned IndexBits = MASK_COUNT == 64 ? 6 : 7;
    static constexpr unsigned CodeBits = IndexBits + 5;
    static constexpr uint32_t patterns[MASK_COUNT] = {
#include BF_DENSE_DICTIONARY
    };
    std::vector<uint32_t,AlignedAllocator<uint32_t,64>> words_;
    uint32_t word_mask_;
    static uint32_t mask(uint32_t code) {
        const uint32_t pattern=patterns[code & (MASK_COUNT-1)], shift=(code >> IndexBits)&31;
        return (pattern<<shift)|(pattern>>((-shift)&31));
    }
    uint32_t first(uint64_t h) const { return (h>>32)&word_mask_; }
    static uint32_t partner(uint32_t a,uint64_t h) { return a^(8+((static_cast<uint32_t>(h)>>(2*CodeBits))&7)); }
public:
    FastPatternBF(size_t n,uint32_t bpk) {
        const size_t bits=std::max<size_t>(512,n*bpk);
        size_t words=32;
        while(words<=bits/32) words*=2;
        words_.resize(words);word_mask_=words-1;
    }
    size_t SizeInBytes() const { return words_.size()*4; }
    void Insert(uint32_t n,const uint64_t*h) {
        for(size_t i=0;i<n;++i) {
            const uint32_t a=first(h[i]),b=partner(a,h[i]);
            words_[a]|=mask(static_cast<uint32_t>(h[i]));
            words_[b]|=mask(static_cast<uint32_t>(h[i])>>CodeBits);
        }
    }
    uint32_t Lookup(uint32_t n,const uint64_t*h,uint32_t*out) const {
        for(size_t i=0;i<n;++i) {
            const uint32_t a=first(h[i]),b=partner(a,h[i]);
            const uint32_t m1=mask(static_cast<uint32_t>(h[i])),m2=mask(static_cast<uint32_t>(h[i])>>CodeBits);
            out[i]=((words_[a]&m1)==m1)&((words_[b]&m2)==m2);
        }
        return n;
    }
};
}
