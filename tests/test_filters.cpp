#include <algorithm>
#include <cstdint>
#include <iostream>
#include <random>
#include <sstream>
#include <stdexcept>
#include <vector>
#include "base.h"
#include "cache_sectorized_BF_32bit.h"
#include "new_cache_sectorized_BF_32bit.h"
#include "register_blocked_BF_32bit.h"
#include "register_blocked_BF_32bit_Masks.h"
#include "register_blocked_BF_64bit.h"
#include "register_blocked_BF_64bit_Masks.h"
#include "register_blocked_BF_2x32bit.h"
#include "impala_blocked_BF_64bit.h"
#ifdef __AVX512F__
#include "impala_blocked_BF_64bit_avx512.h"
#endif
using namespace bloom_filters;
void require(bool ok) { if(!ok) throw std::runtime_error("filter correctness failure"); }
template<class BF, class H> void check() {
    std::mt19937_64 rng(734901);
    for (size_t n : {size_t{0},size_t{1},size_t{17},size_t{255},size_t{4096}}) {
        BF bf(n,16);
        bf.Insert(0,nullptr); bf.Lookup(0,nullptr,nullptr);
        std::vector<H> keys(n);
        for(auto&h:keys) h=static_cast<H>(rng());
        // Single-key and odd batches, with repeated hashes to exercise update collisions.
        for(size_t i=0;i<n;) {
            size_t len=std::min<size_t>(1+rng()%35,n-i);
            bf.Insert(len,keys.data()+i); i+=len;
        }
        if(n) bf.Insert(n,keys.data());
        std::vector<uint32_t> out(n);
        bf.Lookup(n,keys.data(),out.data());
        for(auto x:out) require(x==1);
        for(size_t offset=0;offset<8;++offset) for(size_t len=0;len<70;++len) {
            // Exact allocations let ASan catch tail overreads; sentinels catch writes outside output.
            std::vector<H> queries(offset+len);
            for(auto&h:queries) h=static_cast<H>(rng());
            std::vector<uint32_t> got(len+2,0xdeadbeef);
            H *ptr=queries.empty()?nullptr:queries.data()+offset;
            bf.Lookup(len,ptr,got.data()+1);
            require(got.front()==0xdeadbeef && got.back()==0xdeadbeef);
            for(size_t j=0;j<len;++j) {
                uint32_t one=99;
                bf.Lookup(1,ptr+j,&one);
                require(one<=1 && one==got[j+1]);
            }
        }
    }
}
int main() {
    try {
        check<RegisterBlockedBF32Bit,uint32_t>();
        check<RegisterBlockedBF32BitMasks,uint32_t>();
        check<RegisterBlockedBF64Bit,uint64_t>();
        check<RegisterBlockedBF64BitMasks,uint64_t>();
        check<RegisterBlockedBF2x32Bit,uint64_t>();
        check<CacheSectorizedBF32Bit,uint64_t>();
        check<NewCacheSectorizedBF32Bit,uint64_t>();
        check<ImpalaBlockedBF64Bit,uint64_t>();
#ifdef __AVX512F__
        check<ImpalaBlockedBF64BitAVX512,uint64_t>();
#endif
        std::cout<<"All filter correctness checks passed\n";
    } catch(const std::exception&e) {std::cerr<<e.what()<<'\n';return 1;}
}
