#pragma once
#include <algorithm>
#include <cstdint>
#include <stdexcept>
#include <vector>
#include <immintrin.h>
#include "base.h"
namespace bloom_filters {
// Eight independent 5-bit positions, drawn directly from a uniform 64-bit hash.
// 24 low bits address 32-byte blocks; 40 high bits choose the eight positions.
class DirectSplitBF {
public:
    DirectSplitBF(size_t n, uint32_t bpk) {
        if(!bpk || n > (size_t{1}<<31)/bpk) throw std::invalid_argument("size");
        size_t bits=std::max<size_t>(512,n*bpk), words=32;
        while(words<=bits/32)words*=2;
        blocks_.resize(words); mask_=static_cast<uint32_t>(words/8-1);
    }
    size_t SizeInBytes() const {return blocks_.size()*4;}
    void Insert(uint32_t n,const uint64_t *keys) {
        for(size_t i=0;i<n;++i) {
            if(SizeInBytes()>(1u<<21) && i+64<n) __builtin_prefetch(blocks_.data()+((keys[i+64]&mask_)*8),1,3);
            auto p=reinterpret_cast<__m256i*>(blocks_.data()+(keys[i]&mask_)*8);
            _mm256_store_si256(p,_mm256_or_si256(_mm256_load_si256(p),MakeMask(keys[i])));
        }
    }
    uint32_t Lookup(uint32_t n,const uint64_t *keys,uint32_t *out) const {
        for(size_t i=0;i<n;++i) {
            if(SizeInBytes()>(1u<<21) && i+64<n) __builtin_prefetch(blocks_.data()+((keys[i+64]&mask_)*8),0,3);
            auto p=reinterpret_cast<const __m256i*>(blocks_.data()+(keys[i]&mask_)*8);
            out[i]=_mm256_testc_si256(_mm256_load_si256(p),MakeMask(keys[i]));
        }
        return n;
    }
private:
    static __m256i MakeMask(uint64_t h) {
        __m256i x=_mm256_srlv_epi64(_mm256_set1_epi64x(h),_mm256_setr_epi64x(24,34,44,54));
        __m256i positions=_mm256_or_si256(_mm256_and_si256(x,_mm256_set1_epi64x(31)),
            _mm256_and_si256(_mm256_slli_epi64(x,27),_mm256_set1_epi64x(uint64_t{31}<<32)));
        return _mm256_sllv_epi32(_mm256_set1_epi32(1),positions);
    }
    uint32_t mask_;
    std::vector<uint32_t,AlignedAllocator<uint32_t,64>> blocks_;
};
}
