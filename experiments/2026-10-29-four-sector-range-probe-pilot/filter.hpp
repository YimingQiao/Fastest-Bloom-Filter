#pragma once
#include "../2026-10-29-four-sector-range24/range_size.hpp"
#include "base.h"
#include <algorithm>
#include <vector>

namespace range_probe_pilot {
// Accuracy-only scalar implementation. Existing range24 address mapping and
// historical dictionaries; this source is not a throughput candidate.
template<unsigned K> class Filter {
    static_assert(K == 8 || K == 9 || K == 10 || K == 12);
    inline static constexpr uint32_t two[16] = {
        0x3,0x5,0x9,0x11,0x21,0x41,0x81,0x101,
        0x201,0x401,0x801,0x1001,0x2001,0x4001,0x8001,0x10001};
    inline static constexpr uint32_t three[16] = {
#include "../2026-10-28-four-sector/masks3-count16.txt"
    };
    std::vector<uint32_t, bloom_filters::AlignedAllocator<uint32_t, 64>> words_;
    size_t lines_;
    void Probes(uint64_t h, uint32_t (&indices)[4], uint32_t (&masks)[4]) const {
        const uint32_t hi = h >> 32, lo = h;
        const uint32_t line = (uint64_t(hi >> 8) * lines_) >> 24;
        const uint32_t first = (line << 4) | (hi & 3);
        for (unsigned j = 0; j < 4; ++j) {
            indices[j] = first ^ (j * 4) ^ (j ? ((hi >> (2*j)) & 3) : 0);
            const unsigned r = 8*j;
            const uint32_t code = (lo >> r) | (lo << ((-r) & 31));
            const bool use_three = K == 12 || (K == 10 && j >= 2) || (K == 9 && j == 3);
            const uint32_t p = (use_three ? three : two)[code & 15];
            const unsigned rotation = (code >> 4) & 31;
            masks[j] = (p << rotation) | (p >> ((-rotation) & 31));
        }
    }
public:
    explicit Filter(bloom_filters::RangeBytes bytes)
        : words_(bloom_filters::range_detail::LineCount(bytes.bytes)*16), lines_(words_.size()/16) {}
    size_t SizeInBytes() const { return words_.capacity()*sizeof(uint32_t); }
    const uint32_t* Data() const { return words_.data(); }
    void Insert(uint32_t n, const uint64_t* hashes) {
        for (size_t i=0;i<n;++i) {
            uint32_t indices[4],masks[4];Probes(hashes[i],indices,masks);
            for(unsigned j=0;j<4;++j)words_[indices[j]] |= masks[j];
        }
    }
    uint32_t Lookup(uint32_t n,const uint64_t* hashes,uint32_t* out) const {
        for(size_t i=0;i<n;++i) {
            uint32_t indices[4],masks[4];Probes(hashes[i],indices,masks);
            uint32_t missing=0;
            for(unsigned j=0;j<4;++j)missing |= masks[j] & ~words_[indices[j]];
            out[i] = missing == 0;
        }
        return n;
    }
};
}
