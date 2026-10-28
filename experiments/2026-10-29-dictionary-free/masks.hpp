#pragma once
#include "base.h"
#include <array>
#include <cstdint>
#include <vector>
namespace dictionary_free_experiment {
inline uint32_t rotate(uint32_t x,unsigned r) {r&=31;return(x<<r)|(x>>((-r)&31));}
inline constexpr uint32_t dense[32]={0x8b,0x402021,0x5003,0x10091,0x4109,0x8023,0x8105,0x200403,0x40025,0x1411,0x80c1,0x22009,0x210201,0x53,0x40103,0x2205,0x100121,0x80803,0x41201,0x20811,0x10805,0x81005,0x641,0x3101,0x24041,0x4085,0x12401,0x202011,0x2a1,0xc09,0x20007,0x80421};
inline constexpr const char* names[]={"DenseTable32","PeriodicAllowCollision","PeriodicCrossHalf","PeriodicDistinctModulo","AdjacentPairs16","AsymmetricPairs16","NonperiodicPair8","NonperiodicPair4","TriadOddSingleton"};
inline constexpr unsigned families=sizeof(names)/sizeof(names[0]);
template<unsigned Family> inline uint32_t mask(uint32_t code) {
    code&=1023;
    if constexpr(Family==0)return rotate(dense[code&31],code>>5);
    if constexpr(Family==1)return rotate(0x00010001,code&15)|rotate(0x00010001,(code>>4)&15);
    if constexpr(Family==2) {const unsigned a=code&15,b=a^(8+((code>>4)&7));return rotate(0x00010001,a)|rotate(0x00010001,b);}
    if constexpr(Family==3) {const unsigned a=code&15,b=(a+1+((code>>4)%15))&15;return rotate(0x00010001,a)|rotate(0x00010001,b);}
    if constexpr(Family==4)return rotate(3U|(3U<<(2+((code>>5)&15))),code&31);
    if constexpr(Family==5)return rotate(3U|(5U<<(2+((code>>5)&15))),code&31);
    if constexpr(Family==6)return rotate(0x00010001,code&31)|rotate(0x00002001,(code&31)+8+((code>>5)&7));
    if constexpr(Family==7)return rotate(0x00010001,code&31)|rotate(0x00002001,(code&31)+4+((code>>5)&7));
    if constexpr(Family==8)return rotate(0x00010101,code&31)|rotate(1U,(code&31)+1+2*((code>>5)&15));
}
template<unsigned Family> class Filter {
    std::vector<uint32_t,bloom_filters::AlignedAllocator<uint32_t,64>> words_;
    uint32_t word_mask_;
public:
    Filter(size_t n,unsigned actual_bpk):words_(n*actual_bpk/32),word_mask_(words_.size()-1){}
    size_t bytes()const{return words_.size()*4;}
    void insert(uint64_t h) {
        const uint32_t a=(h>>32)&word_mask_,b=a^(8+((h>>20)&7));
        words_[a]|=mask<Family>(static_cast<uint32_t>(h));
        words_[b]|=mask<Family>(static_cast<uint32_t>(h>>10));
    }
    bool contains(uint64_t h)const {
        const uint32_t a=(h>>32)&word_mask_,b=a^(8+((h>>20)&7));
        const uint32_t m1=mask<Family>(static_cast<uint32_t>(h)),m2=mask<Family>(static_cast<uint32_t>(h>>10));
        return ((words_[a]&m1)==m1)&((words_[b]&m2)==m2);
    }
};
} // namespace dictionary_free_experiment
