#pragma once
#include "base_snapshot.h"
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <vector>
namespace bloom_filters {
class FastPatternBF {
    static constexpr uint32_t patterns2[8] = {
#include "masks2-count8.txt"
    };
    static constexpr uint32_t patterns3[8] = {
#include "masks3-count8.txt"
    };
    std::vector<uint32_t,AlignedAllocator<uint32_t,64>> words_;
    uint32_t word_mask_;
    static uint32_t mask(uint32_t code,unsigned sector) {
        const bool three = MASK_MODE==12 || (MASK_MODE==10 && sector>=2);
        const uint32_t pattern=(three?patterns3:patterns2)[code&7], shift=(code>>3)&31;
        return (pattern<<shift)|(pattern>>((-shift)&31));
    }
    void probe(uint64_t h,uint32_t*index,uint32_t*masks) const {
        const uint32_t hi=h>>32,lo=h;
        index[0]=hi&word_mask_;
        index[1]=(index[0]^4)^((hi>>26)&3);
        index[2]=(index[0]^8)^((hi>>28)&3);
        index[3]=(index[0]^12)^((hi>>30)&3);
        for(unsigned j=0;j<4;++j) masks[j]=mask(lo>>(8*j),j);
    }
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
            uint32_t index[4],masks[4];probe(h[i],index,masks);
            for(unsigned j=0;j<4;++j) words_[index[j]]|=masks[j];
        }
    }
    uint32_t Lookup(uint32_t n,const uint64_t*h,uint32_t*out) const {
        for(size_t i=0;i<n;++i) {
            uint32_t index[4],masks[4];probe(h[i],index,masks);uint32_t pass=1;
            for(unsigned j=0;j<4;++j) pass&=(words_[index[j]]&masks[j])==masks[j];
            out[i]=pass;
        }
        return n;
    }
};
}
