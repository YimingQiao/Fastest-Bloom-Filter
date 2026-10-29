// SPDX-License-Identifier: MIT
// Register-blocked Bloom filter using 64 fixed four-bit patterns and rotations.
// Each key touches one 64-bit word. Uniform prehashed inputs, exclusive insertion.
// The shared 512-byte dictionary is separate from the reported bitmap bytes.
#pragma once
#include "base.h"
#include "layout_detail.h"
#include <vector>
namespace bloom_filters {
class Word64BloomFilter {
private:
    template <class> friend class ParallelLayoutBloomFilter;
    std::vector<uint64_t, AlignedAllocator<uint64_t, 64>> words_;
    uint32_t word_mask_;
    inline static constexpr uint64_t patterns_[64] = {
    0x802000005000000ULL, 0x600000002002000ULL, 0x4000000c00001000ULL, 0x600000000004020ULL,
    0x84000180000000ULL, 0x4104040000ULL, 0x4008000120000ULL, 0x220400000400000ULL,
    0x220000810000ULL, 0x8002a00000000ULL, 0x8000c0000000004ULL, 0x880000000101000ULL,
    0x1000000020000300ULL, 0x20008000004010ULL, 0x60000402000ULL, 0x200048000000400ULL,
    0x80800000800010ULL, 0x300000008800ULL, 0x30001001ULL, 0xc000100000008ULL,
    0x40002000011000ULL, 0x2100800000000001ULL, 0x40000000409ULL, 0x48000408ULL,
    0xc010000000100000ULL, 0x140000000000c0ULL, 0x1000004000042000ULL, 0x840400000040000ULL,
    0x4020000080040000ULL, 0x80000080000012ULL, 0x100020000010200ULL, 0x8000008004000200ULL,
    0x4000000481ULL, 0x20004000102ULL, 0x60400002000000ULL, 0x400000000200009ULL,
    0x4014400000ULL, 0x100002000202ULL, 0x2000800000000081ULL, 0x841000000080000ULL,
    0x220002000000001ULL, 0x3060000ULL, 0x202000020000010ULL, 0x1000008000000900ULL,
    0x220000000000084ULL, 0xc010004ULL, 0x9000000014000000ULL, 0x209000000020ULL,
    0x40001202000000ULL, 0x402000000050000ULL, 0x1000100000800010ULL, 0x4040000020100000ULL,
    0x812000002000ULL, 0x40000880002ULL, 0x200002080200000ULL, 0x408000000082ULL,
    0x1001010004000ULL, 0x410000000040010ULL, 0x28000440000000ULL, 0x8000120000080000ULL,
    0x800400001040ULL, 0x250000000040000ULL, 0x220000000000880ULL, 0x24000000400004ULL
};
    size_t CacheLineCount() const { return words_.size() / 8; }
    size_t CacheLineIndex(uint64_t h) const { return Index(h) >> 3; }
    uint32_t Index(uint64_t h) const { return uint32_t(h >> 32) & word_mask_; }
    static uint64_t Mask(uint64_t h) {
        const uint64_t p = patterns_[h & 63];
        const unsigned r = (h >> 6) & 63;
        return (p << r) | (p >> ((-r) & 63));
    }
    template<unsigned Distance>
    void InsertImpl(uint32_t n, const uint64_t* h) {
#if defined(__clang__)
#pragma clang loop unroll_count(4)
#endif
        for (size_t i=0; i<n; ++i) {
            if constexpr(Distance != 0) if (i+Distance<n) __builtin_prefetch(&words_[Index(h[i+Distance])],1,3);
            words_[Index(h[i])] |= Mask(h[i]);
        }
    }
    template<unsigned Distance>
    uint32_t LookupImpl(uint32_t n, const uint64_t* h, uint32_t* out) const {
#if defined(__clang__)
#pragma clang loop unroll_count(4)
#endif
        for (size_t i=0; i<n; ++i) {
            if constexpr(Distance != 0) if (i+Distance<n) __builtin_prefetch(&words_[Index(h[i+Distance])],0,3);
            const auto mask=Mask(h[i]);
            out[i]=(words_[Index(h[i])] & mask)==mask;
        }
        return n;
    }
public:
    explicit Word64BloomFilter(size_t n,uint32_t bpk):words_(layout_detail::WordCount(n,bpk)/2),word_mask_(words_.size()-1) {}
    size_t SizeInBytes() const { return words_.capacity()*8; }
    void Insert(uint32_t n,const uint64_t* h) {
        if (n > 64 && SizeInBytes() >= (1u << 26)) InsertImpl<64>(n,h);
        else if (n > 128 && SizeInBytes() > (1u << 23)) InsertImpl<128>(n,h);
        else InsertImpl<0>(n,h);
    }
    uint32_t Lookup(uint32_t n,const uint64_t* h,uint32_t* out) const {
        if (n == 1) {
            const auto mask = Mask(h[0]);
            out[0] = (words_[Index(h[0])] & mask) == mask;
            return 1;
        }
        if (n > 64 && SizeInBytes() >= (1u << 26)) return LookupImpl<64>(n,h,out);
        if (n > 128 && SizeInBytes() > (1u << 21)) return LookupImpl<128>(n,h,out);
        return LookupImpl<0>(n,h,out);
    }
};
}
